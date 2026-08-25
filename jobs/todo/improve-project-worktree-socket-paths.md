---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/ensure-project-worktree.sh
Bound the job-base portion of deterministic project-worktree paths with a stable hash suffix. The current full base can still exceed Unix socket limits despite the repo/branch digest; make daemon suites reliable without relying on agents to choose short slugs.
