# CU18 - REGISTRO AUTOMÁTICO DE BITÁCORA
## Guía Completa y Final

---

## ✨ En Una Línea

**CU18 es 100% automático: El usuario realiza acciones normalmente → El sistema automáticamente registra TODO en la bitácora → El admin accede a `/bitacora` y ve todo.**

---

## 📋 Tabla de Contenido

1. [¿Qué es CU18?](#qué-es-cu18)
2. [¿Por qué es automático?](#por-qué-es-automático)
3. [Los 7 Puntos de Captura](#los-7-puntos-de-captura)
4. [Cómo Funciona](#cómo-funciona)
5. [Archivos Implementados](#archivos-implementados)
6. [Datos Capturados](#datos-capturados)
7. [Cómo Usar](#cómo-usar)
8. [Cómo Probar](#cómo-probar)
9. [Preguntas Frecuentes](#preguntas-frecuentes)

---

## ¿Qué es CU18?

**Caso de Uso 18: Registrar Bitácora de Acciones**

Es un sistema de auditoría que registra automáticamente TODAS las acciones que hacen los usuarios en el sistema.

### Propósito:
- 📊 Mantener un historial completo de todas las acciones
- 🔍 Permitir a administradores auditar el sistema
- 🔐 Mejorar la seguridad con IP y User-Agent
- 📈 Analizar uso del sistema con estadísticas

### Cobertura:
- Inicio de sesión (login)
- Cierre de sesión (logout)
- Generación de códigos QR
- Registro de asistencia por QR
- Cierre de sesiones
- Carga de justificativos
- Resolución de inasistencias

---

## ¿Por Qué es Automático?

### ❌ Alternativa Manual (Lo que NO hacemos)
```
Usuario realiza acción
    ↓
Usuario abre pantalla de "Registrar en Bitácora"
    ↓
Usuario llena formulario manualmente
    ↓
Usuario presiona botón "Guardar"
    ↓
Sistema registra
```

**Problemas:**
- Lento (requiere pasos adicionales)
- Propenso a errores (usuario se olvida)
- Incompleto (falta información como IP)
- Inconsistente (no siempre se registra)

### ✅ Lo que Implementamos (100% Automático)
```
Usuario realiza acción (login, generar QR, etc)
    ↓
Controlador procesa la solicitud
    ↓
⭐ AUTOMÁTICAMENTE se llama: Bitacora::registrar()
    ↓
Se capturan AUTOMÁTICAMENTE: IP, User-Agent, Timestamp
    ↓
Se inserta en base de datos
    ↓
Listo - el usuario nunca supo que fue registrado
```

**Ventajas:**
- Rápido (cero pasos adicionales)
- Confiable (nunca se olvida)
- Completo (datos del contexto)
- Consistente (siempre igual)

---

## Los 7 Puntos de Captura

Estas son las 7 acciones que se registran automáticamente:

### 1️⃣ LOGIN - Inicio de Sesión
| Aspecto | Detalle |
|---------|---------|
| **Acción** | Usuario ingresa al sistema |
| **Ubicación** | `app/Http/Controllers/Autenticación_y_Control_de_Acceso/AuthController.php` línea 53 |
| **Módulo Registrado** | "Autenticación" |
| **Acción Registrada** | "Inicio de sesión exitoso" |
| **Detalles Capturados** | IP, User-Agent, timestamp, ID usuario |
| **Código** | `Bitacora::registrar('Autenticación', 'Inicio de sesión exitoso', $usuario->id_usuario);` |

### 2️⃣ LOGOUT - Cierre de Sesión
| Aspecto | Detalle |
|---------|---------|
| **Acción** | Usuario se desconecta del sistema |
| **Ubicación** | `app/Http/Controllers/Autenticación_y_Control_de_Acceso/AuthController.php` línea 93 |
| **Módulo Registrado** | "Autenticación" |
| **Acción Registrada** | "Cierre de sesión" |
| **Detalles Capturados** | IP, User-Agent, timestamp, ID usuario |
| **Código** | `Bitacora::registrar('Autenticación', 'Cierre de sesión', $usuario->id_usuario);` |

### 3️⃣ GENERAR QR - Creación de Código QR
| Aspecto | Detalle |
|---------|---------|
| **Acción** | Docente genera QR para clase de asistencia |
| **Ubicación** | `app/Http/Controllers/Asistencia_Docente/RegistroAsistenciaController.php` línea 75 |
| **Módulo Registrado** | "Asistencia_Docente" |
| **Acción Registrada** | "GENERAR_SESION" |
| **Detalles Capturados** | IP, User-Agent, timestamp, código QR, duración |
| **Código** | `Bitacora::registrar('Asistencia_Docente', 'GENERAR_SESION', $usuario->id_usuario, [...]);` |

### 4️⃣ REGISTRAR ASISTENCIA - Escaneo de QR
| Aspecto | Detalle |
|---------|---------|
| **Acción** | Estudiante escanea QR para registrar asistencia |
| **Ubicación** | `app/Http/Controllers/Asistencia_Docente/RegistroAsistenciaController.php` línea 260 |
| **Módulo Registrado** | "Asistencia_Docente" |
| **Acción Registrada** | "REGISTRAR_ASISTENCIA_QR" |
| **Detalles Capturados** | IP, User-Agent, timestamp, resultado del escaneo |
| **Código** | `Bitacora::registrar('Asistencia_Docente', 'REGISTRAR_ASISTENCIA_QR', $usuario->id_usuario, [...]);` |

### 5️⃣ CERRAR SESIÓN - Finalización de QR
| Aspecto | Detalle |
|---------|---------|
| **Acción** | Docente cierra la sesión de asistencia |
| **Ubicación** | `app/Http/Controllers/Asistencia_Docente/RegistroAsistenciaController.php` línea 350 |
| **Módulo Registrado** | "Asistencia_Docente" |
| **Acción Registrada** | "CERRAR_SESION" |
| **Detalles Capturados** | IP, User-Agent, timestamp, cantidad de asistentes |
| **Código** | `Bitacora::registrar('Asistencia_Docente', 'CERRAR_SESION', $usuario->id_usuario);` |

### 6️⃣ SUBIR JUSTIFICATIVO - Envío de Documento
| Aspecto | Detalle |
|---------|---------|
| **Acción** | Estudiante sube documento justificativo |
| **Ubicación** | `app/Http/Controllers/Asistencia_Docente/GestionInasistenciasController.php` línea 120 |
| **Módulo Registrado** | "Asistencia_Docente" |
| **Acción Registrada** | "SUBIR_JUSTIFICATIVO" |
| **Detalles Capturados** | IP, User-Agent, timestamp, nombre archivo, tipo |
| **Código** | `Bitacora::registrar('Asistencia_Docente', 'SUBIR_JUSTIFICATIVO', $usuario->id_usuario, [...]);` |

### 7️⃣ RESOLVER INASISTENCIA - Aprobación/Rechazo
| Aspecto | Detalle |
|---------|---------|
| **Acción** | Admin aprueba o rechaza un justificativo |
| **Ubicación** | `app/Http/Controllers/Asistencia_Docente/GestionInasistenciasController.php` línea 195 |
| **Módulo Registrado** | "Asistencia_Docente" |
| **Acción Registrada** | "RESOLVER_INASISTENCIA" |
| **Detalles Capturados** | IP, User-Agent, timestamp, decisión, motivo |
| **Código** | `Bitacora::registrar('Asistencia_Docente', 'RESOLVER_INASISTENCIA', $usuario->id_usuario, [...]);` |

---

## Cómo Funciona

### Arquitectura Técnica

```
┌─────────────────────────────────────────────────────────────┐
│  1. Usuario realiza acción (login, generar QR, etc)         │
└──────────────────┬──────────────────────────────────────────┘
                   │
┌──────────────────▼──────────────────────────────────────────┐
│  2. Controlador ejecuta la lógica de negocio                │
│     AuthController::login()                                  │
│     RegistroAsistenciaController::generarSesion()           │
│     etc.                                                     │
└──────────────────┬──────────────────────────────────────────┘
                   │
┌──────────────────▼──────────────────────────────────────────┐
│  3. ⭐ AUTOMÁTICAMENTE se ejecuta:                          │
│                                                              │
│     Bitacora::registrar(                                    │
│       'modulo',           // ej: 'Autenticación'            │
│       'accion',           // ej: 'Inicio de sesión'         │
│       $idUsuario,         // ID del usuario                 │
│       $detalles           // Información adicional          │
│     );                                                      │
└──────────────────┬──────────────────────────────────────────┘
                   │
┌──────────────────▼──────────────────────────────────────────┐
│  4. El método registrar() captura AUTOMÁTICAMENTE:          │
│                                                              │
│     • request()->ip()              → IP del cliente         │
│     • request()->header('User-Agent') → Navegador usado     │
│     • now()                        → Timestamp exacto       │
│                                                              │
│     Todo esto sin que el usuario tenga que hacer nada       │
└──────────────────┬──────────────────────────────────────────┘
                   │
┌──────────────────▼──────────────────────────────────────────┐
│  5. Se inserta en la tabla bitacora de PostgreSQL            │
│                                                              │
│     INSERT INTO bitacora (                                  │
│       modulo, accion, id_usuario, ip_address,              │
│       user_agent, fecha_accion, detalles_json, ...          │
│     ) VALUES (...)                                          │
└──────────────────┬──────────────────────────────────────────┘
                   │
┌──────────────────▼──────────────────────────────────────────┐
│  6. Admin accede a http://localhost:3000/bitacora            │
│                                                              │
│     VE TODO AUTOMÁTICAMENTE:                               │
│     • Tabla con todos los registros                         │
│     • Filtros por usuario, módulo, acción, fecha           │
│     • Paginación                                            │
│     • Estadísticas (total, hoy, usuarios activos, etc)      │
│     • Modal con detalles completos                          │
│     • Opción para exportar a CSV                            │
│                                                              │
│     ¿Intervención manual? ❌ NO                             │
│     ¿Se actualiza automáticamente? ✅ SÍ                    │
└─────────────────────────────────────────────────────────────┘
```

### Método `Bitacora::registrar()`

```php
// Ubicación: app/Models/Bitacora.php

public static function registrar(
    $modulo,
    $accion,
    $idUsuario = null,
    $detalles = [],
    $tablaAfectada = null,
    $registroId = null
) {
    return self::create([
        // Datos pasados por el controlador
        'modulo' => $modulo,                          // ej: 'Autenticación'
        'accion' => $accion,                          // ej: 'Inicio de sesión'
        'id_usuario' => $idUsuario,                   // ID del usuario
        'descripcion' => $accion,
        'detalles_json' => json_encode($detalles),    // JSON con contexto
        
        // Datos capturados AUTOMÁTICAMENTE
        'ip_address' => request()->ip(),              // 💾 AUTOMÁTICO
        'user_agent' => request()->header('User-Agent'),  // 💾 AUTOMÁTICO
        'fecha_accion' => now(),                      // 💾 AUTOMÁTICO
        
        // Datos opcionales para referencia
        'tabla_afectada' => $tablaAfectada,
        'registro_id' => $registroId
    ]);
}
```

**Nota:** Los datos en `// 💾 AUTOMÁTICO` se capturan sin intervención del usuario.

---

## Archivos Implementados

### 1. Modelo - `app/Models/Bitacora.php`
**Responsabilidad:** Definir la estructura y lógica de la bitácora

**Métodos principales:**
- `registrar()` - Método estático para registrar acciones
- `porUsuario()` - Scope para filtrar por usuario
- `porModulo()` - Scope para filtrar por módulo
- `porAccion()` - Scope para filtrar por acción
- `entreFechas()` - Scope para filtrar por rango de fechas

**Ubicación:** `app/Models/Bitacora.php` (103 líneas)

### 2. Controlador - `app/Http/Controllers/Auditoria_y_Trazabilidad/BitacoraController.php`
**Responsabilidad:** Manejar solicitudes API para consultar la bitácora

**Métodos principales:**
- `listarAcciones()` - GET /api/bitacora - Lista paginada de registros
- `obtenerDetalle()` - GET /api/bitacora/{id} - Detalles de un registro
- `filtrar()` - GET /api/bitacora/filtrar - Filtrado avanzado
- `estadisticas()` - GET /api/bitacora/estadisticas - Dashboard con métricas
- `exportarCSV()` - POST /api/bitacora/exportar-csv - Descargar como CSV
- `limpiarAntiguos()` - DELETE /api/bitacora/limpiar-antiguos - Borrar registros viejos
- `obtenerModulos()` - GET para opciones de filtro
- `obtenerAcciones()` - GET para opciones de filtro

**Ubicación:** `app/Http/Controllers/Auditoria_y_Trazabilidad/BitacoraController.php` (380 líneas)

### 3. Rutas API - `routes/api.php`
**Responsabilidad:** Definir los endpoints para acceder a la bitácora

**Rutas:**
```
GET    /api/bitacora                  → listarAcciones()
GET    /api/bitacora/estadisticas     → estadisticas()
GET    /api/bitacora/modulos          → obtenerModulos()
GET    /api/bitacora/acciones         → obtenerAcciones()
GET    /api/bitacora/filtrar          → filtrar()
GET    /api/bitacora/{id}             → obtenerDetalle()
POST   /api/bitacora/exportar-csv     → exportarCSV()
DELETE /api/bitacora/limpiar-antiguos → limpiarAntiguos()
```

**Middleware:** `auth:sanctum` (requiere usuario autenticado)

### 4. Componente React - `resources/js/pages/Bitacora.jsx`
**Responsabilidad:** Interfaz web para visualizar y filtrar registros

**Características:**
- Estadísticas en tiempo real (cards con totales)
- Tabla con paginación (50 registros por página)
- Filtros avanzados (usuario, módulo, acción, fecha, búsqueda)
- Modal con detalles completos de cada registro
- Exportación a CSV
- Responsive design (funciona en móvil, tablet, desktop)

**Ubicación:** `resources/js/pages/Bitacora.jsx` (450+ líneas)

### 5. Estilos CSS - `resources/js/pages/Bitacora.css`
**Responsabilidad:** Dar estilo a la interfaz

**Características:**
- Diseño responsive (3 breakpoints: mobile, tablet, desktop)
- Gradiente naranja (#ff6b35 a #ff8c42)
- Tablas con hover effects
- Badges de colores (CREATE, UPDATE, DELETE, LOGIN, etc)
- Modal con animaciones
- Monospace para datos técnicos (IP, User-Agent)

**Ubicación:** `resources/js/pages/Bitacora.css` (700+ líneas)

### 6. Migración BD - `database/migrations/2025_11_11_000005_enhance_bitacora_table.php`
**Responsabilidad:** Crear/modificar la tabla en PostgreSQL

**Tabla `bitacora` con columnas:**
- `id_bit` BIGSERIAL PRIMARY KEY
- `modulo` VARCHAR(100) - Módulo del sistema
- `accion` VARCHAR(100) - Acción realizada
- `descripcion` TEXT - Descripción
- `detalles_json` JSON - Datos adicionales
- `id_usuario` BIGINT FK - Usuario que realizó acción
- `ip_address` VARCHAR(50) - IP del cliente
- `user_agent` TEXT - Navegador/dispositivo
- `tabla_afectada` VARCHAR(100) - Tabla modificada (opcional)
- `registro_id` BIGINT - ID del registro afectado (opcional)
- `fecha_accion` TIMESTAMP WITH TIME ZONE - Timestamp exacto

**Índices para rendimiento:**
- `id_usuario` - Para filtrar por usuario
- `fecha_accion` - Para filtrar por rango de fechas
- `modulo` - Para filtrar por módulo
- `accion` - Para filtrar por acción

**Ubicación:** `database/migrations/2025_11_11_000005_enhance_bitacora_table.php` (153 líneas)

### 7. Integraciones en Controladores (6 archivos)

#### a) AuthController.php
```php
// Login (línea 53)
Bitacora::registrar('Autenticación', 'Inicio de sesión exitoso', $usuario->id_usuario);

// Logout (línea 93)
Bitacora::registrar('Autenticación', 'Cierre de sesión', $usuario->id_usuario);
```

#### b) RegistroAsistenciaController.php
```php
// Generar QR (línea 75)
Bitacora::registrar('Asistencia_Docente', 'GENERAR_SESION', ...);

// Registrar asistencia (línea 260)
Bitacora::registrar('Asistencia_Docente', 'REGISTRAR_ASISTENCIA_QR', ...);

// Cerrar sesión (línea 350)
Bitacora::registrar('Asistencia_Docente', 'CERRAR_SESION', ...);
```

#### c) GestionInasistenciasController.php
```php
// Subir justificativo (línea 120)
Bitacora::registrar('Asistencia_Docente', 'SUBIR_JUSTIFICATIVO', ...);

// Resolver inasistencia (línea 195)
Bitacora::registrar('Asistencia_Docente', 'RESOLVER_INASISTENCIA', ...);
```

---

## Datos Capturados

### Cada registro de bitácora contiene:

```json
{
  "id_bit": 1,
  "modulo": "Autenticación",
  "accion": "Inicio de sesión exitoso",
  "descripcion": "Usuario admin ingresó al sistema",
  "detalles_json": {
    "navegador": "Chrome",
    "duracion_sesion": "30 minutos",
    "dispositivo": "Windows 10",
    "otros_datos": "depende de la acción"
  },
  "id_usuario": 1,
  "ip_address": "192.168.1.100",
  "user_agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36...",
  "tabla_afectada": "usuarios",
  "registro_id": 1,
  "fecha_accion": "2024-11-15 14:30:45.123456+00:00",
  "usuario": {
    "id_usuario": 1,
    "nombre": "Admin User",
    "email": "admin@example.com"
  }
}
```

### Datos Capturados Automáticamente:
- **IP Address:** Obtenida con `request()->ip()`
- **User-Agent:** Obtenida con `request()->header('User-Agent')`
- **Fecha/Hora:** Obtenida con `now()` (incluye timestamp exacto con microsegundos)

### Datos Proporcionados por el Controlador:
- **Módulo:** El módulo donde ocurre la acción
- **Acción:** El tipo de acción realizada
- **ID Usuario:** Quién realizó la acción
- **Detalles:** Información específica de la acción (como JSON)

---

## Cómo Usar

### Como Usuario (Nada especial que hacer)
```
1. Ingresa al sistema normalmente
2. Realiza tus acciones (generar QR, cargar documentos, etc)
3. Sistema automáticamente registra TODO
4. ¡Listo! Tus acciones están en la bitácora
```

### Como Administrador

#### Acceder a la bitácora:
```
Abre: http://localhost:3000/bitacora
```

#### Ver estadísticas:
```
Dashboard muestra automáticamente:
• Total de acciones registradas
• Acciones de hoy
• Usuarios activos
• Módulos más utilizados
• Acciones más comunes
```

#### Filtrar registros:
```
Usa los filtros:
• Por Usuario: Selecciona un usuario
• Por Módulo: Selecciona un módulo
• Por Acción: Selecciona un tipo de acción
• Por Fecha: Rango de fechas (Hoy, Semana, Mes, Todo)
• Búsqueda: Escribe texto para buscar
```

#### Ver detalles:
```
Haz clic en "Ver" en cualquier registro
Se abre modal con:
• Información completa
• IP y User-Agent
• Detalles en JSON
• Timestamp exacto
```

#### Exportar a CSV:
```
Presiona "📥 Descargar CSV"
Se descarga archivo con todos los registros actuales
Abre en Excel para análisis
```

---

## Cómo Probar

### Opción 1: Script Automatizado (Recomendado)

#### En Windows (PowerShell):
```powershell
.\test_automatic_bitacora.ps1
```

#### En Linux/Mac (Bash):
```bash
chmod +x test_automatic_bitacora.sh
./test_automatic_bitacora.sh
```

### Opción 2: Manualmente en Interfaz Web

**Pasos:**
1. Abre http://localhost:3000
2. Inicia sesión (se registra automáticamente en bitácora)
3. Navega y realiza acciones (se registran automáticamente)
4. Abre http://localhost:3000/bitacora
5. Verás todas tus acciones registradas automáticamente
6. Prueba los filtros
7. Intenta exportar a CSV

### Opción 3: Usando API Directamente

```powershell
# 1. Login
$login = Invoke-RestMethod -Uri "http://localhost:8000/api/auth/login" `
    -Method POST `
    -ContentType "application/json" `
    -Body '{"login":"admin","contrasena":"password"}'

$token = $login.token

# 2. Ver estadísticas
Invoke-RestMethod -Uri "http://localhost:8000/api/bitacora/estadisticas" `
    -Headers @{"Authorization" = "Bearer $token"} | ConvertTo-Json | Write-Host

# 3. Listar registros
$bitacora = Invoke-RestMethod -Uri "http://localhost:8000/api/bitacora" `
    -Headers @{"Authorization" = "Bearer $token"}

$bitacora.data | Format-Table -AutoSize
```

---

## Preguntas Frecuentes

### ❓ ¿El usuario sabe que está siendo registrado?
**Respuesta:** No. Es completamente transparente. El usuario realiza sus acciones normales sin ver nada relacionado con la bitácora. El registro sucede automáticamente en el backend.

### ❓ ¿Qué pasa si el usuario olvida algo?
**Respuesta:** No importa. El sistema registra automáticamente. No hay riesgo de que se olvide nada.

### ❓ ¿Se captura la IP del usuario?
**Respuesta:** Sí, automáticamente. Con `request()->ip()` se obtiene la IP del cliente.

### ❓ ¿Se captura qué navegador usa?
**Respuesta:** Sí, automáticamente. El User-Agent se captura con `request()->header('User-Agent')`.

### ❓ ¿Qué tan exacto es el timestamp?
**Respuesta:** Muy exacto. Se usa `now()` que captura fecha, hora, minutos, segundos Y microsegundos con zona horaria.

### ❓ ¿Puedo filtrar por usuario específico?
**Respuesta:** Sí, hay un filtro "Usuario" que muestra todos los usuarios con acciones registradas.

### ❓ ¿Puedo ver solo las acciones de hoy?
**Respuesta:** Sí, usa el filtro de fecha y selecciona "Hoy".

### ❓ ¿Puedo descargar los registros?
**Respuesta:** Sí, presiona "📥 Descargar CSV" para descargar un archivo Excel con todos los registros.

### ❓ ¿Quién puede ver la bitácora?
**Respuesta:** Solo usuarios con rol "Administrador" que estén autenticados (tienen token válido).

### ❓ ¿Se registran todas las acciones?
**Respuesta:** Se registran los 7 tipos principales:
1. Login
2. Logout
3. Generar QR
4. Registrar asistencia por QR
5. Cerrar sesión
6. Subir justificativo
7. Resolver inasistencia

### ❓ ¿Puedo agregar más puntos de registro?
**Respuesta:** Sí. Solo agrega `Bitacora::registrar(...)` donde necesites registrar acciones adicionales.

### ❓ ¿Cómo borro registros antiguos?
**Respuesta:** Use el endpoint DELETE `/api/bitacora/limpiar-antiguos` que borra registros más antiguos de 90 días.

### ❓ ¿Es seguro?
**Respuesta:** Sí:
- Requiere autenticación (auth:sanctum)
- Registra IP y User-Agent para verificación
- Solo admins pueden ver bitácora
- Datos en PostgreSQL con respaldos

---

## Resumen Técnico

| Aspecto | Detalles |
|---------|----------|
| **Tipo** | Sistema de auditoría automático |
| **Lenguaje Backend** | Laravel 11 (PHP) |
| **Base de Datos** | PostgreSQL |
| **Frontend** | React 18 + Vite |
| **Autenticación** | Laravel Sanctum |
| **Puntos de Registro** | 7 acciones principales |
| **Datos Capturados** | 11 campos (modulo, accion, usuario, IP, User-Agent, timestamp, etc) |
| **Interfaz Admin** | http://localhost:3000/bitacora |
| **API Endpoints** | 8 rutas bajo /api/bitacora |
| **Automatización** | 100% - El usuario no hace nada manualmente |
| **Seguridad** | Requiere autenticación y rol de admin |

---

## Conclusión

**CU18 es completamente automático.**

Cuando un usuario realiza una acción:
1. ✅ El sistema captura automáticamente los detalles
2. ✅ Se registra automáticamente en la base de datos
3. ✅ Se capturan automáticamente IP, User-Agent y timestamp
4. ✅ El admin puede ver todo sin intervención manual

**No hay pasos manuales. Todo sucede automáticamente en el backend.**

---

## Archivos de Referencia

| Archivo | Propósito |
|---------|-----------|
| `app/Models/Bitacora.php` | Modelo con método registrar() |
| `app/Http/Controllers/Auditoria_y_Trazabilidad/BitacoraController.php` | Controlador API |
| `routes/api.php` | Rutas API |
| `resources/js/pages/Bitacora.jsx` | Componente React |
| `resources/js/pages/Bitacora.css` | Estilos |
| `database/migrations/2025_11_11_000005_enhance_bitacora_table.php` | Migración BD |
| `CU18_HOW_TO_TEST_AUTOMATIC.md` | Guía de pruebas |
| `CU18_AUTOMATIC_FLOW_DIAGRAM.md` | Diagramas de flujo |
| `test_automatic_bitacora.ps1` | Script de prueba (PowerShell) |
| `test_automatic_bitacora.sh` | Script de prueba (Bash) |

---

**Última actualización:** 2024-11-15
**Estado:** ✅ Completamente implementado y funcional
**Automatización:** 100% - Sin intervención manual requerida
