[Bug] TOMS post-trade: amend and cancel events are not processed

Descripción

* *Environment:* UAT2

*Overview*
Amend and cancel events received from TOMS do not result in a PostTradeEvent published to STP Hub. No amend has been seen processed in UAT or UAT2. DWU-418 maps PostTradeEvent.EventType from the Trade Model field LifecycleAction, with NEW, AMEND and CANCEL as the values. DWU-417 maps the fields that identify an amendment and its original trade: PostTradeEvent.Trade.PreviousTradeId from the trade entity field PreviousTransactionId, PostTradeEvent.Trade.TomsTicketId and PostTradeEvent.Trade.TradeNo from TransactionId, and PostTradeEvent.Trade.SourceId from the TOMS field <LongNotes><LongNote><Index>2</Index><Text> when populated, otherwise from TransactionNumber.

*Steps to reproduce*
1. In TOMS, book a bond trade, then amend it, then cancel it.
2. For the amend and for the cancel, check whether a PostTradeEvent was published to STP Hub, and read EventType, PreviousTradeId, TomsTicketId, TradeNo and SourceId on it.
