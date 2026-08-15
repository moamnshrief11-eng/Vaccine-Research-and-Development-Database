USE vaccine_rd_db;

-- VIEW 1: vw_vaccine_pipeline_summary

CREATE OR REPLACE VIEW vw_vaccine_pipeline_summary AS
SELECT
    vc.vaccine_id,
    vc.candidate_code,
    vc.name                              AS vaccine_name,
    vc.target_disease,
    vc.technology_platform,
    vc.development_stage,
    vc.sponsor_organization,
    COUNT(DISTINCT va.antigen_id)        AS num_antigens,
    COUNT(DISTINCT f.formulation_id)     AS num_formulations,
    COUNT(DISTINCT b.batch_id)           AS num_batches,
    COUNT(DISTINCT cp.phase_id)          AS num_clinical_phases,
    COUNT(DISTINCT ae.event_id)          AS num_adverse_events
FROM vaccine_candidates vc
LEFT JOIN vaccine_antigens va          ON va.vaccine_id = vc.vaccine_id
LEFT JOIN formulations f               ON f.vaccine_id = vc.vaccine_id
LEFT JOIN batches b                    ON b.formulation_id = f.formulation_id
LEFT JOIN clinical_study_phases cp     ON cp.vaccine_id = vc.vaccine_id
LEFT JOIN participant_enrollments pe   ON pe.phase_id = cp.phase_id
LEFT JOIN adverse_events ae            ON ae.enrollment_id = pe.enrollment_id
GROUP BY vc.vaccine_id, vc.candidate_code, vc.name, vc.target_disease,
         vc.technology_platform, vc.development_stage, vc.sponsor_organization;


CREATE OR REPLACE VIEW vw_adverse_event_report AS
SELECT
    ae.event_id,
    p.anonymized_code                     AS participant_code,
    vc.candidate_code,
    vc.name                               AS vaccine_name,
    cp.phase_number,
    s.site_name,
    ae.severity,
    ae.causality_assessment,
    ae.serious_event,
    ae.onset_date,
    ae.resolution_date,
    CONCAT(r.first_name, ' ', r.last_name) AS reported_by,
    ae.outcome
FROM adverse_events ae
JOIN participant_enrollments pe ON pe.enrollment_id = ae.enrollment_id
JOIN participants p             ON p.participant_id = pe.participant_id
JOIN clinical_study_phases cp   ON cp.phase_id = pe.phase_id
JOIN vaccine_candidates vc      ON vc.vaccine_id = cp.vaccine_id
JOIN sites s                    ON s.site_id = cp.site_id
JOIN researchers r              ON r.researcher_id = ae.reported_by;


CREATE OR REPLACE VIEW vw_active_recruitment AS
SELECT
    cp.protocol_number,
    vc.candidate_code,
    vc.name           AS vaccine_name,
    cp.phase_number,
    s.site_name,
    cp.status,
    cp.target_enrollment,
    COUNT(pe.enrollment_id)                              AS current_enrollment,
    cp.target_enrollment - COUNT(pe.enrollment_id)        AS spots_remaining
FROM clinical_study_phases cp
JOIN vaccine_candidates vc     ON vc.vaccine_id = cp.vaccine_id
JOIN sites s                    ON s.site_id = cp.site_id
LEFT JOIN participant_enrollments pe ON pe.phase_id = cp.phase_id
WHERE cp.status IN ('Recruiting', 'Active')
GROUP BY cp.phase_id, cp.protocol_number, vc.candidate_code, vc.name,
         cp.phase_number, s.site_name, cp.status, cp.target_enrollment;

