# ✨ CU18 - REGISTRO AUTOMÁTICO DE BITÁCORA ✨

## 🎯 CÓMO FUNCIONA (100% AUTOMÁTICO)

El usuario **NO necesita hacer nada manualmente**. Todas las acciones se registran automáticamente en la bitácora.

---

## 🔄 FLUJO DE REGISTRO AUTOMÁTICO

### 1️⃣ **USUARIO REALIZA UNA ACCIÓN**
```
Usuario inicia sesión
    ↓
AuthController::login() se ejecuta
    ↓
Bitacora::registrar() se llama AUTOMÁTICAMENTE
    ↓
Acción guardada en tabla `bitacora`
```

### 2️⃣ **ADMINISTRADOR ACCEDE A BITÁCORA**
```
Admin abre http://localhost:3000/bitacora
    ↓
Frontend carga datos del API
    ↓
GET /api/bitacora retorna todos los registros
    ↓
Se muestran en tabla con filtros
```

---

## 📝 ACCIONES QUE SE REGISTRAN AUTOMÁTICAMENTE

### **AUTENTICACIÓN** (CU1)
```php
// Archivo: AuthController.php

✅ LOGIN
   Línea 53: Bitacora::registrar('Autenticación', 'Inicio de sesión exitoso', $usuario->id_usuario);
   
   Dispara automáticamente cuando:
   - Usuario entra credenciales correctas en login
   
   Se captura:
   - ID del usuario
   - IP Address
   - User-Agent
   - Timestamp exacto

✅ LOGOUT  
   Línea 93: Bitacora::registrar('Autenticación', 'Cierre de sesión', $usuario->id_usuario);
   
   Dispara automáticamente cuando:
   - Usuario hace click en botón logout O
   - Token expira
   
   Se captura:
   - ID del usuario
   - IP Address
   - User-Agent
   - Timestamp exacto
```

---

### **ASISTENCIA DOCENTE** (CU14)

#### A. **Generación de QR** - Automático
```php
// Archivo: RegistroAsistenciaController.php, línea ~75

✅ GENERAR_SESION_ASISTENCIA
   Bitacora::registrar(
       'Asistencia_Docente',
       'GENERAR_SESION_ASISTENCIA',
       auth('sanctum')->id(),
       ['id_sesion' => $sesion->id_sesion, 'token' => $token],
       'sesiones_asistencia',
       $sesion->id_sesion
   );
   
   Dispara AUTOMÁTICAMENTE cuando:
   - Docente genera QR desde GenerarQR.jsx
   - Hace click en botón "Generar Código QR"
   
   Se captura:
   - ID de docente
   - ID de sesión
   - ID de asignación
   - IP Address
   - Timestamp exacto
```

#### B. **Registro por QR** - Automático
```php
// Archivo: RegistroAsistenciaController.php, línea ~260

✅ REGISTRAR_ASISTENCIA_QR
   Bitacora::registrar(
       'Asistencia_Docente',
       'REGISTRAR_ASISTENCIA_QR',
       null,  // Es público (sin usuario identificado)
       ['id_asistencias' => $asistencia->id_asistencias, 'estado' => $estado],
       'asistencias',
       $asistencia->id_asistencias
   );
   
   Dispara AUTOMÁTICAMENTE cuando:
   - Usuario escanea QR desde Bitácora de asistencia
   - O accede directamente a la URL del QR
   
   Se captura:
   - ID de asistencia
   - Estado (PRESENTE, RETRASO, FALTA)
   - Minutos transcurridos
   - IP Address
   - Timestamp exacto
```

#### C. **Cierre de Sesión QR** - Automático
```php
// Archivo: RegistroAsistenciaController.php, línea ~350

✅ CERRAR_SESION_ASISTENCIA
   Bitacora::registrar(
       'Asistencia_Docente',
       'CERRAR_SESION_ASISTENCIA',
       auth('sanctum')->id(),
       ['id_sesion' => $sesion->id_sesion],
       'sesiones_asistencia',
       $sesion->id_sesion
   );
   
   Dispara AUTOMÁTICAMENTE cuando:
   - Docente hace click en botón "Cerrar Sesión"
   - O vence el tiempo de la sesión
   
   Se captura:
   - ID de sesión
   - ID de docente que cierra
   - IP Address
   - Timestamp exacto
```

---

### **GESTIÓN DE INASISTENCIAS** (CU15)

#### A. **Submisión de Justificativo** - Automático
```php
// Archivo: GestionInasistenciasController.php, línea ~120

✅ SUBIR_JUSTIFICATIVO
   Bitacora::registrar(
       'Asistencia_Docente',
       'SUBIR_JUSTIFICATIVO',
       auth('sanctum')->id(),
       ['id_inasistencia' => $inasistencia->id_inasistencia, 'archivo' => $nombreArchivo],
       'justificativos',
       $justificativo->id_justificativo
   );
   
   Dispara AUTOMÁTICAMENTE cuando:
   - Docente sube justificativo desde GestionInasistencias.jsx
   - Hace click en botón "Subir Justificativo"
   - Selecciona archivo y hace submit
   
   Se captura:
   - ID del justificativo
   - ID de inasistencia
   - Nombre del archivo
   - Tipo MIME
   - Tamaño del archivo
   - IP Address
   - Timestamp exacto
```

#### B. **Revisión de Inasistencia** - Automático
```php
// Archivo: GestionInasistenciasController.php, línea ~195

✅ RESOLVER_INASISTENCIA
   Bitacora::registrar(
       'Asistencia_Docente',
       'RESOLVER_INASISTENCIA',
       auth('sanctum')->id(),
       ['id_inasistencia' => $id, 'decision' => $decision, 'tipo_accion' => $tipoAccion],
       'resoluciones_inasistencias',
       $resolucion->id_resolucion
   );
   
   Dispara AUTOMÁTICAMENTE cuando:
   - Coordinador hace click en botón "Revisar"
   - Selecciona APROBADA o RECHAZADA
   - Hace submit del formulario
   
   Se captura:
   - ID de resolución
   - ID de inasistencia
   - Decisión (APROBADA/RECHAZADA)
   - Tipo de acción (REPOSICIÓN, AJUSTE, CONDONACIÓN)
   - Coordinador que resolvió
   - IP Address
   - Timestamp exacto
```

---

## 🎬 EJEMPLO COMPLETO: FLUJO DE UN USUARIO

### **Timeline de Acciones de Usuario "docente123"**

```
09:00 - Usuario intenta login FALLIDO (credenciales incorrectas)
        ↓ NO se registra en bitácora (porque el login falló)

09:02 - Usuario intenta login EXITOSO
        ↓ ✅ Bitácora registra: LOGIN EXITOSO
        ↓    Módulo: Autenticación
        ↓    Usuario: docente123
        ↓    IP: 192.168.1.100
        ↓    Timestamp: 2025-11-11 09:02:15

09:15 - Usuario genera QR para asistencia
        ↓ ✅ Bitácora registra: GENERAR_SESION_ASISTENCIA
        ↓    Módulo: Asistencia_Docente
        ↓    Acción: GENERAR_SESION_ASISTENCIA
        ↓    ID de sesión: 45
        ↓    IP: 192.168.1.100

09:30 - Usuario sube justificativo de una inasistencia
        ↓ ✅ Bitácora registra: SUBIR_JUSTIFICATIVO
        ↓    Módulo: Asistencia_Docente
        ↓    Archivo: "justificativo_45_2025110115.pdf"
        ↓    ID de justificativo: 23
        ↓    IP: 192.168.1.100

12:00 - Usuario cierra sesión
        ↓ ✅ Bitácora registra: LOGOUT
        ↓    Módulo: Autenticación
        ↓    Usuario: docente123
        ↓    IP: 192.168.1.100
        ↓    Timestamp: 2025-11-11 12:00:45
```

**Administrador accede a /bitacora:**
```
VE TODA LA TABLA CON LOS 4 REGISTROS AUTOMÁTICOS:

┌────┬──────────────────────┬──────────────────────┬────────────┐
│ ID │ Usuario              │ Módulo               │ Acción     │
├────┼──────────────────────┼──────────────────────┼────────────┤
│ 1  │ docente123           │ Autenticación        │ LOGIN      │
│ 2  │ docente123           │ Asistencia_Docente   │ GEN_QR     │
│ 3  │ docente123           │ Asistencia_Docente   │ SUBIR_JUST │
│ 4  │ docente123           │ Autenticación        │ LOGOUT     │
└────┴──────────────────────┴──────────────────────┴────────────┘
```

---

## 🔍 DÓNDE SE DISPARAN LOS REGISTROS

### **Archivos con Bitacora::registrar() AUTOMÁTICO**

| Archivo | Método | Acción | Línea | Automático |
|---------|--------|--------|-------|-----------|
| AuthController.php | login() | LOGIN | 53 | ✅ Sí |
| AuthController.php | logout() | LOGOUT | 93 | ✅ Sí |
| RegistroAsistenciaController.php | generarSesion() | GENERAR_SESION | 75 | ✅ Sí |
| RegistroAsistenciaController.php | registrar() | REGISTRAR_QR | 260 | ✅ Sí |
| RegistroAsistenciaController.php | cerrarSesion() | CERRAR_SESION | 350 | ✅ Sí |
| GestionInasistenciasController.php | subirJustificativo() | SUBIR_JUST | 120 | ✅ Sí |
| GestionInasistenciasController.php | revisar() | RESOLVER_INAS | 195 | ✅ Sí |

---

## 📊 DATOS CAPTURADOS AUTOMÁTICAMENTE

Para CADA acción, el sistema captura automáticamente:

```php
Bitacora::registrar(
    'Módulo',                    // ✅ Automático - del controlador
    'Acción',                    // ✅ Automático - del método
    auth('sanctum')->id(),       // ✅ Automático - del usuario autenticado
    [                            // ✅ Automático - contexto específico
        'datos' => 'relevantes'
    ],
    'tabla_afectada',            // ✅ Automático - qué tabla se modificó
    $registro_id                 // ✅ Automático - qué registro se afectó
);

// Además, el modelo Bitacora captura automáticamente:
- ip_address         // ✅ De request()->ip()
- user_agent         // ✅ De request()->header('User-Agent')
- fecha_accion       // ✅ Timestamp automático con timezone
```

---

## 🎯 CÓMO VERIFICAR QUE TODO ES AUTOMÁTICO

### **Paso 1: Inicia sesión en la aplicación**
```
URL: http://localhost:3000/login
Usuario: admin
Contraseña: password
```

### **Paso 2: Realiza algunas acciones**
```
✓ Inicia sesión (se registra automáticamente)
✓ Genera QR de asistencia
✓ Sube un justificativo
✓ Resuelve una inasistencia
✓ Cierra sesión
```

### **Paso 3: Accede a la bitácora**
```
URL: http://localhost:3000/bitacora
```

### **Paso 4: Verifica que todas las acciones estén registradas**
```
Deberías ver una tabla con TODOS tus movimientos:
- Fila 1: LOGIN a las 09:02
- Fila 2: GENERAR QR a las 09:15
- Fila 3: SUBIR JUSTIFICATIVO a las 09:30
- Fila 4: LOGOUT a las 12:00

TODO SIN HACER NADA MANUALMENTE ✨
```

---

## 🔐 SEGURIDAD AUTOMÁTICA

El sistema automáticamente:

✅ Captura IP Address del cliente
✅ Captura User-Agent del navegador
✅ Registra timestamp exacto con timezone
✅ Asocia al usuario autenticado
✅ Identifica el módulo y acción
✅ Almacena contexto en JSON
✅ Crea índices para búsquedas rápidas
✅ Protege contra SQL injection (Eloquent)

---

## 📈 FLUJO AUTOMÁTICO COMPLETO

```
┌─────────────────────────────────────────────────────────┐
│         1. USUARIO REALIZA ACCIÓN                       │
│         (Login, genera QR, sube archivo, etc.)          │
└──────────────────┬──────────────────────────────────────┘
                   │
                   ↓
┌─────────────────────────────────────────────────────────┐
│         2. CONTROLADOR PROCESA ACCIÓN                   │
│         (AuthController, AsistenciaController, etc.)    │
└──────────────────┬──────────────────────────────────────┘
                   │
                   ↓
┌─────────────────────────────────────────────────────────┐
│         3. BITACORA::REGISTRAR() SE EJECUTA             │
│         (AUTOMÁTICAMENTE, sin intervención del usuario) │
└──────────────────┬──────────────────────────────────────┘
                   │
                   ↓
┌─────────────────────────────────────────────────────────┐
│         4. MODELO BITACORA CAPTURA DATOS                │
│         (IP, User-Agent, Timestamp, Usuario, Contexto) │
└──────────────────┬──────────────────────────────────────┘
                   │
                   ↓
┌─────────────────────────────────────────────────────────┐
│         5. DATOS GUARDADOS EN TABLA BITACORA            │
│         (PostgreSQL con índices de performance)         │
└──────────────────┬──────────────────────────────────────┘
                   │
                   ↓
┌─────────────────────────────────────────────────────────┐
│         6. ADMINISTRADOR ACCEDE A /BITACORA             │
│         (Ve todos los registros automáticos)            │
└────────────────────────────────────────────────────────┘
```

---

## ✨ CONCLUSIÓN

**CU18 ES 100% AUTOMÁTICO**

✅ El usuario NO necesita hacer nada para registrar acciones
✅ Todas las acciones se capturan automáticamente
✅ El administrador solo necesita acceder a `/bitacora` para verlas
✅ Los filtros permiten buscar por usuario, módulo, acción, fecha
✅ Puede exportar a CSV para análisis

**LISTO PARA USAR** 🚀

---

**Fecha:** 11 de Noviembre de 2025
**CU18:** Registro Automático de Bitácora
**Versión:** 1.0.0
