---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
`garden-state-clone-keeper.service` fails rc=127 ("No such file or directory" for `scripts/jobs/state-clone-keeper.sh`) because the deployed root checkout's HEAD has silently regressed behind the systemd units rendered for it.

Signature: root HEAD is at `252205765d`, but `.garden-state/deploy/deployed-sha` (and the rendered `garden-state-clone-keeper.{service,timer}`, mtime 06:42Z today) reflect `3cfbeb5ac4` — a later commit that actually contains `scripts/jobs/state-clone-keeper.sh` (added `830a4b299b`, extended `ce57d564b7`). `git reflog show HEAD` in `$GARDEN_ROOT` shows the regression path: a legitimate deploy landed `3cfbeb5ac4` at 06:42:50Z, then at 19:44:22Z something `reset --hard`'d root's HEAD to `origin/journal2` (the shared-repo-corruption class documented in root-repo-guard.sh's header, incident 2026-07-17/07-21 — a job ran git with `$GARDEN_ROOT` as its enclosing repo), then at 19:48:50Z an out-of-band `git reset --hard 252205765d` "fixed" it — but to an arbitrary old commit, not the recorded deploy point. Both fix-up entries are plain `reset`, not `deploy-garden.sh`'s `checkout --detach --force`, so this wasn't the deploy path or the guard's repair.

Root cause in `scripts/jobs/root-repo-guard.sh`'s `guard_head()` (invariant B, ~line 234): it treats HEAD as healthy whenever it is `detached AND an ancestor of origin/main2` — it never compares HEAD against `deployed_sha()`. `252205765d` satisfies that check (it genuinely is an older main2 ancestor), so the guard has never flagged or repaired this drift; there is no `root-repo-head-repaired`/`-deferred` alert for this host despite the tree being ~42 commits stale relative to what was deployed and what the live systemd units expect.

Fix: tighten `guard_head()` so a detached HEAD that is a main2 ancestor but does NOT equal the current `deployed_sha()` (and is not on a draining deploy) is also treated as drift — re-detach to `deployed_sha()` (same repair path already used for the branch-drift case, backing up the pre-repair HEAD to `root-guard-backup/<ts>` as it does today) and alert. Add a case to `scripts/jobs/test/root-repo-guard-test.sh` for "HEAD detached at a valid-but-stale main2 ancestor, not the deployed sha" to lock in the repair. As immediate remediation this host's root also needs re-advancing to the current deployed sha (or a fresh `deploy-garden.sh` run) so the tree matches the already-rendered units.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-03T22:26:25Z
