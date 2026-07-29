from_host: endolin-garden2-5bcdff64
from: reaper:endolin-garden2-5bcdff64
sent_at: 2026-07-29T08:23:08Z
poison_base: endojs-endo-but-for-bots-pr403-weave
poison_signature: deadline-overrun
notice_count: 1
first_seen: 2026-07-29T08:23:08Z
last_seen: 2026-07-29T08:23:08Z
---
POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 DEADLINE-OVERRUN cycles on endolin-garden2-5bcdff64.
Its handler hit its OWN wall-clock budget every cycle (rc=124, elapsed≈GARDEN_HANDLER_TIMEOUT=2400s):
this job EXCEEDS THE HANDLER BUDGET and would be killed identically on every requeue,
so the reaper surfaced it after 1 overrun cycles (not the full 5-cycle poison threshold).
The work is preserved at jobs/plan/endojs-endo-but-for-bots-pr403-weave; it stays HELD until a human promotes it
(promote-plan.sh endojs-endo-but-for-bots-pr403-weave) or removes it. Triage: split the job, raise GARDEN_HANDLER_TIMEOUT
for this work, or fix what makes it run long.
Original job base: endojs-endo-but-for-bots-pr403-weave

--- original job body ---
---
role: weaver
---

# Rebase/unfreeze endojs/endo-but-for-bots PR #403 before merge

The conductor for PR #403 re-verified the PR before merge and found it is still OPEN, non-draft, reviewDecision=APPROVED, and CI is green on the frozen base `llm-c85d618`, but it cannot be safely merged as-is because the live trunk has moved.

Required work:
- Repo: endojs/endo-but-for-bots
- PR: https://github.com/endojs/endo-but-for-bots/pull/403
- Head branch: `feat/registry-capability`
- Current head: `051baffb9e38eeca14421f6c24732dc8cd7210cf766432`
- Current PR base: `llm-c85d618`
- Live `llm` at conductor check: `bfc91f55802c0b2fb63257b86762bf0dd5645c64`

Conductor evidence:
- `gh pr view 403 -R endojs/endo-but-for-bots --json state,isDraft,mergeable,mergeStateStatus,reviewDecision,baseRefName,headRefOid,statusCheckRollup` showed `state=OPEN`, `isDraft=false`, `mergeable=MERGEABLE`, `mergeStateStatus=CLEAN`, `reviewDecision=APPROVED`, all checks `SUCCESS`, base `llm-c85d618`, head `051baffb9e38eeca14421f6c24732dc8cd7210cf766432`.
- `git rev-list --left-right --count origin/llm...origin/feat/registry-capability` showed `1258 26`.
- `git merge-tree --write-tree origin/llm origin/feat/registry-capability` failed with conflicts in `.changeset/daemon-cas-extraction.md`, `.gitignore`, `packages/daemon-cas/*`, `packages/daemon/package.json`, `packages/daemon/src/manager-persistence-powers.js`, `tsconfig.composite.json`, and `yarn.lock`.

Please weave/rebase PR #403 onto current `llm` using the frozen-base branch discipline, resolve conflicts per the weaver role, run affected verification, force-push with lease, and update the PR base to the new frozen base. After it is green again, a conductor can merge it.

<!-- garden-deadline-overrun: 1 -->
