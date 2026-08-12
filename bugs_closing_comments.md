### **QA Execution: PASSED ✅**
* **Environment:** DEV2

**Execution Summary:**
The intermittent bug where the saved submarket venue lost its internal state after a layout reload has been successfully resolved. The system no longer defaults to the "MULTI" venue in the backend while visually displaying a specific venue like "ESP". The internal state now correctly matches the rendered UI upon layout reload.

---

### 1. State Synchronization upon Layout Reload - **PASSED ✅**
Followed the original steps to reproduce by selecting a specific submarket (e.g., ESP), saving the layout, and reloading the screen. Verified that the widget correctly loads displaying the saved venue in the dropdown. Executing an order immediately after the reload now accurately utilizes the visually selected venue, completely fixing the previous state mismatch.



---

### 2. Network Payload, Toast, and Blotter Accuracy - **PASSED ✅**
Verified that when an order is submitted after a layout reload, the network Request Payload correctly sends the visually selected subMarket (e.g., "ESP") instead of incorrectly defaulting to "Multi". Confirmed that the UI Toast confirmation and the trade registered in the Blotter now reflect the exact expected venue, rather than routing incorrectly to venues like SENAF.



---
**Sign-off:** Approved to close. The intermittent defect reported in DWU-437 has been successfully fixed and retested.
