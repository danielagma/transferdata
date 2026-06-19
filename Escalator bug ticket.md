QA Testing: PASSED

Environment: DEV2
ISIN Used: ES0000012L29

Business Logic Note: As confirmed with Business, the Escalator accurately respects the MTS market mirroring behavior when using the MULTI view. The system correctly aggregates the liquidity mirrored across submarkets (e.g., ESP + EBM), and the UI dynamically updates to reflect this expected business logic without filtering the backend data.

Scenario: Successful submission of a passive Sell order

Validated the submission of a passive Sell order by clicking the right column at the 100.055 price level (Initial Qty: 14) with a selected quantity of 10. The system submitted the order, displayed the green banner, and rendered the own order indicator [10]. The updated Ask quantity displayed 34, correctly reflecting the aggregated mirrored liquidity ((10 * 2) + 14) across submarkets as expected in the MULTI view.

(Insert Passive Sell Order screenshots below)
[ 🖼️ INSERT PASSIVE SELL ORDER IMAGES HERE ]

Scenario: Successful submission of a passive Buy order

Validated the submission of a passive Buy order by clicking the left column at the 99.960 price level (Initial Qty: 4) with a selected quantity of 100. The system successfully submits the order, triggering the green confirmation banner and displaying the own order indicator [100]. The updated Bid quantity displayed 204, accurately reflecting the aggregated mirrored liquidity ((100 * 2) + 4) across submarkets as expected in the MULTI view.

(Insert Passive Buy Order screenshots below)
[ 🖼️ INSERT PASSIVE BUY ORDER IMAGES HERE ]

Block passive order submission when VWAP is active - PASSED

Validated that enabling the VWAP mode successfully acts as a kill switch for passive execution. Clicking on any column within the Escalator grid while VWAP is ON does not trigger any order submission, no confirmation banners are displayed, and the market depth remains completely unchanged.

(Insert VWAP Active screenshot below)
[ 🖼️ INSERT VWAP ACTIVE IMAGE HERE ]
