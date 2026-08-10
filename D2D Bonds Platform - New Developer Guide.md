**QA Execution: PASSED ✅**

* **Environment:** DEV2

**Execution Summary:**
The Iceberg orders (Show Qty) functionality has been successfully validated. The UI correctly handles the display, dynamic locking of fields, MULTI venue restrictions, mathematical boundary rules, payload communication to ORCA, and UI behavior post-submission (ACK/REJ) as defined in the Acceptance Criteria.

---

### 1. Default UI state and Quick Quantity buttons behavior (AC1, AC2, AC12)
Verified that the "Show Qty" field is correctly displayed next to "Total Qty" and defaults to a blank state upon widget load. Clicking the quick quantity buttons on the bottom bar successfully populates only the "Total Qty" field, leaving "Show Qty" blank and the total quantity fully editable.

---

### 2. Iceberg mode restrictions when changing venue to MULTI (AC10, AC11)
Verified that switching the routing venue to "MULTI" automatically clears any existing value in the "Show Qty" field, immediately deactivating Iceberg mode. The mode remains correctly disabled and unavailable as long as MULTI is selected.

---

### 3. Automatic locking and unlocking of Order Type and TiF fields (AC3, AC8, AC9)
Verified the automatic field locking behavior. Entering a value in "Show Qty" successfully defaults the Order Type to "LMT" and TiF to "GTD", instantly disabling (greying out) both fields. Clearing the "Show Qty" value successfully restores editability to both fields while retaining the LMT/GTD values.

---

### 4. Show Qty strict mathematical and instrument validation rules (AC4, AC5, AC6, AC7)
Verified the mathematical boundary validations for the "Show Qty" field. The system correctly applies the following rules and error states:
* Attempting to input a value less than 0 automatically resets the field to `0`.
* Attempting to input a value less than 1 (minimum quantity) triggers the validation message: `"Show Qty must be at least 1"`.
* Attempting to input a value greater than the Total Qty successfully triggers the error message: `"cannot exceed Total Qty"`.
Order submission is properly blocked when these invalid states are triggered.

---

### 5. Total Qty dependency validation check (AC15)
Verified the dynamic dependency between Total Qty and Show Qty. Reducing an already populated "Total Qty" to a value strictly below the current "Show Qty" immediately flags the fields as invalid and successfully prevents the Iceberg order from being submitted until the values are manually corrected.

---

### 6. Successful Iceberg order submission payload and UI reset (AC13, AC14)
Verified that upon submitting a valid Iceberg order that is successfully acknowledged (ACK) by the venue, the system accurately sends both the Total Qty and Show Qty values to ORCA. Confirmed that the "Show Qty" field automatically resets to a blank state immediately after the successful submission, clearing the form for the next order.

---

### 7. Failed Iceberg order submission UI retention (AC13, AC14)
Verified that when an Iceberg order is submitted but gets rejected (REJ) by the backend/venue, the system correctly sends both the Total Qty and Show Qty values to ORCA. Confirmed that the "Show Qty" value purposefully remains populated in the UI, allowing the user to easily retry or modify the order without having to re-enter the iceberg values.

---

**Sign-off:** Approved to close. All Acceptance Criteria for DWU-413 have been successfully met.
