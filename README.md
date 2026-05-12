LOCAL_GUIA_DEFINITIVA_TESTS_PLAYWRIGHT_DARWIN.md

# Guía Definitiva para Crear Tests E2E en Darwin (Playwright)

## 1) Objetivo
Crear tests **quirúrgicos, estables, legibles y mantenibles**, respetando el framework (fixtures + Page Objects), minimizando flakiness y dejando un historial Git limpio para revisión.

---

## 2) Principios rectores
1. **Cambiar solo lo necesario**.
2. **Aislar por feature**: la lógica específica vive en su POM/área.
3. **No romper código compartido** para resolver casos puntuales.
4. **Reutilizar patrones existentes** del repo (fixtures, naming, estructura).
5. **Tests deterministas**: independientes del orden de ejecución.
6. **Cada cambio debe ser auditable y reversible**.

---

## 3) Flujo recomendado de implementación
1. **Entender el caso de negocio**
   - Qué se valida.
   - Datos de entrada.
   - Resultado observable final.
2. **Definir escenarios mínimos**
   - Caso feliz.
   - Variantes relevantes.
   - Limpieza/rollback.
3. **Revisar reutilización existente**
   - Buscar métodos `open*`, `set*`, `check*`, `verify*`.
   - Si no existe, crear método reusable en Page Object.
4. **Validar selectores reales en runtime** (DOM/traza) antes de codificar.
5. **Implementar con `test.step()`**
   - 1 intención por step.
   - Test describe comportamiento, no selectores.
6. **Agregar metadata de trazabilidad**
   - `test_key` (Xray/Jira).
   - Bug conocido (`bug: DWB-xxxx`) cuando aplique.
7. **Validar estabilidad**
   - Ejecutar test aislado.
   - Ejecutar suite relacionada.
   - Repetir corridas para detectar intermitencia.
8. **Auditar diff final**
   - Pequeño, coherente y sin cambios colaterales.

---

## 4) Estrategia de selectores (prioridad)
1. `getByTestId`
2. `getByRole`
3. `getByText({ exact: true })` si no hay mejor opción
4. CSS como último recurso, siempre con scope local

Reglas clave:
- Evitar selectores globales ambiguos.
- Si hay elementos repetidos, hacer scope por fila/componente (`row.locator(...).nth(...)`).
- Usar el trigger real verificado en runtime (ejemplo aprendido: `.color-group` fue más fiable que `.color`).

---

## 5) Page Object Pattern (obligatorio)
- Métodos de alto nivel claros: `open...`, `add...`, `remove...`, `check...`, `verify...`.
- Encapsular detalles frágiles en métodos privados.
- No duplicar selectores complejos en el spec.
- No introducir código muerto.
- Respetar APIs correctas de Playwright (`Locator` vs selector string).

---

## 6) Assertions estables y esperas
Preferir assertions con auto-retry:
- `expect(locator).toHaveText(...)`
- `expect(locator).toContainText(...)`
- `expect(locator).toHaveCSS(...)`

Reglas:
- Evitar `waitForTimeout` salvo último recurso justificado.
- Esperar por condición real (visible, attached/detached, contenido).
- En inputs/chips con re-render, validar estado visible en contenedor/fila, no suposiciones frágiles del input.

---

## 7) Manejo de estado, datos y limpieza
- Limpiar estado previo (reglas/configs duplicadas) antes de crear nuevo dato.
- Si hay dependencias de eventos/mensajería (RabbitMQ), asegurar teardown (ej. reject) siempre.
- No depender de ejecuciones previas.
- Datos de prueba claros y trazables.

---

## 8) Anti-flake (práctico)
- Verificar estado de UI antes de interactuar.
- Usar `scrollIntoViewIfNeeded()` cuando el control pueda quedar oculto.
- `force: true` solo como fallback controlado.
- Cerrar overlays/popups que puedan interferir (por ejemplo, `Escape`).
- Evitar recalcular locators dinámicos repetidamente; guardar referencias reutilizadas.

---

## 9) Qué NO hacer
- No tocar componentes compartidos para arreglar una feature puntual.
- No mezclar refactors amplios con un test nuevo.
- No hardcodear waits largos sin causa real.
- No duplicar validaciones innecesarias entre tests.
- No dejar comentarios temporales/fixme olvidados.
- No commitear sin lint/errores en verde.
- No usar `git push --force` sin protección (preferir `--force-with-lease`).

---

## 10) Convenciones de estilo
- Seguir estilo del repo (imports, formato, estructura de `test.step`).
- Reutilizar fixtures/utilidades existentes.
- Constantes de valores específicos con `as const` cuando aplique.
- Usar `softExpect` solo en verificaciones no críticas del flujo principal.

---

## 11) Debug rápido de intermitencia
1. Ejecutar con reporter detallado/traza.
2. Ejecutar sin retries para ver fallo real.
3. Detectar si el problema es sincronización UI.
4. Revisar dependencia de estado previo.
5. Cambiar espera por condición real (no tiempo fijo).
6. Re-ejecutar múltiples veces para confirmar estabilidad.

---

## 12) Workflow Git recomendado
1. `fetch` de `origin/main`.
2. Rebase/limpieza de historial local.
3. Commits coherentes, pequeños y autoexplicativos.
4. Validar tests y lint antes de push.
5. Push seguro: `--force-with-lease` solo si hubo reescritura.
6. PR clara: alcance, riesgos y evidencia de ejecución.

---

## 13) Checklist “listo para PR/merge”
- [ ] Test pasa repetidamente (no solo una vez).
- [ ] Sin cambios en componentes compartidos sin justificación fuerte.
- [ ] Selectores correctos y con scope local.
- [ ] Limpieza previa/posterior de datos y eventos.
- [ ] Assertions con auto-retry; sin sleeps arbitrarios.
- [ ] Métodos reutilizables en Page Objects.
- [ ] Metadata de test/bug incluida.
- [ ] Lint/format/errores en verde.
- [ ] Diff pequeño, limpio y dentro de alcance.
- [ ] Sin código muerto ni comentarios temporales.

---

## 14) Plantilla operativa rápida (para cada test)
1. Abrir pantalla/settings.
2. Limpiar estado previo.
3. Crear regla/configuración.
4. Guardar.
5. Disparar evento/acción de negocio.
6. Esperar condición objetivo.
7. Validar estado final con `toHave...`.
8. Teardown completo.

---

## 15) Prompt breve para futuros chats
> Estoy trabajando en tests Playwright dentro de un framework con fixtures y Page Objects.
> Quiero una solución senior: sin duplicación, sin waits fijos innecesarios, con métodos `check*/verify*` en Page Objects, tests estables y commit limpio para PR.
> Necesito: implementación + validación + auditoría final + estrategia Git segura.

---

## 16) Regla de oro
Si una solución arregla un test pero afecta lógica compartida, **no es quirúrgica**.
La solución correcta es la que **aísla, estabiliza y minimiza impacto**.
