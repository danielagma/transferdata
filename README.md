QA Testing: IN PROGRESS
Environment: DEV2
ISIN Used: ES0000012000 (SPGB 2.700 01/30)

Results:

The new mandatory parameter 'Price Format:*' has been successfully integrated into the 'Classifications' section of the Bond Referential form.

UI spatial mapping is correct, positioned exactly underneath the 'Quote Group' dropdown field.

Initial state validation confirmed that the field automatically defaults to 'Decimal' upon loading existing instruments, successfully preventing unpopulated or null fields by design.

Baseline Search & Initial Field Load:
(Aquí colocas tu primera imagen: image_394f40.png)

Field Positioning & Default Value Validation:
(Aquí colocas tu segunda imagen: image_395340.png - Te sugiero agregarle un recuadro azul o verde alrededor del nuevo campo 'Price Format: Decimal')*

Dropdown Options Verification (Enforcement of UI Constraints):
(Aquí colocas tu tercera imagen: image_3955e7.png - Donde se ve tu flecha azul apuntando a la lista desplegable)

The dropdown list exclusively exposes 'Decimal' and '32nds' as selectable options. The interface structurally bars the user from clearing the field or leaving it blank, fulfilling the mandatory constraint requirement via input restriction.
