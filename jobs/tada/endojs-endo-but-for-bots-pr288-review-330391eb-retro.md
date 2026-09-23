Done. Definition of done met.

## Completion report

**Job:** Prosecutor retrospective (review-retrospective second loop) on `endojs/endo-but-for-bots` #288, maintainer review `4629027865`.

**Idempotency:** Neither `misses/` nor `dismissed/endojs-endo-but-for-bots-pr288-review-330391eb.md` existed → proceeded (not a no-op).

**Discrimination (grounded in the PR's real board history, not the comment text):** The review's three asks were (1) hand `@endo/cbor-frame` to a Fable agent for a closer pass, (2) factor the package's local byte-concat onto shared `@endo/bytes/concat.js`, (3) move the `materialize()` optimizations into that shared module. The dispositive fact: **the garden fleet never authored or review-owned this package** — the journal holds only branch-ops and routing jobs for #288 (`-refresh`, `-shepherd`, `-review-330391eb`) plus the Fable pass those asks spawned; there is **no build / gauntlet / panel / clean / judge / fixer** job for cbor-frame anywhere. With no garden panel ever reviewing the package, no seat "demonstrably knew a convention and failed to bind." Ask (1) is an unanticipatable maintainer process directive; asks (2)/(3) are exploratory ("Now provided by…", "presumably…"), and the Fable review the maintainer requested found ask (3) **partly incorrect** (the zero-copy short-circuit must stay at the call site to preserve concatBytes's no-aliasing contract) — a review-cycle check firing here would have produced a wrong finding.

**Verdict: NOT-A-MISS (new-direction).** Recorded durably via `review-miss-record.sh record` → `review-misses/dismissed/endojs-endo-but-for-bots-pr288-review-330391eb.md`. No cluster minted, no threshold evaluated, no `review-improve-*` dispatched.

**Reporting:** `result` journal entry posted (`220700Z-result-gardener-c71c7e.md`) with grounds and the self-improvement line.

**Changed:** journal2 only (one dismissal record + one result entry). No `main2` / garden-library change — a dismissal is record-and-complete. Inbox drained (empty).

**Follow-ups:** None. The primary loop (`endojs-endo-but-for-bots-pr288-review-330391eb` and the `ebfb-pr288-fable-review*` chain) remains unchanged and owns the actual feedback.
