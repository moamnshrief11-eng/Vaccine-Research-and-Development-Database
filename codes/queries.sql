USE vaccine_rd_db;
-- A1. All vaccine candidates currently in Phase III trials
SELECT candidate_code, name, target_disease, sponsor_organization, date_initiated
FROM vaccine_candidates
WHERE development_stage = 'Phase III';

-- A2. All active clinical study phases, most recent first
SELECT phase_id, protocol_number, phase_number, start_date, status
FROM clinical_study_phases
WHERE status IN ('Active', 'Recruiting')
ORDER BY start_date DESC;

-- A3. Batches that are expired as of today or failed/recalled QC
SELECT batch_number, manufacture_date, expiry_date, quality_status
FROM batches
WHERE quality_status IN ('Failed', 'Recalled') OR expiry_date < CURDATE();

-- B1. Vaccine candidates with their antigens (inner join across the M:N
-- associative table)
SELECT vc.candidate_code, vc.name AS vaccine_name,
       a.antigen_name, va.concentration_ug, va.role_in_formulation
FROM vaccine_candidates vc
JOIN vaccine_antigens va ON va.vaccine_id = vc.vaccine_id
JOIN antigens a           ON a.antigen_id = va.antigen_id
ORDER BY vc.candidate_code;

-- B2. Clinical study phases with vaccine, site, and principal
-- investigator details (multi-table join)
SELECT vc.candidate_code, vc.name AS vaccine_name, cp.phase_number,
       s.site_name, s.country,
       CONCAT(r.first_name, ' ', r.last_name) AS principal_investigator,
       cp.status
FROM clinical_study_phases cp
JOIN vaccine_candidates vc ON vc.vaccine_id = cp.vaccine_id
JOIN sites s               ON s.site_id = cp.site_id
JOIN researchers r         ON r.researcher_id = cp.principal_investigator_id
ORDER BY vc.candidate_code, cp.start_date;

-- B3. Every adverse event with participant (anonymized), vaccine and
-- reporting researcher (join across enrollment -> phase -> vaccine)
SELECT p.anonymized_code, vc.name AS vaccine_name, ae.severity,
       ae.onset_date, ae.causality_assessment,
       CONCAT(r.first_name, ' ', r.last_name) AS reported_by
FROM adverse_events ae
JOIN participant_enrollments pe ON pe.enrollment_id = ae.enrollment_id
JOIN participants p             ON p.participant_id = pe.participant_id
JOIN clinical_study_phases cp   ON cp.phase_id = pe.phase_id
JOIN vaccine_candidates vc      ON vc.vaccine_id = cp.vaccine_id
JOIN researchers r              ON r.researcher_id = ae.reported_by
ORDER BY ae.onset_date;

-- B4. LEFT JOIN: every clinical phase and how many participants are
-- enrolled (phases with zero participants would still be listed)
SELECT cp.protocol_number, cp.phase_number, cp.status,
       COUNT(pe.enrollment_id) AS enrolled_participants
FROM clinical_study_phases cp
LEFT JOIN participant_enrollments pe ON pe.phase_id = cp.phase_id
GROUP BY cp.phase_id, cp.protocol_number, cp.phase_number, cp.status
ORDER BY enrolled_participants DESC;

-- C1. Number of vaccine candidates per development stage
SELECT development_stage, COUNT(*) AS num_candidates
FROM vaccine_candidates
GROUP BY development_stage
ORDER BY num_candidates DESC;

-- C2. Average, min and max quantity produced per quality status
SELECT quality_status,
       COUNT(*)              AS num_batches,
       AVG(quantity_produced) AS avg_quantity,
       MIN(quantity_produced) AS min_quantity,
       MAX(quantity_produced) AS max_quantity
FROM batches
GROUP BY quality_status;

-- C3. Adverse event count and % serious, per vaccine candidate,
-- only for vaccines with 2 or more reported events (HAVING clause)
SELECT vc.candidate_code, vc.name,
       COUNT(ae.event_id)                                   AS total_events,
       SUM(ae.serious_event = TRUE)                          AS serious_events,
       ROUND(100 * SUM(ae.serious_event = TRUE) / COUNT(ae.event_id), 1) AS pct_serious
FROM adverse_events ae
JOIN participant_enrollments pe ON pe.enrollment_id = ae.enrollment_id
JOIN clinical_study_phases cp   ON cp.phase_id = pe.phase_id
JOIN vaccine_candidates vc      ON vc.vaccine_id = cp.vaccine_id
GROUP BY vc.vaccine_id, vc.candidate_code, vc.name
HAVING COUNT(ae.event_id) >= 2
ORDER BY total_events DESC;

-- C4. Enrollment totals per site, vaccine arm breakdown
SELECT s.site_name, s.country,
       COUNT(*)                                     AS total_enrollments,
       SUM(pe.arm = 'Vaccine')                       AS vaccine_arm,
       SUM(pe.arm = 'Placebo')                        AS placebo_arm,
       SUM(pe.arm = 'Control')                         AS control_arm
FROM participant_enrollments pe
JOIN clinical_study_phases cp ON cp.phase_id = pe.phase_id
JOIN sites s                   ON s.site_id = cp.site_id
GROUP BY s.site_id, s.site_name, s.country
ORDER BY total_enrollments DESC;

-- D1. Vaccine candidates that have NEVER had a serious adverse event
-- (subquery in WHERE with NOT IN)
SELECT candidate_code, name, development_stage
FROM vaccine_candidates
WHERE vaccine_id NOT IN (
    SELECT DISTINCT cp.vaccine_id
    FROM adverse_events ae
    JOIN participant_enrollments pe ON pe.enrollment_id = ae.enrollment_id
    JOIN clinical_study_phases cp   ON cp.phase_id = pe.phase_id
    WHERE ae.serious_event = TRUE
);

-- D2. Participants whose most recent lab test result was flagged
-- 'Abnormal' or 'Critical' (correlated subquery)
SELECT p.anonymized_code, lt.test_type, lt.test_date, lt.result_flag
FROM participants p
JOIN participant_enrollments pe ON pe.participant_id = p.participant_id
JOIN lab_tests lt                ON lt.enrollment_id = pe.enrollment_id
WHERE lt.test_date = (
        SELECT MAX(lt2.test_date)
        FROM lab_tests lt2
        WHERE lt2.enrollment_id = lt.enrollment_id
      )
  AND lt.result_flag IN ('Abnormal', 'Critical');

-- D3. Vaccine candidates whose average antibody-titer result is above
-- the overall average across all vaccines (subquery in HAVING)
SELECT vc.candidate_code, vc.name, ROUND(AVG(lt.result_value), 1) AS avg_titer
FROM lab_tests lt
JOIN participant_enrollments pe ON pe.enrollment_id = lt.enrollment_id
JOIN clinical_study_phases cp   ON cp.phase_id = pe.phase_id
JOIN vaccine_candidates vc      ON vc.vaccine_id = cp.vaccine_id
WHERE lt.test_type = 'Antibody Titer'
GROUP BY vc.vaccine_id, vc.candidate_code, vc.name
HAVING AVG(lt.result_value) > (
    SELECT AVG(result_value) FROM lab_tests WHERE test_type = 'Antibody Titer'
)
ORDER BY avg_titer DESC;

-- D4. Sites that have hosted more clinical phases than the average
-- number of phases per site (subquery in FROM / derived table)
SELECT site_name, phase_count
FROM (
    SELECT s.site_name, COUNT(cp.phase_id) AS phase_count
    FROM sites s
    JOIN clinical_study_phases cp ON cp.site_id = s.site_id
    GROUP BY s.site_id, s.site_name
) AS site_phase_counts
WHERE phase_count > (
    SELECT COUNT(*) / COUNT(DISTINCT site_id) FROM clinical_study_phases
)
ORDER BY phase_count DESC;

-- E1. INSERT: register a brand-new vaccine candidate
INSERT INTO vaccine_candidates
    (candidate_code, name, target_disease, technology_platform,
     sponsor_organization, development_stage, date_initiated)
VALUES
    ('VX-011', 'MpoxRing', 'Mpox', 'Protein Subunit',
     'OutbreakShield Inc', 'Discovery', CURDATE());

-- E2. INSERT: log a new lab test result for an existing enrollment
INSERT INTO lab_tests
    (enrollment_id, technician_id, test_type, test_date,
     result_value, unit, reference_range, result_flag)
VALUES
    (3, 3, 'PCR', CURDATE(), 0.000, 'copies/ml', 'negative', 'Normal');

-- E3. UPDATE: advance a candidate to the next development stage
UPDATE vaccine_candidates
SET development_stage = 'Preclinical'
WHERE candidate_code = 'VX-011';

-- E4. UPDATE: close out a completed clinical phase
UPDATE clinical_study_phases
SET status = 'Completed', end_date = '2023-06-30'
WHERE protocol_number = 'PR-VX008-1';

-- E5. UPDATE (multi-row, based on a subquery): mark all batches from
-- an expired formulation batch run as 'Recalled' if they are already
-- past their expiry date and were still 'Released'
UPDATE batches
SET quality_status = 'Recalled'
WHERE quality_status = 'Released'
  AND expiry_date < CURDATE();

-- E6. DELETE: remove a withdrawn participant's enrollment record that
-- has no further dependent lab tests or adverse events (safe delete

DELETE FROM participant_enrollments
WHERE enrollment_id = 12
  AND withdrawal_date IS NOT NULL
  AND NOT EXISTS (SELECT 1 FROM lab_tests WHERE enrollment_id = 12)
  AND NOT EXISTS (SELECT 1 FROM adverse_events WHERE enrollment_id = 12);


