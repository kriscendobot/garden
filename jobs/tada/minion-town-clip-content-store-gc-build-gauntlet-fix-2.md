Fix round 2 complete. Summary of work done.

## Report

Applied the round-2 jury panel's **code/doc must-fix items** to PR #93 (`kriscendobot/minion.town`, `feat/clip-content-store-gc`), pushed as three review-feedback follow-up commits (`655e584` → `da10407`), and confirmed CI green.

**Must-fix items applied:**

1. **#1 (assessor, saboteur) — `unpublish` cleanup comment was false.** `src/endo/gateway/publish.ts`: corrected the "safely retried on a later unpublish" claim (the record is deregistered first, so a later `unpublish` short-circuits at `no-such-clip` and never re-attempts cleanup — the failed pet-name cleanup permanently strands the guest `clip-*` pet name and its `back` capability). Replaced the silent `catch {}` with a `console.warn` naming the stranded pet name for out-of-band reclaim. The takedown is still never gated or reversed.
2. **#2 (typist) — `primaryWorkerName` catch narrowing.** `src/endo/gateway/daemon-site-registry.ts`: restored the unconditional `catch` so a non-`Error` CapTP rejection falls back to `MAIN` per the documented contract, instead of propagating out of `createDirectory`/`removeDirectory`.
3. **#3 (archivist) — design-doc status contradicted shipped code.** `designs/clip-formula-id-origin-and-content-gc.md`: updated the header status and § B.10 from "designed, not yet implemented" to "implemented, pending production audit"; kept the pre-`GATEWAY_GC_DELETE=1` audit requirement pointing at the deployment runbook.

**Not a code fix (noted, deferred to maintainer):**
- **#4 (integrator) — duplicate strand.** #93 near-duplicates #92 (which carries the production spot-check evidence) and #83 attacks the same gap. Picking one strand and closing/rebasing the others is a maintainer decision.

**Also:** posted a fix-round summary comment (round-2 should-fix #9, `skills/pr-completion-summary-comment`).

**Verification:** `npm run typecheck` clean; full suite `364 passed | 5 skipped`; the `unpublish` cleanup-rejection test still asserts the takedown succeeds.

**CI:** `ci-wait-merge.sh … --no-merge` → **rc 0 (GREEN)**.

Should-fix / comment-only items (race-tolerant `--drop-unresolved` excision, cross-tenant GC blast-radius isolation, `evaluateRegister` grace-window bound, shared vhost predicate extraction, property tests, DEPLOYMENT.md durability) were left for a later round per the fix-stage scope. Per the driver contract I did not re-run the panel — the driver re-posts panel-3.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-clip-content-store-gc-build-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 60 tokens (1639147 cached reads)
- Output: 12885 tokens
- Cost: $1.7243145000000006
- Wall-clock: 277s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
