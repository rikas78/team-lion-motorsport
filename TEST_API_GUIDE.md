# 🧪 Guida Test API TLM - Sistema Crediti

## ⚙️ Prerequisiti

1. **Database PostgreSQL configurato** con schema applicato (`tlm_schema.sql`)
2. **Environment variables** in Netlify:
   - `DATABASE_URL` - Connection string PostgreSQL
   - `JWT_SECRET` - Secret per token JWT

3. **URL API Base**: `https://your-site.netlify.app/.netlify/functions/api`

---

## 🔑 1. Test Autenticazione (Gratuiti - 0 crediti)

### Registrazione Nuovo Pilota
```bash
curl -X POST https://your-site.netlify.app/.netlify/functions/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "nome": "Mario Rossi",
    "email": "mario.rossi@test.com",
    "password": "password123",
    "psn_id": "MarioRacing99"
  }'
```

**Risposta Attesa:**
```json
{
  "success": true,
  "token": "eyJhbGc...",
  "user": {
    "id": 1,
    "nome": "Mario Rossi",
    "email": "mario.rossi@test.com",
    "categoria": "Academy"
  }
}
```

✅ **Verifica Database:**
- Pilota creato in tabella `piloti`
- **1000 crediti** inizializzati automaticamente in `api_credits` (trigger)

---

### Login
```bash
curl -X POST https://your-site.netlify.app/.netlify/functions/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "mario.rossi@test.com",
    "password": "password123"
  }'
```

**Salva il token** dalla risposta per i test successivi!

```bash
# Salva il token in variabile
export TOKEN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

---

## 🪙 2. Test Endpoint Crediti

### A) Visualizza Crediti (0 crediti)
```bash
curl -X GET https://your-site.netlify.app/.netlify/functions/api/crediti \
  -H "Authorization: Bearer $TOKEN"
```

**Risposta Attesa:**
```json
{
  "success": true,
  "crediti": {
    "crediti_disponibili": 1000,
    "crediti_totali_utilizzati": 0,
    "ultimo_utilizzo": null,
    "ultimo_ricarico": null
  }
}
```

---

### B) Statistiche Crediti (0 crediti)
```bash
curl -X GET https://your-site.netlify.app/.netlify/functions/api/crediti/stats \
  -H "Authorization: Bearer $TOKEN"
```

**Risposta Attesa:**
```json
{
  "success": true,
  "stats": {
    "crediti_disponibili": 1000,
    "crediti_utilizzati": 0,
    "chiamate_oggi": 0,
    "chiamate_settimana": 0,
    "chiamate_totali": 0
  }
}
```

---

### C) Storico Utilizzo (1 credito)
```bash
curl -X GET https://your-site.netlify.app/.netlify/functions/api/crediti/storico \
  -H "Authorization: Bearer $TOKEN"
```

**Dopo questa chiamata:**
- ✅ 999 crediti disponibili (consumato 1)
- ✅ Log in tabella `api_usage`

---

## 📊 3. Test Endpoint Standard (Consumano Crediti)

### Lista Piloti (1 credito)
```bash
curl -X GET https://your-site.netlify.app/.netlify/functions/api/piloti \
  -H "Authorization: Bearer $TOKEN"
```

**Costo:** 1 credito
**Risposta:**
```json
{
  "success": true,
  "totale": 5,
  "piloti": [...]
}
```

---

### Classifica Campionato (2 crediti)
```bash
curl -X GET https://your-site.netlify.app/.netlify/functions/api/classifica?campionato_id=1 \
  -H "Authorization: Bearer $TOKEN"
```

**Costo:** 2 crediti

---

### Stats Generali (1 credito)
```bash
curl -X GET https://your-site.netlify.app/.netlify/functions/api/stats \
  -H "Authorization: Bearer $TOKEN"
```

**Costo:** 1 credito

---

### Gare Prossime (1 credito)
```bash
curl -X GET https://your-site.netlify.app/.netlify/functions/api/gare/prossime \
  -H "Authorization: Bearer $TOKEN"
```

**Costo:** 1 credito

---

### Inserimento Risultato (3 crediti)
```bash
curl -X POST https://your-site.netlify.app/.netlify/functions/api/risultati \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "gara_id": 1,
    "posizione_finale": 3,
    "tempo_totale": "1:45:32",
    "auto_utilizzata": "Mazda RX-7"
  }'
```

**Costo:** 3 crediti (operazione write)

---

## ⚠️ 4. Test Crediti Insufficienti

Consuma tutti i crediti ripetendo chiamate fino ad arrivare a 0:

```bash
# Ripeti 200 volte per consumare tutti i crediti
for i in {1..200}; do
  curl -X GET https://your-site.netlify.app/.netlify/functions/api/piloti \
    -H "Authorization: Bearer $TOKEN"
  echo "Chiamata $i completata"
done
```

Poi prova una chiamata:

```bash
curl -X GET https://your-site.netlify.app/.netlify/functions/api/classifica \
  -H "Authorization: Bearer $TOKEN"
```

**Risposta Attesa (HTTP 429):**
```json
{
  "success": false,
  "error": "Crediti insufficienti",
  "message": "Non hai abbastanza crediti API per questa operazione"
}
```

---

## 💰 5. Test Ricarica Crediti (Solo Manager)

### A) Registra un Manager
Prima devi modificare il ruolo nel database:

```sql
UPDATE piloti
SET ruolo = 'manager'
WHERE email = 'mario.rossi@test.com';
```

### B) Login come Manager
```bash
curl -X POST https://your-site.netlify.app/.netlify/functions/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "mario.rossi@test.com",
    "password": "password123"
  }'
```

### C) Ricarica Crediti (0 crediti - riservato manager)
```bash
curl -X POST https://your-site.netlify.app/.netlify/functions/api/crediti/ricarica \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "pilota_id": 1,
    "crediti": 500,
    "motivo": "Ricarica test sistema"
  }'
```

**Risposta Attesa:**
```json
{
  "success": true,
  "message": "Ricaricati 500 crediti con successo"
}
```

✅ **Verifica:**
- Crediti aggiornati in `api_credits`
- Log in `api_credit_recharges`

---

## 📝 6. Verifica Database

Dopo i test, controlla le tabelle:

### Crediti Disponibili
```sql
SELECT
  p.nome,
  p.email,
  ac.crediti_disponibili,
  ac.crediti_totali_utilizzati,
  ac.ultimo_utilizzo
FROM piloti p
JOIN api_credits ac ON ac.pilota_id = p.id;
```

### Storico Utilizzo API
```sql
SELECT
  p.nome,
  au.endpoint,
  au.metodo,
  au.crediti_consumati,
  au.status_code,
  au.response_time_ms,
  au.created_at
FROM api_usage au
JOIN piloti p ON p.id = au.pilota_id
ORDER BY au.created_at DESC
LIMIT 20;
```

### Ricariche Crediti
```sql
SELECT
  p.nome as pilota,
  acr.crediti_aggiunti,
  acr.tipo_ricarica,
  acr.motivo,
  pm.nome as eseguita_da,
  acr.created_at
FROM api_credit_recharges acr
JOIN piloti p ON p.id = acr.pilota_id
LEFT JOIN piloti pm ON pm.id = acr.eseguita_da
ORDER BY acr.created_at DESC;
```

### View Statistiche
```sql
SELECT * FROM v_api_usage_stats ORDER BY chiamate_totali DESC;
```

---

## ✅ Checklist Test Completa

### Autenticazione
- [ ] Registrazione crea pilota con 1000 crediti
- [ ] Login restituisce token valido
- [ ] Token JWT decodificabile

### Sistema Crediti
- [ ] Endpoint gratuiti (login/register) non consumano crediti
- [ ] Endpoint a pagamento consumano crediti corretti
- [ ] Crediti insufficienti → HTTP 429
- [ ] Log `api_usage` registra tutte le chiamate
- [ ] Manager può ricaricare crediti
- [ ] Piloti normali NON possono ricaricare

### Database
- [ ] Trigger inizializza crediti automaticamente
- [ ] Funzione `consuma_crediti()` funziona
- [ ] Funzione `ricarica_crediti()` funziona
- [ ] View `v_api_usage_stats` aggiornata

### Frontend
- [ ] Dashboard crediti mostra dati corretti
- [ ] Storico utilizzo si aggiorna
- [ ] Bottone ricarica visibile solo per manager

---

## 🚀 Test in Produzione

Dopo il deploy su Netlify:

1. **Configura variabili ambiente** in Netlify UI
2. **Applica schema database** su PostgreSQL production
3. **Crea utente test** con API
4. **Esegui tutti i curl commands** sostituendo l'URL
5. **Monitora logs** Netlify Functions per errori

---

## 📊 Costi Endpoint - Reference

| Endpoint | Costo | Tipo |
|----------|-------|------|
| `/auth/login` | 0 | Auth |
| `/auth/register` | 0 | Auth |
| `/crediti` | 0 | Crediti |
| `/crediti/stats` | 0 | Crediti |
| `/crediti/ricarica` | 0 | Crediti (manager) |
| `/piloti` | 1 | Read |
| `/gare` | 1 | Read |
| `/gare/prossime` | 1 | Read |
| `/stats` | 1 | Read |
| `/crediti/storico` | 1 | Read |
| `/classifica` | 2 | Read Complex |
| `/campionati` | 2 | Read Complex |
| `/reclami` | 2 | Read/Write |
| `/risultati` | 3 | Write |

---

## 🐛 Troubleshooting

### "Crediti insufficienti" subito
→ Verifica trigger `trigger_inizializza_crediti` sia attivo

### Crediti non si decrementano
→ Controlla funzione `consuma_crediti()` nel database

### 401 Unauthorized
→ Token scaduto o non valido, rifai login

### 500 Internal Server Error
→ Controlla logs Netlify e connessione database

---

**✅ Tutti i test passati = Sistema Crediti API Production Ready!** 🚀
