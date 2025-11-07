# 🚀 Team Lion Motorsport - Deployment Produzione

## ✅ PRE-REQUISITI

Prima di iniziare, assicurati di avere:
- Account Netlify (gratuito o a pagamento)
- Database PostgreSQL (consigliato: Supabase, Neon, Railway, o Heroku Postgres)
- Repository GitHub connesso

---

## 📋 STEP 1: Setup Database PostgreSQL Produzione

### Opzione A: Supabase (CONSIGLIATO - Gratuito)

1. Vai su [https://supabase.com](https://supabase.com)
2. Crea un nuovo progetto
3. Aspetta che il database sia pronto
4. Vai su **Settings → Database**
5. Copia la **Connection String** in formato URI:
   ```
   postgres://postgres:[PASSWORD]@[HOST]:5432/postgres
   ```

### Opzione B: Neon (Gratuito)

1. Vai su [https://neon.tech](https://neon.tech)
2. Crea nuovo progetto
3. Copia la connection string PostgreSQL

### Opzione C: Railway (Gratuito per iniziare)

1. Vai su [https://railway.app](https://railway.app)
2. Crea nuovo progetto → Add PostgreSQL
3. Copia la DATABASE_URL

---

## 📋 STEP 2: Esegui le Migrazioni Database

Una volta ottenuta la connection string del database:

### Via pgAdmin / Postico / TablePlus

1. Connettiti al database usando la connection string
2. Esegui i file SQL in questo ordine:

```sql
-- 1. Schema principale
\i tlm_schema.sql

-- 2. Dati iniziali
\i tlm_seed_data.sql

-- 3. Migrazione 001
\i tlm_migration_001.sql

-- 4. Migrazione 002 (Lions on Fire + Comunicazioni + Allenamenti)
\i tlm_migration_002.sql
```

### Via Command Line (psql)

```bash
# Connetti al database
psql "postgres://user:password@host:5432/dbname"

# Esegui i file
\i tlm_schema.sql
\i tlm_seed_data.sql
\i tlm_migration_001.sql
\i tlm_migration_002.sql
```

### Via Supabase SQL Editor

1. Vai su **SQL Editor** nel dashboard Supabase
2. Copia e incolla il contenuto di ogni file SQL
3. Esegui nell'ordine: schema → seed → migration_001 → migration_002

---

## 📋 STEP 3: Configurazione Netlify

### 3.1 Connetti Repository

1. Login su [Netlify](https://www.netlify.com)
2. Click su **Add new site → Import an existing project**
3. Seleziona **GitHub** e autorizza
4. Seleziona il repository `rikas78/team-lion-motorsport`
5. Scegli il branch: **claude/protect-main-branch-011CUsSKiJzfwCzZqpuvwspJ** (o main dopo il merge)

### 3.2 Configurazione Build

Netlify dovrebbe rilevare automaticamente le impostazioni da `netlify.toml`:

- **Build command**: `npm install`
- **Publish directory**: `.` (root)
- **Functions directory**: `netlify/functions`

Se non rileva automaticamente, inserisci manualmente.

### 3.3 Variabili d'Ambiente

**IMPORTANTE**: Vai su **Site settings → Environment variables** e aggiungi:

```bash
# Database PostgreSQL
DATABASE_URL=postgres://user:password@host:5432/dbname

# JWT Secret (CAMBIALO!)
JWT_SECRET=TUO_SECRET_SUPER_SICURO_MINIMO_32_CARATTERI

# Node Environment
NODE_ENV=production
```

**⚠️ SECURITY:**
- **NON usare** `supersecretkey123` in produzione!
- Genera un secret sicuro:
  ```bash
  # Linux/Mac
  openssl rand -base64 32

  # Online
  https://www.grc.com/passwords.htm
  ```

### 3.4 Deploy

1. Click su **Deploy site**
2. Aspetta che il build completi (circa 1-2 minuti)
3. Verifica che non ci siano errori nei logs

---

## 📋 STEP 4: Verifica Post-Deployment

### 4.1 Test API

Apri il sito deployato e vai alla console del browser (F12):

```javascript
// Test API Health
fetch('https://tuo-sito.netlify.app/api/piloti')
  .then(r => r.json())
  .then(d => console.log(d))

// Test Login
fetch('https://tuo-sito.netlify.app/api/auth/login', {
  method: 'POST',
  headers: {'Content-Type': 'application/json'},
  body: JSON.stringify({
    email: 'rikas78@example.com',
    password: 'password123'
  })
})
  .then(r => r.json())
  .then(d => console.log(d))
```

### 4.2 Test Frontend

1. Vai su **Login**
2. Usa credenziali di test:
   - Email: `rikas78@example.com`
   - Password: `password123`
3. Verifica che la home carichi:
   - Comunicazioni
   - Lions on Fire (se configurato)
   - Allenamenti
   - TOP 5 Classifiche
4. Vai su **Profilo** e verifica i dati

### 4.3 Test Upload CSV

1. Login come manager
2. Vai su **Upload CSV**
3. Seleziona una gara
4. Carica un CSV di test:
   ```csv
   posizione,pilota_id,psn_id,tempo_totale,giro_veloce,auto_utilizzata
   1,1,rikas78,01:25:30.123,02:15.456,Porsche 911 GT3 R
   2,2,Mikedb_91_,01:25:45.789,02:16.123,BMW M4 GT3
   ```
5. Verifica che le classifiche si aggiornino automaticamente

---

## 📋 STEP 5: Configurazione Dominio (Opzionale)

### 5.1 Dominio Custom

1. Vai su **Site settings → Domain management**
2. Click su **Add custom domain**
3. Inserisci il tuo dominio (es. `teamlionmotorsport.it`)
4. Segui le istruzioni per configurare i DNS

### 5.2 SSL/HTTPS

Netlify attiva automaticamente HTTPS gratuito con Let's Encrypt.
Verifica che il certificato sia attivo dopo 24h dalla configurazione DNS.

---

## 📋 STEP 6: Gestione Utenti Produzione

### 6.1 Cambio Password di Default

⚠️ **IMPORTANTE**: Tutti gli utenti hanno password `password123` di default!

**Opzione A - Via Database:**
```sql
-- Genera hash bcrypt per nuova password
-- Usa: https://bcrypt-generator.com/
UPDATE piloti
SET password = '$2a$10$NUOVO_HASH_BCRYPT'
WHERE email = 'rikas78@example.com';
```

**Opzione B - Implementa Reset Password:**
Aggiungi endpoint `/api/auth/reset-password` (da sviluppare se necessario)

### 6.2 Crea Nuovo Manager

```sql
INSERT INTO piloti (
  nome, email, password, psn_id, categoria, ruolo, numero_gara
) VALUES (
  'Nome Amministratore',
  'admin@teamlionmotorsport.it',
  '$2a$10$TUO_HASH_BCRYPT',
  'psn_id',
  'Manager',
  'manager',
  NULL
);
```

---

## 📋 STEP 7: Backup e Manutenzione

### 7.1 Backup Automatico Database

**Supabase**: Backup giornalieri automatici inclusi nel piano gratuito

**Neon**: Backup automatici con retention 7 giorni

**Manuale**: Esegui settimanalmente:
```bash
pg_dump "postgres://user:password@host:5432/dbname" > backup_$(date +%Y%m%d).sql
```

### 7.2 Monitoring

- **Netlify Analytics**: Attiva per vedere traffico e performance
- **Database Monitoring**: Controlla connessioni e query lente
- **Error Tracking**: Controlla i logs di Netlify per errori

### 7.3 Aggiornamenti

Quando fai modifiche:
1. Commit e push su GitHub
2. Netlify rebuilda automaticamente
3. Zero downtime per gli utenti

---

## 🔒 SECURITY CHECKLIST

Prima di andare live, verifica:

- [ ] Database connection string è in variabile d'ambiente (NON hardcoded)
- [ ] JWT_SECRET è stato cambiato da quello di default
- [ ] Password utenti di default sono state cambiate
- [ ] SSL/HTTPS è attivo
- [ ] Backup database configurato
- [ ] Errori di produzione non mostrano stack traces completi
- [ ] CORS configurato correttamente
- [ ] Rate limiting sugli endpoint (opzionale ma consigliato)

---

## 📊 COSA FARE DOPO IL DEPLOYMENT

### Configurare Lions on Fire

Per attivare "Lions on Fire" per una gara:

```sql
INSERT INTO lions_on_fire (
  gara_id,
  canale_streaming,
  descrizione,
  data_inizio,
  data_fine
) VALUES (
  1,  -- ID della gara
  'https://twitch.tv/teamlionmotorsport',
  'Segui la gara in diretta!',
  '2025-01-20 23:30:00',  -- Inizio (23:30 del giorno prima)
  '2025-01-21 23:30:00'   -- Fine (23:30 del giorno della gara)
);
```

### Creare Comunicazioni

```sql
INSERT INTO comunicazioni (
  titolo,
  messaggio,
  tipo,
  priorita,
  creato_da
) VALUES (
  'Benvenuto!',
  'Sistema Team Lion Motorsport è ora online!',
  'Info',
  1,
  1  -- ID del manager
);
```

### Programmare Allenamenti

Usa l'endpoint API o inserisci direttamente:

```sql
INSERT INTO allenamenti (
  titolo,
  descrizione,
  data_allenamento,
  durata_minuti,
  circuito,
  tipo_trazione,
  max_partecipanti,
  canale_streaming,
  creato_da
) VALUES (
  'Allenamento Pre-Gara',
  'Preparazione per la gara di domenica',
  '2025-01-19 20:00:00',
  90,
  'Monza',
  'ALL',
  20,
  'https://twitch.tv/teamlionmotorsport',
  1
);
```

---

## 🆘 TROUBLESHOOTING

### Errore: "Database connection failed"

- Verifica che DATABASE_URL sia configurata correttamente su Netlify
- Controlla che il database sia accessibile pubblicamente
- Verifica username/password

### Errore: "JWT verification failed"

- Verifica che JWT_SECRET sia uguale tra deploy
- Fai logout e re-login

### Frontend mostra pagina bianca

- Apri console browser (F12) per vedere errori JavaScript
- Verifica che `/api/piloti` risponda correttamente
- Controlla che index.html sia stato deployato

### CSV Upload non funziona

- Verifica formato CSV (vedi esempio sopra)
- Controlla che l'utente sia autenticato
- Verifica che la gara_id esista nel database

---

## 📞 SUPPORTO

Se hai problemi:
1. Controlla i logs di Netlify (Site → Functions → Logs)
2. Controlla i logs del database
3. Verifica le variabili d'ambiente
4. Ricontrolla che tutte le migrazioni siano state eseguite

---

## ✅ CHECKLIST FINALE DEPLOYMENT

- [ ] Database PostgreSQL creato e configurato
- [ ] Migrazioni SQL eseguite (schema + seed + migration_001 + migration_002)
- [ ] Repository connesso a Netlify
- [ ] Variabili d'ambiente configurate (DATABASE_URL, JWT_SECRET)
- [ ] Site deployato con successo
- [ ] Test login funzionante
- [ ] API endpoints rispondono
- [ ] Upload CSV testato
- [ ] Password di default cambiate
- [ ] Backup database configurato
- [ ] SSL/HTTPS attivo
- [ ] Dominio custom configurato (opzionale)

**🎉 Sistema pronto per la produzione!**
