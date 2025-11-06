-- ============================================
-- TEAM LION MOTORSPORT - DATABASE SCHEMA
-- PostgreSQL Database
-- ============================================

-- Drop esistenti (per fresh install)
DROP TABLE IF EXISTS api_endpoint_costs CASCADE;
DROP TABLE IF EXISTS api_credit_recharges CASCADE;
DROP TABLE IF EXISTS api_usage CASCADE;
DROP TABLE IF EXISTS api_credits CASCADE;
DROP TABLE IF EXISTS impostazioni_gara CASCADE;
DROP TABLE IF EXISTS documenti_campionato CASCADE;
DROP TABLE IF EXISTS iscrizioni_campionati CASCADE;
DROP TABLE IF EXISTS log_attivita CASCADE;
DROP TABLE IF EXISTS notifiche CASCADE;
DROP TABLE IF EXISTS sessioni CASCADE;
DROP TABLE IF EXISTS penalita CASCADE;
DROP TABLE IF EXISTS reclami CASCADE;
DROP TABLE IF EXISTS statistiche_piloti CASCADE;
DROP TABLE IF EXISTS classifiche CASCADE;
DROP TABLE IF EXISTS risultati_gare CASCADE;
DROP TABLE IF EXISTS eventi CASCADE;
DROP TABLE IF EXISTS gare CASCADE;
DROP TABLE IF EXISTS campionati CASCADE;
DROP TABLE IF EXISTS piloti CASCADE;

-- Tabella Piloti
CREATE TABLE piloti (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cognome VARCHAR(100),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    psn_id VARCHAR(100) UNIQUE NOT NULL,
    gt_id VARCHAR(100),
    numero_gara INTEGER UNIQUE,
    categoria VARCHAR(50) DEFAULT 'Academy' CHECK (categoria IN ('Ufficiali', 'Academy', 'Junior')),
    ruolo VARCHAR(50) DEFAULT 'pilota' CHECK (ruolo IN ('manager', 'pilota', 'staff')),
    attivo BOOLEAN DEFAULT true,
    data_registrazione TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ultimo_accesso TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabella Campionati
CREATE TABLE campionati (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    descrizione TEXT,
    status VARCHAR(50) DEFAULT 'Active' CHECK (status IN ('Active', 'Completed', 'Upcoming')),
    anno INTEGER NOT NULL,
    data_inizio DATE NOT NULL,
    data_fine DATE,
    regolamento_url TEXT,
    creato_da INTEGER REFERENCES piloti(id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabella Gare
CREATE TABLE gare (
    id SERIAL PRIMARY KEY,
    campionato_id INTEGER REFERENCES campionati(id) ON DELETE CASCADE,
    numero_gara INTEGER NOT NULL,
    nome VARCHAR(255) NOT NULL,
    circuito VARCHAR(255) NOT NULL,
    data_gara TIMESTAMP NOT NULL,
    durata_minuti INTEGER,
    tipo_trazione VARCHAR(50) CHECK (tipo_trazione IN ('FWD', 'RWD', 'AWD', 'ALL')),
    status VARCHAR(50) DEFAULT 'Scheduled' CHECK (status IN ('Scheduled', 'In Progress', 'Completed', 'Cancelled')),
    risultati_pubblicati BOOLEAN DEFAULT false,
    meteo VARCHAR(50),
    temperatura INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (campionato_id, numero_gara)
);

-- Tabella Risultati Gare
CREATE TABLE risultati_gare (
    id SERIAL PRIMARY KEY,
    gara_id INTEGER REFERENCES gare(id) ON DELETE CASCADE,
    pilota_id INTEGER REFERENCES piloti(id) ON DELETE CASCADE,
    posizione_qualifica INTEGER,
    posizione_partenza INTEGER,
    posizione_finale INTEGER NOT NULL,
    punti_assegnati INTEGER DEFAULT 0,
    tempo_totale VARCHAR(20),
    giro_veloce VARCHAR(20),
    auto_utilizzata VARCHAR(100),
    note TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (gara_id, pilota_id)
);

-- Tabella Classifiche
CREATE TABLE classifiche (
    id SERIAL PRIMARY KEY,
    campionato_id INTEGER REFERENCES campionati(id) ON DELETE CASCADE,
    pilota_id INTEGER REFERENCES piloti(id) ON DELETE CASCADE,
    posizione_attuale INTEGER,
    punti_totali INTEGER DEFAULT 0,
    vittorie INTEGER DEFAULT 0,
    podi INTEGER DEFAULT 0,
    gare_disputate INTEGER DEFAULT 0,
    ultimo_aggiornamento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (campionato_id, pilota_id)
);

-- Tabella Statistiche Piloti
CREATE TABLE statistiche_piloti (
    id SERIAL PRIMARY KEY,
    pilota_id INTEGER REFERENCES piloti(id) ON DELETE CASCADE UNIQUE,
    punti_totali INTEGER DEFAULT 0,
    vittorie_totali INTEGER DEFAULT 0,
    podi_totali INTEGER DEFAULT 0,
    gare_totali INTEGER DEFAULT 0,
    giri_veloci INTEGER DEFAULT 0,
    media_posizione_arrivo DECIMAL(5,2),
    tasso_completamento DECIMAL(5,2) DEFAULT 100.00,
    ultimo_aggiornamento TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabella Reclami
CREATE TABLE reclami (
    id SERIAL PRIMARY KEY,
    gara_id INTEGER REFERENCES gare(id) ON DELETE CASCADE,
    reclamante_id INTEGER REFERENCES piloti(id) ON DELETE CASCADE,
    contro_pilota_id INTEGER REFERENCES piloti(id) ON DELETE SET NULL,
    tipo VARCHAR(100) NOT NULL CHECK (tipo IN ('Contatto', 'Sorpasso Irregolare', 'Track Limits', 'Comportamento Antisportivo', 'Altro')),
    giro INTEGER,
    curva VARCHAR(100),
    descrizione TEXT NOT NULL,
    video_url TEXT,
    status VARCHAR(50) DEFAULT 'In esame' CHECK (status IN ('In esame', 'Accettato', 'Respinto', 'Risolto')),
    decisione_commissario TEXT,
    data_reclamo TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_risoluzione TIMESTAMP
);

-- Tabella Penalità
CREATE TABLE penalita (
    id SERIAL PRIMARY KEY,
    reclamo_id INTEGER REFERENCES reclami(id) ON DELETE CASCADE,
    pilota_id INTEGER REFERENCES piloti(id) ON DELETE CASCADE,
    gara_id INTEGER REFERENCES gare(id) ON DELETE CASCADE,
    tipo_penalita VARCHAR(100) NOT NULL CHECK (tipo_penalita IN ('Tempo', 'Posizioni', 'Punti', 'Squalifica', 'Ammonizione')),
    valore INTEGER,
    descrizione TEXT,
    data_applicazione TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabella Eventi
CREATE TABLE eventi (
    id SERIAL PRIMARY KEY,
    titolo VARCHAR(255) NOT NULL,
    descrizione TEXT,
    data_inizio TIMESTAMP NOT NULL,
    data_fine TIMESTAMP,
    tipo VARCHAR(50) CHECK (tipo IN ('Gara', 'Test', 'Riunione', 'Altro')),
    luogo VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabella Sessioni (JWT Storage)
CREATE TABLE sessioni (
    id SERIAL PRIMARY KEY,
    pilota_id INTEGER REFERENCES piloti(id) ON DELETE CASCADE,
    token TEXT NOT NULL UNIQUE,
    scadenza TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabella Notifiche
CREATE TABLE notifiche (
    id SERIAL PRIMARY KEY,
    pilota_id INTEGER REFERENCES piloti(id) ON DELETE CASCADE,
    titolo VARCHAR(255) NOT NULL,
    messaggio TEXT NOT NULL,
    tipo VARCHAR(50) CHECK (tipo IN ('Info', 'Avviso', 'Urgente')),
    letta BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabella Log Attività
CREATE TABLE log_attivita (
    id SERIAL PRIMARY KEY,
    pilota_id INTEGER REFERENCES piloti(id) ON DELETE SET NULL,
    azione VARCHAR(100) NOT NULL,
    entita_tipo VARCHAR(50),
    entita_id INTEGER,
    dettagli TEXT,
    ip_address VARCHAR(50),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabella Iscrizioni Campionati
CREATE TABLE iscrizioni_campionati (
    id SERIAL PRIMARY KEY,
    campionato_id INTEGER REFERENCES campionati(id) ON DELETE CASCADE,
    pilota_id INTEGER REFERENCES piloti(id) ON DELETE CASCADE,
    data_iscrizione TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    auto_scelta VARCHAR(255),
    numero_gara INTEGER,
    status VARCHAR(50) DEFAULT 'Attivo' CHECK (status IN ('Attivo', 'Ritirato', 'Squalificato')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (campionato_id, pilota_id)
);

-- Tabella Documenti Campionato
CREATE TABLE documenti_campionato (
    id SERIAL PRIMARY KEY,
    campionato_id INTEGER REFERENCES campionati(id) ON DELETE CASCADE,
    titolo VARCHAR(255) NOT NULL,
    descrizione TEXT,
    file_url TEXT NOT NULL,
    tipo VARCHAR(50) CHECK (tipo IN ('Regolamento', 'Setup', 'Classifica', 'Comunicato', 'Altro')),
    caricato_da INTEGER REFERENCES piloti(id) ON DELETE SET NULL,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabella Impostazioni Gara
CREATE TABLE impostazioni_gara (
    id SERIAL PRIMARY KEY,
    gara_id INTEGER REFERENCES gare(id) ON DELETE CASCADE UNIQUE,
    meteo VARCHAR(100),
    durata_gara INTEGER,
    durata_qualifiche INTEGER,
    consumo_carburante VARCHAR(50),
    usura_gomme VARCHAR(50),
    tipo_partenza VARCHAR(50) CHECK (tipo_partenza IN ('Griglia', 'Rolling', 'LeMans')),
    bop BOOLEAN DEFAULT false,
    danni VARCHAR(50),
    penalita TEXT,
    modificato_da INTEGER REFERENCES piloti(id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- SISTEMA CREDITI API
-- ============================================

-- Tabella Crediti API - Gestione saldo crediti per pilota
CREATE TABLE api_credits (
    id SERIAL PRIMARY KEY,
    pilota_id INTEGER REFERENCES piloti(id) ON DELETE CASCADE UNIQUE,
    crediti_disponibili INTEGER DEFAULT 1000,
    crediti_totali_utilizzati INTEGER DEFAULT 0,
    ultimo_utilizzo TIMESTAMP,
    ultimo_ricarico TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabella Utilizzo API - Log dettagliato chiamate API
CREATE TABLE api_usage (
    id SERIAL PRIMARY KEY,
    pilota_id INTEGER REFERENCES piloti(id) ON DELETE CASCADE,
    endpoint VARCHAR(255) NOT NULL,
    metodo VARCHAR(10) NOT NULL,
    crediti_consumati INTEGER NOT NULL,
    ip_address VARCHAR(50),
    user_agent TEXT,
    status_code INTEGER,
    response_time_ms INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabella Ricariche Crediti - Storico ricariche
CREATE TABLE api_credit_recharges (
    id SERIAL PRIMARY KEY,
    pilota_id INTEGER REFERENCES piloti(id) ON DELETE CASCADE,
    crediti_aggiunti INTEGER NOT NULL,
    tipo_ricarica VARCHAR(50) CHECK (tipo_ricarica IN ('Manuale', 'Automatica', 'Bonus', 'Admin')),
    motivo TEXT,
    eseguita_da INTEGER REFERENCES piloti(id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabella Configurazione Endpoint API - Costo per endpoint
CREATE TABLE api_endpoint_costs (
    id SERIAL PRIMARY KEY,
    endpoint VARCHAR(255) UNIQUE NOT NULL,
    descrizione TEXT,
    costo_crediti INTEGER DEFAULT 1,
    attivo BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indici per Performance
CREATE INDEX idx_piloti_email ON piloti(email);
CREATE INDEX idx_piloti_psn ON piloti(psn_id);
CREATE INDEX idx_gare_campionato ON gare(campionato_id);
CREATE INDEX idx_gare_data ON gare(data_gara);
CREATE INDEX idx_risultati_gara ON risultati_gare(gara_id);
CREATE INDEX idx_risultati_pilota ON risultati_gare(pilota_id);
CREATE INDEX idx_classifiche_campionato ON classifiche(campionato_id);
CREATE INDEX idx_reclami_gara ON reclami(gara_id);
CREATE INDEX idx_sessioni_token ON sessioni(token);
CREATE INDEX idx_iscrizioni_campionato ON iscrizioni_campionati(campionato_id);
CREATE INDEX idx_iscrizioni_pilota ON iscrizioni_campionati(pilota_id);
CREATE INDEX idx_documenti_campionato ON documenti_campionato(campionato_id);
CREATE INDEX idx_impostazioni_gara ON impostazioni_gara(gara_id);
CREATE INDEX idx_api_credits_pilota ON api_credits(pilota_id);
CREATE INDEX idx_api_usage_pilota ON api_usage(pilota_id);
CREATE INDEX idx_api_usage_endpoint ON api_usage(endpoint);
CREATE INDEX idx_api_usage_created ON api_usage(created_at);
CREATE INDEX idx_api_recharges_pilota ON api_credit_recharges(pilota_id);

-- Trigger per Update Timestamp
CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER piloti_update_timestamp BEFORE UPDATE ON piloti
FOR EACH ROW EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER campionati_update_timestamp BEFORE UPDATE ON campionati
FOR EACH ROW EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER gare_update_timestamp BEFORE UPDATE ON gare
FOR EACH ROW EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER risultati_update_timestamp BEFORE UPDATE ON risultati_gare
FOR EACH ROW EXECUTE FUNCTION update_timestamp();

-- Funzione: Calcola Classifica Campionato
CREATE OR REPLACE FUNCTION calcola_classifica(p_campionato_id INTEGER)
RETURNS void AS $$
BEGIN
    -- Aggiorna classifiche da risultati gare
    INSERT INTO classifiche (campionato_id, pilota_id, punti_totali, vittorie, podi, gare_disputate)
    SELECT 
        g.campionato_id,
        rg.pilota_id,
        COALESCE(SUM(rg.punti_assegnati), 0) as punti_totali,
        COUNT(CASE WHEN rg.posizione_finale = 1 THEN 1 END) as vittorie,
        COUNT(CASE WHEN rg.posizione_finale <= 3 THEN 1 END) as podi,
        COUNT(*) as gare_disputate
    FROM risultati_gare rg
    JOIN gare g ON g.id = rg.gara_id
    WHERE g.campionato_id = p_campionato_id
    GROUP BY g.campionato_id, rg.pilota_id
    ON CONFLICT (campionato_id, pilota_id) 
    DO UPDATE SET
        punti_totali = EXCLUDED.punti_totali,
        vittorie = EXCLUDED.vittorie,
        podi = EXCLUDED.podi,
        gare_disputate = EXCLUDED.gare_disputate,
        ultimo_aggiornamento = CURRENT_TIMESTAMP;

    -- Aggiorna posizioni
    WITH ranked AS (
        SELECT 
            id,
            ROW_NUMBER() OVER (ORDER BY punti_totali DESC, vittorie DESC) as new_pos
        FROM classifiche
        WHERE campionato_id = p_campionato_id
    )
    UPDATE classifiche c
    SET posizione_attuale = r.new_pos
    FROM ranked r
    WHERE c.id = r.id;
END;
$$ LANGUAGE plpgsql;

-- Funzione: Aggiorna Statistiche Pilota
CREATE OR REPLACE FUNCTION aggiorna_statistiche_pilota(p_pilota_id INTEGER)
RETURNS void AS $$
BEGIN
    INSERT INTO statistiche_piloti (pilota_id, punti_totali, vittorie_totali, podi_totali, gare_totali, media_posizione_arrivo)
    SELECT 
        p_pilota_id,
        COALESCE(SUM(punti_assegnati), 0),
        COUNT(CASE WHEN posizione_finale = 1 THEN 1 END),
        COUNT(CASE WHEN posizione_finale <= 3 THEN 1 END),
        COUNT(*),
        ROUND(AVG(posizione_finale), 2)
    FROM risultati_gare
    WHERE pilota_id = p_pilota_id
    ON CONFLICT (pilota_id)
    DO UPDATE SET
        punti_totali = EXCLUDED.punti_totali,
        vittorie_totali = EXCLUDED.vittorie_totali,
        podi_totali = EXCLUDED.podi_totali,
        gare_totali = EXCLUDED.gare_totali,
        media_posizione_arrivo = EXCLUDED.media_posizione_arrivo,
        ultimo_aggiornamento = CURRENT_TIMESTAMP;
END;
$$ LANGUAGE plpgsql;

-- Views
CREATE OR REPLACE VIEW v_classifica_generale AS
SELECT 
    p.id,
    p.nome,
    p.psn_id,
    p.categoria,
    COALESCE(sp.punti_totali, 0) as punti,
    COALESCE(sp.vittorie_totali, 0) as vittorie,
    COALESCE(sp.podi_totali, 0) as podi,
    COALESCE(sp.gare_totali, 0) as gare,
    sp.media_posizione_arrivo
FROM piloti p
LEFT JOIN statistiche_piloti sp ON sp.pilota_id = p.id
WHERE p.attivo = true
ORDER BY sp.punti_totali DESC NULLS LAST, sp.vittorie_totali DESC NULLS LAST;

CREATE OR REPLACE VIEW v_prossime_gare AS
SELECT 
    g.id,
    g.numero_gara,
    g.nome,
    g.circuito,
    g.data_gara,
    g.durata_minuti,
    g.tipo_trazione,
    c.nome as campionato
FROM gare g
JOIN campionati c ON c.id = g.campionato_id
WHERE g.data_gara > CURRENT_TIMESTAMP
  AND g.status = 'Scheduled'
ORDER BY g.data_gara ASC
LIMIT 10;

CREATE OR REPLACE VIEW v_reclami_pendenti AS
SELECT
    r.id,
    r.gara_id,
    g.nome as gara_nome,
    p1.nome as reclamante,
    p2.nome as contro_pilota,
    r.tipo,
    r.descrizione,
    r.status,
    r.data_reclamo
FROM reclami r
JOIN gare g ON g.id = r.gara_id
JOIN piloti p1 ON p1.id = r.reclamante_id
LEFT JOIN piloti p2 ON p2.id = r.contro_pilota_id
WHERE r.status IN ('In esame', 'Accettato')
ORDER BY r.data_reclamo DESC;

-- ============================================
-- FUNZIONI SISTEMA CREDITI API
-- ============================================

-- Funzione: Inizializza crediti per nuovo pilota
CREATE OR REPLACE FUNCTION inizializza_crediti_pilota()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO api_credits (pilota_id, crediti_disponibili)
    VALUES (NEW.id, 1000);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_inizializza_crediti
AFTER INSERT ON piloti
FOR EACH ROW
EXECUTE FUNCTION inizializza_crediti_pilota();

-- Funzione: Consuma crediti API
CREATE OR REPLACE FUNCTION consuma_crediti(
    p_pilota_id INTEGER,
    p_endpoint VARCHAR(255),
    p_crediti INTEGER
) RETURNS BOOLEAN AS $$
DECLARE
    crediti_attuali INTEGER;
BEGIN
    -- Verifica crediti disponibili
    SELECT crediti_disponibili INTO crediti_attuali
    FROM api_credits
    WHERE pilota_id = p_pilota_id
    FOR UPDATE;

    IF crediti_attuali IS NULL THEN
        -- Crea record se non esiste
        INSERT INTO api_credits (pilota_id, crediti_disponibili)
        VALUES (p_pilota_id, 1000);
        crediti_attuali := 1000;
    END IF;

    IF crediti_attuali < p_crediti THEN
        RETURN FALSE; -- Crediti insufficienti
    END IF;

    -- Decrementa crediti
    UPDATE api_credits
    SET crediti_disponibili = crediti_disponibili - p_crediti,
        crediti_totali_utilizzati = crediti_totali_utilizzati + p_crediti,
        ultimo_utilizzo = CURRENT_TIMESTAMP,
        updated_at = CURRENT_TIMESTAMP
    WHERE pilota_id = p_pilota_id;

    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- Funzione: Ricarica crediti
CREATE OR REPLACE FUNCTION ricarica_crediti(
    p_pilota_id INTEGER,
    p_crediti INTEGER,
    p_tipo VARCHAR(50),
    p_motivo TEXT,
    p_admin_id INTEGER
) RETURNS void AS $$
BEGIN
    -- Aggiorna saldo
    UPDATE api_credits
    SET crediti_disponibili = crediti_disponibili + p_crediti,
        ultimo_ricarico = CURRENT_TIMESTAMP,
        updated_at = CURRENT_TIMESTAMP
    WHERE pilota_id = p_pilota_id;

    -- Log ricarica
    INSERT INTO api_credit_recharges (pilota_id, crediti_aggiunti, tipo_ricarica, motivo, eseguita_da)
    VALUES (p_pilota_id, p_crediti, p_tipo, p_motivo, p_admin_id);
END;
$$ LANGUAGE plpgsql;

-- Funzione: Ottieni statistiche utilizzo API
CREATE OR REPLACE FUNCTION get_api_stats(p_pilota_id INTEGER)
RETURNS TABLE(
    crediti_disponibili INTEGER,
    crediti_utilizzati INTEGER,
    chiamate_oggi INTEGER,
    chiamate_settimana INTEGER,
    chiamate_totali BIGINT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        ac.crediti_disponibili,
        ac.crediti_totali_utilizzati,
        COUNT(CASE WHEN au.created_at >= CURRENT_DATE THEN 1 END)::INTEGER as chiamate_oggi,
        COUNT(CASE WHEN au.created_at >= CURRENT_DATE - INTERVAL '7 days' THEN 1 END)::INTEGER as chiamate_settimana,
        COUNT(*)::BIGINT as chiamate_totali
    FROM api_credits ac
    LEFT JOIN api_usage au ON au.pilota_id = ac.pilota_id
    WHERE ac.pilota_id = p_pilota_id
    GROUP BY ac.crediti_disponibili, ac.crediti_totali_utilizzati;
END;
$$ LANGUAGE plpgsql;

-- View: Statistiche utilizzo API per pilota
CREATE OR REPLACE VIEW v_api_usage_stats AS
SELECT
    p.id as pilota_id,
    p.nome,
    p.email,
    ac.crediti_disponibili,
    ac.crediti_totali_utilizzati,
    COUNT(au.id) as chiamate_totali,
    COUNT(CASE WHEN au.created_at >= CURRENT_DATE THEN 1 END) as chiamate_oggi,
    ac.ultimo_utilizzo,
    ac.ultimo_ricarico
FROM piloti p
LEFT JOIN api_credits ac ON ac.pilota_id = p.id
LEFT JOIN api_usage au ON au.pilota_id = p.id
WHERE p.attivo = true
GROUP BY p.id, p.nome, p.email, ac.crediti_disponibili, ac.crediti_totali_utilizzati, ac.ultimo_utilizzo, ac.ultimo_ricarico
ORDER BY ac.crediti_totali_utilizzati DESC;

-- Dati iniziali: Costi endpoint API
INSERT INTO api_endpoint_costs (endpoint, descrizione, costo_crediti) VALUES
('/auth/login', 'Login autenticazione', 0),
('/auth/register', 'Registrazione nuovo utente', 0),
('/piloti', 'Lista piloti', 1),
('/classifica', 'Classifica campionato', 2),
('/gare', 'Lista gare', 1),
('/gare/prossime', 'Prossime gare', 1),
('/stats', 'Statistiche generali', 1),
('/risultati', 'Inserimento risultati', 3),
('/reclami', 'Visualizza/Invia reclami', 2),
('/campionati', 'Lista/Crea campionati', 2),
('/piloti/profilo', 'Profilo pilota', 1),
('/piloti/campionati', 'Campionati del pilota', 2),
('/crediti', 'Visualizza crediti API', 0),
('/crediti/storico', 'Storico utilizzo crediti', 1)
ON CONFLICT (endpoint) DO NOTHING;

-- ============================================
-- SCHEMA COMPLETO
-- ============================================
