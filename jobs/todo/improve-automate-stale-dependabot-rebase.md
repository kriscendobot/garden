---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gardening/garden-pr.sh
Replace the rebase-stage placeholder with a deterministic fresh-base/head check and safe rebase path. The approved Dependabot PR #868 was conflicting/dirty and required a gardener to manually rebase its reviewed commits and resolve `yarn.lock` before CI and merge; automating the routine stale-branch recovery will keep that work out of agent discretion while failing closed for non-deterministic conflicts.
