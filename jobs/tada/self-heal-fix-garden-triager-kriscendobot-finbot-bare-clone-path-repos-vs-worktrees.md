The job's requested fix is **already fully present** in the current `main2` tree — no code changes were needed. The root cause described in the job was resolved by the commit chain `2c76c8cd92`→`54ed2c98f0`, which landed after this self-heal job was posted.

## Completion report

**Investigation.** The job cited `triager.sh:24` / `comment-watcher.sh:179` defaulting `GARDEN_REPOS` to `$GARDEN_ROOT/repos`, causing a fleet-wide `FATAL: no bare clone` for every watched repo. I checked the current tree and found that default no longer exists anywhere in `scripts/`.

**What is already in place (root cause fixed):**
- Both `triager.sh:46` and `comment-watcher.sh:326` now resolve the bare clone through the shared `bare_clone_dir()` helper (`common.sh:480`), which defaults `GARDEN_REPOS` to `$GARDEN_ROOT/worktrees` — exactly the fix the job prescribed. Sharing one resolver prevents the two defaults from drifting (commit `83e0eb0f41`).
- The `GARDEN_REPOS` env-override contract is preserved (`${GARDEN_REPOS:-$GARDEN_ROOT/worktrees}`), so the test harness's `GARDEN_REPOS=$TR/norepos` still exercises the missing-clone path.
- The secondary concern from the job ("should triager degrade rather than FATAL?") is also handled: the old `die` is gone (`triager.sh:73–115`), replaced by skip (default) / opt-in self-provision / throttled maintainer escalation for corrupt or underivable clones (commits `2c76`, `4c0e`, `372e`).

**Verification performed:**
- `bare_clone_dir kriscendobot-finbot` resolves (default, no override) to `/home/kris/garden2/worktrees/kriscendobot-finbot.git`, confirmed a valid bare repo with `refs/remotes/origin/main`.
- `comment-watcher-test.sh`: **213 passed, 0 failed**.
- `triager-test.sh`: **68 passed, 0 failed** (including case I locking the `worktrees/` default and the corrupt-clone escalation cases).
- `triager-claude-handler-test.sh`: **7 passed, 0 failed**.
- `grep` for any stale `GARDEN_REPOS:=.../repos` default across `scripts/`: none.

**Changes committed / pushed:** none — the tree already contains the fix; there was nothing to change.

**Follow-ups:** The live fleet failures were observed against the *deployed* garden root, which advances only via the deliberate drained `deploy-garden.sh`. If any instance is still emitting the FATAL signature, it is running a pre-`2c76` deployed checkout and simply needs a deploy to pick up `main2@54ed2c98f0`; no further code work is required.
