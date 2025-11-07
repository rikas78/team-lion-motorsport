# 🦁 Team Lion Motorsport - Guida Utilizzo Sistema

## ✅ COSA FUNZIONA ORA

### 1. **CLASSIFICHE** ✅ AUTOMATICHE
Le classifiche si aggiornano **automaticamente** quando carichi i CSV risultati:

```bash
# Quando fai upload CSV risultati:
POST /api/gare/:id/upload-csv

# Il sistema automaticamente:
1. Inserisce i risultati nel database
2. Calcola i punti (25-18-15-12-10-8-6-4-2-1)
3. Ricalcola la classifica del campionato
4. Aggiorna le statistiche di tutti i piloti
```

**Non devi fare nulla manualmente!** 🎉

---

### 2. **CREARE CAMPIONATO + DOCUMENTI** ✅ FUNZIONA

#### Passo 1: Crea Campionato
```bash
POST /api/campionati
{
  "nome": "All Traction 5.0",
  "descrizione": "Nuovo campionato 2025",
  "data_inizio": "2025-01-15",
  "data_fine": "2025-06-30"
}
```

#### Passo 2: Carica Documento PDF
```bash
POST /api/campionati/1/documenti
{
  "titolo": "Regolamento AT 5.0",
  "file_url": "https://tuoserver.com/docs/regolamento.pdf",
  "tipo": "Regolamento"
}
```

⚠️ **PROBLEMA**: Devi **prima caricare il PDF su un servizio esterno** (es. Google Drive, Dropbox, servizio cloud) e poi mettere l'URL.

**MANCA**: Upload diretto PDF dal frontend.

---

### 3. **ISCRIZIONI GARE/CAMPIONATI** ✅ FUNZIONA

#### Iscrizione Gara
```bash
# Iscriviti
POST /api/gare/1/iscrizione

# Cancella iscrizione
DELETE /api/gare/1/iscrizione
```

#### Iscrizione Campionato
```bash
# Iscriviti
POST /api/campionati/1/iscrizione

# Cancella iscrizione
DELETE /api/campionati/1/iscrizione
```

⚠️ **PROBLEMA**: Nel frontend **non c'è il bottone** per iscriversi/cancellarsi!

**MANCA**: UI per gestire iscrizioni.

---

### 4. **RECLAMI/CONTESTAZIONI** ⚠️ PARZIALE

#### Backend ✅ Funziona:
```bash
# Crea reclamo
POST /api/reclami
{
  "gara_id": 1,
  "tipo": "Contatto",
  "descrizione": "Contatto alla curva 1",
  "contro_pilota_id": 5,
  "giro": 12,
  "curva": "Parabolica",
  "video_url": "https://youtube.com/..."
}

# Vedi i tuoi reclami
GET /api/reclami/miei

# Dettaglio reclamo
GET /api/reclami/123

# Manager aggiorna status
PUT /api/reclami/123/status
{
  "status": "Accettato",
  "decisione_commissario": "Penalità di 5 secondi al pilota X"
}
```

⚠️ **PROBLEMA**: Nel frontend c'è solo un placeholder - **non c'è il form completo!**

**MANCA**: Form reclami nel frontend.

---

### 5. **PROFILO UTENTE** ✅ FUNZIONA MA LIMITATO

Il profilo mostra:
- ✅ Nome
- ✅ Email
- ✅ PSN ID
- ✅ Numero gara
- ✅ Categoria
- ✅ Ruolo

**MANCA**:
- ❌ Storico gare del pilota
- ❌ Statistiche dettagliate (vittorie, podi, punti totali)
- ❌ Grafico andamento
- ❌ Modifica dati profilo

---

## ❌ COSA NON ESISTE

### 1. **ALLENAMENTI** ❌ NON IMPLEMENTATO

**Non c'è NIENTE:**
- ❌ Tabella database
- ❌ Endpoint API
- ❌ Frontend

Se vuoi gli allenamenti, devo crearli da zero.

**Cancellazione automatica?** No, non esiste proprio il sistema.

---

### 2. **UPLOAD FILE DIRETTI** ❌ NON FUNZIONA

Il sistema **NON può caricare file** (PDF, immagini, video).

Per i documenti devi:
1. Caricare il file su servizio esterno (Google Drive, Dropbox, ecc.)
2. Prendere il link pubblico
3. Salvare il link nel database

**MANCA**: Storage file (serve Supabase Storage o S3).

---

### 3. **EVENTI/CALENDARIO COMPLETO** ⚠️ PARZIALE

Esiste la tabella `eventi` nel database, ma:
- ❌ Nessun endpoint API per creare/modificare eventi
- ❌ Nessuna UI nel frontend
- ❌ No iscrizioni eventi
- ❌ No notifiche eventi

---

### 4. **BACHECA VITTORIE** ❌ NON IMPLEMENTATO
- ❌ Nessuna tabella
- ❌ Nessun endpoint
- ❌ Nessuna UI

---

### 5. **BACHECA AVVISI** ❌ NON IMPLEMENTATO
- ❌ Nessuna tabella
- ❌ Nessun endpoint
- ❌ Nessuna UI

---

## 📋 RIEPILOGO FUNZIONALITÀ

| Funzionalità | Backend | Frontend | Completo? |
|-------------|---------|----------|-----------|
| Login/Registrazione | ✅ | ✅ | ✅ |
| Classifiche | ✅ | ✅ | ✅ |
| **Upload CSV Risultati** | ✅ | ✅ | ✅ |
| Calendario Gare | ✅ | ✅ | ✅ |
| Elenco Piloti | ✅ | ✅ | ✅ |
| Profilo Base | ✅ | ✅ | ⚠️ Limitato |
| Profilo Dettagliato | ✅ | ❌ | ❌ |
| Crea Campionato | ✅ | ❌ | ⚠️ Solo API |
| Iscrizione Gara | ✅ | ❌ | ⚠️ Solo API |
| Iscrizione Campionato | ✅ | ❌ | ⚠️ Solo API |
| Reclami (crea) | ✅ | ❌ | ⚠️ Solo API |
| Reclami (lista) | ✅ | ❌ | ⚠️ Solo API |
| Reclami (gestione manager) | ✅ | ❌ | ⚠️ Solo API |
| Upload Documenti PDF | ⚠️ | ❌ | ❌ |
| Allenamenti | ❌ | ❌ | ❌ |
| Eventi | ⚠️ DB only | ❌ | ❌ |
| Bacheca Vittorie | ❌ | ❌ | ❌ |
| Bacheca Avvisi | ❌ | ❌ | ❌ |

---

## 🚀 COSA SERVE AGGIUNGERE SUBITO

### Priorità ALTA (per usare il sistema):

1. **Form Reclami nel Frontend** ⚠️
2. **Bottoni Iscrizione Gare/Campionati** ⚠️
3. **Profilo Dettagliato con Stats** ⚠️
4. **Upload File (serve storage esterno)** ⚠️

### Priorità MEDIA:

5. **Sistema Allenamenti completo**
6. **Gestione Eventi completa**
7. **Form Crea Campionato**

### Priorità BASSA:

8. Bacheca Vittorie
9. Bacheca Avvisi
10. Statistiche avanzate

---

## 💡 COME USARE IL SISTEMA ORA

### Scenario 1: Caricare Risultati Gara ✅
1. Login nel sito
2. Vai su "Upload CSV"
3. Seleziona gara
4. Carica CSV
5. Le classifiche si aggiornano automaticamente ✅

### Scenario 2: Creare Reclamo ⚠️
**Opzione A - Tramite API:**
```bash
curl -X POST https://tuo-sito/.netlify/functions/api/reclami \
  -H "Authorization: Bearer TUO_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "gara_id": 1,
    "tipo": "Contatto",
    "descrizione": "Contatto curva 1",
    "contro_pilota_id": 5
  }'
```

**Opzione B - Aggiungo form nel frontend** (serve sviluppo)

### Scenario 3: Iscriversi a Gara ⚠️
**Solo tramite API:**
```bash
curl -X POST https://tuo-sito/.netlify/functions/api/gare/1/iscrizione \
  -H "Authorization: Bearer TUO_TOKEN"
```

### Scenario 4: Creare Campionato ⚠️
**Solo tramite API:**
```bash
curl -X POST https://tuo-sito/.netlify/functions/api/campionati \
  -H "Authorization: Bearer TUO_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "nome": "All Traction 5.0",
    "descrizione": "Nuovo campionato",
    "data_inizio": "2025-01-15",
    "data_fine": "2025-06-30"
  }'
```

---

## 🎯 VUOI CHE AGGIUNGA QUESTE FUNZIONALITÀ?

Dimmi cosa è **prioritario per te**:

1. **Form Reclami completo?** ⚠️
2. **Bottoni Iscrizione Gare?** ⚠️
3. **Profilo pilota dettagliato?** ⚠️
4. **Sistema Allenamenti completo?** ❌
5. **Upload PDF documenti?** (serve storage esterno) ❌
6. **Gestione Eventi?** ❌

Posso aggiungere tutto, ma dimmi **l'ordine di priorità!** 🚀
