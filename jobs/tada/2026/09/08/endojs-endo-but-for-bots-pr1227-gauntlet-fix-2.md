Fix stage complete. CI is green.

## Completion report

**Job:** Gauntlet FIX round 2 for endojs/endo-but-for-bots PR #1227 (design doc `designs/daemon-guest-bot-incarnation.md`).

**Panel verdict addressed:** round-2 design panel (critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice, orthographer), all request-changes. Applied the must-fix items and the high-value should-fix/comment items in one revision.

**Substantive fixes:**
- **Shared-launcher contradiction (critic/skeptic/ergonomist must-fix):** decided explicitly for **one bot incarnation per guest** — each guest binds its own `bot` identifier, so `provide`'s per-identifier memoization yields a distinct incarnation/worker per guest. Reworked the cancellation, worker-cost, and force-reap claims onto that decision; scoped shared-incarnation out.
- **`provideHost` silent no-op (ergonomist must-fix):** `bot` typed on a guest-specific options type; `provideHost` rejects it as type + runtime error.
- **`{ type: 'stopped' }` transition (ergonomist must-fix):** added clean-exit → `dormant`, settle-time `blocked`, and rejection → `backoff` transitions.
- **Crash-loop breaker store (critic/skeptic/decomplector):** named its store (per-guest daemon store), atomic write path, collection-with-guest, and its three-count escape from the "second mutable truth" objection.
- **Content-addressing rationale (skeptic):** corrected — guest identity is minted, so byte-shape is a serialization guarantee, not identity; stability rests on formulation discipline + get-or-create.
- **`followMessages` drain duplicate (skeptic/critic):** stated at-least-once-with-stable-key consumer dedupe contract; added the interleave test case. **Silent non-consumer (skeptic):** explicitly scoped out.
- **Operator lever (critic):** added `stopBot` to give the `operator` state both directions.
- **`retryBot` breakers named + resolution point (copyeditor must-fix/ergonomist):** enumerated breakers; dropped the false `cancel` precedent; split the `blocked` status record by reason (ergonomist).
- **Glossary/terminology (novice/critic/ergonomist must-fix):** added `bot`, `caplet`, `@pins` to Background; standardized on one referent per word (dropped "launcher"/"bot caplet" drift).
- **decomplector alternatives:** recorded the out-of-band guest→bot-table alternative and the `onMessageCommitted`-vs-`followMessages` rationale.
- **Conventions:** added `## Prompt` section, README summary-table row, `followBotStatus` deferral.
- **Style (pedant/copyeditor/orthographer):** re-wrapped the 109-col line, wrapped host methods in `interface EndoHost`, `possibly-repaired`→`possibly repaired`, serial-conjunction commas, prose `cancelled`→`canceled` (API symbol kept).

**Push + CI:** committed and pushed as review-feedback follow-up. The PR was CONFLICTING against `llm` with an empty rollup (base advanced 540+/131- on `designs/README.md`), so CI could not attach. Rebased the head onto current `upstream/llm`, re-resolved the one README-row conflict, force-pushed via `safe-push-pr-head.sh --mode rewrite`. Final diff vs `llm` is exactly the new 617-line design file plus one README row. CI ran to terminal **GREEN** (7/7, 0 failed).

**Follow-ups:** none blocking. Some out-of-scope panel notes remain (branch-ref URL permalinks; optional mermaid stateDiagram; full README milestone/dependency-graph/Gantt integration beyond the summary-table row). The driver re-posts panel-3.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1227-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 70 tokens (3302836 cached reads)
- Output: 47764 tokens
- Cost: $4.010321
- Wall-clock: 1265s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
