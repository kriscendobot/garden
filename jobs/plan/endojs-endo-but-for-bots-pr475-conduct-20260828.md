---
gate: orchestrated
orchestrated_by: endojs-endo-but-for-bots-pr475-retcon-conduct-20260828
priority: normal
posted_by: gardener
posted_at: 2026-08-28T03:24:48Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# conduct (merge) endojs/endo-but-for-bots PR #475

Maintainer directive (kriskowal, pr-comment 5447969981, 2026-08-28): "Retcon and conduct." This is the conduct half; it runs AFTER the retcon child completes.

Repo: endojs/endo-but-for-bots
PR: https://github.com/endojs/endo-but-for-bots/pull/475
Head branch: feat/narrow-bytearray-to-uint8
Base branch: llm-e22e67a (frozen-base snapshot → unfreeze to `llm` per conductor loop)

Wear the conductor role (roles/conductor/AGENT.md). Drive the merge to completion via
scripts/jobs/gardening/ci-wait-merge.sh: unfreeze the frozen base to the live `llm`
trunk, rebase through safe-rebase.sh, wait for terminal-green CI on the resulting head,
require a current maintainer approval on that head, then `gh pr merge --merge`.
NOTE: the retcon force-push (and any rebase) rewrites the head, so a prior approval is
stale by design — stall `merge blocked: no maintainer approval` on the retconned/rebased
head until kriskowal re-approves; do NOT merge without a fresh allowlist approval. After
merge, sweep the frozen `llm-<sha>` base branch per skills/frozen-base-branch.
