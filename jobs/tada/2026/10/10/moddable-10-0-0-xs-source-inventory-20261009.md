---
handed-off: moddable-10-0-0-xs-source-inventory-20261009-split
deliverable-complete: false
---
I split the job into three child jobs; none of the research itself is done yet. The original inventory breaks cleanly by item group, so I parked three research child jobs (`researcher`, tier `mentor` with `minion` fallback). They are recorded under orchestration `moddable-10-0-0-xs-source-inventory-20261009-split`, which runs them in parallel and continues if one child fails.

Each child gets the original job's full instructions:
- the same commit window, ending at `5f215f776f93039755343dbe75a09aa2615045f4`
- commit URLs, changed XS symbols and files, and test262 paths for every item
- engine changes kept apart from ECMA-419/device/Piu/board/TypeScript/xsdb work
- a compact table, with uncertainties stated

| Child | Items |
|---|---|
| `moddable-10-0-0-xs-inventory-part-a-20261009` | Immutable ArrayBuffer, plus the question of whether it changes the minimum oracle `xst` version, any hardened262/ironhorse matrix assumption, or the ratchet baseline (child reads `context/operations/ironhorse-ratchet.md`); ArrayBuffer resize rejection order; setFromHex order; TypedArray ordering and detached checks; Atomics.wait leak/deadlock |
| `moddable-10-0-0-xs-inventory-part-b-20261009` | Math.round subnormals; Math.irandom; charAt/charCodeAt truncation; String repeat/replace/search edge cases; the String.prototype.replace capture-group memory-safety fix; Symbol.for with no argument |
| `moddable-10-0-0-xs-inventory-part-c-20261009` | Revoked Proxy IsCallable; Array.from order; Reflect.apply/construct argument-read order; Object.prototype.toString Symbol.toStringTag through a handler; Array.fromAsync non-object next; Set methods with size over 2^31-1; the 65535 scope-slot SyntaxError; the switch labelled break/continue stack leak |

The full inventory will be the three child reports read together; no job merges them into one table. I did not commit anything to the garden repo; everything was posted to the journal.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/moddable-10-0-0-xs-source-inventory-20261009.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 8 tokens (176029 cached reads)
- Output: 2663 tokens
- Cost: $0.4492818 (1 engagement(s) unpriced)
- Wall-clock: 2469s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
