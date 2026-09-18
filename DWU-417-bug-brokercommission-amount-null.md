[Bug] TOMS post-trade: BrokerCommission.Amount is published as null when the TOMS transaction cost is informed

* **Environment:** UAT2

**Overview**
DWU-417 maps `PostTradeEvent.Trade.Broker.BrokerCommission.Amount` from `<TransactionCosts><TransactionCost><Type>2</Type><Cost>` when the TOMS field `ClearingBroker` and that transaction cost are populated. On `BloombergToms$21023156` the payload publishes `"BrokerCommission":{"Amount":null}` while `"BrokerCode":"6ATE"`, which is mapped from `ClearingBroker`. The TOMS message carries one transaction cost, and it is `Type 1`:

```xml
<TransactionCosts>
  <TransactionCost><Type>1</Type><Currency>EUR</Currency><Cost>1200.0</Cost></TransactionCost>
</TransactionCosts>
```

**Actual result:** `BrokerCommission.Amount` is published as `null`.

**Expected result:** `BrokerCommission.Amount` carries the `<Cost>` value of the transaction cost, `1200.0`.

**Evidence:**
