---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/handlers/worker-common.sh
At worker-common.sh:93 `worker_ensure_worktree` dies with no cause when every `rev-parse --verify` in the ref loop (line ~72) fails. `last_err` is only set by a failed `worktree add`, and the loop never reaches that when no ref resolves. On 2026-10-11 at 08:50 the monk on oros-studio logged "could not create per-job worktree /Users/dom/garden/scratch/gardener-wt-claude-on-minion-town-press-20261010-133536 off any of origin/main2, main2, HEAD" with no suffix. The job was then left in doin for the reaper. Record why each ref failed, such as GARDEN_ROOT not being a git repo, a missing origin/main2 or an unborn HEAD. Add those details to the die message. Run `git -C "$GARDEN_ROOT" fetch origin main2` once and retry before giving up. Also check that `$GARDEN_ROOT` is a work tree up front and fail with an explicit "GARDEN_ROOT=... is not a git checkout" message. That way a host with a bad checkout is classified as a host fault and the job requeues, instead of burning the job's attempts.
