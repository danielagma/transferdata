**Summary:**
[Bug] Fast Size Buttons: Missing 'Max Order Size' validation allows astronomical numbers, breaking Escalator UI

**Environment:**
* DEV2

**Linked to Story:** DWU-260

**Severity:** High (Blocks AC14 / UI Breakage)

**Description:**

**Overview:**
As per AC14, quantity values must not exceed, or be able to save, the maximum order size configured for the selected instrument. Currently, this validation is missing. The user can input infinitely large numbers in the Fast Size Buttons settings, which save successfully and cause the Escalator quantity bar UI to break due to text overflow.

**Steps to Reproduce:**
1. Navigate to **Settings -> Order Management -> Fast Size Buttons**.
2. Input an astronomically large integer in one of the fields (e.g., `10000000000000000000000`).
3. Click **Save** (Note that a success toast appears).
4. Open an **Escalator** widget for any instrument.
5. Observe the Quantity Bar at the bottom.

**Expected Result:**
The Settings page must trigger a validation error preventing the save if the number exceeds the instrument's maximum order size (or at a minimum, enforce standard platform limits for numerical inputs).

**Actual Result:**
The massive number is saved and pushed to the Escalator widget. The text overflows its designated button container, visually overlapping other elements and breaking the quick bar's layout.

**Evidence:**
Please see attached screenshot: `image_47685f.png`
