### 1. Default UI state and Quick Quantity buttons behavior (AC1, AC2, AC12)
**Status: PASSED ✅**
Verified that the "Show Qty" field is correctly displayed next to "Total Qty" and defaults to a blank state upon widget load. Clicking the quick quantity buttons on the bottom bar successfully populates only the "Total Qty" field, leaving "Show Qty" blank and the total quantity fully editable.


### 2. Iceberg mode restrictions when changing venue to MULTI (AC10, AC11)
**Status: PASSED ✅**
Verified that switching the routing venue to "MULTI" automatically clears any existing value in the "Show Qty" field, immediately deactivating Iceberg mode. The mode remains correctly disabled and unavailable as long as MULTI is selected.


### 3. Automatic locking and unlocking of Order Type and TiF fields (AC3, AC8, AC9)
**Status: PASSED ✅**
Verified the automatic field locking behavior. Entering a value in "Show Qty" successfully defaults the Order Type to "LMT" and TiF to "GTD", instantly disabling (greying out) both fields. Clearing the "Show Qty" value successfully restores editability to both fields while retaining the LMT/GTD values.


### 4. Show Qty strict mathematical and instrument validation rules (AC4, AC5, AC6, AC7)
**Status: PASSED ✅**
Verified the mathematical boundary validations for the "Show Qty" field. The system correctly applies the following rules and error states:
* Attempting to input a value less than 0 automatically resets the field to `0`.
* Attempting to input a value less than 1 (minimum quantity) triggers the validation message: `"Show Qty must be at least 1"`.
* Attempting to input a value greater than the Total Qty successfully triggers the error message: `"cannot exceed Total Qty"`.
Order submission is properly blocked when these invalid states are triggered.


### 5. Total Qty dependency validation check (AC15)
**Status: PASSED ✅**
Verified the dynamic dependency between Total Qty and Show Qty. Reducing an already populated "Total Qty" to a value strictly below the current "Show Qty" immediately flags the fields as invalid and successfully prevents the Iceberg order from being submitted until the values are manually corrected.
