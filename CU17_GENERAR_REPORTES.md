# CU17 - Generar Reportes (PDF/Excel)

## Descripción
El caso de uso CU17 permite a los coordinadores académicos y administradores generar reportes operacionales/gerenciales en formato PDF y Excel con información sobre:
- **Asignaciones de Carga Horaria**: Detalle de docentes, materias, grupos y aulas asignados
- **Asistencia Docente**: Registro de asistencias diarias y estados
- **Inasistencias y Justificaciones**: Justificativos presentados y estado de resolución
- **Ocupación de Aulas**: Análisis de utilización y disponibilidad de infraestructura

## Ubicación en el Sistema

### 📦 Paquete: **P5 - Monitoreo y Reportes**

### Ruta de Acceso
- **URL**: `/monitoreo` → Seleccionar pestaña **"CU17 - Generar Reportes (PDF/Excel)"**
- **Componente**: `GenerarReportes`
- **Ubicación en código**: 
  - Componente: `/resources/js/pages/monitoreo/GenerarReportes.jsx`
  - Estilos: `/resources/js/pages/monitoreo/GenerarReportes.css`

### 👥 Roles Autorizados
- ✅ **Administrador**
- ✅ **Coordinador Académico**

## Características Principales

### 1. Selección de Tipo de Reporte
El usuario puede elegir entre los siguientes tipos:
- 📊 Asignaciones de Carga Horaria
- ✅ Asistencia Docente
- ⚠️ Inasistencias y Justificaciones
- 🏢 Ocupación de Aulas

### 2. Filtros Disponibles
Para cada reporte es posible aplicar filtros:
- **Período Académico**: Seleccionar período específico
- **Docente**: Filtrar por docente
- **Grupo**: Filtrar por grupo
- **Estado**: Filtrar por estado (Activo, Inactivo, Pendiente)
- **Rango de Fechas**: Especificar desde/hasta

### 3. Formatos de Salida
- 📄 **PDF**: Reporte formateado en PDF descargable
- 📊 **Excel**: Reporte en formato Excel descargable

### 4. Funcionalidades
- 👁️ **Previsualización**: Ver datos antes de descargar
- 📥 **Descarga**: Descargar en formato seleccionado
- 🔗 **Compartir**: Compartir enlace del reporte
- 📝 **Registro en Bitácora**: Cada descarga se registra automáticamente

## Flujo Principal

```
1. Usuario accede a /monitoreo
2. Selecciona pestaña "CU17 - Generar Reportes"
3. Selecciona tipo de reporte
4. (Opcional) Aplica filtros
5. Selecciona formato(s): PDF y/o Excel
6. (Opcional) Hace clic en "Previsualizar" para ver datos
7. Hace clic en "Descargar PDF" o "Descargar Excel"
8. El sistema genera y descarga el archivo
9. Se registra la acción en la bitácora
```

## Integración con el Sistema

### Componente Principal: Monitoreo.jsx

El componente `Monitoreo.jsx` gestiona:
- Navegación entre CU16 (Dashboard) y **CU17 (Reportes)**
- Visualización condicional según rol del usuario
- Información descriptiva de cada componente

### Archivo: `/resources/js/pages/monitoreo/Monitoreo.jsx`

```jsx
const componentes = [
  {
    id: 'dashboard',
    name: 'CU16 - Visualizar Dashboard',
    description: 'Indicadores de planificación, asistencia y conflictos',
    icon: '📊',
    component: Dashboard,
    roles: ['Administrador', 'Coordinador Académico']
  },
  {
    id: 'reportes',  // ← CU17 agregado
    name: 'CU17 - Generar Reportes (PDF/Excel)',
    description: 'Obtener reportes operacionales/gerenciales',
    icon: '📄',
    component: GenerarReportes,
    roles: ['Administrador', 'Coordinador Académico']
  }
];
```

## Archivos Creados/Modificados

### ✅ Nuevos Archivos
1. **`/resources/js/pages/monitoreo/GenerarReportes.jsx`**
   - Componente React principal
   - Gestiona lógica de generación de reportes
   - Interfaz de selección de filtros y formatos

2. **`/resources/js/pages/monitoreo/GenerarReportes.css`**
   - Estilos del componente
   - Responsive para móviles y desktop
   - Gradientes y animaciones

### 📝 Modificados
1. **`/resources/js/pages/monitoreo/Monitoreo.jsx`**
   - Agregado importación de `GenerarReportes`
   - Agregada configuración de CU17 en el arreglo `componentes`

## Endpoints API Requeridos

El componente espera los siguientes endpoints en el backend:

```
POST   /api/reportes/generar
       - Generar reporte (con previsualización)
       - Parámetros: tipo_reporte, formato, filtros

POST   /api/reportes/compartir
       - Generar enlace compartible

GET    /api/periodos-academicos
       - Obtener lista de períodos

GET    /api/docentes
       - Obtener lista de docentes

GET    /api/grupos
       - Obtener lista de grupos

POST   /api/bitacora/registrar
       - Registrar descarga en bitácora
```

## Estructura de Datos Esperados

### Respuesta de Periodos
```json
[
  "2024-1",
  "2024-2",
  "2025-1"
]
```

### Respuesta de Docentes
```json
[
  {
    "codigo_doc": "DOC001",
    "nombre_completo": "Juan García",
    "usuario": {
      "persona": {
        "nombre": "Juan",
        "apellido_paterno": "García"
      }
    }
  }
]
```

### Respuesta de Reporte
```json
{
  "success": true,
  "data": [
    {
      "id_asignacion": 1,
      "docente": "Juan García",
      "materia": "Matemáticas",
      "grupo": "GRP-101",
      "aula": "101",
      "estado": "ACTIVO"
    }
  ]
}
```

## Estilos y Temas

### Colores Principales
- 🟠 **Naranja**: #f97316 (primario)
- 🔴 **Rojo**: #dc2626 (secundario)
- ✅ **Verde**: #10b981 (éxito)
- ❌ **Rojo**: #ef4444 (error)
- 🟡 **Amarillo**: #eab308 (advertencia)

### Componentes UI
- Formularios con estilos modernos
- Tablas con hover effects
- Botones con gradientes
- Alertas de éxito/error
- Modales para previsualización (futura mejora)

## Responsividad

El componente es totalmente responsive:
- **Desktop** (>768px): Grid de múltiples columnas
- **Tablet** (768px): Grid adaptativo
- **Mobile** (<768px): Una sola columna, botones full-width

## Mejoras Futuras

1. 📈 Gráficos en los reportes
2. 🔔 Notificaciones por email
3. 📅 Programación de reportes automáticos
4. 🎨 Temas personalizables
5. 💾 Caché de reportes generados
6. 🔐 Control de acceso más granular
7. 📊 Más tipos de reportes (eficiencia, rendimiento)

## Testing

### Casos de Prueba

1. **Generar reporte sin filtros**
   - Seleccionar tipo de reporte
   - Descargar en PDF/Excel
   - Verificar descarga

2. **Generar reporte con filtros**
   - Aplicar filtros (período, docente, estado)
   - Previsualizar datos
   - Descargar

3. **Control de acceso**
   - Docente no debe ver opción CU17
   - Solo Admin y Coordinador ven CU17

4. **Validaciones**
   - Debe seleccionar al menos un formato
   - Fechas válidas (desde <= hasta)
   - Manejo de errores en descarga

## Documentación de Usuario

### Para Coordinadores Académicos

**¿Cómo generar un reporte de asignaciones?**
1. Accede a Monitoreo y Reportes → Generar Reportes
2. Selecciona "Asignaciones de Carga Horaria"
3. (Opcional) Filtra por período académico
4. Elige PDF o Excel
5. Haz clic en "Descargar"

**¿Puedo compartir un reporte?**
Sí, después de previsualizar:
1. Haz clic en "Previsualizar"
2. Luego en "Compartir Reporte"
3. Se generará un enlace copiable

## Notas Técnicas

- El componente usa **React Hooks** (useState, useEffect)
- API calls con **axios** (instancia configurada)
- CSS modular con clases BEM
- Manejo de errores con try/catch
- Estados de carga (cargando, éxito, error)

---

**Versión**: 1.0  
**Última actualización**: 13 de noviembre de 2025  
**Estado**: ✅ Completado e integrado
