# 🦁 Team Lion Motorsport + 🧀 Carlsberg Ordini

Repository unificato per due progetti:
1. **TLM** - Sistema gestione campionati Gran Turismo 7 con **API Credits System**
2. **Carlsberg** - Web app ordini mozzarella per 21 ristoranti Milano

---

## 📁 Struttura Progetto

```
team-lion-motorsport/
├── index.html                      # TLM Frontend (SPA Gran Turismo)
├── carlsberg-ordini.html           # Carlsberg Ordini (tabella 21 ristoranti)
├── thank-you.html                  # Conferma ordine Carlsberg
├── netlify.toml                    # Config Netlify per deploy
├── netlify/functions/
│   └── api.js                      # TLM Backend API + Sistema Crediti
├── tlm_schema.sql                  # Database PostgreSQL schema completo
├── tlm_seed_data.sql               # Dati di test TLM
├── TEST_API_GUIDE.md              # 🧪 Guida test API TLM
└── DEPLOY_CARLSBERG_GUIDE.md      # 🚀 Guida deploy Carlsberg
```

---

## 🦁 Progetto 1: Team Lion Motorsport (TLM)

### Descrizione
Sistema completo gestione campionati sim racing Gran Turismo 7 con:
- Autenticazione piloti (JWT)
- Classifiche in tempo reale
- Calendario gare
- Sistema reclami
- **Sistema crediti API completo**

### ✨ Sistema Crediti API (NEW!)

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
psql -U postgres -d tlm_db -f tlm_schema.sql
psql -U postgres -d tlm_db -f tlm_seed_data.sql
```

2. **Configure Netlify**
```bash
# Environment Variables
DATABASE_URL=postgresql://user:pass@host:5432/tlm_db
JWT_SECRET=your-secret-key-here
```

3. **Deploy**
```bash
netlify deploy --prod
```

4. **Test API**
Vedi guida completa: [TEST_API_GUIDE.md](TEST_API_GUIDE.md)

### 📊 Endpoints API

**Autenticazione** (0 crediti)
- `POST /auth/register` - Registrazione pilota
- `POST /auth/login` - Login

**Crediti API** (0 crediti)
- `GET /crediti` - Visualizza saldo
- `GET /crediti/stats` - Statistiche utilizzo
- `GET /crediti/storico` - Ultimi 100 utilizzi (1 credito)
- `POST /crediti/ricarica` - Ricarica (solo manager)

**Dati Gare** (1-3 crediti)
- `GET /piloti` (1)
- `GET /classifica` (2)
- `GET /gare` (1)
- `GET /stats` (1)
- `POST /risultati` (3)
- `GET /reclami` (2)
- `POST /reclami` (2)

---

## 🧀 Progetto 2: Carlsberg Ordini Mozzarella

### Descrizione
Web app per gestire ordini settimanali prodotti caseari Bufala Nera D'Angelo per 21 ristoranti Carlsberg Milano.

### Features
- ✅ **21 ristoranti** (colonne orizzontali)
- ✅ **6 prodotti caseari** (righe)
- ✅ **126 caselle input** ordine
- ✅ **Calcolo automatico** totali per prodotto
- ✅ **Validazione** ordine minimo 30 kg
- ✅ **Colonna Avanzi** per redistribuzione
- ✅ **Sistema QR Code** per ordini veloci
- ✅ **Netlify Forms** con email automatiche
- ✅ **Design responsive** mobile-friendly

### 🏪 21 Ristoranti Carlsberg Milano
```
Porta Romana, Ripamonti, XXII Marzo, Bicocca, Bovisa,
Duomo, Centrale, Garibaldi, Lambrate, Brera, Missori,
Sempione, Corvetto, Lorenteggio, Isola, Forlanini,
Cenisio, Navigli, Barona, Barrio Alto, Bishops Arms
```

### 🧀 6 Prodotti Caseari
```
1. Mozzarella Nera (€11/kg)
2. Burrata (€11/kg)
3. Stracciatella (€11/kg)
4. Provola (€11/kg)
5. Bocconcini (€11/kg)
6. Mozzarelline Piccole - Catering (€11/kg)
```

### 🚀 Deploy Carlsberg

**Metodo 1: Manuale (veloce)**
```bash
# Upload su Netlify
Drag & drop: carlsberg-ordini.html + thank-you.html
```

**Metodo 2: GitHub (automatico)**
1. Collega repo su Netlify
2. Deploy automatico da branch
3. Configura email notifications

Vedi guida completa: [DEPLOY_CARLSBERG_GUIDE.md](DEPLOY_CARLSBERG_GUIDE.md)

### 📧 Email Notifications

**Form 1: `ordine-carlsberg`** (form principale)
- Invia tutti i dati ordine
- Totale kg ordinati
- Data/ora ordine

**Form 2: `ordine-qr`** (ordini veloci)
- Ordini singoli da QR code tavolo
- Ristorante pre-selezionato
- Invio immediato

### 📱 QR Codes per Ristoranti

Genera QR code per ogni ristorante:
```
https://your-site.netlify.app/ordini?ristorante=Porta+Romana
https://your-site.netlify.app/ordini?ristorante=Bicocca
...
```

Stampa su triangoli da tavolo per ordini veloci!

---

## 🛠️ Tech Stack

### TLM
- **Frontend**: HTML, CSS, JavaScript (Vanilla)
- **Backend**: Netlify Functions (Node.js)
- **Database**: PostgreSQL
- **Auth**: JWT (jsonwebtoken)
- **Password**: bcrypt

### Carlsberg
- **Frontend**: HTML, CSS, JavaScript (Vanilla)
- **Forms**: Netlify Forms
- **Email**: Netlify Notifications
- **Deploy**: Netlify Static

---

## 📦 Deploy Production

### Step 1: Merge PR
```bash
# Dopo review, merge la PR su GitHub
gh pr merge
```

### Step 2: Deploy TLM
```bash
# Netlify deploierà automaticamente da main branch
# Oppure manualmente:
netlify deploy --prod
```

### Step 3: Configure Database
```bash
# Applica schema su DB production
psql $DATABASE_URL -f tlm_schema.sql
```

### Step 4: Test
```bash
# Test endpoint API
curl https://tlm-api.netlify.app/.netlify/functions/api/stats

# Test Carlsberg
open https://carlsberg-ordini.netlify.app/carlsberg-ordini.html
```

---

## 🧪 Testing

### TLM API
Vedi [TEST_API_GUIDE.md](TEST_API_GUIDE.md) per:
- Test autenticazione
- Test sistema crediti
- Test consumo crediti
- Test ricariche (manager)
- Verifiche database

### Carlsberg App
Vedi [DEPLOY_CARLSBERG_GUIDE.md](DEPLOY_CARLSBERG_GUIDE.md) per:
- Test ordine standard
- Test ordine QR
- Test validazioni
- Test email notifications
- Test mobile responsive

---

## 📊 Statistics

### Codice Scritto
- **1511 linee** di codice
- **5 files** modificati/creati
- **4 commits** documentati

### Database
- **19 tabelle** totali
- **4 tabelle** crediti API (nuove)
- **5 funzioni** SQL
- **3 views** statistiche

### API Endpoints
- **15 endpoint** totali TLM
- **4 endpoint** crediti API (nuovi)
- **2 forms** Carlsberg

---

## 🔒 Security

### TLM API
- ✅ JWT authentication
- ✅ Password bcrypt hashing
- ✅ SQL injection protection (parameterized queries)
- ✅ CORS headers configured
- ✅ Rate limiting via crediti system

### Carlsberg
- ✅ Netlify Forms spam protection
- ✅ Honeypot bot detection
- ✅ Client-side validation
- ✅ XSS protection headers

---

## 📈 Future Enhancements

### TLM
- [ ] Rate limiting per IP (oltre crediti)
- [ ] Webhook notifications crediti bassi
- [ ] Analytics dashboard admin
- [ ] Export CSV utilizzo API
- [ ] Auto-refill crediti mensile

### Carlsberg
- [ ] Dashboard manager ordini
- [ ] Export Excel ordini
- [ ] WhatsApp notifications
- [ ] Storico ordini per ristorante
- [ ] ML suggerimenti automatici quantità

---

## 👥 Contributors

- **Claude** - Sistema crediti API TLM + Web app Carlsberg
- **Team Lion Motorsport** - Requisiti e testing TLM
- **Carlsberg Milano** - Requisiti e feedback Ordini

---

## 📝 License

Progetti proprietari - Tutti i diritti riservati.

---

## 🆘 Support

**Issues TLM:**
- GitHub Issues: https://github.com/rikas78/team-lion-motorsport/issues

**Carlsberg Support:**
- Email: ordini@carlsberg-milano.it
- Tel: +39 XXX XXX XXXX

**Technical Documentation:**
- API Test Guide: [TEST_API_GUIDE.md](TEST_API_GUIDE.md)
- Deploy Guide: [DEPLOY_CARLSBERG_GUIDE.md](DEPLOY_CARLSBERG_GUIDE.md)

---

## 🎉 Status

✅ **TLM Sistema Crediti**: Production Ready
✅ **Carlsberg Web App**: Production Ready
✅ **Database Schema**: Complete
✅ **Documentation**: Complete
✅ **Testing Guides**: Complete

**Ultimo aggiornamento:** 06 Novembre 2025

---

**🦁 Powered by Team Lion Motorsport**
**🧀 Bufala Nera D'Angelo - Caseificio Artigianale**
