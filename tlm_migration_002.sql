-- ============================================
-- MIGRAZIONE 002 - Lions on Fire + Comunicazioni + Allenamenti
-- Team Lion Motorsport
-- ============================================

-- Tabella Comunicazioni/Avvisi Importanti
CREATE TABLE IF NOT EXISTS comunicazioni (
    id SERIAL PRIMARY KEY,
    titolo VARCHAR(255) NOT NULL,
    messaggio TEXT NOT NULL,
    tipo VARCHAR(50) DEFAULT 'Info' CHECK (tipo IN ('Info', 'Avviso', 'Urgente', 'Evento')),
    priorita INTEGER DEFAULT 0,
    attiva BOOLEAN DEFAULT true,
    data_inizio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_fine TIMESTAMP,
    creato_da INTEGER REFERENCES piloti(id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabella Allenamenti
CREATE TABLE IF NOT EXISTS allenamenti (
    id SERIAL PRIMARY KEY,
    titolo VARCHAR(255) NOT NULL,
    descrizione TEXT,
    data_allenamento TIMESTAMP NOT NULL,
    durata_minuti INTEGER DEFAULT 60,
    circuito VARCHAR(255),
    tipo_trazione VARCHAR(50),
    max_partecipanti INTEGER,
    canale_streaming VARCHAR(255),
    status VARCHAR(50) DEFAULT 'Programmato' CHECK (status IN ('Programmato', 'In corso', 'Completato', 'Cancellato')),
    creato_da INTEGER REFERENCES piloti(id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabella Iscrizioni Allenamenti
CREATE TABLE IF NOT EXISTS iscrizioni_allenamenti (
    id SERIAL PRIMARY KEY,
    allenamento_id INTEGER REFERENCES allenamenti(id) ON DELETE CASCADE,
    pilota_id INTEGER REFERENCES piloti(id) ON DELETE CASCADE,
    auto_scelta VARCHAR(100),
    note TEXT,
    data_iscrizione TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (allenamento_id, pilota_id)
);

-- Tabella Lions on Fire (gare del giorno + streaming)
CREATE TABLE IF NOT EXISTS lions_on_fire (
    id SERIAL PRIMARY KEY,
    gara_id INTEGER REFERENCES gare(id) ON DELETE CASCADE UNIQUE,
    canale_streaming VARCHAR(255) NOT NULL,
    descrizione TEXT,
    data_inizio TIMESTAMP NOT NULL,
    data_fine TIMESTAMP NOT NULL,
    attivo BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indici
CREATE INDEX IF NOT EXISTS idx_comunicazioni_attiva ON comunicazioni(attiva, data_inizio, data_fine);
CREATE INDEX IF NOT EXISTS idx_comunicazioni_tipo ON comunicazioni(tipo);
CREATE INDEX IF NOT EXISTS idx_allenamenti_data ON allenamenti(data_allenamento);
CREATE INDEX IF NOT EXISTS idx_allenamenti_status ON allenamenti(status);
CREATE INDEX IF NOT EXISTS idx_iscrizioni_allenamenti_allenamento ON iscrizioni_allenamenti(allenamento_id);
CREATE INDEX IF NOT EXISTS idx_iscrizioni_allenamenti_pilota ON iscrizioni_allenamenti(pilota_id);
CREATE INDEX IF NOT EXISTS idx_lions_on_fire_attivo ON lions_on_fire(attivo, data_inizio, data_fine);

-- Triggers
CREATE TRIGGER comunicazioni_update_timestamp BEFORE UPDATE ON comunicazioni
FOR EACH ROW EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER allenamenti_update_timestamp BEFORE UPDATE ON allenamenti
FOR EACH ROW EXECUTE FUNCTION update_timestamp();

-- View: Lions on Fire attivi (piloti che corrono oggi)
CREATE OR REPLACE VIEW v_lions_on_fire_oggi AS
SELECT
    lof.*,
    g.nome as gara_nome,
    g.circuito,
    g.data_gara,
    c.nome as campionato_nome,
    (SELECT COUNT(*) FROM iscrizioni_gara ig WHERE ig.gara_id = g.id) as totale_iscritti,
    array_agg(p.nome || ' (' || p.psn_id || ')') FILTER (WHERE p.id IS NOT NULL) as piloti_iscritti
FROM lions_on_fire lof
JOIN gare g ON g.id = lof.gara_id
JOIN campionati c ON c.id = g.campionato_id
LEFT JOIN iscrizioni_gara ig ON ig.gara_id = g.id
LEFT JOIN piloti p ON p.id = ig.pilota_id
WHERE lof.attivo = true
  AND CURRENT_TIMESTAMP >= lof.data_inizio
  AND CURRENT_TIMESTAMP <= lof.data_fine
GROUP BY lof.id, g.id, c.id;

-- View: Prossimi Allenamenti
CREATE OR REPLACE VIEW v_prossimi_allenamenti AS
SELECT
    a.*,
    COUNT(ia.id) as totale_iscritti,
    array_agg(p.nome) FILTER (WHERE p.id IS NOT NULL) as piloti_iscritti
FROM allenamenti a
LEFT JOIN iscrizioni_allenamenti ia ON ia.allenamento_id = a.id
LEFT JOIN piloti p ON p.id = ia.pilota_id
WHERE a.status = 'Programmato'
  AND a.data_allenamento > CURRENT_TIMESTAMP
GROUP BY a.id
ORDER BY a.data_allenamento ASC
LIMIT 10;

-- Funzione: Gestione automatica status allenamenti
CREATE OR REPLACE FUNCTION aggiorna_status_allenamenti()
RETURNS void AS $$
BEGIN
    -- Segna come completati gli allenamenti finiti
    UPDATE allenamenti
    SET status = 'Completato'
    WHERE status = 'Programmato'
      AND data_allenamento + (durata_minuti || ' minutes')::INTERVAL < CURRENT_TIMESTAMP;

    -- Segna come in corso gli allenamenti in svolgimento
    UPDATE allenamenti
    SET status = 'In corso'
    WHERE status = 'Programmato'
      AND data_allenamento <= CURRENT_TIMESTAMP
      AND data_allenamento + (durata_minuti || ' minutes')::INTERVAL >= CURRENT_TIMESTAMP;
END;
$$ LANGUAGE plpgsql;

-- Funzione: Disattiva automaticamente Lions on Fire scaduti
CREATE OR REPLACE FUNCTION disattiva_lions_on_fire_scaduti()
RETURNS void AS $$
BEGIN
    UPDATE lions_on_fire
    SET attivo = false
    WHERE attivo = true
      AND data_fine < CURRENT_TIMESTAMP;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- DATI DI ESEMPIO
-- ============================================

-- Comunicazioni di esempio
INSERT INTO comunicazioni (titolo, messaggio, tipo, priorita, creato_da) VALUES
('Benvenuto su Team Lion Motorsport!', 'Benvenuto nella nuova piattaforma TLM. Qui troverai tutte le informazioni sui campionati, classifiche e eventi.', 'Info', 1, 1),
('Nuovo Campionato All Traction 5.0', 'È stato annunciato il nuovo campionato All Traction 5.0! Iscriviti ora per partecipare.', 'Evento', 3, 1),
('Manutenzione Server - Domenica 15/12', 'Domenica 15 dicembre dalle 03:00 alle 06:00 i server saranno in manutenzione.', 'Avviso', 2, 1)
ON CONFLICT DO NOTHING;

-- Allenamenti di esempio
INSERT INTO allenamenti (titolo, descrizione, data_allenamento, durata_minuti, circuito, tipo_trazione, max_partecipanti, canale_streaming, creato_da) VALUES
('Allenamento Pre-Gara Monza', 'Allenamento collettivo in preparazione alla gara di Monza', '2025-01-18 19:00:00', 90, 'Autodromo di Monza', 'ALL', 20, 'https://twitch.tv/teamlionmotorsport', 1),
('Test Setup Spa', 'Sessione di test per provare i setup su Spa', '2025-01-19 20:00:00', 60, 'Spa-Francorchamps', 'RWD', 15, 'https://twitch.tv/teamlionmotorsport', 1),
('Allenamento Libero Nürburgring', 'Sessione libera per provare il circuito', '2025-01-20 18:00:00', 120, 'Nürburgring GP', 'FWD', 25, '', 1)
ON CONFLICT DO NOTHING;

-- Lions on Fire di esempio (gara di oggi)
-- Nota: Questo va aggiornato manualmente o tramite script il giorno della gara
INSERT INTO lions_on_fire (gara_id, canale_streaming, descrizione, data_inizio, data_fine)
SELECT
    id,
    'https://twitch.tv/teamlionmotorsport',
    'Segui la gara in diretta sul nostro canale Twitch!',
    data_gara - INTERVAL '30 minutes',
    data_gara + INTERVAL '23 hours 30 minutes'
FROM gare
WHERE id = 1
ON CONFLICT DO NOTHING;

-- Iscrizioni allenamenti di esempio
INSERT INTO iscrizioni_allenamenti (allenamento_id, pilota_id, auto_scelta) VALUES
(1, 1, 'Porsche 911 GT3 R'),
(1, 2, 'BMW M4 GT3'),
(1, 10, 'Lexus RC F GT3'),
(2, 1, 'Ferrari 488 GT3'),
(2, 3, 'Audi R8 LMS')
ON CONFLICT DO NOTHING;

-- ============================================
-- MIGRAZIONE COMPLETATA
-- ============================================
