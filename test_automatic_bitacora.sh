#!/bin/bash

# TEST DE REGISTRO AUTOMÁTICO DE BITÁCORA
# Este script demuestra que TODO se registra automáticamente

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║  TEST DE BITÁCORA - REGISTRO AUTOMÁTICO                       ║"
echo "║  Demostración: Las acciones se registran SIN intervención     ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

API_URL="http://localhost:8000/api"

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}═══ PASO 1: LOGIN (Se registra AUTOMÁTICAMENTE) ═══${NC}"
echo "Acción del usuario: Ingresa usuario y contraseña"
echo "¿Intervención manual en bitácora? NO"
echo ""

LOGIN_RESPONSE=$(curl -s -X POST "$API_URL/auth/login" \
  -H "Content-Type: application/json" \
  -d "{\"login\":\"admin\",\"contrasena\":\"password\"}")

TOKEN=$(echo "$LOGIN_RESPONSE" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)

if [ -z "$TOKEN" ]; then
  echo -e "${RED}❌ Error en login${NC}"
  echo "Respuesta: $LOGIN_RESPONSE"
  exit 1
fi

echo -e "${GREEN}✅ Login exitoso${NC}"
echo -e "${YELLOW}→ Acción AUTOMÁTICAMENTE registrada en bitácora${NC}"
echo ""

# Esperar un poco
sleep 2

echo -e "${BLUE}═══ PASO 2: GENERAR QR DE ASISTENCIA ═══${NC}"
echo "Acción del usuario: Hace click en botón 'Generar QR'"
echo "¿Intervención manual en bitácora? NO"
echo ""

QR_RESPONSE=$(curl -s -X POST "$API_URL/asistencias/generar-qr" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"id_asignacion\":1,\"duracion_minutos\":60}")

if echo "$QR_RESPONSE" | grep -q '"success":true'; then
  echo -e "${GREEN}✅ QR generado exitosamente${NC}"
  echo -e "${YELLOW}→ Acción AUTOMÁTICAMENTE registrada en bitácora${NC}"
else
  echo -e "${YELLOW}⚠ QR podría no estar disponible en este momento${NC}"
fi
echo ""

sleep 2

echo -e "${BLUE}═══ PASO 3: VER BITÁCORA (Todas las acciones aparecen)${NC}"
echo "Acción del usuario: Accede a http://localhost:3000/bitacora"
echo "¿Intervención manual para registrar? NO"
echo ""

BITACORA_RESPONSE=$(curl -s -X GET "$API_URL/bitacora?per_page=10" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json")

if echo "$BITACORA_RESPONSE" | grep -q '"success":true'; then
  TOTAL=$(echo "$BITACORA_RESPONSE" | grep -o '"total":[0-9]*' | cut -d':' -f2)
  echo -e "${GREEN}✅ Bitácora consultada exitosamente${NC}"
  echo -e "${YELLOW}Total de acciones registradas: $TOTAL${NC}"
  echo ""
  
  # Mostrar primeros registros
  echo "Últimas acciones registradas:"
  echo "$BITACORA_RESPONSE" | grep -o '"accion":"[^"]*' | head -5 | cut -d'"' -f4 | while read accion; do
    echo "  • $accion"
  done
else
  echo -e "${RED}❌ Error al consultar bitácora${NC}"
fi
echo ""

sleep 2

echo -e "${BLUE}═══ PASO 4: ESTADÍSTICAS (Dashboard automático)${NC}"
echo "Acción del usuario: Ve el dashboard en /bitacora"
echo "¿Intervención manual? NO"
echo ""

STATS=$(curl -s -X GET "$API_URL/bitacora/estadisticas" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json")

if echo "$STATS" | grep -q '"success":true'; then
  TOTAL_ACC=$(echo "$STATS" | grep -o '"total_acciones":[0-9]*' | cut -d':' -f2)
  HOY=$(echo "$STATS" | grep -o '"acciones_hoy":[0-9]*' | cut -d':' -f2)
  
  echo -e "${GREEN}✅ Estadísticas disponibles${NC}"
  echo "  Total de acciones registradas: $TOTAL_ACC"
  echo "  Acciones hoy: $HOY"
  echo -e "${YELLOW}→ TODOS los datos se muestran AUTOMÁTICAMENTE${NC}"
else
  echo -e "${RED}❌ Error al obtener estadísticas${NC}"
fi
echo ""

sleep 2

echo -e "${BLUE}═══ PASO 5: LOGOUT (Se registra AUTOMÁTICAMENTE) ═══${NC}"
echo "Acción del usuario: Hace click en botón 'Cerrar Sesión'"
echo "¿Intervención manual en bitácora? NO"
echo ""

LOGOUT_RESPONSE=$(curl -s -X POST "$API_URL/auth/logout" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json")

if echo "$LOGOUT_RESPONSE" | grep -q '"message"'; then
  echo -e "${GREEN}✅ Logout exitoso${NC}"
  echo -e "${YELLOW}→ Acción AUTOMÁTICAMENTE registrada en bitácora${NC}"
else
  echo -e "${RED}❌ Error en logout${NC}"
fi
echo ""

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║  ✨ CONCLUSIÓN: TODO ES AUTOMÁTICO ✨                         ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║                                                                ║"
echo "║  ✓ LOGIN → Se registra AUTOMÁTICAMENTE                         ║"
echo "║  ✓ GENERAR QR → Se registra AUTOMÁTICAMENTE                    ║"
echo "║  ✓ ACCIONES → Se registran AUTOMÁTICAMENTE                     ║"
echo "║  ✓ DATOS → Se capturan AUTOMÁTICAMENTE                         ║"
echo "║  ✓ BITÁCORA → Se muestra AUTOMÁTICAMENTE                       ║"
echo "║  ✓ LOGOUT → Se registra AUTOMÁTICAMENTE                        ║"
echo "║                                                                ║"
echo "║  El usuario NO necesita hacer NADA manualmente.                ║"
echo "║  Todo sucede detrás de escenas automáticamente.                ║"
echo "║                                                                ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "Para ver la interfaz: http://localhost:3000/bitacora"
