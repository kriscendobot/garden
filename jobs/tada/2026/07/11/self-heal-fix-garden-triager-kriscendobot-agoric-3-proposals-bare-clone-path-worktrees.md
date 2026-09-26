All 68 triager tests pass, including case I — the exact regression guard for this defect — and the two non-test `GARDEN_REPOS` default assignments both resolve to `worktrees/`. No code change is warranted; the fix is already in place.

## Completion report

**Finding: the requested fix is already present in `origin/main2` — this self-heal job is a no-op.**

The job's premise (a live `GARDEN_REPOS=$GARDEN_ROOT/repos` default at `triager.sh:25` producing the `triager.sh:32` "no bare clone at .../repos/<slug>.git" fatal) is **stale**. That defect was already corrected by two prior commits on the branch this worktree is based on:

- `118f7384fc` — first changed the triager/comment-watcher default bare-clone dir from `repos/` to `worktrees/`.
- `83e0eb0f41` — consolidated both defaults into a single shared resolver, `bare_clone_dir()` in `common.sh:480`, whose default is `${GARDEN_REPOS:-$GARDEN_ROOT/worktrees}`. Both `triager.sh:46` and `comment-watcher.sh:326` now call `bare_clone_dir "$slug"`, so their defaults cannot drift.

**Verification performed:**
- `bare_clone_dir kriscendobot-agoric-3-proposals` → `/home/kris/garden2/worktrees/kriscendobot-agoric-3-proposals.git` (the real, healthy clone; HEAD=`main`).
- Ran `triager.sh kriscendobot-agoric-3-proposals` (no-op handler, self-provision off): it fetched the `worktrees/` bare clone and resolved `refs/remotes/origin/main` → `96ece5368…`, logged "no change", exit 0. No `repos/`-path fatal.
- Swept all non-test `GARDEN_REPOS` default assignments: `common.sh:480` and `fork-watch-provisioner.sh:100` both default to `worktrees/`. No reader still defaults to `repos/`. `repos/`/`comment-repos/` remain the watch-set config dirs, untouched.
- Ran `triager-test.sh`: **68 passed, 0 failed**, including case I ("default `GARDEN_REPOS` resolves to `$GARDEN_ROOT/worktrees`, not `/repos`") — the standing regression guard for exactly this bug. Test harnesses still pass `GARDEN_REPOS` explicitly (`comment-watcher-test.sh` → `norepos/`), so they were correctly left alone.

**Changes made:** none. Nothing to commit or push — the desired end state already holds and is test-guarded.

**Follow-ups:** none. The producer that emitted this job (likely a triager self-heal escalation from an instance whose deployed root predates `118f7384fc`) should clear once that instance deploys the current `main2`.
