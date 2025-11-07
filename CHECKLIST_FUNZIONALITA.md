# 🦁 Team Lion Motorsport - Checklist Funzionalità

## ✅ GIÀ FUNZIONANTE (Database + API)

### 🔐 Autenticazione
- ✅ Login (`POST /api/auth/login`)
- ✅ Registrazione (`POST /api/auth/register`)
- ✅ JWT Token (7 giorni validità)

### 👥 Piloti
- ✅ Lista piloti (`GET /api/piloti`)
- ✅ 37 piloti già nel database
- ✅ Profilo pilota (`GET /api/piloti/profilo`)
- ✅ Campionati pilota (`GET /api/piloti/campionati`)

### 🏆 Classifiche
- ✅ Classifica generale (`GET /api/classifica`)
- ✅ Filtro per campionato
- ✅ Calcolo automatico punti
- ✅ Statistiche piloti

### 🏁 Gare
- ✅ Lista gare (`GET /api/gare`)
- ✅ Prossime gare (`GET /api/gare/prossime`)
- ✅ 7 gare già configurate
- ✅ Risultati gare (`POST /api/risultati`)

### 🏆 Campionati
- ✅ Lista campionati (`GET /api/campionati`)
- ✅ Crea campionato (`POST /api/campionati`)
- ✅ Iscrizione campionato (`POST /api/campionati/:id/iscrizione`)
- ✅ Cancella iscrizione (`DELETE /api/campionati/:id/iscrizione`)
- ✅ Upload documenti (`POST /api/campionati/:id/documenti`)
- ✅ Ottieni documenti (`GET /api/campionati/:id/documenti`)

### ⚙️ Impostazioni Gare
- ✅ Salva impostazioni (`POST /api/gare/impostazioni`)
- ✅ Ottieni impostazioni (`GET /api/gare/:id/impostazioni`)

### 📋 Reclami
- ✅ Lista reclami (`GET /api/reclami`)
- ✅ Crea reclamo (`POST /api/reclami`)
- ✅ Sistema penalità incluso

### 📊 Statistiche
- ✅ Stats generali (`GET /api/stats`)

---

## ❌ MANCANTE - DA IMPLEMENTARE

### 1. 📤 UPLOAD CSV RISULTATI ⚠️ PRIORITÀ ALTA
**Problema attuale**: Il frontend chiama `/.netlify/functions/upload_to_supabase` che NON esiste

**Serve:**
- ✅ Endpoint API per parsare CSV risultati gara
- ✅ Validazione formato CSV
- ✅ Inserimento bulk risultati nel database
- ✅ Ricalcolo automatico classifiche dopo upload

**Formato CSV atteso:**
```csv
posizione,pilota_id,psn_id,tempo_totale,giro_veloce,auto_utilizzata
1,10,rikas78,01:25:30.123,02:15.456,Porsche 911 GT3 R
2,2,Mikedb_91_,01:25:45.789,02:16.123,BMW M4 GT3
```

### 2. 🏅 BACHECA VITTORIE
**Chiamate nel frontend ma endpoint mancante:**
- ❌ `GET /api/bacheca/vittorie` - Lista foto vittorie
- ❌ `POST /api/bacheca/vittorie/foto` - Upload foto vittoria

**Serve:**
- Tabella `bacheca_vittorie` nel database
- Storage foto (Supabase Storage o servizio esterno)
- API per CRUD foto

### 3. 📢 BACHECA AVVISI
**Chiamate nel frontend ma endpoint mancante:**
- ❌ `GET /api/bacheca/avvisi` - Lista avvisi
- ❌ `POST /api/bacheca/avvisi` - Crea avviso
- ❌ `DELETE /api/bacheca/avvisi/:id` - Cancella avviso

**Serve:**
- Tabella `bacheca_avvisi` nel database
- Sistema notifiche push (opzionale)

### 4. 🏋️ ALLENAMENTI
**Chiamate nel frontend ma endpoint mancante:**
- ❌ `GET /api/allenamenti` - Lista allenamenti
- ❌ `POST /api/allenamenti` - Crea allenamento
- ❌ `POST /api/allenamenti/:id/iscrizione` - Iscrizione allenamento

**Serve:**
- Tabella `allenamenti` nel database
- Tabella `iscrizioni_allenamenti`

### 5. 🔍 DETTAGLI AVANZATI
**Endpoint chiamati ma non implementati:**
- ❌ `GET /api/pilota/:id/stats` - Stats dettagliate pilota
- ❌ `GET /api/pilota/:id/gare` - Storico gare pilota
- ❌ `GET /api/pilota/:id/campionati` - Campionati pilota
- ❌ `PUT /api/pilota/:id` - Aggiorna profilo
- ❌ `GET /api/gare/:id` - Dettagli singola gara
- ❌ `POST /api/gare/:id/iscrizione` - Iscrizione gara
- ❌ `DELETE /api/gare/:id/iscrizione` - Cancella iscrizione gara
- ❌ `POST /api/gare/:id/risultati` - Upload risultati gara (con file)

### 6. 🔐 AUTH AVANZATA
**Chiamate nel frontend:**
- ❌ `GET /api/auth/me` - Ottieni info utente corrente
- ❌ `POST /api/auth/verify` - Verifica validità token

### 7. 📋 RECLAMI AVANZATI
- ❌ `GET /api/reclami/miei` - Solo miei reclami
- ❌ `GET /api/reclami/:id` - Dettaglio reclamo
- ❌ `PUT /api/reclami/:id/status` - Aggiorna status reclamo (admin)

---

## 🛠️ PROBLEMI DA SISTEMARE

### 1. index.html CORROTTO
Il file HTML principale è corrotto e contiene:
- JSON misto con HTML
- JavaScript incompleto
- Struttura HTML mancante

**Soluzione**: Ricostruire index.html pulito

### 2. UPLOAD FILE
Il sistema di upload chiama un endpoint Supabase inesistente.

**Soluzione**:
- Opzione A: Creare endpoint Netlify per upload
- Opzione B: Usare upload diretto client-side
- Opzione C: Processare CSV senza storage, solo parsing

### 3. CREDENZIALI TEST
Tutte le password nel seed data sono `password123` (OK per test)

**Nota**: Va bene per test, NON per produzione!

---

## 🎯 PRIORITÀ IMPLEMENTAZIONE

### 🔴 ALTA PRIORITÀ (Funzionalità Core)
1. **Upload CSV Risultati** - Necessario per gestire gare
2. **Dettagli Gara singola** - Per visualizzare info gara
3. **Stats Pilota dettagliate** - Per profilo completo
4. **Fix index.html** - Frontend non funziona

### 🟡 MEDIA PRIORITÀ (Nice to Have)
5. Bacheca Vittorie
6. Bacheca Avvisi
7. Auth avanzata (me, verify)
8. Reclami avanzati

### 🟢 BASSA PRIORITÀ (Opzionali)
9. Allenamenti
10. Upload foto
11. Notifiche push

---

## 📋 LISTA RAPIDA: COSA SERVE ORA

Per avere un sistema **minimamente funzionante** serve:

✅ Database configurato (fatto)
✅ API base (fatto)
❌ **Fix index.html**
❌ **Endpoint upload CSV**
❌ **Endpoint dettagli gara**
❌ **Endpoint stats pilota**

---

## 🚀 PROSSIMI STEP

1. Ricostruisco index.html pulito
2. Creo endpoint `/api/gare/:id/upload-csv` per caricare risultati
3. Creo endpoint `/api/gare/:id` per dettagli
4. Creo endpoint `/api/piloti/:id/stats`
5. Test completo

---

**Vuoi che proceda con questi fix?** 🚀
