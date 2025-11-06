# 🧀 Guida Deploy Carlsberg - Web App Ordini

## 📦 File Progetto

```
carlsberg-ordini.html    → Pagina principale ordini
thank-you.html           → Pagina conferma ordine
netlify.toml            → Configurazione Netlify
```

---

## 🚀 Metodo 1: Deploy Manuale (Più Veloce)

### Step 1: Vai su Netlify
1. Apri **https://app.netlify.com**
2. Login con il tuo account
3. Click **"Add new site"** → **"Deploy manually"**

### Step 2: Upload Files
Trascina questi 2 files:
- `carlsberg-ordini.html`
- `thank-you.html`

### Step 3: Configurazione Automatica
Netlify deploierà il sito in ~30 secondi!

**URL generato:** `https://random-name-123.netlify.app`

---

## 🔧 Metodo 2: Deploy da GitHub (Consigliato)

### Step 1: Collega Repository
1. Su Netlify: **"Add new site"** → **"Import from Git"**
2. Seleziona **GitHub**
3. Autorizza Netlify
4. Seleziona repository: `rikas78/team-lion-motorsport`
5. Seleziona branch: `claude/finish-tlm-api-credits-011CUrDziPWukEKKwZReVUkt`

### Step 2: Configurazione Build
Il file `netlify.toml` è già configurato! Netlify lo rileverà automaticamente.

**Settings auto-rilevate:**
- Base directory: `/`
- Build command: `echo 'Static site'`
- Publish directory: `.`

### Step 3: Deploy
Click **"Deploy site"**!

---

## 📧 Configurazione Email Notifiche

### Step 1: Attiva Netlify Forms
Le form sono già configurate nel HTML:
- `ordine-carlsberg` (form principale)
- `ordine-qr` (ordini veloci QR)

### Step 2: Configura Email
1. Vai su **Site settings** → **Forms**
2. Click **"Form notifications"**
3. Add **"Email notification"**
4. Inserisci la tua email (es. `ordini@carlsberg.com`)
5. Seleziona form: **"ordine-carlsberg"**
6. Salva

### Step 3: Test
Compila un ordine di prova e verifica che arrivi l'email!

**Formato Email Ricevuta:**
```
From: Netlify Forms
Subject: Nuovo ordine da ordine-carlsberg

Dati ordine:
- Mozzarella Nera Porta Romana: 5 kg
- Burrata Bicocca: 3 kg
- ...
- Totale: 45 kg
- Data: 06/11/2025 15:30
```

---

## 🔗 URL Custom (Opzionale)

### Cambia Nome Sito
1. **Site settings** → **Site details**
2. Click **"Change site name"**
3. Scegli: `carlsberg-ordini-milano`
4. Nuovo URL: `https://carlsberg-ordini-milano.netlify.app`

### Dominio Personalizzato
1. **Site settings** → **Domain management**
2. Click **"Add domain"**
3. Inserisci: `ordini.carlsberg-milano.it` (esempio)
4. Segui istruzioni DNS

---

## 🎨 Personalizzazioni Post-Deploy

### A) Modifica Prezzi
Se vuoi cambiare i prezzi, edita `carlsberg-ordini.html`:

```javascript
// Linea ~350
const prodotti = [
    { nome: 'Mozzarella Nera', prezzoAcquisto: 11.00, prezzoVendita: 15.00 },
    { nome: 'Burrata', prezzoAcquisto: 12.00, prezzoVendita: 16.00 },  // ← modifica qui
    ...
];
```

### B) Aggiungi Ristoranti
Nel file HTML, sezione `<thead>`:

```html
<th>Nuovo Ristorante</th>  <!-- ← aggiungi colonna -->
```

E nel JavaScript, modifica:
```javascript
const numRistoranti = 22;  // ← era 21
```

### C) Email Custom
Modifica destinatario email in Netlify UI (vedi sopra)

---

## 📱 QR Code per Ristoranti

### Genera QR Codes
Usa servizio gratuito come **https://qr-code-generator.com**

**URL QR per ogni ristorante:**
```
https://carlsberg-ordini-milano.netlify.app/ordini?ristorante=Porta+Romana
https://carlsberg-ordini-milano.netlify.app/ordini?ristorante=Bicocca
...
```

Il parametro `ristorante` pre-compilerà il form QR!

### Stampa Triangoli Tavolo
1. Genera QR code per ogni ristorante
2. Usa template grafico (Canva, Figma)
3. Stampa su cartoncino formato triangolo
4. Posiziona su tavoli

**Esempio Template:**
```
┌─────────────────────┐
│   Ordina Veloce!    │
│  [QR CODE IMAGE]    │
│ Inquadra per ordinare│
│  Bufala Nera D'Angelo│
└─────────────────────┘
```

---

## ✅ Checklist Deploy

### Pre-Deploy
- [ ] File HTML testati in locale
- [ ] Validazione ordine minimo funziona
- [ ] Calcolo totali corretto
- [ ] Form submission funziona

### Deploy
- [ ] Sito deployato su Netlify
- [ ] URL accessibile pubblicamente
- [ ] Redirect `/ordini` → `carlsberg-ordini.html` funziona
- [ ] Thank you page si carica

### Post-Deploy
- [ ] Email notifiche configurate
- [ ] Test ordine completo inviato
- [ ] Email ricevuta correttamente
- [ ] QR codes generati per ogni ristorante
- [ ] Materiale packaging preparato

---

## 🧪 Test Completo Post-Deploy

### Test 1: Ordine Standard
1. Vai su `https://your-site.netlify.app/carlsberg-ordini.html`
2. Compila ordini per vari ristoranti
3. Verifica totale >= 30 kg
4. Click "Invia Ordine"
5. Verifica redirect a thank-you.html
6. **Controlla email** ricevuta

### Test 2: Ordine QR
1. Scroll alla sezione "Ordine Veloce QR Code"
2. Seleziona ristorante: Bicocca
3. Seleziona prodotto: Mozzarella Nera
4. Quantità: 5 kg
5. Click "Invia Ordine QR"
6. **Controlla email** ricevuta (separata)

### Test 3: Validazione
1. Compila ordine < 30 kg totale
2. Click "Invia Ordine"
3. Verifica alert: "⚠️ Ordine minimo 30 kg!"

### Test 4: Reset
1. Compila alcuni campi
2. Click "Reset"
3. Verifica tutti i campi tornano a 0

### Test 5: Mobile
1. Apri sito su smartphone
2. Verifica tabella scrollabile orizzontalmente
3. Verifica input facili da toccare
4. Verifica buttons grandi abbastanza

---

## 📊 Monitoraggio Ordini

### Visualizza Submissions Netlify
1. **Site dashboard** → **Forms**
2. Vedi tutti gli ordini ricevuti
3. Export CSV per analisi
4. Filtra per data

### Statistiche
- Ordini al giorno
- Ristorante più attivo
- Prodotto più richiesto
- Totale kg ordinati

---

## 🐛 Troubleshooting

### Form non invia
→ Verifica attributi `data-netlify="true"` presenti
→ Controlla `name="form-name"` matching

### Email non arrivano
→ Controlla spam/junk
→ Verifica configurazione in Netlify Forms
→ Testa con email personale prima

### Tabella non si vede mobile
→ Scroll orizzontalmente è normale
→ CSS responsive già implementato

### Calcoli totali errati
→ Verifica `calcolaTotali()` nel JavaScript
→ Controlla console browser per errori

### QR code non funziona
→ Verifica URL generato correttamente
→ Testa URL manualmente nel browser

---

## 💡 Features Opzionali Avanzate

### A) Export Excel Ordini
Aggiungi bottone export in Netlify Forms dashboard

### B) Integrazione WhatsApp
Invia notifiche ordini anche su WhatsApp Business API

### C) Dashboard Manager
Crea pagina admin per vedere tutti gli ordini in tempo reale

### D) Storico Ordini Ristorante
Ogni ristorante può vedere cronologia propri ordini

### E) Suggerimenti Automatici
Sistema ML che suggerisce quantità in base a storico

---

## 📞 Support

**Problemi tecnici Netlify:**
- Docs: https://docs.netlify.com
- Support: https://answers.netlify.com

**Modifiche HTML/CSS:**
- Edita files in repository
- Netlify rebuilda automaticamente

---

## 🎉 Deployment Completato!

**Il tuo sistema ordini Carlsberg è live!** 🚀

URL condividilo con:
- 21 ristoranti Carlsberg Milano
- Staff logistica
- Caseificio D'Angelo
- Team interno

**Prossimi step:**
1. Stampa QR codes
2. Distribuisci triangoli ai ristoranti
3. Forma staff sull'uso
4. Monitora primi ordini
5. Raccogli feedback per miglioramenti

---

**🧀 Buone vendite con la Bufala Nera D'Angelo!**
