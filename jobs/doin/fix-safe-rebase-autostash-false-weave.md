---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: fixer
# safe-rebase.sh: inherited rebase.autostash=true falsely refuses clean rebases as "needs-weave"

Repo: kriscendobot/garden (main2). Script: scripts/jobs/gardening/safe-rebase.sh (called by ci-wait-merge.sh / rebase-pr-before-merge.sh).

Evidence (2026-10-17, conductor job screen-minion-town-pr194-bf3d844-conduct, host oros-studio-garden-ce242c49):
kriscendobot/minion.town#194 head bf3d844 onto main 3d161b9ef1f. safe-rebase aborted with
"error: Your local changes to the following files would be overwritten by merge: DEPLOYMENT.md, test/caddy-account-routes.test.ts, test/shell-clip.test.ts"
on a CLEAN worktree, then "REFUSED — non-deterministic conflict" with an EMPTY conflicted-paths list, and ci-wait-merge reported rebase-blocked reason=needs-weave.
Reproduced in a fresh clone with /usr/bin/git 2.43.0. The host's inherited global ~/.config/git/config sets rebase.autostash=true (plus rebase.stat, autosquash).
`git -c rebase.autostash=false rebase 3d161b9ef1f` succeeds cleanly (both commits); `git cherry-pick f3dadcf bf3d844` onto main also applies cleanly. So there is NO real conflict.

Fix: make safe-rebase.sh hermetic — call hermetic_gitconfig (scripts/jobs/common.sh) or pin `-c rebase.autostash=false` on its rebase, and treat an abort with zero conflicted paths as a tooling error, not needs-weave. Add a regression case to scripts/jobs/test/safe-rebase-test.sh with GIT_CONFIG_GLOBAL carrying rebase.autostash=true.
After landing, the minion.town screener will re-post the conductor for #194 (or re-run ci-wait-merge --screened-delegated-merge for it).

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-17T03:40:57Z
