USE vaccine_rd_db;

-- 1. RESEARCHERS (10)

INSERT INTO researchers (first_name, last_name, role, institution, email, phone) VALUES
('Amina',  'El-Sayed', 'Principal Investigator', 'Cairo University Faculty of Medicine',      'a.elsayed@cufm.edu.eg',   '+20-100-111-2222'),
('Daniel', 'Osei',     'Study Coordinator',      'Kumasi Biomedical Research Center',         'd.osei@kbrc.gh',          '+233-24-555-1010'),
('Priya',  'Nair',     'Lab Technician',         'National Institute of Virology',            'p.nair@niv.in',           '+91-98-2233-4455'),
('Wei',    'Zhang',    'Data Manager',           'Shanghai Public Health Institute',          'w.zhang@sphi.cn',         '+86-136-0000-1111'),
('Fatima', 'Haddad',   'Safety Monitor',         'Beirut Clinical Research Center',           'f.haddad@bcrc.lb',        '+961-3-222-333'),
('Carlos', 'Mendes',   'Principal Investigator', 'Sao Paulo Vaccine Institute',                'c.mendes@spvi.br',        '+55-11-98888-7777'),
('Sara',   'Kowalski', 'Study Coordinator',      'Warsaw Medical University',                  's.kowalski@wmu.pl',       '+48-501-222-333'),
('Kenji',  'Watanabe', 'Lab Technician',         'Osaka Biotech Labs',                         'k.watanabe@obl.jp',       '+81-90-1234-5678'),
('Grace',  'Mwangi',   'Safety Monitor',         'Nairobi Research Hospital',                  'g.mwangi@nrh.ke',         '+254-71-234-5678'),
('Omar',   'Farouk',   'Principal Investigator', 'Alexandria Biomedical Center',                'o.farouk@abc.eg',         '+20-111-333-4444');

-- 2. SITES (10)

INSERT INTO sites (site_name, country, city, contact_person, contact_email, capacity) VALUES
('Cairo Clinical Research Center',   'Egypt',  'Cairo',      'Nourhan Aly',    'contact@ccrc.eg',    500),
('Kumasi Biomedical Trial Unit',     'Ghana',  'Kumasi',     'Kwame Boateng',  'contact@kbtu.gh',    300),
('Mumbai Vaccine Trial Center',      'India',  'Mumbai',     'Anjali Rao',     'contact@mvtc.in',    800),
('Shanghai Public Health Site',      'China',  'Shanghai',   'Li Wei',         'contact@sphs.cn',    600),
('Beirut Medical Research Site',     'Lebanon','Beirut',     'Rana Khalil',    'contact@bmrs.lb',    250),
('Sao Paulo Trial Center',           'Brazil', 'Sao Paulo',  'Bruno Alves',    'contact@sptc.br',    700),
('Warsaw Clinical Site',             'Poland', 'Warsaw',     'Anna Nowak',     'contact@wcs.pl',     400),
('Osaka Research Hospital',          'Japan',  'Osaka',      'Hiroshi Sato',   'contact@orh.jp',     450),
('Nairobi Trial Center',             'Kenya',  'Nairobi',    'Wanjiru Kamau',  'contact@ntc.ke',     350),
('Alexandria Research Site',         'Egypt',  'Alexandria', 'Youssef Adel',   'contact@ars.eg',     300);

-- 3. VACCINE_CANDIDATES (10)

INSERT INTO vaccine_candidates (candidate_code, name, target_disease, technology_platform, sponsor_organization, development_stage, date_initiated) VALUES
('VX-001', 'CoronaShield mRNA',   'COVID-19',      'mRNA',             'BioNova Therapeutics',   'Phase III',    '2022-01-15'),
('VX-002', 'InfluGuard-4',        'Influenza',     'Protein Subunit',  'GlobalVax Inc',          'Phase II',     '2022-05-10'),
('VX-003', 'MalariVec',           'Malaria',       'Viral Vector',     'TropiMed Research',      'Preclinical',  '2023-02-20'),
('VX-004', 'TBActiv',             'Tuberculosis',  'Live Attenuated',  'PulmoVax Labs',          'Phase I',      '2022-11-01'),
('VX-005', 'DengueGuard',         'Dengue Fever',  'Inactivated',      'TropiMed Research',      'Phase II',     '2021-09-12'),
('VX-006', 'HepaShield-B2',       'Hepatitis B',   'Protein Subunit',  'BioNova Therapeutics',   'Approved',     '2019-03-01'),
('VX-007', 'RSVax',               'RSV',           'mRNA',             'GlobalVax Inc',          'Phase III',    '2021-06-18'),
('VX-008', 'EbolaBar',            'Ebola',         'Viral Vector',     'OutbreakShield Inc',     'Phase I',      '2023-01-05'),
('VX-009', 'NoroBlock',           'Norovirus',     'VLP',              'GlobalVax Inc',          'Discovery',    '2024-01-10'),
('VX-010', 'ZikaDefend',          'Zika Virus',    'DNA',              'TropiMed Research',      'Discontinued', '2020-04-22');

-- 4. ANTIGENS (12)

INSERT INTO antigens (antigen_name, antigen_type, source_organism, description) VALUES
('Spike Protein S1',            'Protein',       'SARS-CoV-2',                      'Receptor-binding subunit used to elicit neutralizing antibodies.'),
('Spike Protein RBD',           'Protein',       'SARS-CoV-2',                      'Receptor binding domain, booster component.'),
('Hemagglutinin H3N2',          'Protein',       'Influenza A virus',               'Surface glycoprotein used for strain-specific immunity.'),
('Circumsporozoite Protein',    'Protein',       'Plasmodium falciparum',           'Major surface protein of the malaria sporozoite stage.'),
('Ag85B Antigen',               'Protein',       'Mycobacterium tuberculosis',      'Secreted mycolyltransferase, strong T-cell immunogen.'),
('Dengue Envelope Protein',     'Protein',       'Dengue virus serotype 2',         'Envelope glycoprotein used for tetravalent immunity.'),
('Hepatitis B Surface Antigen', 'Protein',       'Hepatitis B virus',               'Classic recombinant HBV surface antigen.'),
('RSV Fusion Protein (F)',      'Protein',       'Respiratory syncytial virus',     'Prefusion-stabilized fusion glycoprotein.'),
('Ebola Glycoprotein',          'Vector-based',  'Zaire ebolavirus',                'Surface glycoprotein delivered via viral vector.'),
('Norovirus VLP Capsid',        'Protein',       'Norovirus GII.4',                 'Virus-like particle capsid protein.'),
('Zika Envelope Protein',       'DNA',           'Zika virus',                      'DNA-encoded envelope protein construct.'),
('Hemagglutinin H1N1',          'Protein',       'Influenza A virus',               'Second strain component for broader flu coverage.');

-- 5. VACCINE_ANTIGENS (13) -- M:N junction

INSERT INTO vaccine_antigens (vaccine_id, antigen_id, concentration_ug, role_in_formulation) VALUES
(1, 1, 30.000, 'Primary immunogen'),
(1, 2, 10.000, 'Booster component'),
(2, 3, 15.000, 'Primary immunogen'),
(2, 12, 15.000, 'Secondary strain component'),
(3, 4, 20.000, 'Primary immunogen'),
(4, 5, 25.000, 'Primary immunogen'),
(5, 6, 12.500, 'Primary immunogen'),
(6, 7, 20.000, 'Primary immunogen'),
(7, 8, 30.000, 'Primary immunogen'),
(8, 9, 5.000,  'Primary immunogen'),
(9, 10, 10.000,'Primary immunogen'),
(10, 11, 8.000,'Primary immunogen'),
(10, 2, 5.000, 'Cross-reactivity booster');

-- 6. FORMULATIONS (12)

INSERT INTO formulations (vaccine_id, formulation_code, dose_volume_ml, adjuvant, storage_temp_celsius, route_of_administration, formulation_date, doses_in_regimen) VALUES
(1,  'FRM-001', 0.30, 'Lipid Nanoparticle', -70.0, 'Intramuscular', '2022-01-20', 2),
(1,  'FRM-002', 0.10, 'Lipid Nanoparticle', -70.0, 'Intramuscular', '2022-06-01', 2),
(2,  'FRM-003', 0.50, 'Alum Adjuvant',        4.0, 'Intramuscular', '2022-05-15', 1),
(3,  'FRM-004', 0.50, 'AS01 Adjuvant',        4.0, 'Intramuscular', '2023-03-01', 3),
(4,  'FRM-005', 0.10, NULL,                   4.0, 'Subcutaneous',  '2022-11-10', 1),
(5,  'FRM-006', 0.50, 'Alum Adjuvant',        4.0, 'Subcutaneous',  '2021-09-20', 3),
(6,  'FRM-007', 1.00, 'Alum Adjuvant',        4.0, 'Intramuscular', '2019-03-10', 3),
(6,  'FRM-008', 0.50, 'Alum Adjuvant',        4.0, 'Intramuscular', '2019-04-01', 3),
(7,  'FRM-009', 0.50, 'Lipid Nanoparticle',  -20.0, 'Intramuscular', '2021-07-01', 2),
(8,  'FRM-010', 1.00, NULL,                   4.0, 'Intramuscular', '2023-01-15', 1),
(9,  'FRM-011', 0.50, 'AS03 Adjuvant',        4.0, 'Oral',          '2024-02-01', 2),
(10, 'FRM-012', 0.50, NULL,                   4.0, 'Intramuscular', '2020-05-01', 2);

-- 7. BATCHES (15)

INSERT INTO batches (formulation_id, batch_number, manufacture_date, expiry_date, quantity_produced, quality_status, manufacturing_site) VALUES
(1,  'BX-2022-0001', '2022-02-01', '2023-02-01', 50000, 'Released', 'BioNova Plant - Cairo'),
(1,  'BX-2022-0002', '2022-07-01', '2023-07-01', 60000, 'Released', 'BioNova Plant - Cairo'),
(2,  'BX-2022-0003', '2022-06-15', '2023-06-15', 20000, 'Passed',   'BioNova Plant - Cairo'),
(3,  'BX-2022-0004', '2022-06-01', '2023-12-01', 35000, 'Released', 'GlobalVax Plant - Warsaw'),
(4,  'BX-2023-0005', '2023-03-15', '2024-03-15',  8000, 'Pending QC','TropiMed Pilot Plant'),
(5,  'BX-2022-0006', '2022-11-20', '2023-11-20', 10000, 'Passed',   'PulmoVax Plant - Kumasi'),
(6,  'BX-2021-0007', '2021-10-01', '2022-10-01', 40000, 'Released', 'TropiMed Plant - Sao Paulo'),
(6,  'BX-2022-0008', '2022-04-01', '2023-04-01', 42000, 'Recalled', 'TropiMed Plant - Sao Paulo'),
(7,  'BX-2019-0009', '2019-04-01', '2022-04-01',100000, 'Released', 'BioNova Plant - Cairo'),
(8,  'BX-2019-0010', '2019-05-01', '2022-05-01', 80000, 'Released', 'BioNova Plant - Cairo'),
(9,  'BX-2021-0011', '2021-08-01', '2022-08-01', 55000, 'Released', 'GlobalVax Plant - Osaka'),
(10, 'BX-2023-0012', '2023-02-01', '2024-02-01',  5000, 'Failed',   'OutbreakShield Pilot Plant'),
(11, 'BX-2024-0013', '2024-03-01', '2025-03-01',  3000, 'Pending QC','GlobalVax Plant - Warsaw'),
(12, 'BX-2020-0014', '2020-06-01', '2021-06-01', 15000, 'Recalled', 'TropiMed Plant - Sao Paulo'),
(12, 'BX-2020-0015', '2020-09-01', '2021-09-01', 12000, 'Recalled', 'TropiMed Plant - Sao Paulo');

-- 8. PRECLINICAL_STUDIES (12)

INSERT INTO preclinical_studies (vaccine_id, researcher_id, study_type, start_date, end_date, immunogenicity_result, safety_outcome, outcome_summary) VALUES
(1,  3, 'Animal - Mouse',              '2020-03-01', '2020-06-01', 'Strong neutralizing antibody titers', 'No adverse findings',        'Supported advancement to Phase I trials.'),
(1,  8, 'Animal - Non-human Primate',  '2020-07-01', '2020-10-15', 'Robust T-cell and antibody response', 'Mild injection-site reaction','Confirmed dose selection for human trials.'),
(2,  3, 'Animal - Mouse',              '2022-01-10', '2022-03-20', 'Moderate antibody response',          'No adverse findings',        'Proceeded to Phase I with adjuvant optimization.'),
(3,  8, 'In Vitro',                    '2023-02-25', '2023-04-10', 'Promising sporozoite neutralization', 'Not applicable',             'In vitro results support animal testing.'),
(3,  3, 'Animal - Mouse',              '2023-04-15', '2023-07-01', 'Partial protection observed',         'No adverse findings',        'Further formulation optimization required.'),
(4,  8, 'Animal - Rat',                '2022-01-05', '2022-04-05', 'Sustained cellular immunity',         'No adverse findings',        'Supported IND application.'),
(5,  3, 'Animal - Non-human Primate',  '2020-10-01', '2021-02-01', 'High neutralizing titers vs all 4 serotypes','No adverse findings',  'Advanced to human trials.'),
(6,  8, 'Animal - Mouse',              '2017-01-01', '2017-05-01', 'Seroconversion in 98% of subjects',   'No adverse findings',        'Historical study supporting original approval.'),
(7,  3, 'Animal - Non-human Primate',  '2020-01-15', '2020-06-01', 'Strong protective response',          'No adverse findings',        'Supported progression to Phase I.'),
(8,  8, 'Animal - Non-human Primate',  '2022-05-01', '2022-09-01', 'High survival rate post-challenge',   'Mild fever observed',        'Supported emergency-use pathway discussion.'),
(9,  3, 'In Vitro',                    '2024-01-15', '2024-03-01', 'Positive VLP binding assay results',  'Not applicable',             'Planning animal studies next.'),
(10, 8, 'Animal - Mouse',              '2019-06-01', '2019-09-01', 'Weak immunogenicity',                 'No adverse findings',        'Program discontinued due to low efficacy.');

-- 9. CLINICAL_STUDY_PHASES (13)

INSERT INTO clinical_study_phases (vaccine_id, site_id, principal_investigator_id, phase_number, protocol_number, start_date, end_date, status, target_enrollment) VALUES
(1, 1,  1,  'Phase I',   'PR-VX001-1', '2021-06-01', '2021-09-01', 'Completed', 50),
(1, 1,  1,  'Phase II',  'PR-VX001-2', '2021-10-01', '2022-01-15', 'Completed', 200),
(1, 3,  6,  'Phase III', 'PR-VX001-3', '2022-02-01', NULL,         'Active',    3000),
(2, 10, 10, 'Phase I',   'PR-VX002-1', '2022-06-01', '2022-08-15', 'Completed', 60),
(2, 10, 10, 'Phase II',  'PR-VX002-2', '2022-09-01', NULL,         'Recruiting',300),
(4, 2,  1,  'Phase I',   'PR-VX004-1', '2022-12-01', NULL,         'Active',    40),
(5, 6,  6,  'Phase I',   'PR-VX005-1', '2021-10-01', '2022-01-01', 'Completed', 45),
(5, 6,  6,  'Phase II',  'PR-VX005-2', '2022-02-01', '2022-08-01', 'Completed', 250),
(6, 1,  1,  'Phase III', 'PR-VX006-3', '2017-06-01', '2018-06-01', 'Completed', 5000),
(6, 1,  1,  'Phase IV',  'PR-VX006-4', '2019-06-01', NULL,         'Active',    10000),
(7, 9,  10, 'Phase II',  'PR-VX007-2', '2020-08-01', '2021-01-01', 'Completed', 300),
(7, 9,  10, 'Phase III', 'PR-VX007-3', '2021-02-01', NULL,         'Active',    2500),
(8, 2,  6,  'Phase I',   'PR-VX008-1', '2023-02-01', NULL,         'Recruiting',30);

-- 10. PARTICIPANTS (20) -- anonymized, no directly identifying data

INSERT INTO participants (anonymized_code, birth_year, gender, enrollment_site_id, health_status_at_enrollment) VALUES
('PT-0001', 1990, 'Female', 1,  'Healthy adult volunteer'),
('PT-0002', 1985, 'Male',   1,  'Healthy adult volunteer'),
('PT-0003', 1978, 'Male',   3,  'Controlled hypertension'),
('PT-0004', 1995, 'Female', 3,  'Healthy adult volunteer'),
('PT-0005', 2000, 'Other',  10, 'Healthy adult volunteer'),
('PT-0006', 1988, 'Female', 10, 'Healthy adult volunteer'),
('PT-0007', 1975, 'Male',   2,  'Type 2 diabetes, controlled'),
('PT-0008', 1993, 'Female', 2,  'Healthy adult volunteer'),
('PT-0009', 1982, 'Male',   6,  'Healthy adult volunteer'),
('PT-0010', 1998, 'Female', 6,  'Healthy adult volunteer'),
('PT-0011', 1970, 'Male',   1,  'Healthy adult volunteer'),
('PT-0012', 1991, 'Female', 1,  'Mild asthma'),
('PT-0013', 1986, 'Male',   9,  'Healthy adult volunteer'),
('PT-0014', 1996, 'Female', 9,  'Healthy adult volunteer'),
('PT-0015', 1980, 'Male',   9,  'Healthy adult volunteer'),
('PT-0016', 1992, 'Female', 2,  'Healthy adult volunteer'),
('PT-0017', 1965, 'Male',   6,  'Controlled hypertension'),
('PT-0018', 1999, 'Prefer not to say', 10, 'Healthy adult volunteer'),
('PT-0019', 1989, 'Female', 3,  'Healthy adult volunteer'),
('PT-0020', 1977, 'Male',   3,  'Healthy adult volunteer');

-- 11. PARTICIPANT_ENROLLMENTS (25) -- M:N junction

INSERT INTO participant_enrollments (participant_id, phase_id, enrollment_date, dose_number, arm, withdrawal_date, withdrawal_reason) VALUES
(1,  1, '2021-06-05', 1, 'Vaccine', NULL, NULL),
(1,  2, '2021-10-05', 1, 'Vaccine', NULL, NULL),
(2,  1, '2021-06-05', 1, 'Placebo', NULL, NULL),
(11, 2, '2021-10-06', 1, 'Vaccine', NULL, NULL),
(12, 2, '2021-10-06', 1, 'Placebo', '2021-11-20', 'Moved out of study area'),
(3,  3, '2022-02-10', 1, 'Vaccine', NULL, NULL),
(4,  3, '2022-02-10', 1, 'Vaccine', NULL, NULL),
(19, 3, '2022-02-11', 1, 'Placebo', NULL, NULL),
(20, 3, '2022-02-11', 1, 'Vaccine', NULL, NULL),
(5,  4, '2022-06-05', 1, 'Vaccine', NULL, NULL),
(6,  4, '2022-06-05', 1, 'Placebo', NULL, NULL),
(18, 5, '2022-09-10', 1, 'Vaccine', NULL, NULL),
(5,  5, '2022-09-10', 1, 'Vaccine', NULL, NULL),
(7,  6, '2022-12-05', 1, 'Vaccine', NULL, NULL),
(16, 6, '2022-12-05', 1, 'Placebo', NULL, NULL),
(9,  7, '2021-10-05', 1, 'Vaccine', NULL, NULL),
(10, 7, '2021-10-05', 1, 'Placebo', NULL, NULL),
(9,  8, '2022-02-05', 2, 'Vaccine', NULL, NULL),
(17, 8, '2022-02-06', 1, 'Vaccine', '2022-03-01', 'Adverse event unrelated to withdrawal'),
(13, 11,'2020-08-05', 1, 'Vaccine', NULL, NULL),
(14, 11,'2020-08-05', 1, 'Control', NULL, NULL),
(13, 12,'2021-02-05', 2, 'Vaccine', NULL, NULL),
(15, 12,'2021-02-06', 1, 'Vaccine', NULL, NULL),
(8,  13,'2023-02-10', 1, 'Vaccine', NULL, NULL),
(16, 13,'2023-02-11', 1, 'Placebo', NULL, NULL);

-- 12. LAB_TESTS (30)

INSERT INTO lab_tests (enrollment_id, technician_id, test_type, test_date, result_value, unit, reference_range, result_flag) VALUES
(1,  3, 'Antibody Titer',        '2021-07-05', 512.000, 'titer',   '<16 negative',   'Normal'),
(2,  3, 'Antibody Titer',        '2021-11-05', 2048.000,'titer',   '<16 negative',   'Normal'),
(3,  3, 'Antibody Titer',        '2021-07-05', 12.000,  'titer',   '<16 negative',   'Normal'),
(4,  8, 'Neutralization Assay',  '2021-11-06', 640.000, 'titer',   '<20 negative',   'Normal'),
(5,  8, 'Neutralization Assay',  '2021-11-06', 8.000,   'titer',   '<20 negative',   'Normal'),
(6,  3, 'PCR',                   '2022-02-15', 0.000,   'copies/ml','negative',      'Normal'),
(7,  3, 'PCR',                   '2022-02-15', 0.000,   'copies/ml','negative',      'Normal'),
(8,  8, 'ELISA',                 '2022-02-16', 1.850,   'OD',      '<0.5 negative',  'Abnormal'),
(9,  8, 'ELISA',                 '2022-02-16', 0.900,   'OD',      '<0.5 negative',  'Abnormal'),
(10, 3, 'CBC',                   '2022-06-10', 5.400,   '10^9/L',  '4.0-11.0',       'Normal'),
(11, 3, 'CBC',                   '2022-06-10', 5.900,   '10^9/L',  '4.0-11.0',       'Normal'),
(12, 8, 'Antibody Titer',        '2022-10-01', 1024.000,'titer',   '<16 negative',   'Normal'),
(13, 8, 'Antibody Titer',        '2022-10-01', 890.000, 'titer',   '<16 negative',   'Normal'),
(14, 3, 'Liver Function Panel',  '2023-01-05', 32.000,  'U/L',     '7-56',           'Normal'),
(15, 3, 'Liver Function Panel',  '2023-01-05', 60.000,  'U/L',     '7-56',           'Abnormal'),
(16, 8, 'Cytokine Panel',        '2021-10-20', 14.200,  'pg/mL',   '<10',            'Abnormal'),
(17, 8, 'Cytokine Panel',        '2021-10-20', 6.500,   'pg/mL',   '<10',            'Normal'),
(18, 3, 'Antibody Titer',        '2022-03-01', 2048.000,'titer',   '<16 negative',   'Normal'),
(19, 3, 'Antibody Titer',        '2022-03-15', 1512.000,'titer',   '<16 negative',   'Normal'),
(20, 8, 'ELISA',                 '2020-09-05', 2.100,   'OD',      '<0.5 negative',  'Abnormal'),
(21, 8, 'ELISA',                 '2020-09-05', 0.300,   'OD',      '<0.5 negative',  'Normal'),
(22, 3, 'Antibody Titer',        '2021-03-01', 3096.000,'titer',   '<16 negative',   'Normal'),
(23, 3, 'Antibody Titer',        '2021-03-02', 2500.000,'titer',   '<16 negative',   'Normal'),
(24, 8, 'PCR',                   '2023-03-01', 0.000,   'copies/ml','negative',      'Normal'),
(25, 8, 'PCR',                   '2023-03-01', 150.000, 'copies/ml','negative',      'Critical'),
(1,  3, 'CBC',                   '2021-06-06', 6.100,   '10^9/L',  '4.0-11.0',       'Normal'),
(6,  8, 'CBC',                   '2022-02-16', 5.700,   '10^9/L',  '4.0-11.0',       'Normal'),
(9,  3, 'Neutralization Assay',  '2022-02-17', 512.000, 'titer',   '<20 negative',   'Normal'),
(13, 8, 'CBC',                   '2022-10-02', 5.200,   '10^9/L',  '4.0-11.0',       'Normal'),
(24, 3, 'CBC',                   '2023-03-02', 5.800,   '10^9/L',  '4.0-11.0',       'Normal');

-- 13. ADVERSE_EVENTS (15)

INSERT INTO adverse_events (enrollment_id, reported_by, event_description, severity, onset_date, resolution_date, causality_assessment, serious_event, outcome) VALUES
(1,  5, 'Pain and redness at injection site',        'Mild',     '2021-06-06', '2021-06-09', 'Probable',  FALSE, 'Resolved without treatment'),
(4,  5, 'Low-grade fever for 24 hours',               'Mild',     '2021-10-07', '2021-10-08', 'Probable',  FALSE, 'Resolved without treatment'),
(5,  9, 'Fatigue and headache',                       'Moderate', '2021-10-08', '2021-10-12', 'Possible',  FALSE, 'Resolved with OTC medication'),
(8,  5, 'Severe allergic reaction requiring epinephrine','Severe','2022-02-17', '2022-02-18', 'Definite',  TRUE,  'Resolved after treatment, withdrawn from study'),
(9,  9, 'Myalgia and chills',                         'Mild',     '2022-02-17', '2022-02-19', 'Probable',  FALSE, 'Resolved without treatment'),
(12, 5, 'Injection-site swelling',                    'Mild',     '2022-10-05', '2022-10-08', 'Probable',  FALSE, 'Resolved without treatment'),
(15, 9, 'Elevated liver enzymes noted on routine test','Moderate','2023-01-05', NULL,         'Possible',  FALSE, 'Under monitoring'),
(16, 5, 'Nausea and dizziness',                       'Mild',     '2021-10-21', '2021-10-22', 'Possible',  FALSE, 'Resolved without treatment'),
(19, 9, 'Hospitalization for chest pain (unrelated cardiac event)','Life-threatening','2022-03-01', '2022-03-10', 'Unrelated', TRUE, 'Recovered, withdrawn from study'),
(20, 5, 'Fatigue lasting 2 days',                     'Mild',     '2020-08-06', '2020-08-08', 'Probable',  FALSE, 'Resolved without treatment'),
(22, 9, 'Localized rash',                             'Mild',     '2021-02-06', '2021-02-10', 'Possible',  FALSE, 'Resolved without treatment'),
(24, 5, 'Joint pain following vaccination',           'Moderate', '2023-02-11', '2023-02-16', 'Possible',  FALSE, 'Resolved with OTC medication'),
(2,  9, 'Mild fever after second dose',               'Mild',     '2021-10-06', '2021-10-07', 'Probable',  FALSE, 'Resolved without treatment'),
(13, 5, 'Severe fatigue and muscle weakness',         'Severe',   '2022-12-06', '2022-12-14', 'Possible',  TRUE,  'Resolved after 8 days, continued in study'),
(25, 9, 'Injection-site pain',                        'Mild',     '2023-02-12', '2023-02-13', 'Probable',  FALSE, 'Resolved without treatment');

