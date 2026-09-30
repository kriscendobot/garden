---
handed-off: retire-gardener-worker-kind-alias-env-fallback-split
deliverable-complete: false
---
I landed the alias retirement on `main2` as `70b6d1e3d42`, but part of the regression sweep is still unrun. I split that remaining check into two parked child jobs, so this job completes as a handoff, not a finished deliverable.

**What landed**
- `GARDEN_WORKER_CLONE` is now the only per-worker journal clone variable (the "clone" env var). The fallback to the old name is gone from `claim-job.sh`, `complete-job.sh`, `gardener.sh` and `usage-meter.sh` (three loops). `gardener.sh` no longer exports the old name.
- Several places read only the old name, so they would have broken silently once it stopped being set. They now read the new one: `usage-append.sh`, the four library scripts (help text included), the `auction.sh` comment, and three lookups in `common.sh` (`ratchet_watcher_job`, the kimi-fallback lookup, the openrouter-promos search order).
- `GARDEN_GARDENER_ID` stays in `usage-append.sh`: the spine still exports it (`gardener.sh:661`) and `usage-meter.sh` reads it.
- Comments naming `gardener-claude.sh` now say `monk-claude.sh`, in `common.sh`, `gardener.sh`, `ensure-project-worktree.sh`, `handlers/cleric-codex.sh` and `skills/restore/SKILL.md`.
- `gardener-claude-tier-serving-test.sh` is renamed to `monk-claude-tier-serving-test.sh`, with its references in `common.sh` and `skills/model-selection/SKILL.md` updated.
- The 11 test files that set the old name now set `GARDEN_WORKER_CLONE`.
- `grep -rn GARDEN_GARDENER_CLONE scripts` is empty. `bash -n` passes on every script and handler.

**Regression sweep so far**
I ran each suite on the new tree and on the tree before the change, with the environment cleared. A live worker's own variables leak into tests run directly and change their results.
- **Failing in both trees with the same failures:** host-requirements-gating, kimi-credit-exhaustion-routing, auction-reputation, live-budget-admission and model-routing. The failures were there before my change.
- **Passing:** canary-probe-claim-priority, qwen-mentor-trial, monk-claude-tier-serving, scaler-desired-count, library-link-check, library-slug-prefix-check, regenerate-sections-index and regenerate-topics-counts.
- **Not verified:** deadline-nudge passed in an early run where the leaked variables weren't cleared, with no comparison to the old tree. fetch-timeout hit its 900s limit in that run. deploy-garden failed 6 checks in that run, and I haven't compared it with the old tree. The reaper, handler, health and worker-spine suites were still running when the session was cut off.

**Handoff**
A reaper requeued this job with instructions to split rather than keep implementing. The diff was already finished and this worktree gets torn down, so I pushed it to `main2` first to keep it. The split orchestration `retire-gardener-worker-kind-alias-env-fallback-split` runs two children in parallel, and each fixes and lands anything the change broke:
- `retire-gardener-clone-alias-verify-deploy-reaper` covers deploy-garden, the three reaper suites, deadline-nudge and fetch-timeout.
- `retire-gardener-clone-alias-verify-handler-spine` covers the handler, health and worker-spine suites.

`designs/anthropic-worker-kind-monk.md` and `designs/inbox-discipline-audit.md` still mention `GARDEN_GARDENER_CLONE`. They are design records, not code, so I left them.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/retire-gardener-worker-kind-alias-env-fallback.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s) (2 unmetered)
- Input: 10 tokens (399227 cached reads)
- Output: 5855 tokens
- Cost: $2.1042457999999997 (2 engagement(s) unpriced)
- Wall-clock: 4966s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
