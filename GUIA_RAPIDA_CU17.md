# 🚀 GUÍA RÁPIDA: CU17 - GENERAR REPORTES

## 📍 ¿Dónde está?

**URL**: `http://localhost:8000/monitoreo`

```
Dashboard Principal
    ↓
[MONITOREO Y REPORTES]
    ├─ [📊 CU16 - Dashboard]
    └─ [📄 CU17 - Generar Reportes] ← TÚ ESTÁS AQUÍ
```

---

## 🎯 ¿Qué hace?

Genera reportes en **PDF** y **Excel** de:
- 📊 Asignaciones de docentes
- ✅ Asistencia diaria
- ⚠️ Inasistencias justificadas
- 🏢 Uso de aulas

---

## 👤 ¿Quién puede usarlo?

✅ **Administrador**  
✅ **Coordinador Académico**  
❌ Docente (sin acceso)  
❌ Estudiante (sin acceso)

---

## 📋 Pasos para Usar

### Paso 1: Acceder
```
1. Ve a http://localhost:8000/monitoreo
2. Haz clic en la pestaña "CU17 - Generar Reportes"
```

### Paso 2: Seleccionar Tipo de Reporte
```
Elige uno de:
- Asignaciones de Carga Horaria
- Asistencia Docente
- Inasistencias y Justificaciones
- Ocupación de Aulas
```

### Paso 3: Aplicar Filtros (Opcional)
```
Puedes filtrar por:
- Período académico
- Docente específico
- Grupo específico
- Estado
- Rango de fechas
```

### Paso 4: Seleccionar Formato
```
☑ PDF  (para imprimir/compartir)
☑ Excel (para análisis en hoja de cálculo)
```

### Paso 5: Generar Reporte
```
Opción A: Previsualizar
  → Click en [👁️ Previsualizar]
  → Ver datos en tabla
  → Click en [🔗 Compartir Reporte]

Opción B: Descargar Directo
  → Click en [📥 Descargar PDF]  o  [📥 Descargar Excel]
  → El archivo se descarga automáticamente
```

---

## 📝 Ejemplo Práctico

### Scenario: Obtener reportes de docentes por período

```
1. Accede a /monitoreo → CU17
2. Tipo de Reporte: "Asignaciones de Carga Horaria"
3. Filtros:
   - Período: 2024-1
   - Docente: Juan García
4. Formato: ☑ PDF ☐ Excel
5. Click: [👁️ Previsualizar]
6. Ver tabla con asignaciones
7. Click: [📥 Descargar PDF]
8. ✅ Archivo descargado: reporte_asignaciones_2025-11-13.pdf
```

---

## 📊 Tipos de Reportes Disponibles

### 1. **Asignaciones de Carga Horaria**
```
Columnas: ID | Docente | Materia | Grupo | Aula | Estado
Ideal para: Planificación, auditoría de asignaciones
```

### 2. **Asistencia Docente**
```
Columnas: Docente | Fecha | Estado | Hora Entrada | Observaciones
Ideal para: Control de asistencia, reportes mensuales
```

### 3. **Inasistencias y Justificaciones**
```
Columnas: Docente | Fecha | Motivo | Estado | Tipo
Ideal para: Seguimiento de justificativos, resoluciones
```

### 4. **Ocupación de Aulas**
```
Columnas: Aula | Capacidad | Ocupación | Porcentaje
Ideal para: Análisis de infraestructura, eficiencia
```

---

## 💾 Formatos

### PDF
- 📄 **Ventajas**: Fácil de imprimir, compartir, preserva formato
- ⬇️ **Descarga**: Automática como `reporte_[tipo]_[fecha].pdf`
- 📨 **Compartir**: Puedes enviar por email directamente

### Excel
- 📊 **Ventajas**: Editable, análisis de datos, gráficos
- ⬇️ **Descarga**: Automática como `reporte_[tipo]_[fecha].xlsx`
- 🔄 **Uso**: Procesar datos, crear pivots, gráficos adicionales

---

## ✨ Características Útiles

### 🔗 Compartir Reporte
```
1. Click [👁️ Previsualizar]
2. Click [🔗 Compartir Reporte]
3. Se genera un enlace
4. Se copia automáticamente al portapapeles
5. ✅ Puedes compartir el enlace
```

### 📋 Previsualizar Datos
```
1. Antes de descargar, puedes ver los datos
2. Tabla interactiva y clara
3. Valida que sea lo que necesitas
4. Luego descargas con confianza
```

### 🔒 Seguridad
```
✅ Solo usuarios autorizados (Admin, Coordinador)
✅ Cada descarga se registra en la bitácora
✅ Trazabilidad completa de acciones
✅ Datos filtrados según rol y permisos
```

---

## ⚠️ Validaciones Importantes

```
❌ Error: "Selecciona al menos un formato"
   → Solución: Marca al menos PDF o Excel

❌ Error: "Rango de fechas inválido"
   → Solución: Asegúrate que "Desde" < "Hasta"

❌ Error: "No hay datos disponibles"
   → Solución: Revisa los filtros aplicados, 
              puede que no haya datos para esos criterios

❌ Error: "No tienes permiso"
   → Solución: Solo Admin y Coordinador Académico 
              pueden acceder a CU17
```

---

## 📝 Formato de Archivo Descargado

**Nombre del archivo:**
```
reporte_[TIPO]_[FECHA].pdf
reporte_[TIPO]_[FECHA].xlsx

Ejemplos:
- reporte_asignaciones_2025-11-13.pdf
- reporte_asistencia_2025-11-13.xlsx
- reporte_inasistencias_2025-11-13.pdf
- reporte_ocupacion_aulas_2025-11-13.xlsx
```

**Fecha**: Se usa la fecha del sistema en que se descarga

---

## 🔍 Registro en Bitácora

Cada descarga queda registrada automáticamente:

```
Acción: Descargar reporte [TIPO] en [FORMATO]
Módulo: Reportes
Fecha: [Automática]
Usuario: [Tu usuario]
Detalles: Filtros aplicados, formato, tipo
```

Puedes ver el historial en **CU18 - Bitácora**

---

## 💡 Tips & Tricks

1. **Usar filtros**: Hará que los reportes sean más específicos y rápidos
2. **Previsualizar primero**: Siempre revisa antes de descargar
3. **Excel para análisis**: Si necesitas hacer cálculos posteriores
4. **PDF para compartir**: Si necesitas enviar por email o imprimir
5. **Fecha específica**: Si necesitas un rango, completa ambas fechas

---

## 🐛 Troubleshooting

| Problema | Solución |
|----------|----------|
| La página no carga | Recarga el navegador (F5) |
| No veo datos | Revisa los filtros, puede no haber datos |
| Botones deshabilitados | Selecciona un formato (PDF/Excel) |
| Descarga no inicia | Revisa configuración de descargas del navegador |
| Error 404 | Asegúrate que los endpoints en backend están implementados |

---

## 📞 Necesito Ayuda

**Documentación Completa**: Ver `CU17_GENERAR_REPORTES.md`  
**Visualización de UI**: Ver `CU17_VISUALIZACION_UI.md`  
**Cambios Técnicos**: Ver `CAMBIOS_CU17.md`

---

## 🎯 Resumido en 3 pasos

```
┌────────────────────────────────────┐
│ 1. Accede a /monitoreo → CU17      │
├────────────────────────────────────┤
│ 2. Selecciona tipo + filtros       │
├────────────────────────────────────┤
│ 3. Elige formato y descarga        │
└────────────────────────────────────┘
         ↓ ✅ ¡Listo!
```

---

**🚀 ¡Ya puedes generar reportes!**
