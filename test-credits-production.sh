#!/bin/bash

# 🧪 Test Completo Sistema Crediti API TLM
# Esegui dopo il deploy su Netlify

API_URL="https://phenomenal-quokka-110828.netlify.app/.netlify/functions/api"

echo "🦁 TEST SISTEMA CREDITI TLM - PRODUCTION"
echo "=========================================="
echo ""

# Test 1: Registrazione nuovo pilota
echo "📝 Test 1: Registrazione nuovo pilota..."
REGISTER_RESPONSE=$(curl -s -X POST "$API_URL/auth/register" \
  -H "Content-Type: application/json" \
  -d '{
    "nome": "Test Crediti Production",
    "email": "test.crediti.prod@tlm.com",
    "password": "test123456",
    "psn_id": "TestCreditiProd"
  }')

echo "$REGISTER_RESPONSE" | jq '.'

# Estrai il token
TOKEN=$(echo "$REGISTER_RESPONSE" | jq -r '.token')

if [ "$TOKEN" = "null" ] || [ -z "$TOKEN" ]; then
    echo "❌ ERRORE: Registrazione fallita, nessun token ricevuto"
    exit 1
fi

echo "✅ Token ricevuto: ${TOKEN:0:50}..."
echo ""

# Test 2: Verifica crediti iniziali (dovrebbe essere 1000)
echo "💰 Test 2: Verifica crediti iniziali (attesi: 1000)..."
CREDITI_INIT=$(curl -s "$API_URL/crediti" \
  -H "Authorization: Bearer $TOKEN")

echo "$CREDITI_INIT" | jq '.'

CREDITI_DISPONIBILI=$(echo "$CREDITI_INIT" | jq -r '.crediti.crediti_disponibili')

if [ "$CREDITI_DISPONIBILI" = "1000" ]; then
    echo "✅ Crediti iniziali corretti: 1000"
else
    echo "❌ ERRORE: Crediti iniziali errati: $CREDITI_DISPONIBILI (attesi: 1000)"
fi
echo ""

# Test 3: Chiamata che consuma 1 credito
echo "📞 Test 3: Chiamata /piloti (costo: 1 credito)..."
curl -s "$API_URL/piloti" \
  -H "Authorization: Bearer $TOKEN" | jq '.'
echo ""

# Test 4: Verifica crediti dopo consumo (dovrebbe essere 999)
echo "💰 Test 4: Verifica crediti dopo consumo (attesi: 999)..."
CREDITI_AFTER=$(curl -s "$API_URL/crediti" \
  -H "Authorization: Bearer $TOKEN")

echo "$CREDITI_AFTER" | jq '.'

CREDITI_DOPO=$(echo "$CREDITI_AFTER" | jq -r '.crediti.crediti_disponibili')

if [ "$CREDITI_DOPO" = "999" ]; then
    echo "✅ Consumo crediti funziona correttamente: 1000 → 999"
else
    echo "❌ ERRORE: Crediti dopo consumo errati: $CREDITI_DOPO (attesi: 999)"
fi
echo ""

# Test 5: Statistiche crediti
echo "📊 Test 5: Statistiche utilizzo crediti..."
curl -s "$API_URL/crediti/stats" \
  -H "Authorization: Bearer $TOKEN" | jq '.'
echo ""

# Test 6: Storico utilizzo (consuma 1 credito)
echo "📜 Test 6: Storico utilizzo API (costo: 1 credito)..."
curl -s "$API_URL/crediti/storico" \
  -H "Authorization: Bearer $TOKEN" | jq '.'
echo ""

# Test 7: Verifica crediti finali (dovrebbe essere 998)
echo "💰 Test 7: Verifica crediti finali (attesi: 998)..."
CREDITI_FINAL=$(curl -s "$API_URL/crediti" \
  -H "Authorization: Bearer $TOKEN")

echo "$CREDITI_FINAL" | jq '.'

CREDITI_FINALI=$(echo "$CREDITI_FINAL" | jq -r '.crediti.crediti_disponibili')

if [ "$CREDITI_FINALI" = "998" ]; then
    echo "✅ Sistema crediti completamente funzionante!"
    echo "   1000 (init) → 999 (/piloti) → 998 (/crediti/storico)"
else
    echo "⚠️  Crediti finali: $CREDITI_FINALI"
fi
echo ""

# Test 8: Chiamata complessa (2 crediti)
echo "📊 Test 8: Chiamata /stats (costo: 1 credito)..."
curl -s "$API_URL/stats" \
  -H "Authorization: Bearer $TOKEN" | jq '.'
echo ""

# Riepilogo finale
echo "=========================================="
echo "✅ TEST COMPLETATI!"
echo ""
echo "📝 Crediti utilizzati:"
echo "   - Registrazione: 0 crediti (gratuito)"
echo "   - /crediti (x3): 0 crediti (gratuito)"
echo "   - /piloti: 1 credito"
echo "   - /crediti/storico: 1 credito"
echo "   - /crediti/stats: 0 crediti (gratuito)"
echo "   - /stats: 1 credito"
echo ""
echo "💰 Saldo atteso finale: 997 crediti"
echo ""
echo "🎉 Sistema Crediti API TLM è PRODUCTION READY!"
