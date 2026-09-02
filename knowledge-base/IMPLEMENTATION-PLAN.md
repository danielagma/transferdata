# Automation Implementation Plan — Darwin Regression Testing

## Purpose

This document orders the 23 user stories in `user-stories/` into a **dependency-safe sequence**. Ticket numbers do not reflect implementation or dependency order — several stories build directly on top of features delivered by other stories (a widget must exist before a field can be added to it; an order must be placeable before it can be cancelled). Automating out of this order means writing a test for a feature whose precondition isn't automated yet, which either blocks the test or forces it to silently re-implement setup steps that belong to an earlier story.

**Before starting any tier, read the "Suggested automation order" row in that story's own `.md` file** — it explains the specific dependency, not just the tier number.

## How to read this plan

- **Tier** = the recommended pass in which to automate that story. Lower tiers have no dependency on higher tiers; a story in Tier N may depend on one or more stories in Tier < N.
- Stories in the **same tier** have no dependency on each other and can be automated in any order, or in parallel by different people.
- Two independent tracks run through the backlog: **Reference Data** (epic DWU-297 — bond configuration, pricing formats) and **Order Management** (epic DWU-300 — the Ladder/Escalator widget and trading actions). They only intersect at Tier 9 ([[DWU-344]]).

## Suggested automation order

### Tier 1 — Reference Data foundations (no dependencies — good starting point)
| Ticket | Story |
|---|---|
| [[DWU-169]] | Reference Data: "Pricing Format" dropdown (Decimal/32nd) |
| [[DWU-375]] | Add Bond Sector to Bond Referential |

### Tier 2 — Reference Data precision
| Ticket | Story | Depends on |
|---|---|---|
| [[DWU-170]] | View Defaults: increase precision to 8 decimal places | DWU-169 |

### Tier 3 — Reference Data display logic
| Ticket | Story | Depends on |
|---|---|---|
| [[DWU-171]] | Bond Pricer: display price fields in 32nd format | DWU-169, DWU-170 |

### Tier 4 — Order Management: base widget + parallel order-entry fields
| Ticket | Story | Depends on |
|---|---|---|
| [[DWU-163]] | Escalator View - MVP (creates the vertical ladder widget) | — |
| [[DWU-188]] | Market Depth Widget: TIF (Time in Force) field | — (parallel) |
| [[DWU-189]] | Market Depth Widget: Order Type parameter | — (parallel) |

### Tier 5 — Quantity bar and ladder layout
| Ticket | Story | Depends on |
|---|---|---|
| [[DWU-180]] | Vertical Quantity Bar with Fixed Values | DWU-163 |
| [[DWU-257]] | Align Price Ladder and Trader Order Indicators | DWU-163 |

### Tier 6 — Core order submission
| Ticket | Story | Depends on |
|---|---|---|
| [[DWU-172]] | Passive Order Submission | DWU-163, DWU-180 |
| [[DWU-173]] | Aggressive Order Submission | DWU-163, DWU-180 |

### Tier 7 — Order visibility and bulk cancellation
| Ticket | Story | Depends on |
|---|---|---|
| [[DWU-253]] | Add Own Orders Column (My Bids/My Asks) | DWU-172, DWU-173 |
| [[DWU-259]] | Persistent Cancel Actions (Cancel Bids/All/Asks) | DWU-172, DWU-173 |

### Tier 8 — Order management refinement
| Ticket | Story | Depends on |
|---|---|---|
| [[DWU-284]] | Fast (per-row) Order Cancellation Buttons | DWU-253 |
| [[DWU-260]] | User-configurable Quantity Bar Values | DWU-180 |
| [[DWU-261]] | Manual Quantity Input | DWU-180 |

### Tier 9 — Widget maturity and Reference Data integration
| Ticket | Story | Depends on |
|---|---|---|
| [[DWU-283]] | Hidden View (Accordion) Functionality | Most of Tiers 4–8 (needs controls to hide) |
| [[DWU-318]] | Scrollbar & Recenter Control | DWU-163 |
| [[DWU-334]] | Rename "Escalator" to "Ladder" (rebrand) | Most of Tiers 4–8 (renames their UI) |
| [[DWU-344]] | Apply Pricing Format to Market Depth/Ladder | DWU-169, DWU-171, DWU-163 |

### Tier 10 — Advanced Ladder features (post-rebrand)
| Ticket | Story | Depends on |
|---|---|---|
| [[DWU-413]] | Show Quantity Redesigned (Iceberg orders) | DWU-334 |
| [[DWU-414]] | Fast Execution / Take Best Buttons | DWU-334, DWU-283 |

### Not tiered — recommended to skip or deprioritize
| Ticket | Story | Reason |
|---|---|---|
| [[DWU-161]] | Futures Maintenance: dynamic vertical resizing | Unrelated screen, pure CSS/responsive-layout behavior with no business logic. See the "Should this be automated?" section in that file for full reasoning — recommendation is to skip or, at most, a single low-priority smoke check. |

## How this ordering was derived

This is **not** the order tickets were created or numbered — it's a dependency graph built from what each story's evidence and acceptance criteria actually require to exist first (e.g. you cannot test "cancel an order" ([[DWU-259]]) before "submit an order" ([[DWU-172]]/[[DWU-173]]) is automated, and you cannot test the per-row cancel icon ([[DWU-284]]) before the column it lives in ([[DWU-253]]) exists). Each story's own file states its specific dependency in the "Suggested automation order" metadata row and in "Notes for automation" — this document is the aggregate view.

## Before starting: check what's already automated

Nobody has verified the actual state of the Playwright test suite against this list yet. **Before picking a story from Tier 1, search the automation repo for existing tests/specs covering these tickets or their features** (by ticket number, by widget name — checking both "Escalator" and "Ladder" since the widget was renamed in [[DWU-334]] — and by user-facing behavior). Classify each story as:
- **Automated** — a spec exists and covers the acceptance criteria in that story's `.md` file.
- **Partially automated** — a spec exists but doesn't cover all acceptance criteria (cross-check against the story's list).
- **Not automated** — no coverage found.

Update the `Automation status` field in each story's `.md` file and the corresponding row in `INDEX.md` once this classification is done — that turns this plan into a live coverage tracker instead of a one-time snapshot.

## Known gaps to resolve before treating a tier as "done"

A few stories have documented open questions that should be resolved (or explicitly accepted) before their automation is considered complete:
- [[DWU-283]]: AC5 requires "Book" and "Pause" controls behind the accordion; QA evidence only confirms Order Type/TIF/VWAP, with Book explicitly marked "pending to verify".
- [[DWU-414]]: QA evidence is missing scenario 3, likely covering AC8 (buttons disabled when no best price/quantity available).
- [[DWU-169]]: a documented backend bug (500 error on a specific ISIN) — confirmed closed by the user, no longer a blocker.
- [[DWU-170]]: a documented "bug found" in QA — confirmed closed by the user, no longer a blocker.
- [[DWU-344]]: an **accepted** deviation (manual Price field never shows/accepts 32nd input) — this is expected behavior, not a gap, but don't assert against the literal AC5/AC6 wording.
- [[DWU-260]]: an **accepted** deviation on AC14 (no max order size validation) — same as above, expected, not a gap.
