**QA Retest: PASSED ✅**

* **Environment:** DEV2
* **Instruments Used:** SPGB 5.900 07/26 / FGBL M6

**Execution Summary:**
Successfully verified the bug fix regarding the missing UI error notifications for failed MULTI order creations. 

**Test Scenario & Business Logic:**
To accurately trigger the condition where "no orders are produced for MULTI", it is necessary to simulate a complete loss of market connectivity for the specific asset. 
1. Accessed the Bank master toggle dropdown and manually turned `OFF` all active subvenues associated with the test ISIN (disabling multiple subvenues like SENAF, MTS, and BROKERTEC for `SPGB`, or exclusively EUREX for `FGBL M6`).
2. Attempted to execute an aggressive/passive MULTI order from the Market Depth / Escalator widget.

**Result:**
The frontend now successfully catches the failed event from the backend. The system correctly blocks the order creation and immediately surfaces the red error toast on the UI with the exact expected message:
`"MULTI [BUY/SELL] [QTY] @ [PRICE] FAILED: No matching price found and no 'active' markets configured for quantity allocation. Cannot create any orders."`

Approved to close.

*(Please see attached my verification evidence: image_a27f4e.png, image_a27ebb.png, image_a22c82.png)*
