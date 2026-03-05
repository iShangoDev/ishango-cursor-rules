# CursorDev — Prompts correctos

Prompts para usar con el orquestador y respetar .cursor. Referencia para usuario y agente.

---

## Iniciar pedido (módulo nuevo)

**Usuario:** `@ishango-orquestador quiero crear el módulo [nombre]`  
Ejemplo: `@ishango-orquestador quiero crear el módulo cobranza`

**Agente:** Entra en **Fase 1**. Recorre el cuestionario 9 dimensiones (inferir con Delegar cuando sea claro) y abre discusión hasta tener: patrón datos, comportamiento, API Motor, BFF, rutas ERP, modelo Devias y ruta de extensión, permisos, doc de referencia. No pasar a implementar hasta cerrar Fase 1.

---

## Cerrar Fase 1 y pasar a Fase 2

**Agente (al tener todo):** "Fase 1 cerrada. Resumen: [listar outputs por dimensión]. Paso a Fase 2 — desarrollo e implementación."

**Usuario (opcional):** "Dale" / "Implementá" / o corregir algo antes de Fase 2.

---

## Iniciar Fase 2 (implementación)

**Agente:** Implementar en este orden:

1. Generar/actualizar `modules/{modulo}.mdc` en ishango-cursor-rules con la plantilla y sección "Pendiente por repo".
2. Código Motor si aplica (tablas, router, repository, service).
3. Código ERP: extender desde el modelo Devias elegido (erp-devia-models), page, BFF, components, types según erp-root.
4. Push solo según workflow.mdc (no inventar comandos).

---

## Cambio en módulo existente (sin fases)

**Usuario:** "Necesito [descripción del cambio] en [módulo]."

**Agente:** Abrir `modules/{modulo}.mdc` y erp-root (o root Motor); implementar el cambio; push según workflow.mdc.

---

## Respetar .cursor (recordatorio)

**Uniline:** "Respetá .cursor: workflow.mdc para push/deploy; fuente-de-verdad.mdc para autoridad; módulo en modules/*.mdc. No inventes pasos; no edites .cursor en ERP/Motor (solo en ishango-cursor-rules + sync)."
