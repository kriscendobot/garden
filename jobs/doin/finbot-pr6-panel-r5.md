---
role: builder
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-08-01T21:01:05Z cleared=none -->

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
blocked_on: finbot-pr6-fix-panel-r4
---

# Run the required merge-governance panel for kriscendobot/finbot PR #6 (round 5, post-fix-r4 head)

PR: https://github.com/kriscendobot/finbot/pull/6 (DRAFT)
Head branch: `feat/forecast-data-sufficiency` — review the CURRENT branch tip (the head that
`finbot-pr6-fix-panel-r4` pushes; do not pin a stale head).
Base: `origin/main`.

**Why this job exists.** The round-4 panel (`finbot-pr6-panel-r4`) returned MUST-FIX with
empirically-reproduced fail-open findings where the round-2/3 own-data discipline stopped short:
a value-scoped (not type-scoped) config-integrity guard letting a non-numeric knob disarm the
risk bounds (M1); `navOf` reading the portfolio via plain `[[Get]]` before the fail-closed
snapshot (M2); invariant 6 (`route`/`substrate`) and invariant 5 (`oracleReadings`) still reading
untrusted input via plain `[[Get]]` and throwing/false-attesting out of `audit()` (M3, M4);
`asset` used as a computed property key (`__proto__` confusion / throwing `toString`) (M5);
`Array.isArray` throwing on a revoked Proxy (M6); `stalenessWindowTicks` reaching the recorded
detail unsanitized (M7); and a stated export-promotion criterion that does not hold for
`MAX_LABEL_CODE_POINTS` (M8). `finbot-pr6-fix-panel-r4` (fixer) addresses them and pushes a new
head; this job re-runs the full panel at that head. This continues the panel→fixer loop until a
clean panel.

## Do

1. Get an isolated project worktree for the PR head (keyed by YOUR job base, not the PR):
   `scripts/jobs/ensure-project-worktree.sh <your-base> kriscendobot/finbot feat/forecast-data-sufficiency`
2. Run the scripted code panel against `origin/main`:
   `scripts/jobs/gardening/panel.sh <worktree> 6 origin/main`
   Require a non-empty formal verdict from EVERY seat; retry any missing/empty seat (do not
   treat an empty block as a pass). (Single-round mode `GARDEN_PANEL_SINGLE_ROUND=1` runs one
   round and emits the disposition without auto-fixing/un-drafting — the supervisor posts the
   follow-ups.)
3. On must-fix findings, post a follow-on fixer job `finbot-pr6-fix-panel-r5` (role: fixer,
   tier: mentor, fallback minion, handler-timeout: 7200) carrying the current round's must-fix
   list, and a further panel re-run `finbot-pr6-panel-r6` blocked_on it — continuing the loop.
   Keep the tree green (CI `test` green, mergeable/CLEAN). Verify in particular that the round-4
   fixes genuinely hold: a non-numeric knob now fails closed via a type-scoped guard and emits
   `config-integrity`; nav is computed from an own-data portfolio snapshot so a throwing/inherited
   accessor yields a verdict not an exception; `route`/`substrate`/`oracleReadings` read through
   `readOwn`/`readOwnFiniteNumber`/`safeArrayLength` and never throw or false-attest out of
   `audit()`; `asset` is string-typed and keys a null-proto/Map accumulator; `Array.isArray` is
   guarded against a revoked Proxy; the `stalenessWindowTicks` detail is sanitized; and the
   export-promotion criterion holds for every promoted name (or is restated).
4. On a PASSING panel, leave the PR DRAFT — do NOT merge or un-draft. Post the sign-off job
   `finbot-pr6-signoff` with `role: orchestrator`, `tier: mentor`, and **NO model pin** (per the
   liaison's 2026-08-01 governance annotation removing the earlier `claude-fable-5` pin; confirmed
   by the plain-orchestrator sign-off that landed PR #4). Include the panel outcome and PR URL in
   that job's body. The orchestrator owns sign-off and any merge it directs — the builder/press
   NEVER merges.

Per merge governance (2026-07-22, amended 2026-08-01), this increment lands only after BOTH a
passing panel and an orchestrator sign-off. Never self-merge.

<!-- garden-reaped: 2 -->

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-01T21:33:15Z
