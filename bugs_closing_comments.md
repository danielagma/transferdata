### **QA Execution: PASSED ✅**
* **Environment:** DEV2

**Execution Summary:**
The visual mismatch and state synchronization bug on the Quantity Bar has been successfully resolved. Changing the instrument now correctly aligns the visual UI highlight with the underlying internal state, completely eliminating the risk of unintended order submissions.

---

### 1. UI and Internal State Synchronization - **PASSED ✅**
Followed the original steps to reproduce. Verified that after selecting a quantity on the vertical bar (triggering the orange highlight) and subsequently changing the instrument, the UI no longer falls out of sync. The Quantity Bar's visual state now perfectly matches the system's internal memory.



---

### 2. Order Submission Payload Accuracy - **PASSED ✅**
Verified that submitting an order (by clicking a price cell on the grid) immediately after changing the instrument correctly utilizes the actively visible/highlighted quantity. Confirmed via network payload observation that no lingering or "invisible" quantities are sent to the backend.



---
**Sign-off:** Approved to close. The defect reported in DWU-274 has been successfully fixed and retested.
