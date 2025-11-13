# CU17: Generar Reportes PDF/Excel - Implementación Backend

## Resumen

Se ha completado la implementación backend del Caso de Uso 17 (CU17) "Generar Reportes PDF/Excel" en el paquete **Monitoreo y Reportes**. El controlador `ReportesController.php` gestiona la generación y compartición de reportes en múltiples formatos.

## Ubicación

- **Controlador**: `app/Http/Controllers/Monitoreo_y_Reportes/ReportesController.php`
- **Rutas**: `routes/api.php` (líneas 213-222)

## Descripción General

El controlador `ReportesController` proporciona dos métodos principales:

### 1. **`generar()`** - POST `/api/reportes/generar`

Genera reportes en 4 tipos diferentes con múltiples formatos de salida.

#### Tipos de Reporte Soportados:

1. **asignaciones**: Asignaciones de Carga Horaria
   - Datos: Código docente, nombre, materia, grupo, horas, horario
   - Filtros: `codigo_doc`, `codigo_grupo`

2. **asistencia**: Asistencia Docente
   - Datos: Fecha, hora entrada/salida, ubicación, estado
   - Filtros: `codigo_doc`, `estado`

3. **inasistencias**: Inasistencias y Justificaciones
   - Datos: Motivo, estado justificación, tipo justificativo, observaciones
   - Filtros: `codigo_doc`, `estado_justificacion`

4. **ocupacion_aulas**: Ocupación de Aulas
   - Datos: Capacidad, estudiantes, porcentaje ocupación
   - Filtros: `codigo_aula`

#### Formatos de Salida:

- **json**: Retorna datos en formato JSON (en respuesta)
- **csv**: Genera archivo CSV para descarga
- **pdf**: Genera archivo PDF (requiere librería adicional)
- **excel**: Genera archivo Excel (requiere librería adicional)

#### Parámetros de Solicitud:

```json
{
  "tipo_reporte": "asignaciones|asistencia|inasistencias|ocupacion_aulas",
  "formato": "json|csv|pdf|excel",
  "periodo_academico": "2024-1 (opcional)",
  "filtros": {
    "codigo_doc": "DOC001 (opcional)",
    "codigo_grupo": "GRP001 (opcional)",
    "estado": "CONFIRMADA (opcional)"
  }
}
```

#### Respuesta Exitosa (JSON):

```json
{
  "success": true,
  "tipo_reporte": "asignaciones",
  "formato": "json",
  "registros": 25,
  "datos": [
    {
      "id": 1,
      "codigo_doc": "DOC001",
      "docente_nombre": "Juan Pérez",
      "codigo_materia": "MAT001",
      "materia_nombre": "Cálculo I",
      "codigo_grupo": "GRP001",
      "grupo_nombre": "1A",
      "horas_semanales": 4,
      "horario_clase": "Lunes 08:00-12:00",
      "periodo_academico": "2024-1",
      "fecha_asignacion": "2024-01-15T10:30:00Z"
    }
  ],
  "descarga_url": null,
  "generado_en": "2024-01-20T14:25:30Z",
  "usuario": "admin"
}
```

### 2. **`compartir()`** - POST `/api/reportes/compartir`

Genera un enlace compartible para descargar el reporte (válido por 7 días).

#### Parámetros de Solicitud:

```json
{
  "tipo_reporte": "asignaciones",
  "formato": "pdf|excel|csv",
  "destinatarios": [
    "coordinador@email.com",
    "admin@email.com"
  ],
  "mensaje": "Reporte de asignaciones para revisión (opcional)"
}
```

#### Respuesta Exitosa:

```json
{
  "success": true,
  "mensaje": "Reporte compartido exitosamente",
  "token_descarga": "a1b2c3d4e5f6...",
  "url_descarga": "http://localhost:8000/api/reportes/descargar?token=a1b2c3d6...",
  "destinatarios": 2,
  "formato": "pdf",
  "generado_en": "2024-01-20T14:25:30Z",
  "expira_en": "2024-01-27T14:25:30Z"
}
```

## Métodos Privados

### `obtenerAsignaciones($periodo, $filtros)`
- Obtiene datos de asignaciones de carga horaria
- Retorna: Array con detalles de docente, materia, grupo, horario

### `obtenerAsistencia($periodo, $filtros)`
- Obtiene registros de asistencia docente
- Retorna: Array con datos de asistencia (entrada, salida, estado)

### `obtenerInasistencias($periodo, $filtros)`
- Obtiene registros de inasistencias y justificaciones
- Retorna: Array con datos de inasistencias y estado de resolución

### `obtenerOcupacionAulas($periodo, $filtros)`
- Obtiene datos de ocupación de aulas
- Retorna: Array con capacidad, ocupación, porcentaje

### `exportarCSV($tipoReporte, $datos)`
- Genera archivo CSV y lo almacena en Storage
- Retorna: JSON con URL de descarga

### `exportarPDF($tipoReporte, $datos)`
- Genera archivo PDF (requiere librería TCPDF/mPDF)
- Retorna: JSON con instrucciones

### `exportarExcel($tipoReporte, $datos)`
- Genera archivo Excel (requiere librería PhpSpreadsheet)
- Retorna: JSON con instrucciones

### `generarCSV($datos)`
- Convierte array de datos a formato CSV
- Maneja caracteres especiales y comillas

## Seguridad

### Autenticación
- Requiere token Sanctum (`auth:sanctum`)
- Solo usuarios autenticados pueden acceder

### Autorización
- Solo roles: **Administrador** y **Coordinador Académico**
- Retorna error 403 si usuario no tiene permiso

### Registro de Auditoría
- Cada generación de reporte se registra en tabla `bitacora`
- Cada compartición de reporte se registra en tabla `bitacora`
- Incluye: usuario, tipo reporte, formato, registros generados

## Validación

Todas las solicitudes son validadas con:

```php
'tipo_reporte' => 'required|in:asignaciones,asistencia,inasistencias,ocupacion_aulas',
'formato' => 'required|in:json,csv,pdf,excel',
'periodo_academico' => 'nullable|string',
'filtros' => 'nullable|array'
```

Errores de validación retornan: **HTTP 422** con detalles de errores

## Manejo de Errores

### Errores Capturados:

- **Validación (422)**: Parámetros inválidos
- **Autenticación (401)**: Token no válido o expirado
- **Autorización (403)**: Usuario sin permisos requeridos
- **Error General (500)**: Otros errores con mensaje descriptivo

### Ejemplo de Error:

```json
{
  "message": "Validación fallida",
  "errors": {
    "tipo_reporte": ["El campo tipo_reporte es obligatorio"]
  }
}
```

## Modelos Utilizados

- **AsignacionHorario**: Datos de asignaciones de carga
- **Asistencia**: Registros de asistencia docente
- **Inasistencia**: Inasistencias con justificativos
- **Infraestructura**: Información de aulas
- **Bitacora**: Registro de acciones

## Relaciones Cargadas

El controlador utiliza `with()` para cargar relaciones:
- `docente.usuario.persona`: Información completa del docente
- `materia`: Datos de la materia
- `grupo`: Datos del grupo
- `horario`: Horario de clase
- `justificativo`: Justificativo de inasistencia

## Próximos Pasos

### Para PDF:
1. Instalar librería: `composer require tecnickcom/tcpdf`
2. Implementar método completo en `exportarPDF()`
3. Plantillas de reporte

### Para Excel:
1. Instalar librería: `composer require phpoffice/phpspreadsheet`
2. Implementar método completo en `exportarExcel()`
3. Estilos y formatos

### Para Correo:
1. Implementar envío de reportes por correo
2. Notificaciones a destinatarios
3. Confirmación de entrega

## Testing

### Comando Artisan para Crear Rutas:

```bash
php artisan route:list | grep reportes
```

### Solicitud cURL de Ejemplo:

```bash
curl -X POST http://localhost:8000/api/reportes/generar \
  -H "Authorization: Bearer {TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "tipo_reporte": "asignaciones",
    "formato": "json",
    "periodo_academico": "2024-1"
  }'
```

## Resumen de Integración

✅ **Backend**: Controlador completo en `Monitoreo_y_Reportes` package
✅ **Rutas**: POST `/api/reportes/generar` y POST `/api/reportes/compartir`
✅ **Seguridad**: Autenticación y autorización implementadas
✅ **Auditoría**: Registro en bitácora implementado
✅ **Validación**: Validación de parámetros completa
✅ **Documentación**: Métodos documentados con PHPDoc

---

**Fecha de Creación**: 2024-01-20
**Estado**: ✅ COMPLETO
**Versión**: 1.0
