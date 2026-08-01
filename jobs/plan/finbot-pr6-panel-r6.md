---
gate: blocked
blocked_on: finbot-pr6-fix-panel-r5
priority: normal
posted_by: producer
posted_at: 2026-08-01T21:55:05Z
---

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
blocked_on: finbot-pr6-fix-panel-r5
---

# Run the required merge-governance panel for kriscendobot/finbot PR #6 (round 6, post-fix-r5 head)

PR: https://github.com/kriscendobot/finbot/pull/6 (DRAFT)
Head branch: `feat/forecast-data-sufficiency` — review the CURRENT branch tip (the head that
`finbot-pr6-fix-panel-r5` pushes; do not pin a stale head). Base: `origin/main`.

**Why this job exists.** The round-5 panel (`finbot-pr6-panel-r5`) returned MUST-FIX: round 4
again hardened one member of each fail-open family and left the siblings. Reproduced at head
`f43b20e`: `prices` reaches `navOf` unsnapshotted (M2's sibling); `hashProposal(steps)` and the
`safeSteps` prefix-truncation let a hostile/oversized step throw or under-measure out of
`audit()`; the M5 null-proto defense is contingent on a `lockdown()` this module never calls;
`safeArrayLength` returns an unchecked `length`; `route` conflates unreadable with absent
(vacuous `routePass`); `currentTick` and `windowTicks` fail-closed branches are unpinned;
coverage counts array- not tick-adjacency; an unreadable `cash` defaults to 0 (shrinks the tail
floor); plus naming, doc/provenance, commit-hygiene, methodology-leak, missing-migration-note,
and a wall-clock-as-correctness-gate test. `finbot-pr6-fix-panel-r5` (fixer) addresses them and
pushes a new head; this job re-runs the full panel at that head. This continues the
panel→fixer loop until a clean panel.

**Dispatch note — panel targeting was fixed on main2 (commit 3b648215e4).** The round-5 panel
run exposed a bug in `scripts/jobs/gardening/panel.sh`: the per-seat prompt named only
"PR #<n>" and never the worktree, so ~9 of 28 seats resolved "PR #6" against the ambient garden
repo (`kriscendobot/garden#6`, a closed design PR) instead of finbot. That is now fixed —
`panel.sh` derives the repo slug from the worktree's origin and pins each seat to
`git -C <wt> diff <base>...HEAD`. **Verify the fix is deployed before you run** (`git -C
/home/kris/garden log --oneline -1 -- scripts/jobs/gardening/panel.sh` should show
`3b648215e4` or later); if the deployed root still predates it, the panel will misdirect seats
again — surface that to the liaison and either await a deploy or run from a checkout that has
the fix. As always, require a non-empty formal verdict from EVERY seat and confirm each seat
actually reviewed **finbot** (not an ambient repo); retry any missing/empty/misdirected seat.

## Do

1. Get an isolated project worktree for the PR head (keyed by YOUR job base, not the PR):
   `scripts/jobs/ensure-project-worktree.sh <your-base> kriscendobot/finbot feat/forecast-data-sufficiency`
2. Run the scripted code panel against `origin/main` in single-round mode:
   `GARDEN_PANEL_SINGLE_ROUND=1 scripts/jobs/gardening/panel.sh <worktree> 6 origin/main`
   Require a non-empty formal verdict from EVERY seat; retry any missing/empty/misdirected seat
   (do not treat an empty block, or a block that reviewed the wrong repo, as a pass).
3. On must-fix findings, post `finbot-pr6-fix-panel-r6` (role: fixer, tier: mentor, fallback
   minion, handler-timeout: 7200) carrying that round's must-fix list, and `finbot-pr6-panel-r7`
   blocked_on it — continuing the loop. Keep the tree green (CI `test` green, mergeable/CLEAN).
   Verify in particular that the round-5 fixes genuinely hold: `prices` snapshotted before
   `navOf`; `hashProposal`/`safeSteps` reject or fail-closed on hostile/oversized steps rather
   than throwing or measuring a prefix; the null-proto primordials captured locally; unreadable
   `cash`/`balances` fold into `config-integrity`; `safeArrayLength`/`route`/`currentTick`/
   `windowTicks` pinned by reddening regressions; coverage counted tick-adjacent; migration notes
   present on user-facing surfaces; and the untrusted-length bound pinned deterministically
   (proxy read-count), not by wall clock.
4. On a PASSING panel, leave the PR DRAFT — do NOT merge or un-draft. Post the sign-off job
   `finbot-pr6-signoff` with `role: orchestrator`, `tier: mentor`, and **NO model pin**. Include
   the panel outcome and PR URL in that job's body. The orchestrator owns sign-off and any merge
   it directs — the builder/press NEVER merges.

Per merge governance (2026-07-22, amended 2026-08-01), this increment lands only after BOTH a
passing panel and an orchestrator sign-off. Never self-merge.
