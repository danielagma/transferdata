[Bug] Trade enrichment replay is blocked by a production support role check, which DWU-432 says must not exist

* **Environment:** UAT2

**Overview**
DWU-432 Functional Requirement 2 states "No restrict the enrichment replay to the roles, every user has access to this functionality". Replaying the outbound enrichment on trade `BloombergToms$21022915` returns `{"IsSuccess":false,"Error":"User c0292415 does not have the production support role required to replay outbound trade enrichment."}`. The role check the requirement rules out is being enforced, so the outbound replay is unusable.

**Actual result:** the replay fails with a production support role error and no enrichment is republished.

**Expected result:** the replay runs for any user, per DWU-432 Functional Requirement 2.

**Evidence:**
