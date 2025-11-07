-- ============================================
-- MIGRAZIONE DATABASE - Aggiunta Tabelle Mancanti
-- Team Lion Motorsport
-- ============================================

-- Aggiungi colonna creato_da alla tabella campionati
ALTER TABLE campionati ADD COLUMN IF NOT EXISTS creato_da INTEGER REFERENCES piloti(id) ON DELETE SET NULL;

-- Tabella Iscrizioni Campionati
CREATE TABLE IF NOT EXISTS iscrizioni_campionati (
    id SERIAL PRIMARY KEY,
    campionato_id INTEGER REFERENCES campionati(id) ON DELETE CASCADE,
    pilota_id INTEGER REFERENCES piloti(id) ON DELETE CASCADE,
    data_iscrizione TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    auto_scelta VARCHAR(100),
    status VARCHAR(50) DEFAULT 'Confermata' CHECK (status IN ('Confermata', 'In attesa', 'Cancellata')),
    note TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (campionato_id, pilota_id)
);

-- Tabella Documenti Campionato
CREATE TABLE IF NOT EXISTS documenti_campionato (
    id SERIAL PRIMARY KEY,
    campionato_id INTEGER REFERENCES campionati(id) ON DELETE CASCADE,
    titolo VARCHAR(255) NOT NULL,
    file_url TEXT NOT NULL,
    tipo VARCHAR(50) CHECK (tipo IN ('Regolamento', 'Calendario', 'Comunicato', 'Altro')),
    caricato_da INTEGER REFERENCES piloti(id) ON DELETE SET NULL,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabella Impostazioni Gara
CREATE TABLE IF NOT EXISTS impostazioni_gara (
    id SERIAL PRIMARY KEY,
    gara_id INTEGER REFERENCES gare(id) ON DELETE CASCADE UNIQUE,
    meteo VARCHAR(50) DEFAULT 'Variabile',
    durata_gara INTEGER DEFAULT 30,
    durata_qualifiche INTEGER DEFAULT 10,
    consumo_carburante VARCHAR(20) DEFAULT 'Normale',
    usura_gomme VARCHAR(20) DEFAULT 'Normale',
    tipo_partenza VARCHAR(50) DEFAULT 'Rolling Start',
    bop BOOLEAN DEFAULT true,
    danni VARCHAR(20) DEFAULT 'Realistici',
    penalita BOOLEAN DEFAULT true,
    modificato_da INTEGER REFERENCES piloti(id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indici per Performance
CREATE INDEX IF NOT EXISTS idx_iscrizioni_campionato ON iscrizioni_campionati(campionato_id);
CREATE INDEX IF NOT EXISTS idx_iscrizioni_pilota ON iscrizioni_campionati(pilota_id);
CREATE INDEX IF NOT EXISTS idx_documenti_campionato ON documenti_campionato(campionato_id);
CREATE INDEX IF NOT EXISTS idx_impostazioni_gara ON impostazioni_gara(gara_id);

-- Trigger per Update Timestamp
CREATE TRIGGER iscrizioni_update_timestamp BEFORE UPDATE ON iscrizioni_campionati
FOR EACH ROW EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER impostazioni_update_timestamp BEFORE UPDATE ON impostazioni_gara
FOR EACH ROW EXECUTE FUNCTION update_timestamp();

-- View Campionati con Iscritti
CREATE OR REPLACE VIEW v_campionati_iscritti AS
SELECT
    c.*,
    COUNT(i.id) as totale_iscritti,
    array_agg(p.nome) FILTER (WHERE p.id IS NOT NULL) as piloti_iscritti
FROM campionati c
LEFT JOIN iscrizioni_campionati i ON i.campionato_id = c.id
LEFT JOIN piloti p ON p.id = i.pilota_id
GROUP BY c.id
ORDER BY c.data_inizio DESC;

-- ============================================
-- DATI DI ESEMPIO PER LE NUOVE TABELLE
-- ============================================

-- Iscrizioni di esempio per All Traction 4.0
INSERT INTO iscrizioni_campionati (campionato_id, pilota_id, auto_scelta, status) VALUES
(1, 1, 'Porsche 911 GT3 R', 'Confermata'),
(1, 2, 'BMW M4 GT3', 'Confermata'),
(1, 3, 'Audi R8 LMS', 'Confermata'),
(1, 4, 'Mercedes-AMG GT3', 'Confermata'),
(1, 5, 'Ferrari 488 GT3', 'Confermata'),
(1, 10, 'Lexus RC F GT3', 'Confermata')
ON CONFLICT DO NOTHING;

-- Documenti di esempio
INSERT INTO documenti_campionato (campionato_id, titolo, file_url, tipo, caricato_da) VALUES
(1, 'Regolamento All Traction 4.0', 'https://tlm.racing/docs/regolamento-at40.pdf', 'Regolamento', 1),
(1, 'Calendario Gare 2025', 'https://tlm.racing/docs/calendario-2025.pdf', 'Calendario', 1),
(1, 'Comunicato #1 - BoP Update', 'https://tlm.racing/docs/comunicato-001.pdf', 'Comunicato', 1)
ON CONFLICT DO NOTHING;

-- Impostazioni per le gare programmate
INSERT INTO impostazioni_gara (gara_id, meteo, durata_gara, durata_qualifiche, consumo_carburante, usura_gomme, tipo_partenza, bop, danni, penalita, modificato_da) VALUES
(1, 'Sereno', 45, 10, 'Normale', 'Normale', 'Rolling Start', true, 'Realistici', true, 1),
(2, 'Variabile', 50, 12, 'Normale', 'Veloce', 'Rolling Start', true, 'Realistici', true, 1),
(3, 'Pioggia', 45, 10, 'Alto', 'Veloce', 'Standing Start', true, 'Pesanti', true, 1),
(4, 'Nuvoloso', 50, 10, 'Normale', 'Normale', 'Rolling Start', true, 'Realistici', true, 1),
(5, 'Sereno', 45, 10, 'Normale', 'Normale', 'Rolling Start', true, 'Leggeri', true, 1),
(6, 'Variabile', 60, 15, 'Alto', 'Veloce', 'Rolling Start', false, 'Realistici', true, 1),
(7, 'Sereno', 50, 12, 'Normale', 'Normale', 'Rolling Start', true, 'Realistici', true, 1)
ON CONFLICT DO NOTHING;

-- ============================================
-- MIGRAZIONE COMPLETATA
-- ============================================
