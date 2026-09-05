---
gate: go-ahead
budget_hold: true
park_reason: over-token-budget
parked_for_budget_at: 2026-09-05T04:33:34Z
budget_window_seconds: 604800
budget_resets_at: 2026-09-12T03:00:00Z
priority: high
role: shepherd
posted_by: producer
posted_at: 2026-09-05T04:33:34Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Finish PR #69 after the next Claude weekly panel reset

Repo: `kriscendobot/minion.town`.
PR: https://github.com/kriscendobot/minion.town/pull/69
Head branch: `fix/weblet-ocap-synthesis-units-4-5`.
Current pushed head: `4e5b982ce7e1cec3b1d818e00e2a3d9313f586d3`.

This is the sequential successor to `minion-town-weblet-ocap-synthesis-units-4-5-land-weekly-reset`. The predecessor rebased the long-lived draft onto current `origin/main`, addressed the earlier partial-panel findings, completed two later 29-seat review rounds and addressed their genuine findings, collapsed the review archaeology into one coherent feature commit, updated the PR body, and pushed the result. A subsequent required full panel exhausted the Claude account again: round 5 returned some verdicts before many seats began returning rc=1 with empty stderr, and round 6 returned empty verdicts for all 29 seats. Do not count either incomplete round as a pass. Resume only after the advertised weekly reset.

## Fresh local evidence at `4e5b982`

- `npm run build && npm run typecheck && npm test`: passed; 35 files passed, one live file skip-gated; 354 tests passed, 5 skipped.
- `GARDEN_YARN=npm pre-push-gates.sh --no-auto-fix --summary --base-ref origin/main`: all 6 stages passed.
- Clean pinned Endo fixture `/home/kris/garden/scratch/project-wt-minion--c51349a5a6ee-f4d57e5d` at `f66505034aaa54ac46294347b2bf0e14655b088a`; pinned live-daemon units 1-5 acceptance passed including restart.
- Round 4 was a complete 29-seat panel and surfaced findings that are fixed at the pushed head. Round 5's completed prover finding prompted concrete live-discard and double-rollback tests; its locksmith verdict was comment-only. Round 6 failed closed because every seat returned no verdict.

## Remaining owned work

1. Rediscover/adopt PR #69 and verify the pushed head/CI state; adopt newer peer work if present.
2. After the weekly reset, run a fresh normal complete 29-seat panel against current `origin/main`. Address genuine findings while preserving the maintainer-required `confirmPublicBuiltIn` acknowledgement gate. The gate intentionally does not attenuate aliases; do not replace it with the retired host-shape/blocklist design.
3. If `origin/main` moved, weave/rebase and rerun local build, typecheck, default tests, garden pre-push probes, and the pinned live-daemon units 1-5 acceptance. Push safely and wait for green CI.
4. Refresh PR #69's verification section, post the completion summary, mark ready, merge with the repository's normal merge-commit method, and verify the merge commit on `main`.
5. Post the required design-tracking comment on PR #47. Be accurate about scope drift: PR #54 actually landed while #69 remained draft, so #69 was refreshed atop its clip rename; the intended cleanup-before-rename ordering was overtaken. PR #88 supersedes the stable-origin/ambient-back direction; #63 is closed and #89 records the current boundary.

Panel artifacts from the latest attempts are under `/home/kris/garden/scratch/panel-minion-town-69-weekly-reset-{4,5,6}` but are not durable; the facts above and pushed commit are the handoff record.
