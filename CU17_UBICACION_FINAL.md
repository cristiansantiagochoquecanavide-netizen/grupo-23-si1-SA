# 📍 UBICACIÓN FINAL DE CU17 EN EL SISTEMA

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                     🎓 SISTEMA DE CARGA HORARIA                            ║
╚══════════════════════════════════════════════════════════════════════════════╝

                         ESTRUCTURA DEL SISTEMA
                         ═══════════════════════

                      ┌─ DASHBOARD PRINCIPAL ─┐
                      │                       │
                      └───────────────────────┘
                              ▲
                    ┌─────────┼─────────┐
                    │         │         │
            [Menú]  │   [P1]  │  [P2]   │  [P3]   [P4]   [P5]   [P6]
                    │         │         │
          ┌─────────▼─────────▼─────────▼──────────────────────────────┐
          │                                                             │
          │  P1: Autenticación       P2: Catálogos      P3: Planificación
          │  P4: Asistencia          P5: Monitoreo      P6: Auditoría
          │
          └─────────┬─────────────────────────────────────────────────┘
                    │
           ┌────────▼────────────────────────────────┐
           │  P5 - MONITOREO Y REPORTES             │
           │  ═══════════════════════════════        │
           │                                        │
           │  ┌─────────────────────────────────┐  │
           │  │ CU16 - Dashboard (📊)           │  │
           │  │ Indicadores y análisis          │  │
           │  └─────────────────────────────────┘  │
           │                                        │
           │  ┌─────────────────────────────────┐  │
           │  │ CU17 - Reportes (📄) ← NUEVO   │  │
           │  │ Generación de PDF/Excel         │  │
           │  └─────────────────────────────────┘  │
           │                                        │
           └────────────────────────────────────────┘


═════════════════════════════════════════════════════════════════════════════════

                    🔍 UBICACIÓN EXACTA DE CU17

                        URL: /monitoreo
                             │
                ┌────────────┼────────────┐
                │            │            │
           [Tab 1]       [Tab 2]     [Contenido]
            CU16          CU17 ◄─────  ┌──────────────┐
           ACTIVO        NUEVO        │              │
                                      │ GenerarReportes
                                      │ - Filtros
                                      │ - Formatos
                                      │ - Descarga
                                      │ - Compartir
                                      │
                                      └──────────────┘


═════════════════════════════════════════════════════════════════════════════════

                     RUTA DE ACCESO EN ARCHIVOS

     /resources/js/pages/monitoreo/
     ├─ Monitoreo.jsx ........................ Contenedor principal
     │  └─ Importa GenerarReportes
     │
     ├─ GenerarReportes.jsx ................. ✨ NUEVO - Componente CU17
     │  └─ Lógica de generación de reportes
     │
     └─ GenerarReportes.css ................. ✨ NUEVO - Estilos
        └─ Diseño responsive


═════════════════════════════════════════════════════════════════════════════════

                    ACCESO DESDE EL NAVEGADOR

        1. Ingresa a: http://localhost:8000/monitoreo

        2. Se carga el componente Monitoreo.jsx con dos pestañas:
           
           ┌────────────────────────────────────┐
           │  [📊 CU16]    [📄 CU17]            │ ◄─ Pestañas
           ├────────────────────────────────────┤
           │                                    │
           │  Contenido según pestaña activa    │
           │                                    │
           │  Por defecto: CU16 (Dashboard)     │
           │  Haz click en: CU17 (Reportes)     │
           │                                    │
           └────────────────────────────────────┘

        3. Al hacer click en CU17, se muestra:
           - Selector de tipo de reporte
           - Campos de filtros
           - Checkboxes de formato
           - Botones de acción


═════════════════════════════════════════════════════════════════════════════════

                    JERARQUÍA DE COMPONENTES

     Dashboard (/)
        │
        └─ Layout
           │
           └─ Routes
              │
              ├─ /usuarios (CU3)
              ├─ /roles (CU4)
              ├─ ... (otros CU)
              │
              └─ /monitoreo ◄──────── CU17 AQUÍ
                 │
                 └─ Monitoreo.jsx
                    ├─ Tab: CU16 (Dashboard)
                    │   └─ Dashboard component
                    │
                    └─ Tab: CU17 (Reportes) ◄─ NUEVO
                        └─ GenerarReportes component
                           ├─ Estados
                           ├─ Métodos
                           ├─ Validaciones
                           └─ Integración API


═════════════════════════════════════════════════════════════════════════════════

                    ESTRUCTURA COMPLETA DE CU17

     GenerarReportes.jsx
     ├─ Estados (9 estados React)
     │  ├─ tipoReporte
     │  ├─ filtros
     │  ├─ formatos
     │  ├─ cargando
     │  ├─ mensaje
     │  ├─ periodos
     │  ├─ docentes
     │  ├─ grupos
     │  └─ datos
     │
     ├─ Efectos (1 useEffect)
     │  └─ cargarDatos()
     │
     ├─ Métodos (5+ funciones)
     │  ├─ handleFiltroChange()
     │  ├─ handleFormatoChange()
     │  ├─ previsualizarReporte()
     │  ├─ generarReporte()
     │  ├─ compartirReporte()
     │  └─ renderizarDatos()
     │
     └─ JSX (Componentes visuales)
        ├─ Header
        ├─ Sección Formulario
        │  ├─ Tipo de reporte
        │  ├─ Filtros
        │  ├─ Formato
        │  └─ Botones
        ├─ Sección Previsualización
        │  ├─ Tabla de datos
        │  └─ Botones de acción
        └─ Info Box


═════════════════════════════════════════════════════════════════════════════════

                    FLUJO DE NAVEGACIÓN

     Usuario autenticado (Admin/Coordinador)
            │
            ▼
     Accede a http://localhost:8000/monitoreo
            │
            ├─ Valida rol ✓
            │
            ├─ Carga Monitoreo.jsx
            │  │
            │  ├─ Muestra 2 pestañas
            │  │  ├─ CU16 (Activo por defecto)
            │  │  └─ CU17 (Disponible)
            │  │
            │  └─ Carga GenerarReportes en fondo
            │
            ▼
     Usuario hace click en [CU17]
            │
            ├─ Actualiza estado activeTab
            │
            ├─ GenerarReportes se hace visible
            │  │
            │  ├─ useEffect ejecuta cargarDatos()
            │  │  └─ API calls: periodos, docentes, grupos
            │  │
            │  └─ Renderiza interfaz
            │     ├─ Formulario de configuración
            │     ├─ Filtros con datos cargados
            │     └─ Botones de acción
            │
            ▼
     Usuario interactúa con CU17
            │
            ├─ Selecciona tipo de reporte
            ├─ Aplica filtros (opcional)
            ├─ Selecciona formato
            ├─ Hace click en [Previsualizar]
            │  └─ Llamada POST /api/reportes/generar
            │     └─ Recibe datos y renderiza tabla
            │
            └─ Hace click en [Descargar]
               └─ Llamada POST /api/reportes/generar
                  └─ Descarga blob (PDF/Excel)
                  └─ Registra en bitácora


═════════════════════════════════════════════════════════════════════════════════

                    RELACIÓN CON OTROS COMPONENTES

     Monitoreo.jsx ─┐
                    ├─ Importa: GenerarReportes
                    ├─ Importa: Dashboard
                    └─ Gestiona: Navegación entre tabs
                       │
                       ├─ Valida rol del usuario
                       ├─ Filtra componentes por rol
                       ├─ Renderiza componente activo
                       └─ Pasa props (si es necesario)

     GenerarReportes.jsx
                    ├─ Llamadas API para datos
                    ├─ Integración con bitácora
                    ├─ Manejo de descargas
                    └─ Renderiza tabla de previsualización


═════════════════════════════════════════════════════════════════════════════════

                    RESUMEN VISUAL FINAL

     ┌──────────────────────────────────────────────────────────┐
     │                                                          │
     │              ✅ CU17 COMPLETAMENTE INTEGRADO            │
     │                                                          │
     │  ├─ Frontend: LISTO PARA USAR  ✓                        │
     │  ├─ Integración: COMPLETADA   ✓                        │
     │  ├─ Documentación: COMPLETA   ✓                        │
     │  └─ Backend: PENDIENTE IMPLEMENTAR ⏳                   │
     │                                                          │
     │             📍 Ubicación: /monitoreo → CU17             │
     │             👥 Acceso: Admin + Coordinador              │
     │             🎯 Estado: LISTO PARA TESTING               │
     │                                                          │
     └──────────────────────────────────────────────────────────┘


═════════════════════════════════════════════════════════════════════════════════
```

## 🎉 ¡LISTO!

El caso de uso **CU17 - Generar Reportes (PDF/Excel)** está completamente integrado 
en el paquete **"Monitoreo y Reportes"** tal como se solicitó.

**Próximo paso**: Implementar los endpoints en el backend para que funcione 
completamente.

---

**Versión**: 1.0  
**Fecha**: 13 de noviembre de 2025  
**Estado**: ✅ COMPLETADO Y LISTO
