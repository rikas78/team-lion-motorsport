# 🏁 TLM Dashboard - Design Interfaccia Grafica

## 🎨 Palette Colori

```
Background Principale: #121212
Background Cards: #1a1a1a, #2a2a2a
Colore Primario TLM: #e10600 (Rosso Racing)
Testo: #ffffff
Testo Secondario: #888888
Bordi: #333333
```

---

## 💻 DESIGN PC (Desktop)

### LAYOUT PRINCIPALE

```
┌─────────────────────────────────────────────────────────────────┐
│                     TEAM LION MOTORSPORT                         │
│                    Stile Gran Turismo 7                          │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│  NAVIGAZIONE ORIZZONTALE                                         │
│  ┌────┐ ┌────┐ ┌────┐ ┌────┐ ┌────┐ ┌────┐ ┌────┐              │
│  │🏠  │ │🏆  │ │📅  │ │👥  │ │👤  │ │📋  │ │⚙️  │              │
│  │Home│ │Clas│ │Cal │ │Pil │ │Prof│ │Recl│ │Adm │              │
│  └────┘ └────┘ └────┘ └────┘ └────┘ └────┘ └────┘              │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                     📊 HOME DASHBOARD                            │
│                                                                  │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐ │
│  │  🏁 PROSSIMA    │  │  📊 MIA         │  │  📋 NUOVO       │ │
│  │     GARA        │  │  POSIZIONE      │  │  RECLAMO        │ │
│  │                 │  │                 │  │                 │ │
│  │  [Dettagli]     │  │  [Classifica]   │  │  [Apri Form]    │ │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘ │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │            📈 STATISTICHE VELOCI                         │   │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐               │   │
│  │  │ Piloti   │  │Campionati│  │Gare Oggi │               │   │
│  │  │   45     │  │    3     │  │    2     │               │   │
│  │  └──────────┘  └──────────┘  └──────────┘               │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │            🏆 TOP 5 CLASSIFICA                           │   │
│  │  1. TLM_Sicily    ━━━━━━━━━━━━━━━━━━━ 75 pts  🏆 5      │   │
│  │  2. Mikedb_91_    ━━━━━━━━━━━━━━━━━━ 68 pts  🏆 3       │   │
│  │  3. [Pilota 3]    ━━━━━━━━━━━━━━━━━ 55 pts  🏆 1        │   │
│  │  4. [Pilota 4]    ━━━━━━━━━━━━━━━━ 48 pts               │   │
│  │  5. [Pilota 5]    ━━━━━━━━━━━━━━━ 42 pts                │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │            📢 BACHECA AVVISI                             │   │
│  │  🔴 [URGENTE] Prossima gara: Suzuka - 15/11/2025        │   │
│  │  🟡 [INFO] Aggiornamento regolamento disponibile         │   │
│  └──────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

### SEZIONE CLASSIFICHE

```
┌─────────────────────────────────────────────────────────────────┐
│  🏆 CLASSIFICHE                                                  │
│                                                                  │
│  Filtri:  [▼ Tutti i Campionati]  [▼ Tutte le Categorie]      │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │ Pos │ PSN ID       │ Categoria │ Punti    │ Vitt. │ Team │   │
│  ├──────────────────────────────────────────────────────────┤   │
│  │ 🥇  │ TLM_Sicily   │ [ELITE]   │ 75 pts   │ 🏆 5  │ TLM  │   │
│  │ 🥈  │ Mikedb_91_   │ [ELITE]   │ 68 pts   │ 🏆 3  │ TLM  │   │
│  │ 🥉  │ [Pilota 3]   │ [STAR]    │ 55 pts   │ 🏆 1  │ TLM  │   │
│  │ 4   │ [Pilota 4]   │ [STAR]    │ 48 pts   │ 🏆 0  │ TLM  │   │
│  │ 5   │ [Pilota 5]   │ [ELITE]   │ 42 pts   │ 🏆 0  │ TLM  │   │
│  └──────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

### SEZIONE CREDITI API

```
┌─────────────────────────────────────────────────────────────────┐
│  🪙 CREDITI API                                                  │
│                                                                  │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐  ┌──────────┐  │
│  │ DISPONIBILI│  │ UTILIZZATI │  │CHIAMATE OGG│  │CHIAM.SETT│  │
│  │            │  │            │  │            │  │          │  │
│  │   1500     │  │    450     │  │     12     │  │    89    │  │
│  │            │  │            │  │            │  │          │  │
│  └────────────┘  └────────────┘  └────────────┘  └──────────┘  │
│                                                                  │
│           [🔄 Aggiorna]  [💰 Ricarica Crediti]                  │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │         📊 STORICO UTILIZZO                              │   │
│  ├────────┬─────────┬────────┬────────┬────────┬──────────┤   │
│  │ Data   │Endpoint │ Metodo │Crediti │ Status │ Tempo ms │   │
│  ├────────┼─────────┼────────┼────────┼────────┼──────────┤   │
│  │13/11 15│/pilots  │  GET   │   5    │  200   │   145    │   │
│  │13/11 14│/races   │  POST  │   10   │  201   │   234    │   │
│  │13/11 13│/standing│  GET   │   5    │  200   │   178    │   │
│  └────────┴─────────┴────────┴────────┴────────┴──────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📱 DESIGN MOBILE (Responsive)

### HOME MOBILE

```
┌─────────────────────────┐
│ ☰  TLM MOTORSPORT    👤 │
└─────────────────────────┘

┌─────────────────────────┐
│     🏁 PROSSIMA GARA    │
│                         │
│    Suzuka Circuit       │
│    15/11/2025 - 21:00  │
│                         │
│    [Dettagli]           │
└─────────────────────────┘

┌─────────────────────────┐
│     📊 MIA POSIZIONE    │
│                         │
│    Posizione: 2°        │
│    Punti: 68            │
│    Vittorie: 3 🏆       │
│                         │
│    [Classifica]         │
└─────────────────────────┘

┌─────────────────────────┐
│     📋 RECLAMI          │
│                         │
│    Reclami aperti: 0    │
│                         │
│    [Nuovo Reclamo]      │
└─────────────────────────┘

┌─────────────────────────┐
│   🏆 TOP 3 CLASSIFICA   │
│                         │
│  🥇 TLM_Sicily   75 pts │
│  🥈 Mikedb_91_   68 pts │
│  🥉 [Pilota3]    55 pts │
│                         │
│  [Vedi tutto]           │
└─────────────────────────┘

┌─────────────────────────┐
│      MENU PRINCIPALE    │
│                         │
│  🏠 Home                │
│  🏆 Classifiche         │
│  📅 Calendario          │
│  👥 Piloti              │
│  👤 Profilo             │
│  📋 Reclami             │
│  🪙 Crediti API         │
│  ⚙️  Admin              │
└─────────────────────────┘
```

### CLASSIFICHE MOBILE

```
┌─────────────────────────┐
│  🏆 CLASSIFICHE         │
│                         │
│  [▼ Campionato]         │
│  [▼ Categoria]          │
└─────────────────────────┘

┌─────────────────────────┐
│ 🥇  1                   │
│ TLM_Sicily              │
│ [ELITE] TLM             │
│ 75 pts | 🏆 5 vittorie  │
└─────────────────────────┘

┌─────────────────────────┐
│ 🥈  2                   │
│ Mikedb_91_              │
│ [ELITE] TLM             │
│ 68 pts | 🏆 3 vittorie  │
└─────────────────────────┘

┌─────────────────────────┐
│ 🥉  3                   │
│ [Pilota 3]              │
│ [STAR] TLM              │
│ 55 pts | 🏆 1 vittoria  │
└─────────────────────────┘

┌─────────────────────────┐
│    4                    │
│ [Pilota 4]              │
│ [STAR] TLM              │
│ 48 pts                  │
└─────────────────────────┘
```

### CREDITI API MOBILE

```
┌─────────────────────────┐
│  🪙 CREDITI API         │
└─────────────────────────┘

┌─────────────────────────┐
│   CREDITI DISPONIBILI   │
│                         │
│       1500              │
└─────────────────────────┘

┌─────────────────────────┐
│   CREDITI UTILIZZATI    │
│                         │
│        450              │
└─────────────────────────┘

┌─────────────────────────┐
│    CHIAMATE OGGI        │
│                         │
│         12              │
└─────────────────────────┘

┌─────────────────────────┐
│  CHIAMATE SETTIMANA     │
│                         │
│         89              │
└─────────────────────────┘

┌─────────────────────────┐
│  [🔄 Aggiorna Dati]     │
│  [💰 Ricarica Crediti]  │
└─────────────────────────┘

┌─────────────────────────┐
│   📊 STORICO RECENTE    │
│                         │
│  13/11 15:30            │
│  /pilots | GET          │
│  5 crediti | 200        │
│  ───────────────────    │
│  13/11 14:15            │
│  /races | POST          │
│  10 crediti | 201       │
│  ───────────────────    │
│  [Vedi tutto]           │
└─────────────────────────┘
```

---

## 🎯 CARATTERISTICHE DESIGN

### Stile Gran Turismo 7
- **Sfondo scuro** (#121212) con elementi in rilievo
- **Card con bordi rossi** (#e10600) per elementi importivi
- **Effetti hover** con trasformazioni e shadow
- **Font monospace** per valori numerici (crediti, punti)
- **Badge colorati** per stato e categorie
- **Animazioni fluide** con transition 0.3s

### Responsive Design
- **Desktop**: Layout a griglia con 3-4 colonne
- **Tablet**: Layout a 2 colonne
- **Mobile**: Layout a colonna singola verticale

### Elementi Interattivi
- **Bottoni hover**: Cambio colore + transform translateY(-2px)
- **Card hover**: Shadow + scale
- **Navigazione sticky**: Sempre visibile in alto
- **Notifiche toast**: Top-right con auto-dismiss

### Accessibilità
- Contrasto alto (bianco su nero)
- Font leggibili (min 0.9rem)
- Icone + testo per chiarezza
- Focus states visibili

---

## 📐 DIMENSIONI BREAKPOINTS

```css
/* Mobile First */
Mobile:  < 768px   (colonna singola)
Tablet:  768-1024px (2 colonne)
Desktop: > 1024px   (3-4 colonne)
```

---

## 🔧 COMPONENTI PRINCIPALI

### Card Standard
```
Background: #1a1a1a
Border: 2px solid #333
Border-radius: 8px
Padding: 20px
Box-shadow: 0 4px 8px rgba(0,0,0,0.2)
```

### Card Evidenziata (TLM Red)
```
Background: linear-gradient(135deg, #1a1a1a 0%, #2a2a2a 100%)
Border: 2px solid #e10600
Box-shadow: 0 4px 8px rgba(225, 6, 0, 0.2)
```

### Bottoni Primari
```
Background: #e10600
Color: white
Padding: 12-16px
Border-radius: 8px
Font-weight: bold
Hover: background #c10500 + translateY(-2px)
```

### Bottoni Secondari
```
Background: #333
Color: white
Hover: background #444
```

### Badge/Tag
```
Padding: 4px 12px
Border-radius: 20px
Font-size: 0.85rem
Font-weight: 600

Categorie:
- ELITE: #4caf50 (verde)
- STAR: #ffc107 (giallo)
- Pending: #ffc107 (giallo)
- Accepted: #4caf50 (verde)
- Rejected: #f44336 (rosso)
```

---

## 🎨 MOCKUP WIREFRAME ASCII

```
DESKTOP VIEW (1920x1080)
┌────────────────────────────────────────────────────────────────────┐
│                     TEAM LION MOTORSPORT                            │
├────────────────────────────────────────────────────────────────────┤
│ 🏠 Home │ 🏆 Classifica │ 📅 Calendario │ 👥 Piloti │ 👤 Profilo ... │
├────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌───────────┐  ┌───────────┐  ┌───────────┐  ┌───────────┐      │
│  │  Quick    │  │   Stats   │  │   Next    │  │  Recent   │      │
│  │  Action   │  │   Card    │  │   Race    │  │  Results  │      │
│  │           │  │           │  │           │  │           │      │
│  └───────────┘  └───────────┘  └───────────┘  └───────────┘      │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐  │
│  │                    MAIN CONTENT AREA                        │  │
│  │                                                              │  │
│  │  (Tabelle, Form, Dati dinamici basati sulla sezione)        │  │
│  │                                                              │  │
│  └─────────────────────────────────────────────────────────────┘  │
│                                                                     │
└────────────────────────────────────────────────────────────────────┘

MOBILE VIEW (375x812)
┌──────────────────┐
│ ☰ TLM        👤  │
├──────────────────┤
│                  │
│  ┌────────────┐  │
│  │   Card 1   │  │
│  └────────────┘  │
│                  │
│  ┌────────────┐  │
│  │   Card 2   │  │
│  └────────────┘  │
│                  │
│  ┌────────────┐  │
│  │   Card 3   │  │
│  └────────────┘  │
│                  │
│  ┌────────────┐  │
│  │   Menu     │  │
│  └────────────┘  │
│                  │
└──────────────────┘
```

---

## 📝 NOTE IMPLEMENTATIVE

1. **CSS Grid** per layout responsive
2. **Flexbox** per allineamenti interni
3. **Media queries** per breakpoints
4. **JavaScript vanilla** per interattività
5. **Fetch API** per chiamate backend
6. **LocalStorage** per cache/auth
7. **CSS Transitions** per animazioni fluide

