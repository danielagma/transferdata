**Overview:**
The "Trader Order" working quantity badge (e.g., the indicator displaying "30") in the Escalator View does not update in real-time via the data stream. 

**Steps to Reproduce:**
1. Open the **Escalator View** widget for an instrument.
2. Place an active working order at a specific price level.
3. Observe the order book UI.

**Actual Result:**
The trader's order badge is not displayed automatically. It only updates/renders when manually clicking on the cells or refreshing the component.

**Expected Result:**
The badge must render, update, and clear dynamically in real-time via WebSocket/stream updates without requiring any manual UI interaction.

**Note:**
Artur Moreira Dobler mentioned on Slack that he already found the solution and the fix is ready to be merged.
