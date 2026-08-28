**QA Acknowledgment: PASSED** ✅

**Environment:** DEV1
**Target Event:** `StpHubAcknowledgementReceived`

As this is an infrastructure task (DWU-503), QA acknowledges the developer's evidence and successfully verified the connectivity to the STP Hub in DEV1. 

**Verification Summary:**
* An RFQ was raised and approved to trigger the trade flow.
* The OpenSearch logs successfully captured the `StpHubAcknowledgementReceived` event.
* As noted by Development and confirmed by the STP Hub team, the event correctly returned `Event.ErrorStr: "Error WORK IN PROGRESS"`. This acts as the expected handshake to prove the communication line is working.

*(Insert OpenSearch screenshot of the ACK log here)*

Approved to close.
@Murat Guney
