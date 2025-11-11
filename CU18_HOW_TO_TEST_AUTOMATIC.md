# CU18 - PRUEBA DEL REGISTRO AUTOMÁTICO

## 🎯 Objetivo

Este documento explica cómo demostrar que **TODA LA BITÁCORA ES AUTOMÁTICA**. No se requiere intervención manual de ningún tipo para registrar acciones.

---

## 📋 ¿Qué es el Registro Automático?

### Antes (Manual - NO es lo que hicimos)
```
Usuario realiza acción → Usuario llena formulario en Bitácora → Usuario presiona Guardar
```

### Ahora (Automático - LO QUE IMPLEMENTAMOS)
```
Usuario realiza acción → Sistema AUTOMÁTICAMENTE registra en Bitácora
                      (Sin intervención del usuario)
```

---

## 🚀 Cómo Ejecutar los Tests

### En Windows (PowerShell)

```powershell
# Abre PowerShell y ejecuta:
.\test_automatic_bitacora.ps1
```

**Salida esperada:**
```
╔════════════════════════════════════════════════════════════════╗
║  TEST DE BITÁCORA - REGISTRO AUTOMÁTICO                       ║
║  Demostración: Las acciones se registran SIN intervención     ║
╚════════════════════════════════════════════════════════════════╝

═══ PASO 1: LOGIN (Se registra AUTOMÁTICAMENTE) ═══
...
✅ Login exitoso
→ Acción AUTOMÁTICAMENTE registrada en bitácora
```

### En Linux/Mac (Bash)

```bash
# Dale permisos de ejecución
chmod +x test_automatic_bitacora.sh

# Ejecuta el script
./test_automatic_bitacora.sh
```

---

## 🔍 Qué Prueba Cada Paso

### PASO 1: LOGIN ✅ AUTOMÁTICO
- **Usuario hace:** Ingresa su usuario y contraseña
- **Sistema hace:** AUTOMÁTICAMENTE registra en bitácora
- **Datos capturados AUTOMÁTICAMENTE:**
  - ID del usuario
  - IP del cliente
  - User-Agent del navegador
  - Timestamp exacto
  - Módulo: "Autenticación"
  - Acción: "Inicio de sesión exitoso"

**Ubicación en código:** `app/Http/Controllers/Autenticación_y_Control_de_Acceso/AuthController.php` línea 53
```php
Bitacora::registrar('Autenticación', 'Inicio de sesión exitoso', $usuario->id_usuario);
```

---

### PASO 2: GENERAR QR ✅ AUTOMÁTICO
- **Usuario hace:** Hace clic en botón "Generar QR"
- **Sistema hace:** AUTOMÁTICAMENTE registra en bitácora
- **Datos capturados AUTOMÁTICAMENTE:**
  - Detalles del QR generado
  - Duración de la sesión
  - ID de asignación
  - Timestamp

**Ubicación en código:** `app/Http/Controllers/Asistencia_Docente/RegistroAsistenciaController.php`
```php
Bitacora::registrar('Asistencia_Docente', 'GENERAR_SESION', $usuario->id_usuario, [...detalles]);
```

---

### PASO 3: VER BITÁCORA ✅ AUTOMÁTICO
- **Usuario hace:** Accede a http://localhost:3000/bitacora
- **Sistema muestra:** Todas las acciones registradas automáticamente
- **Sin intervención manual:** La bitácora se llena sola mientras el usuario usa el sistema

---

### PASO 4: ESTADÍSTICAS ✅ AUTOMÁTICO
- **Usuario hace:** Ve el dashboard en /bitacora
- **Sistema calcula AUTOMÁTICAMENTE:**
  - Total de acciones registradas
  - Acciones de hoy
  - Usuarios activos
  - Módulos más utilizados
  - Acciones más comunes

**Ubicación en código:** `app/Http/Controllers/Auditoria_y_Trazabilidad/BitacoraController.php` método `estadisticas()`

---

### PASO 5: LOGOUT ✅ AUTOMÁTICO
- **Usuario hace:** Hace clic en "Cerrar Sesión"
- **Sistema hace:** AUTOMÁTICAMENTE registra en bitácora
- **Datos capturados AUTOMÁTICAMENTE:**
  - Timestamp de cierre
  - Duración de la sesión
  - Usuario que se desconecta

**Ubicación en código:** `app/Http/Controllers/Autenticación_y_Control_de_Acceso/AuthController.php` línea 93
```php
Bitacora::registrar('Autenticación', 'Cierre de sesión', $usuario->id_usuario);
```

---

## 📊 Flujo Completo Automático

```
┌─────────────────────────────────────────────┐
│  Usuario realiza una acción (ej: Login)     │
└────────────────────┬────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────┐
│  El controlador procesa la solicitud        │
│  (AuthController::login)                    │
└────────────────────┬────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────┐
│  ⭐ AUTOMÁTICAMENTE se llama:               │
│  Bitacora::registrar(...)                   │
│                                             │
│  Captura AUTOMÁTICAMENTE:                   │
│  • id_usuario                               │
│  • ip_address (request()->ip())             │
│  • user_agent (request()->header())         │
│  • timestamp (now())                        │
│  • módulo, acción, descripción              │
└────────────────────┬────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────┐
│  Inserta en tabla bitacora (PostgreSQL)     │
│  Sin intervención del usuario               │
└────────────────────┬────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────┐
│  Admin accede a /bitacora                   │
│                                             │
│  Ve AUTOMÁTICAMENTE:                        │
│  • Todas las acciones registradas           │
│  • Con filtros (usuario, módulo, etc)       │
│  • Con paginación                           │
│  • Con opción de exportar CSV               │
└─────────────────────────────────────────────┘
```

---

## 🎯 7 Puntos de Registro Automático

| # | Evento | Módulo | Acción | Ubicación |
|---|--------|--------|--------|-----------|
| 1 | Login | Autenticación | Inicio de sesión | AuthController:53 |
| 2 | Logout | Autenticación | Cierre de sesión | AuthController:93 |
| 3 | Generar QR | Asistencia_Docente | GENERAR_SESION | RegistroAsistenciaController:75 |
| 4 | Registrar Asistencia QR | Asistencia_Docente | REGISTRAR_ASISTENCIA_QR | RegistroAsistenciaController:260 |
| 5 | Cerrar Sesión | Asistencia_Docente | CERRAR_SESION | RegistroAsistenciaController:350 |
| 6 | Subir Justificativo | Asistencia_Docente | SUBIR_JUSTIFICATIVO | GestionInasistenciasController:120 |
| 7 | Resolver Inasistencia | Asistencia_Docente | RESOLVER_INASISTENCIA | GestionInasistenciasController:195 |

---

## ✅ Verificación Manual

### Opción 1: Usando PowerShell

```powershell
# Ejecuta el test automático
.\test_automatic_bitacora.ps1
```

### Opción 2: Usando Interfaz Web

1. Abre http://localhost:3000
2. Inicia sesión con tu usuario
3. Realiza algunas acciones:
   - Genera un QR
   - Haz click en botones
   - Realiza registros
4. Accede a http://localhost:3000/bitacora
5. **Verás AUTOMÁTICAMENTE todas tus acciones registradas**

### Opción 3: Consultando API Directamente

```powershell
# Obtén token
$login = Invoke-RestMethod -Uri "http://localhost:8000/api/auth/login" `
    -Method POST `
    -Headers @{"Content-Type" = "application/json"} `
    -Body '{"login":"admin","contrasena":"password"}'

$TOKEN = $login.token

# Consulta bitácora
$bitacora = Invoke-RestMethod -Uri "http://localhost:8000/api/bitacora" `
    -Method GET `
    -Headers @{"Authorization" = "Bearer $TOKEN"}

# Muestra resultados
$bitacora.data | Format-Table -AutoSize
```

---

## 🔐 Datos Capturados Automáticamente

### En Cada Registro:

```json
{
  "id_bit": 1,
  "modulo": "Autenticación",
  "accion": "Inicio de sesión exitoso",
  "descripcion": "Usuario admin ingresó al sistema",
  "detalles_json": {
    "navegador": "Chrome",
    "duracion_sesion": "30 minutos",
    "dispositivo": "Windows 10"
  },
  "id_usuario": 1,
  "ip_address": "192.168.1.100",
  "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)...",
  "tabla_afectada": "usuarios",
  "registro_id": 1,
  "fecha_accion": "2024-11-15 14:30:45.123456+00"
}
```

### ¿Quién captura cada dato?

- **id_usuario:** Obtenido del usuario autenticado
- **ip_address:** Capturado AUTOMÁTICAMENTE con `request()->ip()`
- **user_agent:** Capturado AUTOMÁTICAMENTE con `request()->header('User-Agent')`
- **fecha_accion:** Capturada AUTOMÁTICAMENTE con `now()` en la zona horaria del servidor
- **modulo/accion:** Pasados por el controlador (contexto de la acción)
- **detalles_json:** Detalles específicos de la acción

---

## 💡 Clave: Cero Intervención Manual

### ❌ LO QUE NO SUCEDE
```
Usuario login → Sistema espera que usuario ingrese datos en formulario
            → Usuario debe hacer clic en "Guardar" en bitácora
            → Usuario debe confirmar
```

### ✅ LO QUE SUCEDE
```
Usuario login → Sistema AUTOMÁTICAMENTE registra TODOS los datos
            → Usuario nunca ve nada de la bitácora
            → Todo está registrado cuando lo necesites
```

---

## 🛠 Archivos Relevantes

- **Modelo:** `app/Models/Bitacora.php`
  - Método `registrar()` que captura datos automáticamente
  
- **Controladores (6 archivos):**
  - `AuthController.php` - Login/Logout
  - `RegistroAsistenciaController.php` - QR y sesiones
  - `GestionInasistenciasController.php` - Justificativos
  
- **API:** `routes/api.php`
  - 8 endpoints bajo `/api/bitacora`
  
- **Frontend:** `resources/js/pages/Bitacora.jsx`
  - Interfaz para visualizar registros
  
- **Base de datos:** `database/migrations/2025_11_11_000005_enhance_bitacora_table.php`
  - Tabla con 11 campos

---

## 📝 Resumen

| Aspecto | Descripción |
|--------|-------------|
| **¿Requiere intervención manual?** | ❌ NO |
| **¿Se registra automáticamente?** | ✅ SÍ |
| **¿El usuario sabe que está siendo registrado?** | El usuario NO ve el proceso (sucede en background) |
| **¿Se pierden datos?** | NO, todo se captura automáticamente |
| **¿Es seguro?** | SÍ, IP y User-Agent verifican la sesión |
| **¿Puedo filtrar?** | SÍ, por usuario, módulo, acción, fecha |
| **¿Puedo exportar?** | SÍ, a CSV para análisis |

---

## 🎓 Conclusión

**CU18 es 100% AUTOMÁTICO:**
- El usuario realiza acciones
- El sistema automáticamente registra en la bitácora
- El administrador puede ver todo sin que se deba hacer nada manualmente
- Todos los datos (IP, timestamp, usuario, detalles) se capturan automáticamente

**No hay intervención manual en ningún punto del proceso.**

