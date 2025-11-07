# 🦁 Team Lion Motorsport - Configurazione Database

## 📋 Panoramica

Il sistema utilizza **PostgreSQL** come database principale. Questo documento spiega come configurare il database da zero.

## 🗄️ File SQL Disponibili

### 1. `tlm_schema.sql`
Schema completo del database con:
- **Tabelle principali**: piloti, campionati, gare, risultati, classifiche
- **Tabelle amministrative**: reclami, penalità, eventi, notifiche
- **Funzioni SQL**: calcolo classifiche e statistiche
- **Views**: query pre-ottimizzate
- **Trigger**: aggiornamenti automatici

### 2. `tlm_seed_data.sql`
Dati di esempio per testing:
- 37 piloti completi del Team Lion
- 3 campionati configurati
- 7 gare programmate (2 completate con risultati)
- Reclami ed eventi di esempio

### 3. `tlm_migration_001.sql`
Migrazione per nuove funzionalità:
- Tabella `iscrizioni_campionati`
- Tabella `documenti_campionato`
- Tabella `impostazioni_gara`
- Dati di esempio per le nuove tabelle

## 🚀 Setup Iniziale

### Passo 1: Creare Database PostgreSQL

Puoi usare vari servizi:
- **Supabase** (consigliato, piano gratuito)
- **Neon** (serverless PostgreSQL)
- **Railway**
- **PostgreSQL locale**

### Passo 2: Ottenere Connection String

Esempio formato:
```
postgresql://username:password@host:5432/database_name
```

### Passo 3: Configurare Variabili d'Ambiente Netlify

Nel dashboard Netlify, vai su **Site settings > Environment variables** e aggiungi:

```bash
DATABASE_URL=postgresql://user:password@host:5432/dbname
JWT_SECRET=una-chiave-segreta-molto-lunga-e-sicura
```

### Passo 4: Eseguire Script SQL

**Ordine di esecuzione:**

1. **Schema base**
```bash
psql $DATABASE_URL -f tlm_schema.sql
```

2. **Dati di esempio** (opzionale, consigliato per testing)
```bash
psql $DATABASE_URL -f tlm_seed_data.sql
```

3. **Migrazione nuove tabelle**
```bash
psql $DATABASE_URL -f tlm_migration_001.sql
```

### Alternativa: Tramite Client Database

Se usi Supabase, Neon o altri servizi con UI:
1. Apri SQL Editor
2. Copia e incolla il contenuto di ogni file nell'ordine indicato
3. Esegui ogni script

## 📊 Struttura Database

### Tabelle Principali

| Tabella | Scopo |
|---------|-------|
| `piloti` | Gestione utenti e piloti |
| `campionati` | Campionati attivi |
| `gare` | Calendario gare |
| `risultati_gare` | Risultati e tempi |
| `classifiche` | Posizioni campionato |
| `statistiche_piloti` | Stats aggregate piloti |
| `iscrizioni_campionati` | Iscrizioni piloti ai campionati |
| `documenti_campionato` | Regolamenti e documenti |
| `impostazioni_gara` | Settings di ogni gara |
| `reclami` | Sistema gestione reclami |
| `penalita` | Penalità applicate |
| `eventi` | Calendario eventi |
| `notifiche` | Sistema notifiche |
| `sessioni` | JWT token storage |

### Funzioni SQL Disponibili

#### `calcola_classifica(campionato_id)`
Ricalcola la classifica di un campionato basandosi sui risultati.

Esempio:
```sql
SELECT calcola_classifica(1);
```

#### `aggiorna_statistiche_pilota(pilota_id)`
Aggiorna le statistiche totali di un pilota.

Esempio:
```sql
SELECT aggiorna_statistiche_pilota(10);
```

### Views Utili

#### `v_classifica_generale`
Classifica generale con tutte le statistiche piloti.

#### `v_prossime_gare`
Prossime 10 gare in programma.

#### `v_reclami_pendenti`
Reclami in esame o accettati.

#### `v_campionati_iscritti`
Campionati con numero iscritti e lista piloti.

## 🔐 Sicurezza

### Password Hash
Le password sono hashate con **bcrypt** (cost factor 10).

Password di default nei dati di esempio: `password123` (hash già presente nel seed data)

### JWT Token
I token JWT hanno validità di **7 giorni**.
Assicurati di cambiare `JWT_SECRET` in produzione!

## 🧪 Testing Database

### Test Registrazione Utente
```bash
curl -X POST https://tuo-sito.netlify.app/.netlify/functions/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "nome": "Test Pilota",
    "email": "test@tlm.racing",
    "password": "test123",
    "psn_id": "TestPSN123"
  }'
```

### Test Login
```bash
curl -X POST https://tuo-sito.netlify.app/.netlify/functions/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "riccardo.asti@gmail.com",
    "password": "password123"
  }'
```

### Test Classifica
```bash
curl https://tuo-sito.netlify.app/.netlify/functions/api/classifica
```

## 📝 Manutenzione

### Backup Database
Esegui backup regolari:
```bash
pg_dump $DATABASE_URL > backup_$(date +%Y%m%d).sql
```

### Aggiornare Statistiche
Dopo aver inserito nuovi risultati:
```sql
-- Aggiorna classifica campionato
SELECT calcola_classifica(1);

-- Aggiorna stats di tutti i piloti
SELECT aggiorna_statistiche_pilota(id) FROM piloti WHERE attivo = true;
```

## 🐛 Troubleshooting

### Errore: "relation does not exist"
→ Verifica di aver eseguito gli script nell'ordine corretto

### Errore: "duplicate key value"
→ Normale se ricarichi seed_data.sql, usa `ON CONFLICT DO NOTHING`

### Connessione fallita
→ Verifica che `DATABASE_URL` sia configurata correttamente in Netlify

### Funzioni non trovate
→ Assicurati che lo schema base sia stato caricato prima

## 📚 Risorse Utili

- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Netlify Functions](https://docs.netlify.com/functions/overview/)
- [Supabase Docs](https://supabase.com/docs)

## 🦁 Team Lion Motorsport

Per supporto o domande:
- Email: info@tlm.racing
- Discord: Team Lion Motorsport

---

**Ultimo aggiornamento**: 2025-01-07
