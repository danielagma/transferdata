**QA Execution: PASSED ✅**

* **Environment:** DEV2
* **ISIN Used:** SPGB 1.300 10/26

**Execution Summary:**
Successfully verified the implementation of the Fast Order Cancellation buttons within the Escalator widget. All Acceptance Criteria have been met.

**1. Single Order Cancellation & UI Rendering:**
Submitted individual passive Buy and Sell orders. Verified that the red trash icon correctly renders exclusively on the price levels containing the active own orders. Single-clicking the icon successfully processed the cancellation immediately, removed the trash icon, displayed the green confirmation banner, and accurately updated the Order Blotter status to 'Cancel'. 

**2. Multiple Orders Aggregation & Sequential Cancellation:**
Submitted two consecutive passive Buy orders (25MM each) at the exact same price level (99.480). 
* **First click:** Verified the system successfully aggregated the quantity (50) and that a single click on the trash icon canceled only the most recently placed order, updating the remaining active quantity to 25 while keeping the trash icon visible. 
* **Second click:** Verified the subsequent click successfully canceled the remaining order and completely removed the trash icon from the grid.

Approved to close.

*(Please see attached my verification evidence: image_d87e56.jpg, image_d8d0b4.png, image_d8d412.png)*
