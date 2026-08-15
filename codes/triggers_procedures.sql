USE vaccine_rd_db;

DELIMITER $$

-- TRIGGER 1: trg_batch_before_insert

DROP TRIGGER IF EXISTS trg_batch_before_insert$$
CREATE TRIGGER trg_batch_before_insert
BEFORE INSERT ON batches
FOR EACH ROW
BEGIN
    IF NEW.quality_status = 'Released' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'A batch cannot be inserted as Released. It must start as Pending QC or Passed, then be updated after QC review.';
    END IF;
END$$

-- TRIGGER 2: trg_ae_serious_flag

DROP TRIGGER IF EXISTS trg_ae_serious_flag$$
CREATE TRIGGER trg_ae_serious_flag
BEFORE INSERT ON adverse_events
FOR EACH ROW
BEGIN
    IF NEW.severity IN ('Severe', 'Life-threatening', 'Fatal') THEN
        SET NEW.serious_event = TRUE;
    END IF;
END$$


DROP PROCEDURE IF EXISTS sp_enroll_participant$$
CREATE PROCEDURE sp_enroll_participant (
    IN  p_participant_id  INT,
    IN  p_phase_id        INT,
    IN  p_arm             ENUM('Vaccine','Placebo','Control'),
    OUT p_result_message  VARCHAR(200)
)
BEGIN
    DECLARE v_status            VARCHAR(20);
    DECLARE v_target             INT;
    DECLARE v_current_enrolled    INT;

    SELECT status, target_enrollment
        INTO v_status, v_target
        FROM clinical_study_phases
        WHERE phase_id = p_phase_id;

    IF v_status IS NULL THEN
        SET p_result_message = 'ERROR: phase_id does not exist.';

    ELSEIF v_status NOT IN ('Recruiting', 'Active') THEN
        SET p_result_message = CONCAT('ERROR: phase status is "', v_status, '", not open for enrollment.');

    ELSE
        SELECT COUNT(*) INTO v_current_enrolled
            FROM participant_enrollments
            WHERE phase_id = p_phase_id;

        IF v_current_enrolled >= v_target THEN
            SET p_result_message = 'ERROR: phase has already reached its target enrollment.';
        ELSE
            INSERT INTO participant_enrollments
                (participant_id, phase_id, enrollment_date, dose_number, arm)
            VALUES
                (p_participant_id, p_phase_id, CURDATE(), 1, p_arm);

            SET p_result_message = CONCAT('SUCCESS: enrollment_id ', LAST_INSERT_ID(), ' created.');
        END IF;
    END IF;
END$$


DROP FUNCTION IF EXISTS fn_adverse_event_rate$$
CREATE FUNCTION fn_adverse_event_rate (p_vaccine_id INT)
RETURNS DECIMAL(6,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_total_enrolled  INT;
    DECLARE v_total_events     INT;
    DECLARE v_rate              DECIMAL(6,2);

    SELECT COUNT(DISTINCT pe.enrollment_id) INTO v_total_enrolled
        FROM participant_enrollments pe
        JOIN clinical_study_phases cp ON cp.phase_id = pe.phase_id
        WHERE cp.vaccine_id = p_vaccine_id;

    SELECT COUNT(*) INTO v_total_events
        FROM adverse_events ae
        JOIN participant_enrollments pe ON pe.enrollment_id = ae.enrollment_id
        JOIN clinical_study_phases cp   ON cp.phase_id = pe.phase_id
        WHERE cp.vaccine_id = p_vaccine_id;

    IF v_total_enrolled = 0 THEN
        SET v_rate = 0.00;
    ELSE
        SET v_rate = ROUND(100.0 * v_total_events / v_total_enrolled, 2);
    END IF;

    RETURN v_rate;
END$$

DELIMITER ;


INSERT INTO adverse_events
    (enrollment_id, reported_by, event_description, severity, onset_date,
     causality_assessment, serious_event, outcome)
VALUES
    (3, 5, 'Trigger test: anaphylaxis reported', 'Severe', CURDATE(),
     'Probable', FALSE, 'Under review');

SELECT event_id, severity, serious_event
FROM adverse_events
WHERE event_description = 'Trigger test: anaphylaxis reported';

-- Test stored procedure: enroll participant 6 into phase 5 (Recruiting)
CALL sp_enroll_participant(6, 5, 'Placebo', @msg);
SELECT @msg AS enrollment_result;

-- Test function: adverse event rate for vaccine_id 1 (CoronaShield mRNA)
SELECT candidate_code, name, fn_adverse_event_rate(vaccine_id) AS ae_rate_per_100
FROM vaccine_candidates
WHERE vaccine_id = 1;

