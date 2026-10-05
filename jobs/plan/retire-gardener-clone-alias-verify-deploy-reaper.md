---
gate: go-ahead
priority: normal
tier: mentor
token-budget: 60000
doomed: true
doom_signature: requeue-exhausted
doom_count: 1
split_eligible: true
split_reason: repeated-plain-exit
failure_classification: transient
requeue_cycles: 2
deadline_overruns: 0
elapsed_constancy_confirmations: 0
doomed_at: 2026-10-05T11:23:09Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-10-05T11:23:09Z
---

---
tier: mentor
arc: unallocated
token-budget: 60000
---
<!-- garden-promoted-from-plan: gate=deferred priority=normal at=2026-10-05T08:45:02Z cleared=none -->

---
tier: mentor
token-budget: 60000
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-30T22:16:07Z cleared=none -->

---
tier: mentor
fallback-tier: minion
token-budget: 60000
dispatch: automatic
---
Context: parent `retire-gardener-worker-kind-alias-env-fallback` LANDED its full diff on main2 as 70b6d1e3d42 ("refactor(jobs): retire the GARDEN_GARDENER_CLONE env alias"); `grep -rn GARDEN_GARDENER_CLONE scripts` is empty. DO NOT redo it. Remaining work is regression verification only.

Method: run each suite with a SCRUBBED env (`env -i HOME=$HOME PATH=$PATH TMPDIR=$TMPDIR GARDEN_TEST=1 bash scripts/jobs/test/<t>-test.sh`), because a live worker exports GARDEN_WORKER_CLONE etc. that leak into direct runs. Compare against the pre-change tree 70b6d1e3d42^ (extract with `git archive -o $TMPDIR/b.tar 70b6d1e3d42^ scripts && tar -xf $TMPDIR/b.tar -C $TMPDIR/base`) and diff the FAIL lines. Already verified identical-to-baseline (pre-existing failures, NOT regressions): host-requirements-gating, kimi-credit-exhaustion-routing, auction-reputation, live-budget-admission, model-routing. Already passing: canary-probe-claim-priority, qwen-mentor-trial, monk-claude-tier-serving, scaler-desired-count, library-link-check, library-slug-prefix-check, regenerate-sections-index, regenerate-topics-counts. Any NEW failure attributable to 70b6d1e3d42: fix it and land on main2. Report which suites needed updating vs already passed.

Suites for THIS child: deploy-garden, reaper-requeue-cap, reaper-live-handler-guard, reaper-doom-park, deadline-nudge (~10 min), fetch-timeout (>15 min; use a long timeout, foreground).
