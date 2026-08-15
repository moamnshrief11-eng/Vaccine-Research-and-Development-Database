DROP DATABASE IF EXISTS vaccine_rd_db;
CREATE DATABASE vaccine_rd_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE vaccine_rd_db;

-- 1. RESEARCHERS

CREATE TABLE researchers (
    researcher_id   INT AUTO_INCREMENT PRIMARY KEY,
    first_name      VARCHAR(50)  NOT NULL,
    last_name       VARCHAR(50)  NOT NULL,
    role            ENUM('Principal Investigator','Study Coordinator',
                         'Lab Technician','Data Manager','Safety Monitor')
                         NOT NULL,
    institution     VARCHAR(150) NOT NULL,
    email           VARCHAR(120) NOT NULL,
    phone           VARCHAR(30),
    CONSTRAINT uq_researchers_email UNIQUE (email)
) ENGINE=InnoDB;

-- 2. SITES

CREATE TABLE sites (
    site_id         INT AUTO_INCREMENT PRIMARY KEY,
    site_name       VARCHAR(150) NOT NULL,
    country         VARCHAR(80)  NOT NULL,
    city            VARCHAR(80)  NOT NULL,
    contact_person  VARCHAR(100),
    contact_email   VARCHAR(120),
    capacity        INT          NOT NULL DEFAULT 0,
    CONSTRAINT chk_sites_capacity CHECK (capacity >= 0)
) ENGINE=InnoDB;

-- 3. VACCINE_CANDIDATES

CREATE TABLE vaccine_candidates (
    vaccine_id          INT AUTO_INCREMENT PRIMARY KEY,
    candidate_code      VARCHAR(20)  NOT NULL,
    name                VARCHAR(150) NOT NULL,
    target_disease      VARCHAR(120) NOT NULL,
    technology_platform ENUM('mRNA','Viral Vector','Protein Subunit',
                             'Inactivated','Live Attenuated','DNA','VLP')
                             NOT NULL,
    sponsor_organization VARCHAR(150) NOT NULL,
    development_stage   ENUM('Discovery','Preclinical','Phase I','Phase II',
                             'Phase III','Approved','Discontinued')
                             NOT NULL DEFAULT 'Discovery',
    date_initiated       DATE NOT NULL,
    CONSTRAINT uq_vaccine_code UNIQUE (candidate_code)
) ENGINE=InnoDB;


-- 4. ANTIGENS

CREATE TABLE antigens (
    antigen_id      INT AUTO_INCREMENT PRIMARY KEY,
    antigen_name    VARCHAR(150) NOT NULL,
    antigen_type    ENUM('Protein','mRNA','Inactivated Virus',
                        'Live Attenuated Virus','Polysaccharide',
                        'DNA','Vector-based') NOT NULL,
    source_organism VARCHAR(150) NOT NULL,
    description     TEXT,
    CONSTRAINT uq_antigen_name_source UNIQUE (antigen_name, source_organism)
) ENGINE=InnoDB;

-- 5. VACCINE_ANTIGENS  (associative table -> resolves M:N)

CREATE TABLE vaccine_antigens (
    vaccine_id          INT NOT NULL,
    antigen_id          INT NOT NULL,
    concentration_ug    DECIMAL(8,3) NOT NULL,
    role_in_formulation VARCHAR(100) NOT NULL,
    PRIMARY KEY (vaccine_id, antigen_id),
    CONSTRAINT fk_va_vaccine FOREIGN KEY (vaccine_id)
        REFERENCES vaccine_candidates (vaccine_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_va_antigen FOREIGN KEY (antigen_id)
        REFERENCES antigens (antigen_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_va_concentration CHECK (concentration_ug > 0)
) ENGINE=InnoDB;

-- 6. FORMULATIONS

CREATE TABLE formulations (
    formulation_id      INT AUTO_INCREMENT PRIMARY KEY,
    vaccine_id           INT NOT NULL,
    formulation_code     VARCHAR(30) NOT NULL,
    dose_volume_ml        DECIMAL(5,2) NOT NULL,
    adjuvant             VARCHAR(100),
    storage_temp_celsius  DECIMAL(5,1) NOT NULL,
    route_of_administration ENUM('Intramuscular','Subcutaneous','Oral',
                                 'Intranasal') NOT NULL,
    formulation_date      DATE NOT NULL,
    doses_in_regimen      TINYINT NOT NULL DEFAULT 1,
    CONSTRAINT uq_formulation_code UNIQUE (formulation_code),
    CONSTRAINT fk_formulation_vaccine FOREIGN KEY (vaccine_id)
        REFERENCES vaccine_candidates (vaccine_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_formulation_dose CHECK (dose_volume_ml > 0),
    CONSTRAINT chk_formulation_regimen CHECK (doses_in_regimen BETWEEN 1 AND 10)
) ENGINE=InnoDB;

-- 7. BATCHES

CREATE TABLE batches (
    batch_id            INT AUTO_INCREMENT PRIMARY KEY,
    formulation_id       INT NOT NULL,
    batch_number         VARCHAR(30) NOT NULL,
    manufacture_date      DATE NOT NULL,
    expiry_date           DATE NOT NULL,
    quantity_produced     INT NOT NULL,
    quality_status        ENUM('Pending QC','Passed','Failed','Released',
                               'Recalled') NOT NULL DEFAULT 'Pending QC',
    manufacturing_site    VARCHAR(150) NOT NULL,
    CONSTRAINT uq_batch_number UNIQUE (batch_number),
    CONSTRAINT fk_batch_formulation FOREIGN KEY (formulation_id)
        REFERENCES formulations (formulation_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_batch_qty CHECK (quantity_produced > 0),
    CONSTRAINT chk_batch_dates CHECK (expiry_date > manufacture_date)
) ENGINE=InnoDB;

-- 8. PRECLINICAL_STUDIES

CREATE TABLE preclinical_studies (
    study_id             INT AUTO_INCREMENT PRIMARY KEY,
    vaccine_id            INT NOT NULL,
    researcher_id         INT NOT NULL,
    study_type            ENUM('In Vitro','Animal - Mouse','Animal - Rat',
                               'Animal - Non-human Primate','Animal - Other')
                               NOT NULL,
    start_date             DATE NOT NULL,
    end_date               DATE,
    immunogenicity_result  VARCHAR(200),
    safety_outcome         VARCHAR(200),
    outcome_summary        TEXT,
    CONSTRAINT fk_preclin_vaccine FOREIGN KEY (vaccine_id)
        REFERENCES vaccine_candidates (vaccine_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_preclin_researcher FOREIGN KEY (researcher_id)
        REFERENCES researchers (researcher_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_preclin_dates CHECK (end_date IS NULL OR end_date >= start_date)
) ENGINE=InnoDB;

-- 9. CLINICAL_STUDY_PHASES

CREATE TABLE clinical_study_phases (
    phase_id                  INT AUTO_INCREMENT PRIMARY KEY,
    vaccine_id                 INT NOT NULL,
    site_id                    INT NOT NULL,
    principal_investigator_id  INT NOT NULL,
    phase_number                ENUM('Phase I','Phase II','Phase III','Phase IV')
                                 NOT NULL,
    protocol_number              VARCHAR(30) NOT NULL,
    start_date                   DATE NOT NULL,
    end_date                     DATE,
    status                       ENUM('Planned','Recruiting','Active',
                                     'Completed','Terminated','Suspended')
                                     NOT NULL DEFAULT 'Planned',
    target_enrollment            INT NOT NULL,
    CONSTRAINT uq_protocol_number UNIQUE (protocol_number),
    CONSTRAINT fk_phase_vaccine FOREIGN KEY (vaccine_id)
        REFERENCES vaccine_candidates (vaccine_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_phase_site FOREIGN KEY (site_id)
        REFERENCES sites (site_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_phase_pi FOREIGN KEY (principal_investigator_id)
        REFERENCES researchers (researcher_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_phase_dates CHECK (end_date IS NULL OR end_date >= start_date),
    CONSTRAINT chk_phase_target CHECK (target_enrollment > 0)
) ENGINE=InnoDB;


-- 10. PARTICIPANTS

CREATE TABLE participants (
    participant_id       INT AUTO_INCREMENT PRIMARY KEY,
    anonymized_code       VARCHAR(20) NOT NULL,
    birth_year             YEAR NOT NULL,
    gender                 ENUM('Male','Female','Other','Prefer not to say')
                            NOT NULL,
    enrollment_site_id     INT NOT NULL,
    health_status_at_enrollment VARCHAR(150),
    CONSTRAINT uq_participant_code UNIQUE (anonymized_code),
    CONSTRAINT fk_participant_site FOREIGN KEY (enrollment_site_id)
        REFERENCES sites (site_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 11. PARTICIPANT_ENROLLMENTS (associative table -> resolves M:N)

CREATE TABLE participant_enrollments (
    enrollment_id     INT AUTO_INCREMENT PRIMARY KEY,
    participant_id     INT NOT NULL,
    phase_id            INT NOT NULL,
    enrollment_date      DATE NOT NULL,
    dose_number           TINYINT NOT NULL DEFAULT 1,
    arm                   ENUM('Vaccine','Placebo','Control') NOT NULL,
    withdrawal_date       DATE,
    withdrawal_reason     VARCHAR(200),
    CONSTRAINT uq_enrollment UNIQUE (participant_id, phase_id, dose_number),
    CONSTRAINT fk_enroll_participant FOREIGN KEY (participant_id)
        REFERENCES participants (participant_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_enroll_phase FOREIGN KEY (phase_id)
        REFERENCES clinical_study_phases (phase_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_withdrawal_date CHECK (withdrawal_date IS NULL
        OR withdrawal_date >= enrollment_date)
) ENGINE=InnoDB;

-- 12. LAB_TESTS

CREATE TABLE lab_tests (
    test_id          INT AUTO_INCREMENT PRIMARY KEY,
    enrollment_id      INT NOT NULL,
    technician_id       INT NOT NULL,
    test_type            ENUM('Antibody Titer','Neutralization Assay','PCR',
                              'ELISA','CBC','Liver Function Panel',
                              'Cytokine Panel') NOT NULL,
    test_date             DATE NOT NULL,
    result_value           DECIMAL(10,3) NOT NULL,
    unit                   VARCHAR(30) NOT NULL,
    reference_range        VARCHAR(50),
    result_flag             ENUM('Normal','Abnormal','Critical')
                             NOT NULL DEFAULT 'Normal',
    CONSTRAINT fk_test_enrollment FOREIGN KEY (enrollment_id)
        REFERENCES participant_enrollments (enrollment_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_test_technician FOREIGN KEY (technician_id)
        REFERENCES researchers (researcher_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_result_value CHECK (result_value >= 0)
) ENGINE=InnoDB;

-- 13. ADVERSE_EVENTS

CREATE TABLE adverse_events (
    event_id             INT AUTO_INCREMENT PRIMARY KEY,
    enrollment_id          INT NOT NULL,
    reported_by             INT NOT NULL,
    event_description        TEXT NOT NULL,
    severity                 ENUM('Mild','Moderate','Severe',
                                  'Life-threatening','Fatal') NOT NULL,
    onset_date                DATE NOT NULL,
    resolution_date            DATE,
    causality_assessment        ENUM('Unrelated','Unlikely','Possible',
                                     'Probable','Definite') NOT NULL,
    serious_event                 BOOLEAN NOT NULL DEFAULT FALSE,
    outcome                        VARCHAR(150),
    CONSTRAINT fk_ae_enrollment FOREIGN KEY (enrollment_id)
        REFERENCES participant_enrollments (enrollment_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_ae_researcher FOREIGN KEY (reported_by)
        REFERENCES researchers (researcher_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_ae_dates CHECK (resolution_date IS NULL
        OR resolution_date >= onset_date)
) ENGINE=InnoDB;

-- INDEXES

CREATE INDEX idx_vaccine_disease        ON vaccine_candidates (target_disease);
CREATE INDEX idx_vaccine_stage          ON vaccine_candidates (development_stage);
CREATE INDEX idx_phase_status           ON clinical_study_phases (status);
CREATE INDEX idx_ae_severity            ON adverse_events (severity);
CREATE INDEX idx_ae_onset_date          ON adverse_events (onset_date);
CREATE INDEX idx_labtest_type_date      ON lab_tests (test_type, test_date);
CREATE INDEX idx_batch_quality_status   ON batches (quality_status);

