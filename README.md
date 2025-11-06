# 🦁 Team Lion Motorsport (TLM)

Sistema completo gestione campionati sim racing Gran Turismo 7 con **Sistema Crediti API**

---

## 📁 Struttura Progetto

```
team-lion-motorsport/
├── index.html                      # TLM Frontend (SPA Gran Turismo)
├── netlify.toml                    # Config Netlify per deploy
├── netlify/functions/
│   └── api.js                      # TLM Backend API + Sistema Crediti
├── tlm_schema.sql                  # Database PostgreSQL schema completo
├── tlm_seed_data.sql               # Dati di test TLM
└── TEST_API_GUIDE.md              # 🧪 Guida test API TLM
```

---

## 🦁 Team Lion Motorsport (TLM)

### Descrizione
Sistema completo gestione campionati sim racing Gran Turismo 7 con:
- Autenticazione piloti (JWT)
- Classifiche in tempo reale
- Calendario gare
- Sistema reclami
- **Sistema crediti API completo**

### ✨ Sistema Crediti API

#### Features
- ✅ **1000 crediti** iniziali per ogni pilota
- ✅ **Consumo automatico** per ogni chiamata API
- ✅ **Costi differenziati** per endpoint (1-3 crediti)
- ✅ **Log completo** utilizzo (IP, timing, status)
- ✅ **Dashboard frontend** con stats real-time
- ✅ **Ricariche crediti** (solo manager)
- ✅ **Response 429** se crediti insufficienti

#### Database Tables
```sql
api_credits              → Saldo crediti per pilota
api_usage                → Log chiamate API
api_credit_recharges     → Storico ricariche
api_endpoint_costs       → Configurazione costi
```

#### Costi Endpoint
| Endpoint | Costi | Tipo |
|----------|-------|------|
| Login/Register | 0 | Auth |
| Stats/Piloti | 1 | Read |
| Classifica | 2 | Complex |
| Risultati | 3 | Write |

### 🚀 Quick Start TLM

1. **Setup Database**
```bash
psql 'postgresql://user:pass@host:5432/tlm_db?sslmode=require' -f tlm_schema.sql
psql 'postgresql://user:pass@host:5432/tlm_db?sslmode=require' -f tlm_seed_data.sql
```

2. **Configure Netlify**
```bash
# Environment Variables
DATABASE_URL=postgresql://user:pass@host:5432/tlm_db
JWT_SECRET=your-secret-key-here
```

3. **Deploy**
```bash
git push origin main
# Netlify auto-deploy da GitHub
```

4. **Test API**
Vedi guida completa: [TEST_API_GUIDE.md](TEST_API_GUIDE.md)

### 📊 Endpoints API

**Autenticazione** (0 crediti)
- `POST /auth/register` - Registrazione pilota
- `POST /auth/login` - Login

**Crediti API** (0-1 crediti)
- `GET /crediti` - Visualizza saldo (0 crediti)
- `GET /crediti/stats` - Statistiche utilizzo (0 crediti)
- `GET /crediti/storico` - Ultimi 100 utilizzi (1 credito)
- `POST /crediti/ricarica` - Ricarica (solo manager, 0 crediti)

**Dati Gare** (1-3 crediti)
- `GET /piloti` - Lista piloti (1 credito)
- `GET /classifica` - Classifica generale (2 crediti)
- `GET /gare` - Calendario gare (1 credito)
- `GET /stats` - Statistiche generali (1 credito)
- `POST /risultati` - Inserisci risultato (3 crediti)
- `POST /reclami` - Apri reclamo (2 crediti)

---

## 🔧 Tech Stack

### Frontend
- **HTML5 + CSS3**: Single Page Application
- **JavaScript Vanilla**: Gestione stato e routing
- **LocalStorage**: Cache dati e token JWT

### Backend
- **Netlify Functions**: Serverless Node.js
- **PostgreSQL**: Database relazionale (Neon.tech)
- **JWT**: Autenticazione sicura
- **bcryptjs**: Password hashing

### Database
- **PostgreSQL 15+**
- **SQL Functions**: consuma_crediti(), ricarica_crediti()
- **Triggers**: Inizializzazione automatica crediti
- **Transactions**: ACID compliance per crediti

---

## 🧪 Testing

### Test Rapido Sistema Crediti

```bash
# Esegui script di test automatico
./test-credits-production.sh
```

Output atteso:
```
✅ Crediti iniziali corretti: 1000
✅ Consumo crediti funziona: 1000 → 999
✅ Sistema crediti completamente funzionante!
```

### Test Manuale

```bash
# 1. Registrazione
curl -X POST https://phenomenal-quokka-110828.netlify.app/.netlify/functions/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"nome":"Test","email":"test@tlm.com","password":"test123","psn_id":"TestPSN"}'

# 2. Salva token
export TOKEN="eyJ..."

# 3. Verifica crediti
curl https://phenomenal-quokka-110828.netlify.app/.netlify/functions/api/crediti \
  -H "Authorization: Bearer $TOKEN"
```

Vedi guida completa: [TEST_API_GUIDE.md](TEST_API_GUIDE.md)

---

## 🚀 Deployment

### Production
- **URL**: https://phenomenal-quokka-110828.netlify.app
- **Database**: Neon PostgreSQL (us-east-2)
- **Branch**: `main`
- **Auto-deploy**: ✅ Attivo da GitHub

### Deploy Preview
- Ogni Pull Request genera un deploy preview automatico
- URL: `https://deploy-preview-{PR-NUMBER}--phenomenal-quokka-110828.netlify.app`

---

## 📦 Database Schema

### Core Tables (19 tabelle)
- `piloti` - Utenti registrati
- `campionati` - Stagioni racing
- `gare` - Eventi calendario
- `iscrizioni_campionati` - Iscrizioni piloti
- `risultati_gare` - Risultati e punti
- `classifiche` - Ranking generale
- `reclami` - Sistema dispute

### Credits System (4 tabelle)
- `api_credits` - Saldo crediti per pilota
- `api_usage` - Log completo chiamate API
- `api_credit_recharges` - Storico ricariche
- `api_endpoint_costs` - Configurazione costi endpoint

---

## 🔐 Security

### Best Practices
- ✅ JWT tokens con expiry 24h
- ✅ Password hashed con bcryptjs (10 rounds)
- ✅ SQL injection protection (parameterized queries)
- ✅ Rate limiting via credits system
- ✅ HTTPS only
- ✅ Security headers (CSP, X-Frame-Options, etc.)

### Environment Variables
```bash
DATABASE_URL=postgresql://user:pass@host:5432/db?sslmode=require
JWT_SECRET=strong-random-secret-key-here
```

---

## 📊 Sistema Crediti - Architettura

### Flow Consumo Crediti

```
1. Request → Authentication → User ID estratto
2. Middleware controlla saldo crediti
3. Se crediti sufficienti:
   - SQL function consuma_crediti() (TRANSACTION SAFE)
   - Handler endpoint eseguito
   - Log API usage salvato
   - Response 200
4. Se crediti insufficienti:
   - Response 429 "Crediti insufficienti"
```

### SQL Functions

**consuma_crediti(pilota_id, endpoint, costo)**
- Lock FOR UPDATE per evitare race conditions
- Controlla saldo disponibile
- Aggiorna crediti in transazione atomica
- Returns TRUE/FALSE

**ricarica_crediti(pilota_id, quantita, motivo)**
- Aggiunge crediti al saldo
- Log ricarica per audit trail

**get_api_stats(pilota_id)**
- Statistiche utilizzo API
- Chiamate oggi/settimana
- Media response time

---

## 📈 Monitoring

### Metriche Disponibili
- Crediti disponibili per pilota
- Chiamate API per endpoint
- Response time medio
- Errori 429 (out of credits)
- Top consumers

### Dashboard Frontend
Visibile in `/crediti` dopo login:
- 💰 Crediti disponibili
- 📊 Crediti utilizzati totali
- 📞 Chiamate oggi
- 📅 Chiamate settimana
- 📜 Storico ultimi 100 utilizzi

---

## 🐛 Troubleshooting

### Errore "Crediti insufficienti" (429)
```json
{"success": false, "error": "Crediti insufficienti"}
```
**Soluzione**: Contatta admin per ricarica crediti

### Errore "Token non valido"
**Cause possibili**:
1. Token scaduto (>24h)
2. JWT_SECRET cambiato
3. Token da ambiente diverso (dev vs prod)

**Soluzione**: Rigenera token con `/auth/login`

### Database Connection Error
**Verifica**:
1. DATABASE_URL corretto in Netlify env vars
2. IP whitelisting su Neon dashboard
3. SSL mode attivo (`?sslmode=require`)

---

## 📝 Changelog

### v1.2.0 - Sistema Crediti API (2025-01-06)
- ✨ Aggiunto sistema crediti completo
- ✨ Middleware consumo automatico
- ✨ Dashboard frontend crediti
- ✨ 4 nuove tabelle database
- ✨ 5 SQL functions + 4 triggers
- 📝 Documentazione completa TEST_API_GUIDE.md

### v1.1.0 - Database Schema Complete
- ✨ Aggiunte 3 tabelle mancanti
- 🐛 Fix 500 errors su endpoint campionati
- ✨ Colonna creato_da in campionati

### v1.0.0 - Initial Release
- ✨ Sistema autenticazione JWT
- ✨ CRUD campionati e gare
- ✨ Classifiche real-time
- ✨ Sistema reclami

---

## 👥 Team

**Progetto**: Team Lion Motorsport
**Sim Racing**: Gran Turismo 7
**Platform**: PlayStation 5

---

## 📄 License

© 2025 Team Lion Motorsport - All Rights Reserved

---

## 🔗 Links

- **Production**: https://phenomenal-quokka-110828.netlify.app
- **Netlify Dashboard**: https://app.netlify.com/sites/phenomenal-quokka-110828
- **Database**: Neon PostgreSQL (us-east-2)

---

**Sistema Crediti API** ⚡ **Production Ready** ✅
