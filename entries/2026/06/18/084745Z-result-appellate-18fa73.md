---
ts: 2026-06-18T09:00:00Z
kind: result
role: appellate
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/06/18/084348Z-result-solicitor-r2-450.md
---

## Appellate review — PR #450 `designs: Add presence-severance-observation`

Post-loop appellate audit of the solicitor R2 terminating verdict (828d9d).
Items considered: 4 follow-up + 2 acknowledge = 6 total.

### Follow-up items (4)

1. **Concrete type/shape of severance promise rejection reason** (critic + skeptic)
   Disposition: follow-up (impl-PR-facing). The marshal-tables runtime constraint
   that drives the type question is not resolvable from the design document alone;
   it requires CapTP internals. Score: small=marginal, in-context=marginal,
   loss-track=low (ledger entry present). Deferral stands.

2. **Test vectors for all three severance sub-cases** (skeptic)
   Disposition: follow-up (impl-PR-facing). Purely implementation work; no design
   text to amend. Score: small=no (three test scenarios), in-context=no.
   Deferral stands.

3. **Permission-revoked routing through CTP_DISCONNECT** (skeptic)
   Disposition: follow-up (impl-PR-facing). Investigating whether the routing
   path exists requires CapTP internals outside the design document's scope.
   Score: small=no, in-context=no. Deferral stands.

4. **`E.whenSevered` on an already-severed presence** (skeptic)
   Disposition: follow-up (impl-PR-facing). The design states "one-shot,
   monotonic" which directly implies an already-rejected promise on late call;
   a one-sentence explicit statement could land here. Score: small=yes,
   in-context=yes, loss-track=moderate (ledger is durable; impl panel is
   likely to encounter this naturally during testing). Marginal candidate;
   the deferral is reasonable. Deferral stands.

### Acknowledge items (2)

1. **Line-number cites for WeakMaps will become stale** (skeptic)
   Accepted tradeoff, correctly stated in the verdict. Loss-track risk near
   zero: it is a known tradeoff, not an open question. No promotion warranted.

2. **"HandledPromise primitives" heading case** (pedant)
   The document's dominant pattern is sentence case: seven of ten `##`-level
   headings are sentence case. "HandledPromise primitives" is consistent with
   that majority. The only title-case outlier is "What is the Problem Being
   Solved?" which is template-dictated. The finding is correctly classified as
   borderline; no in-PR fix needed. No promotion warranted.

### Summary

No promotions proposed. All 6 items (4 follow-up, 2 acknowledge) hold at
their solicitor-assigned dispositions. The design is clean after R1 and the
R2 panel found no must-fix items.

Un-drafting PR #450 now. Next stage: conductor.

Self-improvement: nothing this time.
