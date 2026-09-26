CI is green on the new head `b92806987f7` (fresh run IDs `321025xxxxx`, newer than the prior `320993xxxxx`). Both must-fix items applied, pushed, CI confirmed GREEN.

## Completion report

**Job:** endojs/endo-but-for-bots PR #989 — gauntlet FIX round 5 (design doc: `worker-quiescence-embargo.md`)

Re-derived state on a clean requeue: HEAD was at `6a6c4d50c3` (panel-4 fix), CI green, round-5 panel verdict (`2026-08-18T04:44:47Z`) returned **must-fix** from two seats.

**Must-fix items applied:**

1. **skeptic — false OCapN-coverage premise.** The design framed OCapN as "layered over" CapTP and claimed the maintainer's "must exist in ocapn" requirement was satisfied by threading `pumpOptions` into `makeMessageCapTP`/`makeMessageSlots`. In fact `@endo/ocapn` is not layered over `@endo/captp` (own object table, refcounting, dispatch loop, and netlayers), and no worker speaks OCapN through `connection.js`, so the mechanism never reaches it. Fixed by **scoping OCapN out honestly** in Definitions, § The configuration option, Decision 7, and § Resolved in review — carrying the option into OCapN's own dispatch surface is now a named follow-up rather than an asserted-but-undelivered coverage. Redefined "all CapTP variants" to the two variants a worker actually speaks (legacy CapTP + slot machine).

2. **pedant — unswept em-dashes.** Swept all 40 em-dash occurrences from prose per `skills/em-dash-style` (period / colon / parentheses by per-instance judgment, not mechanical substitution). Verified count is now 0; only the `§` section-sign (pedant's accepted remit) remains as non-ASCII.

**Pushed:** commit `b92806987f` to `origin/design/worker-quiescence-embargo` via `safe-push-pr-head.sh` (advance mode).

**CI:** all 5 checks (browser-tests, lint, build, zizmor, test) **SUCCESS** on the new head `b92806987f7` — confirmed GREEN via `ci-wait-merge.sh` (rc 0).

Per stage discipline, I applied must-fix items once and stopped; I did not re-run the panel (the driver re-posts panel-6). Should-fix/comment-only items (e.g. critic's `run_supervised` identifier, decomplector's cross-language spelling binding) were left for the driver's next round.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr989-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 2 host(s) (3 unmetered)
- Input: 112 tokens (5751317 cached reads)
- Output: 34041 tokens
- Cost: $4.7864135 (3 engagement(s) unpriced)
- Wall-clock: 1095s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
