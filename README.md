# ishango-cursor-rules

Fuente única del `.cursor/rules/` para el sistema iShango.

## Por qué existe este repo

El sistema iShango tiene dos repos de código (`iShangoERP` y `ishango-motor`). Ambos deben tener el mismo `.cursor/rules/` para que Cursor entienda el sistema completo desde cualquier proyecto. Este repo centraliza el contenido y un script lo distribuye a los dos repos.

**Regla fundamental: nunca editar `.cursor/rules/` directamente en ERP o Motor. Editar siempre aquí y correr el sync.**

## Estructura

```
rules/
├── shared/          ← Archivos idénticos en ERP y Motor
│   ├── ishango-dimensiones.mdc
│   ├── ishango-dimensiones-resumen.mdc
│   ├── ishango-proyectos-contexto.mdc
│   ├── ishango-diccionario.mdc
│   ├── ishango-orquestador.mdc
│   └── modules/     ← Un .mdc por módulo (cubre Motor + ERP en un solo archivo)
│       ├── personas.mdc
│       ├── creditos.mdc
│       ├── usuarios.mdc
│       ├── auth.mdc
│       └── ...
├── erp/             ← Solo va a iShangoERP
│   ├── erp-root.mdc
│   ├── erp-auth.mdc
│   ├── erp-crear-modulo.mdc
│   ├── workflow.mdc
│   └── ...
└── motor/           ← Solo va a ishango-motor
    ├── workflow-motor.mdc  (→ workflow.mdc en Motor)
    ├── root-motor.mdc      (→ root.mdc en Motor)
    ├── entorno-motor.mdc
    └── ...
archive/             ← Archivos obsoletos con historial
```

## Cómo usar el script de sync

```powershell
cd C:\dev\ishango-cursor-rules
.\sync-cursor.ps1
```

El script copia:
- `rules/shared/` → a ERP y a Motor
- `rules/erp/` → solo a ERP
- `rules/motor/` → solo a Motor

**Cuándo correrlo:** cada vez que modificás cualquier archivo en este repo.

## Flujo de trabajo

```
1. Editar archivos en este repo (rules/shared/, rules/erp/, rules/motor/)
2. .\sync-cursor.ps1
3. Verificar en ERP o Motor que los cambios llegaron
4. git add . ; git commit -m "descripción del cambio" ; git push
```

## Rutas esperadas

| Variable | Ruta |
|----------|------|
| ERP | `C:\dev\iShangoERP\.cursor\rules\` |
| Motor | `C:\dev\ishango-motor\.cursor\rules\` |
| Este repo | `C:\dev\ishango-cursor-rules\` |

Si tus rutas son distintas, editar las primeras líneas de `sync-cursor.ps1`.

## Agregar un módulo nuevo

1. Crear `rules/shared/modules/{modulo}.mdc` siguiendo el template de 9 dimensiones
2. Correr `.\sync-cursor.ps1`
3. El `.mdc` queda disponible en ERP y Motor automáticamente

## Módulos actuales

| Módulo | Estado |
|--------|--------|
| `personas` | Fusionado (Motor + ERP) |
| `creditos` | Fusionado (Motor + ERP) |
| `usuarios` | Fusionado (Motor + ERP) |
| `auth` | Fusionado (Motor + ERP) |
| `roles` | ERP (Motor sin .mdc propio) |
| `rbac` | Motor (ERP sin .mdc propio) |
| `etiquetas` | ERP-only con sección Motor pendiente |
| `documentos` | ERP-only con sección Motor pendiente |
| `auditoria` | ERP-only con sección Motor pendiente |
| `calendario` | ERP-only con sección Motor pendiente |
| `notificaciones` | ERP-only con sección Motor pendiente |
| `numeradores` | ERP-only con sección Motor pendiente |
| `perfil` | ERP-only con sección Motor pendiente |
| `configuracion` | ERP-only con sección Motor pendiente |
| `jobs` | ERP-only con sección Motor pendiente |
| `credinter_sync` | Motor-only |

## Referencias

- [MANUAL-CURSOR-ISHANGO.md](C:\dev\vault-trabajo\04_DOCUMENTOS\ISHANGO\ATUM\MANUAL-CURSOR-ISHANGO.md) — cómo operar con Cursor
- [DIMENSIONES-MODULO-RESUMEN.md](C:\dev\vault-trabajo\04_DOCUMENTOS\ISHANGO\ATUM\DIMENSIONES-MODULO-RESUMEN.md) — diseño del sistema
