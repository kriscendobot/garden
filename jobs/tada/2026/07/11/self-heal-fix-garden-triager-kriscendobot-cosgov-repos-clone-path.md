The work is verified and the maintainer is flagged. My worktree is clean — no commit or push is needed because the requested change is already on `origin/main2`.

---

## Completion report

**Requested change was already landed on `origin/main2` — nothing to commit.**

The job asked to change the `GARDEN_REPOS` default from `$GARDEN_ROOT/repos` to `$GARDEN_ROOT/worktrees` in `scripts/jobs/triager.sh` and `scripts/jobs/comment-watcher.sh`, update the header comment, and keep the tests green. All of that is already committed on `origin/main2` (my worktree base):

- Fix commit `118f7384fc` ("fix(jobs): triager/comment-watcher default bare-clone dir to worktrees/") plus follow-ons `9ad9c72931`, `54156852da`, `1628b0995e`, and the self-provision pair `2c76c8cd92`/`4c0e275b0b`.
- The job's own line numbers (`triager.sh:25`, `comment-watcher.sh:179`) place it against the pre-fix tree; in the current tree the defaults live at `triager.sh:38` and `comment-watcher.sh:191` and both read `worktrees`.

**Verification performed:**
- Both defaults now read `${GARDEN_REPOS:=$GARDEN_ROOT/worktrees}`; the buggy `:=$GARDEN_ROOT/repos}` default is gone from the entire `scripts/` tree.
- The `# under $GARDEN_REPOS/<slug>.git` header comment in `triager.sh` is updated to reference `worktrees/`.
- The `[ -d "$BARE" ]` guard now passes for `kriscendobot-endo` (and the other repos with a `worktrees/<slug>.git` clone: finbot, agoric-sdk, minion.town, vattr97).
- `scripts/jobs/test/comment-watcher-test.sh`: **211 passed, 1 failed** — the single failure ("source child never started — CPID=''") is an unrelated sandbox subprocess-spawn/PATH-masking artifact, not related to `GARDEN_REPOS`; the tests that override `GARDEN_REPOS="$TR/norepos"` still pass.

**What I changed:** nothing in the tree (the fix pre-exists). My worktree is clean.

**Flagged to the maintainer (via the liaison inbox, `20260711T005732Z-31c24e`):**
1. **Deploy gap — this is why the fleet is still down at runtime.** The source fix is on `main2`, but the *deployed* root `/home/kris/garden2` is at `688e6174c8`, which predates the fix — its `triager.sh:25` still reads `/repos`, so every `garden-triager@*` is still crash-looping (confirmed live in `journalctl` as of 00:55Z, even for repos that have a `worktrees/` clone). The deployed root is ~10 commits behind `origin/main2`. Actually restoring the fleet requires a deliberate drained `deploy-garden.sh` — a liaison/leader operation, out of scope for a gardener code job.
2. **Out-of-scope instances (per the job note).** After deploy, `kriscendobot-cosgov`, `kriscendobot-ocapn`, and `kriscendobot-agoric-3-proposals` will still fail — no standing clone under `worktrees/` at all. Resolving them (provision via clone-keeper tracked set, or disable) is a separate maintainer decision that intersects the CLAUDE.md § Monitoring safety watch-set authorization requirement, so I flagged rather than silently arming new watched repos.

**Follow-ups:** (a) run a deliberate deploy to advance the deployed root past `118f7384fc`; (b) maintainer decision on the three clone-less instances.
