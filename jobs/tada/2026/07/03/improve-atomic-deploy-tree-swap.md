Both suites pass against the committed, pushed tree.

## Completion report

**Job:** Harden `scripts/jobs/deploy-garden.sh` so advancing the root checkout never exposes a window where a running `garden-*` unit execs a half-written script (the recurring rc=127 storm).

**Root cause.** The MERGE step did an in-place `git merge --ff-only`. Git applies a modified file by unlink+create, so during the merge there's a per-file window where the path is absent or partially written. Every `garden-*` unit execs its script by absolute path (`/bin/bash @GARDEN_ROOT@/scripts/jobs/<x>.sh`), so any unit that execs during that window — a timer-driven oneshot firing, the gardener-scaler re-`enable --now`ing an exited-because-drained gardener, or a service crash-restart — opens a half-written/absent script and dies rc=127, marked Failed.

**Fix (the preferred "make the tree advance atomic" option, at per-file granularity).** New sourced library `scripts/jobs/deploy-tree-swap.sh` provides `atomic_advance_tree`, which replaces the in-place merge:
- Phase 1 stages every incoming blob (add/modify/type-change/symlink) as a sibling temp file — the slow, failure-prone work — touching no live path.
- Phase 2 `rename(2)`s each staged file into place. rename is atomic within a filesystem, so an opener always sees the whole old or whole new inode, never a partial one and never ENOENT. Deletions (retired-unit scripts, which the reconcile step disables) are applied after.
- `git reset --mixed` then advances HEAD+index without touching the placed working tree, leaving `git status` clean.

Because **nothing is stopped or masked**, no singleton timer tick is dropped — a tick that fires mid-swap simply execs a complete script. (The whole-directory rename the design doc floats isn't available: `$GARDEN_ROOT` is the bot's bind-mounted home and can't itself be renamed, so the swap is per-file.) `deploy-garden.sh` branches on the function's rc: 1 = aborted before touching any live file (safe, lift + retry), 2 = half-advanced (surface it; the next deploy's dirty/divergence check refuses to advance over the half-state). The capture uses `|| ff_rc=$?` so `set -e` doesn't abort before branching.

**Changed files:** `scripts/jobs/deploy-tree-swap.sh` (new), `scripts/jobs/deploy-garden.sh` (MERGE step + header), `scripts/jobs/test/deploy-tree-swap-test.sh` (new), `designs/deliberate-deploy.md`. Committed `060e105b5`, pushed to `main2` (first-try CAS).

**Verification (evidence, real runs):**
- `deploy-tree-swap-test.sh` — **17/17 pass**. Covers correctness (adds/modifies/deletes/mode-flips/symlinks reproduce up_sha exactly, clean tree, no temp litter), and **atomicity**: a concurrent hammer that exec's a swapped script across 25 real swap rounds observed **zero rc=127 and zero partial reads**; and safe-abort (an unstageable blob aborts before touching any live file, tree unchanged).
- `deploy-garden-test.sh` — **63/63 pass** (unchanged; drain/quiesce/defer/reconcile/restart behavior preserved).
- `shellcheck -x` clean on the new library; `bash -n` clean.

**Not verified / scope note:** I did not trigger a live systemd deploy (deploy-garden.sh runs against the live root on the leader host; running it from a job worktree would be wrong). The "zero rc=127 in the `garden-*` journalctl tail" acceptance is closed **by construction** (POSIX rename atomicity) and demonstrated by the hermetic hammer test; the production journalctl confirmation will land on the leader's next real deploy through this path.

**Follow-ups (minor, non-blocking):** (1) File *deletions* remain a non-atomic unlink, but only affect going-away paths whose units the reconcile step disables. (2) During the brief multi-rename window a just-exec'd new script could momentarily `source` an old sibling (e.g. common.sh) — both files are always complete, so this is at most a transient semantic mismatch, never an rc=127, and is strictly better than the prior behavior.
