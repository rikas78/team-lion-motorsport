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

// ============================================
// SISTEMA CREDITI API
// ============================================

const ENDPOINT_COSTS = {
    '/auth/login': 0,
    '/auth/register': 0,
    '/piloti': 1,
    '/classifica': 2,
    '/gare': 1,
    '/gare/prossime': 1,
    '/stats': 1,
    '/risultati': 3,
    '/reclami': 2,
    '/campionati': 2,
    '/piloti/profilo': 1,
    '/piloti/campionati': 2,
    '/crediti': 0,
    '/crediti/storico': 1,
    '/crediti/ricarica': 0,
    'default': 1
};

const getEndpointCost = (path) => {
    // Normalizza path per matching
    const normalizedPath = path.replace(/\/\d+/g, '/:id');
    return ENDPOINT_COSTS[normalizedPath] || ENDPOINT_COSTS[path] || ENDPOINT_COSTS['default'];
};

const checkAndConsumeCredits = async (client, userId, endpoint, cost) => {
    if (cost === 0) return true; // Endpoint gratuito

    try {
        // Verifica e consuma crediti usando funzione SQL
        const result = await client.query(
            'SELECT consuma_crediti($1, $2, $3) as success',
            [userId, endpoint, cost]
        );

        return result.rows[0].success;
    } catch (error) {
        console.error('Error checking credits:', error);
        return false;
    }
};

const logApiUsage = async (client, userId, endpoint, method, cost, statusCode, responseTime, ipAddress, userAgent) => {
    try {
        await client.query(
            `INSERT INTO api_usage (pilota_id, endpoint, metodo, crediti_consumati, status_code, response_time_ms, ip_address, user_agent)
             VALUES ($1, $2, $3, $4, $5, $6, $7, $8)`,
            [userId, endpoint, method, cost, statusCode, responseTime, ipAddress, userAgent]
        );
    } catch (error) {
        console.error('Error logging API usage:', error);
    }
};

const withCreditsCheck = async (handler, event, user) => {
    const startTime = Date.now();
    const path = event.path.replace('/.netlify/functions/api', '').toLowerCase();
    const method = event.httpMethod;
    const cost = getEndpointCost(path);

    const client = getDBClient();

    try {
        await client.connect();

        // Se richiede crediti, verifica disponibilità
        if (user && cost > 0) {
            const hasCredits = await checkAndConsumeCredits(client, user.id, path, cost);

            if (!hasCredits) {
                const responseTime = Date.now() - startTime;
                await logApiUsage(client, user.id, path, method, 0, 429, responseTime,
                    event.headers['x-forwarded-for'] || event.headers['client-ip'],
                    event.headers['user-agent']);

                return sendResponse(429, {
                    success: false,
                    error: 'Crediti insufficienti',
                    message: 'Non hai abbastanza crediti API per questa operazione'
                });
            }
        }

        // Esegui handler
        const response = await handler(client, user);
        const responseTime = Date.now() - startTime;

        // Log utilizzo
        if (user) {
            await logApiUsage(client, user.id, path, method, cost, response.statusCode, responseTime,
                event.headers['x-forwarded-for'] || event.headers['client-ip'],
                event.headers['user-agent']);
        }

        return response;

    } finally {
        await client.end();
    }
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

        // ============================================
        // ENDPOINT CREDITI API
        // ============================================

        if (path === '/crediti' && method === 'GET') {
            return await getCrediti(user);
        }

        if (path === '/crediti/storico' && method === 'GET') {
            return await getStoricoCrediti(user);
        }

        if (path === '/crediti/ricarica' && method === 'POST') {
            return await ricaricaCrediti(event.body, user);
        }

        if (path === '/crediti/stats' && method === 'GET') {
            return await getStatsCrediti(user);
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

// ============================================
// HANDLER CREDITI API
// ============================================

const getCrediti = async (user) => {
    const client = getDBClient();
    try {
        await client.connect();
        const result = await client.query(`
            SELECT
                crediti_disponibili,
                crediti_totali_utilizzati,
                ultimo_utilizzo,
                ultimo_ricarico
            FROM api_credits
            WHERE pilota_id = $1
        `, [user.id]);

        if (result.rows.length === 0) {
            // Inizializza crediti se non esistono
            await client.query(`
                INSERT INTO api_credits (pilota_id, crediti_disponibili)
                VALUES ($1, 1000)
            `, [user.id]);

            return sendResponse(200, {
                success: true,
                crediti: {
                    crediti_disponibili: 1000,
                    crediti_totali_utilizzati: 0,
                    ultimo_utilizzo: null,
                    ultimo_ricarico: null
                }
            });
        }

        return sendResponse(200, {
            success: true,
            crediti: result.rows[0]
        });
    } finally {
        await client.end();
    }
};

const getStoricoCrediti = async (user) => {
    const client = getDBClient();
    try {
        await client.connect();
        const result = await client.query(`
            SELECT
                endpoint,
                metodo,
                crediti_consumati,
                status_code,
                response_time_ms,
                created_at
            FROM api_usage
            WHERE pilota_id = $1
            ORDER BY created_at DESC
            LIMIT 100
        `, [user.id]);

        return sendResponse(200, {
            success: true,
            storico: result.rows,
            totale: result.rows.length
        });
    } finally {
        await client.end();
    }
};

const getStatsCrediti = async (user) => {
    const client = getDBClient();
    try {
        await client.connect();
        const result = await client.query(`
            SELECT * FROM get_api_stats($1)
        `, [user.id]);

        return sendResponse(200, {
            success: true,
            stats: result.rows[0] || {
                crediti_disponibili: 0,
                crediti_utilizzati: 0,
                chiamate_oggi: 0,
                chiamate_settimana: 0,
                chiamate_totali: 0
            }
        });
    } finally {
        await client.end();
    }
};

const ricaricaCrediti = async (body, user) => {
    const { pilota_id, crediti, motivo } = JSON.parse(body);

    // Solo manager/admin possono ricaricare crediti
    const client = getDBClient();
    try {
        await client.connect();

        // Verifica ruolo
        const userCheck = await client.query(
            'SELECT ruolo FROM piloti WHERE id = $1',
            [user.id]
        );

        if (!userCheck.rows[0] || userCheck.rows[0].ruolo !== 'manager') {
            return sendResponse(403, {
                success: false,
                error: 'Solo i manager possono ricaricare i crediti'
            });
        }

        if (!pilota_id || !crediti || crediti <= 0) {
            return sendResponse(400, {
                success: false,
                error: 'Dati richiesti mancanti o non validi'
            });
        }

        // Usa funzione SQL per ricarica
        await client.query(
            'SELECT ricarica_crediti($1, $2, $3, $4, $5)',
            [pilota_id, crediti, 'Manuale', motivo || 'Ricarica manuale', user.id]
        );

        return sendResponse(200, {
            success: true,
            message: `Ricaricati ${crediti} crediti con successo`
        });
    } finally {
        await client.end();
    }
};
