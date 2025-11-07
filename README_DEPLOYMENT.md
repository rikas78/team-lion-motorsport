# 🦁 Team Lion Motorsport - DEPLOYMENT UFFICIALE

## 📋 QUICK START - Deployment in 5 Step

### 1️⃣ Database PostgreSQL

**CONSIGLIATO: Supabase (Gratuito)**

1. Vai su [https://supabase.com](https://supabase.com)
2. Crea nuovo progetto
3. Vai su **Settings → Database**
4. Copia la **Connection String**:
   ```
   postgres://postgres:[PASSWORD]@[HOST]:5432/postgres
   ```

### 2️⃣ Esegui Migrazioni SQL

Nel SQL Editor di Supabase (o tramite psql), esegui in ordine:

```sql
-- 1. Schema principale
\i tlm_schema.sql

-- 2. Dati iniziali (37 piloti + campionati)
\i tlm_seed_data.sql

-- 3. Tabelle iscrizioni e documenti
\i tlm_migration_001.sql

-- 4. Lions on Fire + Comunicazioni + Allenamenti
\i tlm_migration_002.sql
```

### 3️⃣ Deploy su Netlify

1. Login su [Netlify](https://www.netlify.com)
2. **Add new site → Import from GitHub**
3. Seleziona repository: `rikas78/team-lion-motorsport`
4. Branch: `claude/protect-main-branch-011CUsSKiJzfwCzZqpuvwspJ`
5. Click **Deploy site**

### 4️⃣ Variabili d'Ambiente Netlify

Vai su **Site settings → Environment variables** e aggiungi:

```bash
DATABASE_URL=postgres://postgres:[PASSWORD]@[HOST]:5432/postgres
JWT_SECRET=[GENERA_SECRET_SICURO_32_CARATTERI]
NODE_ENV=production
```

**Genera JWT_SECRET sicuro:**
```bash
openssl rand -base64 32
```

### 5️⃣ Verifica Funzionamento

1. Apri il sito deployato
2. Login con:
   - Email: `rikas78@example.com`
   - Password: `password123`
3. Verifica che funzionino:
   - Home dashboard
   - Comunicazioni
   - Classifiche
   - Profilo utente

---

## ✅ CHECKLIST PRE-PRODUZIONE

Prima di rendere pubblico il sito:

### Security
- [ ] Database connection string in variabile d'ambiente ✅
- [ ] JWT_SECRET cambiato (NON usare `supersecretkey123`!) ⚠️
- [ ] Password di default cambiate per tutti gli utenti ⚠️
- [ ] SSL/HTTPS attivo su Netlify ✅

### Funzionalità
- [ ] Login/Registrazione funzionante
- [ ] Upload CSV risultati testato
- [ ] Classifiche si aggiornano automaticamente
- [ ] Profilo utente carica correttamente
- [ ] API rispondono senza errori

### Backup
- [ ] Backup automatico database attivato (Supabase lo include)
- [ ] Download backup manuale settimanale

---

## 📚 DOCUMENTAZIONE COMPLETA

Per istruzioni dettagliate, vedi:
- **DEPLOYMENT_PRODUZIONE.md** - Guida completa deployment
- **DATABASE_SETUP.md** - Setup database dettagliato
- **GUIDA_UTILIZZO.md** - Come usare il sistema

---

## 🔧 CONFIGURAZIONE POST-DEPLOYMENT

### Cambia Password Manager

**Via SQL:**
```sql
-- Genera hash bcrypt su https://bcrypt-generator.com/
UPDATE piloti
SET password = '$2a$10$NUOVO_HASH_BCRYPT'
WHERE email = 'rikas78@example.com';
```

### Attiva Lions on Fire per una Gara

```sql
INSERT INTO lions_on_fire (
  gara_id,
  canale_streaming,
  descrizione,
  data_inizio,
  data_fine
) VALUES (
  1,
  'https://twitch.tv/teamlionmotorsport',
  'Segui la gara in diretta!',
  '2025-01-20 23:30:00',
  '2025-01-21 23:30:00'
);
```

### Crea una Comunicazione

```sql
INSERT INTO comunicazioni (
  titolo,
  messaggio,
  tipo,
  priorita,
  creato_da
) VALUES (
  'Benvenuti!',
  'Sistema Team Lion Motorsport è online!',
  'Info',
  1,
  1
);
```

---

## 🆘 PROBLEMI COMUNI

**Database connection failed**
→ Verifica DATABASE_URL in Netlify Environment Variables

**JWT verification failed**
→ Assicurati che JWT_SECRET sia configurato

**Pagina bianca**
→ Apri console browser (F12) per vedere errori

**Upload CSV non funziona**
→ Verifica formato CSV (vedi GUIDA_UTILIZZO.md)

---

## 📞 SUPPORTO

Controlla i logs:
- **Netlify**: Site → Functions → Logs
- **Database**: Supabase Dashboard → Logs

---

## 🎯 SISTEMA PRONTO

Una volta completati questi passi, il sistema Team Lion Motorsport è UFFICIALMENTE in produzione! 🚀

**Feature complete:**
- ✅ Login/Registrazione
- ✅ Classifiche automatiche
- ✅ Upload CSV risultati
- ✅ Lions on Fire (piloti che corrono oggi)
- ✅ Allenamenti programmati
- ✅ Comunicazioni importanti
- ✅ Profilo pilota completo
- ✅ 37 piloti pre-caricati
- ✅ 3 campionati configurati
- ✅ 7 gare programmate

**Enjoy! 🦁**
