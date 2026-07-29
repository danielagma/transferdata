**Summary:**
[Bug] Market Depth: "Price:*" order entry field does not support 32nds format, reverts to decimal translation

**Environment:**
* DEV2

**Linked to Story:** DWU-344

**Severity:** High (Blocks AC5 & AC6)

**Description:**

**Overview:**
As per AC5 and AC6 of DWU-344, all price fields within the Market Depth widget, specifically including the "order entry prices", must display in the 32nds fractional format if the bond is configured this way in Referential Data. Currently, the manual `Price:*` input field fails to inherit this format, translating the fractional value into a decimal format when a price is selected from the grid. Additionally, the field does not accept manual input in the 32nds format.

**Steps to Reproduce:**
1. Navigate to the **Order Management** screen.
2. Open a **Market Depth** widget for a bond configured with the 32nds Pricing Format (e.g., `PGB 3.000 06/35`).
3. Verify that the BID/ASK grid correctly displays prices in fractions (e.g., `97-01 1/2`).
4. Click on any of these fractional price levels in the grid to auto-populate the order entry section at the bottom.
5. Observe the value populated in the **`Price:*`** input field.

**Expected Result:**
The `Price:*` input field must display the exact 32nds format selected from the grid (e.g., `97-01 1/2`), and it must allow the user to manually type and edit prices using this specific fractional format.

**Actual Result:**
The `Price:*` input field converts the fractional price into its decimal equivalent (e.g., clicking `97-01 1/2` populates the field with `97.05`). The field also rejects manual typing of fractions.

**Evidence:**
Please see attached screenshot: `image_e089f8.jpg` (Note the discrepancy between the selected grid level and the Price field below).
