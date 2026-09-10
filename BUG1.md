[Bug] TOMS post-trade: a cancellation is published with EventType "Reversal" instead of "Cancel"

  Descripción

  * *Environment:* UAT

  *Overview*
  DWU-418 maps PostTradeEvent.EventType from the Trade Model field LifecycleAction, and its mapping row states that the current logic does not take into account the values AE to New, CAE to Amend, PCA to Amend, XAE to Cancel and PXA to Cancel. On a cancellation, the Trade Model carries LifecycleAction: "Reversal", which is the value of the Action for position computation and not the value of the TM Lifecycle Action column. DWB-1376, which is Released, defines the expected Trade Manager behaviour for exactly this case: for Transaction Types XTT, XMT, XFT and XRF with CancelDueToCorrection = N, the Action for position computation is Reversal and the TM Lifecycle Action is set to "CANCEL". The message published to STP Hub must carry the TM Lifecycle Action value, which is the final result of the trade status, and not the position computation value, which includes the reversal logic. DWB-1377 covers the other branch, where the same Transaction Types with CancelDueToCorrection = Y are the cancel half of an amendment and are to be ignored.
