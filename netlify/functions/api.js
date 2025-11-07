const { Client } = require('pg');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

const getDBClient = () => {
    return new Client({
        connectionString: process.env.DATABASE_URL,
        ssl: { rejectUnauthorized: false }
    });
};

const JWT_SECRET = process.env.JWT_SECRET || 'tlm-secret-key-change-in-production';

const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'Content-Type, Authorization',
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS'
};

const verifyToken = (token) => {
    try {
        return jwt.verify(token, JWT_SECRET);
    } catch (error) {
        return null;
    }
};

const sendResponse = (statusCode, body) => {
    return {
        statusCode,
        headers: corsHeaders,
        body: JSON.stringify(body)
    };
};

exports.handler = async (event) => {
    if (event.httpMethod === 'OPTIONS') {
        return sendResponse(200, { ok: true });
    }

    const path = event.path.replace('/.netlify/functions/api', '').toLowerCase();
    const method = event.httpMethod;

    try {
        if (path === '/auth/login' && method === 'POST') {
            return await handleLogin(event.body);
        }

        if (path === '/auth/register' && method === 'POST') {
            return await handleRegister(event.body);
        }

        if (path === '/piloti' && method === 'GET') {
            return await getPiloti();
        }

        if (path === '/classifica' && method === 'GET') {
            const campionatoId = event.queryStringParameters?.campionato_id || 1;
            return await getClassifica(campionatoId);
        }

        if (path === '/gare' && method === 'GET') {
            const campionatoId = event.queryStringParameters?.campionato_id || 1;
            return await getGare(campionatoId);
        }

        if (path === '/gare/prossime' && method === 'GET') {
            return await getProssimaGare();
        }

        if (path === '/stats' && method === 'GET') {
            return await getStats();
        }

        // Auth avanzata (pubblico)
        if (path === '/auth/verify' && method === 'POST') {
            return await verifyTokenEndpoint(event.body);
        }

        // Dettagli gara (pubblico)
        if (path.match(/^\/gare\/\d+$/) && method === 'GET') {
            const garaId = path.split('/')[2];
            return await getGaraDettagli(garaId);
        }

        // Stats pilota (pubblico)
        if (path.match(/^\/piloti\/\d+\/stats$/) && method === 'GET') {
            const pilotaId = path.split('/')[2];
            return await getPilotaStats(pilotaId);
        }

        const token = event.headers.authorization?.replace('Bearer ', '');
        
        if (!token) {
            return sendResponse(401, { success: false, error: 'Token non fornito' });
        }

        const user = verifyToken(token);
        if (!user) {
            return sendResponse(401, { success: false, error: 'Token non valido' });
        }

        if (path === '/risultati' && method === 'POST') {
            return await submitRisultato(event.body, user);
        }

        if (path === '/reclami' && method === 'GET') {
            return await getReclami();
        }

        if (path === '/reclami' && method === 'POST') {
            return await submitReclamo(event.body, user);
        }

        // New Championship Routes
        if (path === '/campionati' && method === 'GET') {
            return await getCampionati();
        }

        if (path === '/campionati' && method === 'POST') {
            return await createCampionato(event.body, user);
        }

        if (path.match(/^\/campionati\/\d+\/iscrizione$/) && method === 'POST') {
            const champId = path.split('/')[2];
            return await handleIscrizione(champId, user);
        }

        if (path.match(/^\/campionati\/\d+\/iscrizione$/) && method === 'DELETE') {
            const champId = path.split('/')[2];
            return await handleDisiscrizione(champId, user);
        }

        if (path.match(/^\/campionati\/\d+\/documenti$/) && method === 'POST') {
            const champId = path.split('/')[2];
            return await uploadDocumento(champId, event.body, user);
        }

        if (path === '/gare/impostazioni' && method === 'POST') {
            return await saveImpostazioniGara(event.body, user);
        }

        // Add new routes before the 404 response:
        if (path === '/piloti/profilo' && method === 'GET') {
            return await getPilotaProfilo(user.id);
        }

        if (path === '/piloti/campionati' && method === 'GET') {
            return await getPilotaCampionati(user.id);
        }

        if (path.match(/^\/campionati\/\d+\/documenti$/) && method === 'GET') {
            const champId = path.split('/')[2];
            return await getDocumentiCampionato(champId);
        }

        if (path.match(/^\/gare\/\d+\/impostazioni$/) && method === 'GET') {
            const garaId = path.split('/')[2];
            return await getImpostazioniGara(garaId);
        }

        // AUTH ME
        if (path === '/auth/me' && method === 'GET') {
            return await getAuthMe(user);
        }

        // UPLOAD CSV RISULTATI GARA
        if (path.match(/^\/gare\/\d+\/upload-csv$/) && method === 'POST') {
            const garaId = path.split('/')[2];
            return await uploadCsvRisultati(garaId, event.body, user);
        }

        // ISCRIZIONI GARA
        if (path.match(/^\/gare\/\d+\/iscrizione$/) && method === 'POST') {
            const garaId = path.split('/')[2];
            return await iscriviGara(garaId, user);
        }

        if (path.match(/^\/gare\/\d+\/iscrizione$/) && method === 'DELETE') {
            const garaId = path.split('/')[2];
            return await cancellaIscrizioneGara(garaId, user);
        }

        // UPLOAD RISULTATI GARA (multipart/form-data)
        if (path.match(/^\/gare\/\d+\/risultati$/) && method === 'POST') {
            const garaId = path.split('/')[2];
            return await uploadRisultatiGara(garaId, event.body, user);
        }

        // RECLAMI AVANZATI
        if (path === '/reclami/miei' && method === 'GET') {
            return await getReclamiMiei(user);
        }

        if (path.match(/^\/reclami\/\d+$/) && method === 'GET') {
            const reclamoId = path.split('/')[2];
            return await getReclamoDettaglio(reclamoId, user);
        }

        if (path.match(/^\/reclami\/\d+\/status$/) && method === 'PUT') {
            const reclamoId = path.split('/')[2];
            return await updateReclamoStatus(reclamoId, event.body, user);
        }

        // PILOTA AVANZATO
        if (path.match(/^\/piloti\/\d+$/) && method === 'PUT') {
            const pilotaId = path.split('/')[2];
            return await updatePilota(pilotaId, event.body, user);
        }

        if (path.match(/^\/piloti\/\d+\/gare$/) && method === 'GET') {
            const pilotaId = path.split('/')[2];
            return await getPilotaGare(pilotaId);
        }

        if (path.match(/^\/piloti\/\d+\/campionati$/) && method === 'GET') {
            const pilotaId = path.split('/')[2];
            return await getPilotaCampionati(pilotaId);
        }

        return sendResponse(404, { success: false, error: 'Route non trovata' });

    } catch (error) {
        console.error('API Error:', error);
        return sendResponse(500, { 
            success: false, 
            error: error.message 
        });
    }
};

const handleLogin = async (body) => {
    const { email, password } = JSON.parse(body);

    if (!email || !password) {
        return sendResponse(400, { success: false, error: 'Email e password richiesti' });
    }

    const client = getDBClient();
    
    try {
        await client.connect();

        const result = await client.query(
            'SELECT * FROM piloti WHERE email = $1',
            [email]
        );

        if (result.rows.length === 0) {
            return sendResponse(401, { success: false, error: 'Credenziali non valide' });
        }

        const user = result.rows[0];

        const passwordMatch = await bcrypt.compare(password, user.password_hash);

        if (!passwordMatch) {
            return sendResponse(401, { success: false, error: 'Credenziali non valide' });
        }

        const token = jwt.sign(
            { id: user.id, email: user.email, nome: user.nome },
            JWT_SECRET,
            { expiresIn: '7d' }
        );

        return sendResponse(200, {
            success: true,
            token,
            user: {
                id: user.id,
                nome: user.nome,
                email: user.email,
                categoria: user.categoria,
                ruolo: user.ruolo
            }
        });

    } finally {
        await client.end();
    }
};

const handleRegister = async (body) => {
    const { nome, email, password, psn_id } = JSON.parse(body);

    if (!nome || !email || !password || !psn_id) {
        return sendResponse(400, { success: false, error: 'Campi mancanti' });
    }

    const client = getDBClient();

    try {
        await client.connect();

        const existing = await client.query(
            'SELECT id FROM piloti WHERE email = $1 OR psn_id = $2',
            [email, psn_id]
        );

        if (existing.rows.length > 0) {
            return sendResponse(400, { success: false, error: 'Email o PSN ID già registrati' });
        }

        const passwordHash = await bcrypt.hash(password, 10);

        const result = await client.query(
            `INSERT INTO piloti (nome, email, password_hash, psn_id, categoria, ruolo)
             VALUES ($1, $2, $3, $4, $5, $6)
             RETURNING id, nome, email, categoria`,
            [nome, email, passwordHash, psn_id, 'Academy', 'pilota']
        );

        const newUser = result.rows[0];

        const token = jwt.sign(
            { id: newUser.id, email: newUser.email, nome: newUser.nome },
            JWT_SECRET,
            { expiresIn: '7d' }
        );

        return sendResponse(201, {
            success: true,
            token,
            user: newUser
        });

    } finally {
        await client.end();
    }
};

const getPiloti = async () => {
    const client = getDBClient();

    try {
        await client.connect();

        const result = await client.query(
            'SELECT id, nome, cognome, email, psn_id, gt_id, numero_gara, categoria FROM piloti WHERE attivo = true ORDER BY nome'
        );

        return sendResponse(200, {
            success: true,
            totale: result.rows.length,
            piloti: result.rows
        });

    } finally {
        await client.end();
    }
};

const getClassifica = async (campionatoId) => {
    const client = getDBClient();

    try {
        await client.connect();

        const result = await client.query(
            `SELECT 
                p.id, p.nome, p.categoria,
                COALESCE(sp.punti_totali, 0) as punti,
                COALESCE(sp.vittorie_totali, 0) as vittorie,
                COALESCE(sp.podi_totali, 0) as podi,
                COALESCE(sp.gare_totali, 0) as gare
            FROM piloti p
            LEFT JOIN statistiche_piloti sp ON sp.pilota_id = p.id
            WHERE p.attivo = true
            ORDER BY punti DESC, vittorie DESC
            LIMIT 50`
        );

        return sendResponse(200, {
            success: true,
            campionato_id: campionatoId,
            classifica: result.rows
        });

    } finally {
        await client.end();
    }
};

const getGare = async (campionatoId) => {
    const client = getDBClient();

    try {
        await client.connect();

        const result = await client.query(
            `SELECT 
                g.id, g.numero_gara, g.nome, g.circuito, g.data_gara, 
                g.durata_minuti, g.tipo_trazione, g.status,
                c.nome as campionato
            FROM gare g
            JOIN campionati c ON c.id = g.campionato_id
            WHERE g.campionato_id = $1
            ORDER BY g.data_gara`,
            [campionatoId]
        );

        return sendResponse(200, {
            success: true,
            gare: result.rows
        });

    } finally {
        await client.end();
    }
};

const getProssimaGare = async () => {
    const client = getDBClient();

    try {
        await client.connect();

        const result = await client.query(
            `SELECT 
                g.id, g.numero_gara, g.nome, g.circuito, g.data_gara, 
                g.durata_minuti, g.tipo_trazione,
                c.nome as campionato
            FROM gare g
            JOIN campionati c ON c.id = g.campionato_id
            WHERE g.status = 'Scheduled'
            ORDER BY g.data_gara
            LIMIT 5`
        );

        return sendResponse(200, {
            success: true,
            gare: result.rows
        });

    } finally {
        await client.end();
    }
};

const getStats = async () => {
    const client = getDBClient();

    try {
        await client.connect();

        const pilotsResult = await client.query('SELECT COUNT(*) as count FROM piloti WHERE attivo = true');
        const champResult = await client.query('SELECT COUNT(*) as count FROM campionati WHERE status = \'Active\'');
        const raceResult = await client.query('SELECT COUNT(*) as count FROM gare');

        return sendResponse(200, {
            success: true,
            totale_piloti: parseInt(pilotsResult.rows[0].count),
            totale_campionati: parseInt(champResult.rows[0].count),
            totale_gare: parseInt(raceResult.rows[0].count)
        });

    } finally {
        await client.end();
    }
};

const submitRisultato = async (body, user) => {
    const { gara_id, posizione_finale, tempo_totale, auto_utilizzata } = JSON.parse(body);

    if (!gara_id || !posizione_finale) {
        return sendResponse(400, { success: false, error: 'Dati richiesti mancanti' });
    }

    const client = getDBClient();

    try {
        await client.connect();

        await client.query(
            `INSERT INTO risultati_gare (gara_id, pilota_id, posizione_finale, tempo_totale, auto_utilizzata)
             VALUES ($1, $2, $3, $4, $5)
             ON CONFLICT (gara_id, pilota_id) 
             DO UPDATE SET posizione_finale = $3, tempo_totale = $4, auto_utilizzata = $5`,
            [gara_id, user.id, posizione_finale, tempo_totale, auto_utilizzata]
        );

        return sendResponse(200, {
            success: true,
            message: 'Risultato inserito correttamente'
        });

    } finally {
        await client.end();
    }
};

const getReclami = async () => {
    const client = getDBClient();

    try {
        await client.connect();

        const result = await client.query(
            `SELECT * FROM reclami ORDER BY data_reclamo DESC LIMIT 20`
        );

        return sendResponse(200, {
            success: true,
            reclami: result.rows
        });

    } finally {
        await client.end();
    }
};

const submitReclamo = async (body, user) => {
    const { gara_id, tipo, descrizione, contro_pilota_id, giro, curva } = JSON.parse(body);

    if (!gara_id || !tipo || !descrizione) {
        return sendResponse(400, { success: false, error: 'Dati richiesti mancanti' });
    }

    const client = getDBClient();

    try {
        await client.connect();

        const result = await client.query(
            `INSERT INTO reclami (gara_id, reclamante_id, contro_pilota_id, tipo, giro, curva, descrizione)
             VALUES ($1, $2, $3, $4, $5, $6, $7)
             RETURNING id`,
            [gara_id, user.id, contro_pilota_id, tipo, giro, curva, descrizione]
        );

        return sendResponse(201, {
            success: true,
            reclamo_id: result.rows[0].id,
            message: 'Reclamo inviato correttamente'
        });

    } finally {
        await client.end();
    }
};

const getCampionati = async () => {
    const client = getDBClient();
    try {
        await client.connect();
        const result = await client.query(`
            SELECT 
                c.*,
                COUNT(DISTINCT i.pilota_id) as totale_iscritti,
                EXISTS(SELECT 1 FROM documenti_campionato dc WHERE dc.campionato_id = c.id) as has_docs
            FROM campionati c
            LEFT JOIN iscrizioni_campionati i ON i.campionato_id = c.id
            WHERE c.status = 'Active'
            GROUP BY c.id
            ORDER BY c.data_inizio DESC
        `);
        
        return sendResponse(200, {
            success: true,
            campionati: result.rows
        });
    } finally {
        await client.end();
    }
};

const createCampionato = async (body, user) => {
    const { nome, descrizione, data_inizio, data_fine } = JSON.parse(body);
    
    if (!nome || !data_inizio || !data_fine) {
        return sendResponse(400, { success: false, error: 'Dati mancanti' });
    }

    const client = getDBClient();
    try {
        await client.connect();
        const result = await client.query(`
            INSERT INTO campionati (nome, descrizione, data_inizio, data_fine, creato_da)
            VALUES ($1, $2, $3, $4, $5)
            RETURNING id
        `, [nome, descrizione, data_inizio, data_fine, user.id]);

        return sendResponse(201, {
            success: true,
            campionato_id: result.rows[0].id
        });
    } finally {
        await client.end();
    }
};

const handleIscrizione = async (champId, user) => {
    const client = getDBClient();
    try {
        await client.connect();
        await client.query(`
            INSERT INTO iscrizioni_campionati (campionato_id, pilota_id, data_iscrizione)
            VALUES ($1, $2, CURRENT_TIMESTAMP)
            ON CONFLICT DO NOTHING
        `, [champId, user.id]);

        return sendResponse(200, {
            success: true,
            message: 'Iscrizione effettuata'
        });
    } finally {
        await client.end();
    }
};

const handleDisiscrizione = async (champId, user) => {
    const client = getDBClient();
    try {
        await client.connect();
        await client.query(`
            DELETE FROM iscrizioni_campionati 
            WHERE campionato_id = $1 AND pilota_id = $2
        `, [champId, user.id]);

        return sendResponse(200, {
            success: true,
            message: 'Disiscrizione effettuata'
        });
    } finally {
        await client.end();
    }
};

const uploadDocumento = async (champId, body, user) => {
    const { title, file_url, tipo } = JSON.parse(body);
    
    const client = getDBClient();
    try {
        await client.connect();
        await client.query(`
            INSERT INTO documenti_campionato (campionato_id, titolo, file_url, tipo, caricato_da)
            VALUES ($1, $2, $3, $4, $5)
        `, [champId, title, file_url, tipo, user.id]);

        return sendResponse(201, {
            success: true,
            message: 'Documento caricato'
        });
    } finally {
        await client.end();
    }
};

const saveImpostazioniGara = async (body, user) => {
    const { gara_id, meteo, durata, qualifiche, consumo_carburante, usura_gomme, 
            tipo_partenza, bop, danni, penalita } = JSON.parse(body);
    
    const client = getDBClient();
    try {
        await client.connect();
        await client.query(`
            INSERT INTO impostazioni_gara (
                gara_id, meteo, durata_gara, durata_qualifiche, 
                consumo_carburante, usura_gomme, tipo_partenza,
                bop, danni, penalita, modificato_da
            ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
            ON CONFLICT (gara_id) 
            DO UPDATE SET 
                meteo = $2, durata_gara = $3, durata_qualifiche = $4,
                consumo_carburante = $5, usura_gomme = $6, tipo_partenza = $7,
                bop = $8, danni = $9, penalita = $10, modificato_da = $11
        `, [gara_id, meteo, durata, qualifiche, consumo_carburante, usura_gomme,
            tipo_partenza, bop, danni, penalita, user.id]);

        return sendResponse(200, {
            success: true,
            message: 'Impostazioni salvate'
        });
    } finally {
        await client.end();
    }
};

const getPilotaProfilo = async (pilotaId) => {
    const client = getDBClient();
    try {
        await client.connect();
        const result = await client.query(`
            SELECT 
                p.*,
                COALESCE(sp.punti_totali, 0) as punti,
                COALESCE(sp.vittorie_totali, 0) as vittorie,
                COALESCE(sp.gare_totali, 0) as gare,
                COALESCE(sp.podi_totali, 0) as podi
            FROM piloti p
            LEFT JOIN statistiche_piloti sp ON sp.pilota_id = p.id
            WHERE p.id = $1
        `, [pilotaId]);

        return sendResponse(200, {
            success: true,
            profilo: result.rows[0]
        });
    } finally {
        await client.end();
    }
};

const getPilotaCampionati = async (pilotaId) => {
    const client = getDBClient();
    try {
        await client.connect();
        const result = await client.query(`
            SELECT 
                c.*,
                i.data_iscrizione,
                i.auto_scelta,
                (SELECT COUNT(*) FROM iscrizioni_campionati ic WHERE ic.campionato_id = c.id) as totale_iscritti
            FROM campionati c
            LEFT JOIN iscrizioni_campionati i ON i.campionato_id = c.id AND i.pilota_id = $1
            WHERE c.status = 'Active'
            ORDER BY c.data_inizio DESC
        `, [pilotaId]);

        return sendResponse(200, {
            success: true,
            campionati: result.rows
        });
    } finally {
        await client.end();
    }
};

const getDocumentiCampionato = async (champId) => {
    const client = getDBClient();
    try {
        await client.connect();
        const result = await client.query(`
            SELECT id, titolo, tipo, file_url, uploaded_at
            FROM documenti_campionato
            WHERE campionato_id = $1
            ORDER BY uploaded_at DESC
        `, [champId]);

        return sendResponse(200, {
            success: true,
            documenti: result.rows
        });
    } finally {
        await client.end();
    }
};

const getImpostazioniGara = async (garaId) => {
    const client = getDBClient();
    try {
        await client.connect();
        const result = await client.query(`
            SELECT *
            FROM impostazioni_gara
            WHERE gara_id = $1
        `, [garaId]);

        return sendResponse(200, {
            success: true,
            impostazioni: result.rows[0] || null
        });
    } finally {
        await client.end();
    }
};

// ========== NUOVE FUNZIONI ==========

// Verify Token
const verifyTokenEndpoint = async (body) => {
    const { token } = JSON.parse(body);
    const user = verifyToken(token);

    if (!user) {
        return sendResponse(401, { success: false, valid: false });
    }

    return sendResponse(200, { success: true, valid: true, user });
};

// Dettagli Gara
const getGaraDettagli = async (garaId) => {
    const client = getDBClient();
    try {
        await client.connect();

        const garaResult = await client.query(`
            SELECT
                g.*,
                c.nome as campionato_nome,
                c.descrizione as campionato_descrizione,
                (SELECT COUNT(*) FROM risultati_gare rg WHERE rg.gara_id = g.id) as totale_partecipanti
            FROM gare g
            JOIN campionati c ON c.id = g.campionato_id
            WHERE g.id = $1
        `, [garaId]);

        if (garaResult.rows.length === 0) {
            return sendResponse(404, { success: false, error: 'Gara non trovata' });
        }

        const risultatiResult = await client.query(`
            SELECT
                rg.*,
                p.nome,
                p.psn_id,
                p.categoria
            FROM risultati_gare rg
            JOIN piloti p ON p.id = rg.pilota_id
            WHERE rg.gara_id = $1
            ORDER BY rg.posizione_finale ASC
        `, [garaId]);

        return sendResponse(200, {
            success: true,
            gara: garaResult.rows[0],
            risultati: risultatiResult.rows
        });
    } finally {
        await client.end();
    }
};

// Stats Pilota Dettagliate
const getPilotaStats = async (pilotaId) => {
    const client = getDBClient();
    try {
        await client.connect();

        const statsResult = await client.query(`
            SELECT
                p.*,
                COALESCE(sp.punti_totali, 0) as punti_totali,
                COALESCE(sp.vittorie_totali, 0) as vittorie_totali,
                COALESCE(sp.podi_totali, 0) as podi_totali,
                COALESCE(sp.gare_totali, 0) as gare_totali,
                COALESCE(sp.giri_veloci, 0) as giri_veloci,
                sp.media_posizione_arrivo,
                sp.tasso_completamento
            FROM piloti p
            LEFT JOIN statistiche_piloti sp ON sp.pilota_id = p.id
            WHERE p.id = $1
        `, [pilotaId]);

        if (statsResult.rows.length === 0) {
            return sendResponse(404, { success: false, error: 'Pilota non trovato' });
        }

        const ultimeGareResult = await client.query(`
            SELECT
                g.nome as gara_nome,
                g.data_gara,
                rg.posizione_finale,
                rg.punti_assegnati,
                rg.tempo_totale,
                c.nome as campionato_nome
            FROM risultati_gare rg
            JOIN gare g ON g.id = rg.gara_id
            JOIN campionati c ON c.id = g.campionato_id
            WHERE rg.pilota_id = $1
            ORDER BY g.data_gara DESC
            LIMIT 10
        `, [pilotaId]);

        return sendResponse(200, {
            success: true,
            pilota: statsResult.rows[0],
            ultime_gare: ultimeGareResult.rows
        });
    } finally {
        await client.end();
    }
};

// Auth Me
const getAuthMe = async (user) => {
    const client = getDBClient();
    try {
        await client.connect();

        const result = await client.query(`
            SELECT id, nome, email, psn_id, categoria, ruolo, numero_gara
            FROM piloti
            WHERE id = $1
        `, [user.id]);

        if (result.rows.length === 0) {
            return sendResponse(404, { success: false, error: 'Utente non trovato' });
        }

        const pilota = result.rows[0];
        pilota.isAdmin = pilota.ruolo === 'manager';

        return sendResponse(200, {
            success: true,
            ...pilota
        });
    } finally {
        await client.end();
    }
};

// Upload CSV Risultati (IMPORTANTE!)
const uploadCsvRisultati = async (garaId, body, user) => {
    const { csvData } = JSON.parse(body);

    if (!csvData) {
        return sendResponse(400, { success: false, error: 'CSV data mancante' });
    }

    const client = getDBClient();
    try {
        await client.connect();

        // Verifica che la gara esista
        const garaCheck = await client.query('SELECT id FROM gare WHERE id = $1', [garaId]);
        if (garaCheck.rows.length === 0) {
            return sendResponse(404, { success: false, error: 'Gara non trovata' });
        }

        // Parse CSV (formato: posizione,pilota_id,psn_id,tempo_totale,giro_veloce,auto_utilizzata)
        const lines = csvData.trim().split('\n');
        const headers = lines[0].split(',').map(h => h.trim());

        let insertedCount = 0;
        let errors = [];

        for (let i = 1; i < lines.length; i++) {
            const values = lines[i].split(',').map(v => v.trim());

            if (values.length < 3) continue; // Skip invalid lines

            const [posizione, pilota_id, psn_id, tempo_totale, giro_veloce, auto_utilizzata] = values;

            try {
                // Calcola punti basati su posizione (sistema F1 semplificato)
                const puntiMap = {1:25, 2:18, 3:15, 4:12, 5:10, 6:8, 7:6, 8:4, 9:2, 10:1};
                const punti = puntiMap[parseInt(posizione)] || 0;

                await client.query(`
                    INSERT INTO risultati_gare (
                        gara_id, pilota_id, posizione_finale,
                        punti_assegnati, tempo_totale, giro_veloce, auto_utilizzata
                    ) VALUES ($1, $2, $3, $4, $5, $6, $7)
                    ON CONFLICT (gara_id, pilota_id)
                    DO UPDATE SET
                        posizione_finale = $3,
                        punti_assegnati = $4,
                        tempo_totale = $5,
                        giro_veloce = $6,
                        auto_utilizzata = $7
                `, [garaId, pilota_id, posizione, punti, tempo_totale, giro_veloce, auto_utilizzata]);

                insertedCount++;
            } catch (err) {
                errors.push(`Riga ${i}: ${err.message}`);
            }
        }

        // Ricalcola classifiche
        const campionatoResult = await client.query('SELECT campionato_id FROM gare WHERE id = $1', [garaId]);
        if (campionatoResult.rows.length > 0) {
            await client.query('SELECT calcola_classifica($1)', [campionatoResult.rows[0].campionato_id]);
        }

        // Aggiorna statistiche piloti
        await client.query('SELECT aggiorna_statistiche_pilota(id) FROM piloti WHERE attivo = true');

        return sendResponse(200, {
            success: true,
            message: `${insertedCount} risultati inseriti con successo`,
            errors: errors.length > 0 ? errors : undefined
        });
    } finally {
        await client.end();
    }
};

// Iscrivi Gara
const iscriviGara = async (garaId, user) => {
    const client = getDBClient();
    try {
        await client.connect();

        // Verifica che non sia già iscritto
        const check = await client.query(`
            SELECT id FROM iscrizioni_gara
            WHERE gara_id = $1 AND pilota_id = $2
        `, [garaId, user.id]);

        if (check.rows.length > 0) {
            return sendResponse(400, { success: false, error: 'Già iscritto a questa gara' });
        }

        await client.query(`
            INSERT INTO iscrizioni_gara (gara_id, pilota_id)
            VALUES ($1, $2)
        `, [garaId, user.id]);

        return sendResponse(200, {
            success: true,
            message: 'Iscrizione effettuata con successo'
        });
    } finally {
        await client.end();
    }
};

// Cancella Iscrizione Gara
const cancellaIscrizioneGara = async (garaId, user) => {
    const client = getDBClient();
    try {
        await client.connect();

        await client.query(`
            DELETE FROM iscrizioni_gara
            WHERE gara_id = $1 AND pilota_id = $2
        `, [garaId, user.id]);

        return sendResponse(200, {
            success: true,
            message: 'Iscrizione cancellata'
        });
    } finally {
        await client.end();
    }
};

// Upload Risultati Gara (multipart)
const uploadRisultatiGara = async (garaId, body, user) => {
    // Questa funzione gestisce upload di file multipart
    // Per semplicità, usa lo stesso meccanismo di uploadCsvRisultati
    return await uploadCsvRisultati(garaId, body, user);
};

// Reclami Miei
const getReclamiMiei = async (user) => {
    const client = getDBClient();
    try {
        await client.connect();

        const result = await client.query(`
            SELECT
                r.*,
                g.nome as gara_nome,
                p2.nome as contro_pilota_nome
            FROM reclami r
            JOIN gare g ON g.id = r.gara_id
            LEFT JOIN piloti p2 ON p2.id = r.contro_pilota_id
            WHERE r.reclamante_id = $1
            ORDER BY r.data_reclamo DESC
        `, [user.id]);

        return sendResponse(200, {
            success: true,
            reclami: result.rows
        });
    } finally {
        await client.end();
    }
};

// Dettaglio Reclamo
const getReclamoDettaglio = async (reclamoId, user) => {
    const client = getDBClient();
    try {
        await client.connect();

        const result = await client.query(`
            SELECT
                r.*,
                g.nome as gara_nome,
                g.circuito,
                p1.nome as reclamante_nome,
                p1.psn_id as reclamante_psn,
                p2.nome as contro_pilota_nome,
                p2.psn_id as contro_pilota_psn
            FROM reclami r
            JOIN gare g ON g.id = r.gara_id
            JOIN piloti p1 ON p1.id = r.reclamante_id
            LEFT JOIN piloti p2 ON p2.id = r.contro_pilota_id
            WHERE r.id = $1
        `, [reclamoId]);

        if (result.rows.length === 0) {
            return sendResponse(404, { success: false, error: 'Reclamo non trovato' });
        }

        return sendResponse(200, {
            success: true,
            reclamo: result.rows[0]
        });
    } finally {
        await client.end();
    }
};

// Update Status Reclamo (solo manager)
const updateReclamoStatus = async (reclamoId, body, user) => {
    const { status, decisione_commissario } = JSON.parse(body);

    const client = getDBClient();
    try {
        await client.connect();

        // Verifica che sia manager
        const userCheck = await client.query('SELECT ruolo FROM piloti WHERE id = $1', [user.id]);
        if (userCheck.rows.length === 0 || userCheck.rows[0].ruolo !== 'manager') {
            return sendResponse(403, { success: false, error: 'Accesso negato - solo manager' });
        }

        await client.query(`
            UPDATE reclami
            SET status = $1,
                decisione_commissario = $2,
                data_risoluzione = CURRENT_TIMESTAMP
            WHERE id = $3
        `, [status, decisione_commissario, reclamoId]);

        return sendResponse(200, {
            success: true,
            message: 'Status reclamo aggiornato'
        });
    } finally {
        await client.end();
    }
};

// Update Pilota
const updatePilota = async (pilotaId, body, user) => {
    const { nome, cognome, gt_id, numero_gara } = JSON.parse(body);

    // Solo il pilota stesso o un manager può aggiornare
    if (user.id != pilotaId) {
        const client = getDBClient();
        try {
            await client.connect();
            const userCheck = await client.query('SELECT ruolo FROM piloti WHERE id = $1', [user.id]);
            if (userCheck.rows.length === 0 || userCheck.rows[0].ruolo !== 'manager') {
                return sendResponse(403, { success: false, error: 'Non autorizzato' });
            }
        } finally {
            await client.end();
        }
    }

    const client = getDBClient();
    try {
        await client.connect();

        await client.query(`
            UPDATE piloti
            SET nome = COALESCE($1, nome),
                cognome = COALESCE($2, cognome),
                gt_id = COALESCE($3, gt_id),
                numero_gara = COALESCE($4, numero_gara)
            WHERE id = $5
        `, [nome, cognome, gt_id, numero_gara, pilotaId]);

        return sendResponse(200, {
            success: true,
            message: 'Profilo aggiornato'
        });
    } finally {
        await client.end();
    }
};

// Gare Pilota
const getPilotaGare = async (pilotaId) => {
    const client = getDBClient();
    try {
        await client.connect();

        const result = await client.query(`
            SELECT
                g.id,
                g.nome,
                g.circuito,
                g.data_gara,
                g.status,
                rg.posizione_finale,
                rg.punti_assegnati,
                rg.tempo_totale,
                c.nome as campionato_nome
            FROM gare g
            LEFT JOIN risultati_gare rg ON rg.gara_id = g.id AND rg.pilota_id = $1
            JOIN campionati c ON c.id = g.campionato_id
            ORDER BY g.data_gara DESC
            LIMIT 50
        `, [pilotaId]);

        return sendResponse(200, {
            success: true,
            gare: result.rows
        });
    } finally {
        await client.end();
    }
};
