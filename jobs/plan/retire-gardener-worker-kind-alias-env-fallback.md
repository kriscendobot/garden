---
gate: go-ahead
priority: normal
tier: mentor
token-budget: 100000
doomed: true
doom_signature: requeue-exhausted
doom_count: 1
split_eligible: true
split_reason: repeated-plain-exit
failure_classification: unknown
requeue_cycles: 2
deadline_overruns: 0
elapsed_constancy_confirmations: 0
doomed_at: 2026-09-30T02:13:08Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-09-30T02:13:08Z
---

---
tier: mentor
token-budget: 100000
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-29T20:19:07Z cleared=none -->

---
tier: mentor
fallback-tier: minion
token-budget: 100000
dispatch: automatic
---
Child 1/2 of orchestration `retire-gardener-worker-kind-alias-split` (split of
`retire-gardener-worker-kind-alias` after a 2400s deadline overrun).

Context: the bulk of the legacy `gardener` worker-kind retirement already landed on
`main2` in commit `02513cd130f` ("refactor(jobs): retire gardener worker kind":
common.sh registry/decoder, handlers/gardener-claude.sh + set-gardeners.sh +
migrate-host-to-monk.sh deleted, reputation-reduce dual projection dropped,
install-units RETIRED_UNITS prunes `garden-gardener@.service`, compat/cutover tests
removed). `journal/hosts/*` no longer carry a `gardeners:` line. DO NOT redo that work.

Scope of THIS child: remove the residual legacy env alias `GARDEN_GARDENER_CLONE`
and stale `gardener-claude.sh` references, keeping `GARDEN_WORKER_CLONE` only.

- Fallback readers: `claim-job.sh:~188`, `complete-job.sh:~39`, `gardener.sh:~74-78`
  (stop exporting `GARDEN_GARDENER_CLONE`), `usage-meter.sh` (~130/503/523),
  `usage-append.sh:11` (reads ONLY the legacy var — switch it to
  `GARDEN_WORKER_CLONE`, and check `GARDEN_GARDENER_ID` vs the spine's id var).
- Library scripts that read ONLY the legacy var (switch to `GARDEN_WORKER_CLONE`, or
  the break is silent): `regenerate-topics-counts.sh`, `regenerate-sections-index.sh`,
  `library-slug-prefix-check.sh`, `library-link-check.sh` (help text too); comment in
  `auction.sh:~123`.
- Stale comments naming `gardener-claude.sh` → `monk-claude.sh`: `common.sh`
  (~3840, ~8867, ~9061), `gardener.sh` (~532, ~1241), `ensure-project-worktree.sh`
  (~23, ~35), `handlers/cleric-codex.sh` (~202).
- Tests under `scripts/jobs/test/` that set `GARDEN_GARDENER_CLONE` (grep; e.g.
  run-test.sh, model-routing, qwen-mentor-trial, fetch-timeout, flat-provider-censor,
  gardener-claude-tier-serving, host-requirements-gating, live-budget-admission,
  deadline-nudge, gardener-worktree, auction-reputation, kimi-*, canary-probe-claim-
  priority): retarget to `GARDEN_WORKER_CLONE`. Optionally rename
  `gardener-claude-tier-serving-test.sh` → `monk-claude-...` if its name refers to the
  deleted handler.
- Final `grep -rn GARDEN_GARDENER_CLONE scripts` must be empty (except a deliberate
  regression assertion, if you add one).

Run the regression sweep (scaler/deploy/reaper/handler/health/worker-spine/
auction-reputation suites plus every test you touched) and report which needed
updating vs already passed. Land directly on `main2`.

Orchestrated failure contract: if you finish but cannot achieve the outcome, end your
report with `<<<GARDEN-ORCHESTRATION-FAILED>>>` then `<<<GARDEN-JOB-COMPLETE>>>`.
