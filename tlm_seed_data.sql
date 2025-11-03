-- TEAM LION MOTORSPORT - 37 PILOTI COMPLETI
INSERT INTO campionati (id, nome, descrizione, status, anno, data_inizio, data_fine) VALUES
(1, 'All Traction 4.0', 'Campionato principale 2025 con tutte le trazioni', 'Active', 2025, '2025-01-15', '2025-06-30'),
(2, 'Sprint Series 2025', 'Serie di gare sprint veloci', 'Upcoming', 2025, '2025-07-01', '2025-09-30'),
(3, 'Endurance Cup 2025', 'Gare di resistenza lunghe', 'Upcoming', 2025, '2025-10-01', '2025-12-31');

INSERT INTO piloti (id, nome, email, password_hash, psn_id, gt_id, numero_gara, categoria, ruolo) VALUES
(1, 'Mauro Di Bartolo', 'mauro.dibartolo@tlm.racing', '$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa', 'TLM_Sicily', 'M.Di Bartolo', 1, 'Ufficiali', 'manager'),
(2, 'Michael Mike91', 'michael.mike91@tlm.racing', '$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa', 'Mikedb_91_', 'TLM_Mike91', 3, 'Ufficiali', 'pilota'),
(3, 'Liberato', 'liberato@tlm.racing', '$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa', 'mark126p', 'TLM_mark126p', 4, 'Ufficiali', 'pilota'),
(4, 'Mirco', 'mirco@tlm.racing', '$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa', 'Miciona75', 'TLM_Miciona75', 5, 'Ufficiali', 'pilota'),
(5, 'Lorenzo', 'lorenzo@tlm.racing', '$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa', 'Parenji', 'TLM_Parenti', 8, 'Ufficiali', 'pilota'),
(6, 'Fabio', 'fabio@tlm.racing', '$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa', 'BOMBERDIMA75', 'TER_BOMBERDIMA75', 9, 'Ufficiali', 'pilota'),
(7, 'Luigi', 'luigi@tlm.racing', '$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa', 'Patanel86', 'TLM_PataneL86', 10, 'Ufficiali', 'pilota'),
(8, 'Alessandro', 'alessandro@tlm.racing', '$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa', 'Talsigiano', 'Talsigiano', 11, 'Ufficiali', 'pilota'),
(9, 'Simone', 'simone@tlm.racing', '$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa', 'isnotacrime', 'TLM_Isnotacrime', 13, 'Ufficiali', 'pilota'),
(10, 'Riccardo', 'riccardo.asti@gmail.com', '$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa', 'rikas78', 'RiKaS-78', 14, 'Ufficiali', 'manager'),
(11, 'Domenico', 'domenico@tlm.racing', '$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa', 'Thigo Durante', 'TLM_ThigoDurante', 21, 'Ufficiali', 'pilota'),
(12, 'Ulisse', 'ulisse@tlm.racing', '$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa', 'Ulix1990', 'TLM_Ulix1990', 22, 'Ufficiali', 'pilota'),
(13, 'Carlo', 'carlo@tlm.racing', '$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa', 'TLM_wid83', 'TLM_wid83', 23, 'Ufficiali', 'pilota'),
(14, 'Nicolò', 'nicolo@tlm.racing', '$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa', 'Nicopol46', 'TLM_Nicopol46', 24, 'Ufficiali', 'pilota'),
(15, 'Aldo', 'aldo@tlm.racing', '$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa', 'AldoBabyKiller', 'Babykiller', 25, 'Ufficiali', 'pilota'),
(16, 'Valerio', 'valerio@tlm.racing', '$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa', 'Verce90', 'TLM Verce90', 25, 'Ufficiali', 'pilota'),
(17, 'Steven', 'steven@tlm.racing', '$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa', 'Spake_Mosconi', 'TLM_Steven94', 27, 'Ufficiali', 'pilota'),
(18, 'Federico', 'federico@tlm.racing', '$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa', 'Febshy', 'TLM Febshy', 29, 'Ufficiali', 'pilota'),
(19, 'Paolo', 'paolo@tlm.racing', '$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa', 'Asseemazz', 'TLM_GAMΜΑ', 33, 'Ufficiali', 'pilota'),
(20, 'Nino', 'nino@tlm.racing', '$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa', 'TLM_SKIZ2034', 'TLM_SKIZ20 34', 34, 'Ufficiali', 'pilota'),
(21, 'Roberto', 'roberto@tlm.racing', '$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa', 'rupetheking', 'TLM-Rupetheking-', 44, 'Ufficiali', 'pilota'),
(22, 'Matteo', 'matteo@tlm.racing', '$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa', 'mattebenny', 'Benny89', 46, 'Ufficiali', 'pilota'),
(23, 'Fabio', 'fabio2@tlm.racing', '$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa', 'TLM_Fro51ni', 'TLM_Fro51ni', 51, 'Ufficiali', 'pilota'),
(24, 'Cristian', 'cristian@tlm.racing', '$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa', 'TLM_Kappa0973', 'TLM_Kappa', 53, 'Ufficiali', 'pilota'),
(25, 'Angelo', 'angelo@tlm.racing', '$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa', 'TLM_Buitre83GT', 'TLM_Proietti', 54, 'Ufficiali', 'pilota'),
(26, 'Donato', 'donato@tlm.racing', '$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa', 'TLM_dimaa66', 'SMI_Dimaaa_66', 66, 'Ufficiali', 'pilota'),
(27, 'Angelo', 'angelo2@tlm.racing', '$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa', 'CTR_jet-morello', 'TLM Jet-morello', 71, 'Ufficiali', 'pilota'),
(28, 'Tony', 'tony@tlm.racing', '$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa', 'Tonyroto74', 'Tonyroto', 74, 'Ufficiali', 'pilota'),
(29, 'Christian', 'chry@tlm.racing', '$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa', 'Chry-77', 'TLM_Chry77', 77, 'Ufficiali', 'pilota'),
(30, 'Massimo', 'massimo@tlm.racing', '$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa', 'Liotru1979', 'TLM Max', 79, 'Ufficiali', 'pilota'),
(31, 'Matteo', 'matteo2@tlm.racing', '$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa', 'Silentium884', 'TLM_Sile', 81, 'Ufficiali', 'pilota'),
(32, 'Michele', 'michele@tlm.racing', '$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa', 'XRUA85x', 'TLM_Le Rua', 85, 'Ufficiali', 'pilota'),
(33, 'Paolo', 'paolo2@tlm.racing', '$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa', 'selpa974', 'TLM_Selpa974_#88', 88, 'Ufficiali', 'pilota'),
(34, 'Emanuele', 'emanuele@tlm.racing', '$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa', 'Villab90', 'TLM_Villab90', 90, 'Ufficiali', 'pilota'),
(35, 'Antonio', 'antonio@tlm.racing', '$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa', 'TheGuarny', 'A. Guarnaccia', 92, 'Ufficiali', 'pilota'),
(36, 'Fabio', 'fabio3@tlm.racing', '$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa', 'Ctr_ocior-78', 'TLM-ocior78', 104, 'Ufficiali', 'pilota'),
(37, 'Roberto', 'roberto2@tlm.racing', '$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa', 'BobGre93', 'TLM_BobGre93', 112, 'Ufficiali', 'pilota');

INSERT INTO gare (id, campionato_id, numero_gara, nome, circuito, data_gara, durata_minuti, tipo_trazione, status, risultati_pubblicati) VALUES
(1, 1, 1, 'Gara 1 - Monza', 'Autodromo di Monza', '2025-01-20 20:00:00', 45, 'ALL', 'Completed', true),
(2, 1, 2, 'Gara 2 - Spa', 'Circuit de Spa-Francorchamps', '2025-02-10 20:00:00', 50, 'ALL', 'Completed', true),
(3, 1, 3, 'Gara 3 - Nürburgring', 'Nürburgring GP', '2025-03-15 20:00:00', 45, 'FWD', 'Scheduled', false),
(4, 1, 4, 'Gara 4 - Silverstone', 'Silverstone Circuit', '2025-04-12 20:00:00', 50, 'RWD', 'Scheduled', false),
(5, 1, 5, 'Gara 5 - Barcelona', 'Circuit de Barcelona-Catalunya', '2025-05-10 20:00:00', 45, 'AWD', 'Scheduled', false),
(6, 1, 6, 'Gara 6 - Le Mans', 'Circuit de la Sarthe', '2025-06-14 20:00:00', 60, 'ALL', 'Scheduled', false),
(7, 1, 7, 'Gara 7 - Suzuka', 'Suzuka Circuit', '2025-06-28 20:00:00', 50, 'ALL', 'Scheduled', false);

INSERT INTO risultati_gare (gara_id, pilota_id, posizione_partenza, posizione_finale, punti_assegnati, tempo_totale, giro_veloce, auto_utilizzata) VALUES
(1, 1, 2, 1, 25, '00:52:30.456', '02:18.123', 'Porsche 911 GT3 R'),
(1, 2, 1, 2, 18, '00:52:45.789', '02:17.890', 'BMW M4 GT3'),
(1, 3, 3, 3, 15, '00:53:10.234', '02:18.567', 'Audi R8 LMS'),
(1, 4, 5, 4, 12, '00:53:25.678', '02:19.234', 'Mercedes-AMG GT3'),
(1, 5, 4, 5, 10, '00:53:40.123', '02:19.890', 'Ferrari 488 GT3'),
(1, 6, 7, 6, 8, '00:54:05.456', '02:20.456', 'McLaren 720S GT3'),
(1, 7, 6, 7, 6, '00:54:20.789', '02:20.789', 'Lamborghini Huracan GT3'),
(1, 8, 9, 8, 4, '00:54:45.234', '02:21.234', 'Nissan GT-R GT3'),
(1, 9, 8, 9, 2, '00:55:10.567', '02:21.678', 'Honda NSX GT3'),
(1, 10, 10, 10, 1, '00:55:35.890', '02:22.123', 'Lexus RC F GT3'),
(2, 2, 2, 1, 25, '01:08:25.456', '02:42.123', 'BMW M4 GT3'),
(2, 3, 1, 2, 18, '01:08:40.789', '02:41.890', 'Audi R8 LMS'),
(2, 1, 3, 3, 15, '01:09:05.234', '02:43.567', 'Porsche 911 GT3 R'),
(2, 5, 4, 4, 12, '01:09:30.678', '02:44.234', 'Ferrari 488 GT3'),
(2, 4, 6, 5, 10, '01:09:55.123', '02:44.890', 'Mercedes-AMG GT3'),
(2, 7, 5, 6, 8, '01:10:20.456', '02:45.456', 'Lamborghini Huracan GT3'),
(2, 6, 8, 7, 6, '01:10:45.789', '02:46.789', 'McLaren 720S GT3'),
(2, 9, 7, 8, 4, '01:11:10.234', '02:47.234', 'Honda NSX GT3'),
(2, 8, 9, 9, 2, '01:11:35.567', '02:47.678', 'Nissan GT-R GT3'),
(2, 11, 10, 10, 1, '01:12:00.890', '02:48.123', 'Acura NSX GT3');

SELECT calcola_classifica(1);
SELECT aggiorna_statistiche_pilota(id) FROM piloti WHERE attivo = true;

INSERT INTO reclami (gara_id, reclamante_id, contro_pilota_id, tipo, giro, curva, descrizione, video_url, status) VALUES
(1, 5, 4, 'Contatto', 12, 'Parabolica', 'Contatto in frenata che mi ha fatto perdere una posizione', 'https://youtube.com/watch?v=example1', 'In esame'),
(2, 6, 7, 'Sorpasso Irregolare', 8, 'Eau Rouge', 'Sorpasso effettuato fuori pista senza restituire posizione', 'https://youtube.com/watch?v=example2', 'Accettato');

INSERT INTO penalita (reclamo_id, pilota_id, gara_id, tipo_penalita, valore, descrizione) VALUES
(2, 7, 2, 'Posizioni', 1, 'Penalità di 1 posizione per sorpasso fuori pista');

INSERT INTO eventi (titolo, descrizione, data_inizio, data_fine, tipo, luogo) VALUES
('Test Collettivo Pre-Stagione', 'Test con tutti i piloti per preparare All Traction 4.0', '2025-01-10 18:00:00', '2025-01-10 21:00:00', 'Test', 'Monza - Online'),
('Riunione Commissari Sportivi', 'Riunione mensile per discutere regolamento e casi', '2025-02-05 21:00:00', '2025-02-05 22:30:00', 'Riunione', 'Discord TLM'),
('Live Streaming Gara 3', 'Diretta Twitch della Gara 3 del campionato', '2025-03-15 19:45:00', '2025-03-15 21:30:00', 'Altro', 'Twitch');

SELECT setval('piloti_id_seq', (SELECT MAX(id) FROM piloti));
SELECT setval('campionati_id_seq', (SELECT MAX(id) FROM campionati));
SELECT setval('gare_id_seq', (SELECT MAX(id) FROM gare));
SELECT setval('risultati_gare_id_seq', (SELECT MAX(id) FROM risultati_gare));
SELECT setval('reclami_id_seq', (SELECT MAX(id) FROM reclami));
SELECT setval('penalita_id_seq', (SELECT MAX(id) FROM penalita));
SELECT setval('eventi_id_seq', (SELECT MAX(id) FROM eventi));
