Inbox empty. All work is complete and verified. Writing the completion report.

---

## Completion report

**Job:** Fix `triager.sh` dying with `FATAL: no bare clone`, plus its two compounding defects.

### What I found
The branch had **already advanced** past the state the job was written against. A prior run of this job landed the two production fixes on `origin/main2`:
- **Item 1 (path mismatch):** `GARDEN_REPOS` now defaults to `$GARDEN_ROOT/worktrees` in both `triager.sh:38` and `comment-watcher.sh:191` (commits `9ad9c72931`, `1628b0935e`; a peer later added a shared `bare_clone_dir` resolver, `83e0eb0f41`, so the two can't drift).
- **Item 2 (self-provision refactor):** `triager.sh` no longer dies on a missing clone. It guards on `! is_own_git_repo "$BARE"`, then: surfaces a present-but-corrupt dir without clobbering; default-skips a clone-less host (self-provision opt-in); or self-provisions via the shared `derive_clone_url`+`bounded_clone` helpers (sibling temp + atomic `mv -T`), escalating unreachable/underivable sources to the maintainer inbox (commits `2c76c8cd92`, `4c0e275b0b`, `372e5e7584`). The `common.sh`/`clone-keeper.sh` helper extraction is committed.

### Item 3 — instance-set reconciliation (the open question)
**Conclusion: do NOT disable any instances — all three flagged slugs are authorized.** `kriscendobot-{ocapn,cosgov,agoric-3-proposals}` each have a proper watch-arming record in `journal/repos/`, owner `kriscendobot` is in `journal/config/fork-owners`, and they were auto-armed under the **own-fork auto-provisioning exception** (kriskowal broadcast `20260709T225552Z-e61229`, "watch the garden's own forks"). The job's original "in neither set" diagnosis predates/missed these arming records. Clones for all watched forks — **including `kriscendobot-ocapn`, which the fleet materialized during this job** (absent at start, present now) — are present on this host.

### What I changed
The one remaining defect surfaced during verification: **both test suites keyed fixtures to a fixed shared path** (`/home/kris/.garden-{triager,cw}-test`), which flakes under the ~20-gardener fleet (concurrent `rm -rf; mkdir` → `ENOTEMPTY`; comment-watcher's teardown `rm` failed live). I converted both to **per-run `mktemp` roots with EXIT-trap teardown** (mirroring the mermaid-validation precedent `97d4ec5742`), rooted at `dirname "$HOME"` — the only location that is both exec-capable (`/tmp` is `noexec` here, and the suites exec stubs) and outside a git tree (`$HOME` is the garden checkout, which would break case J's `git rev-parse` corrupt-dir proxy). Committed and pushed to `main2` as `54ed2c98f0`.

### Verification
- Triager end-to-end against the **real** `worktrees/kriscendobot-vattr97.git` (throwaway journal + stub handler): resolves the bare clone, reaches the handler, exits 0 — **no FATAL**.
- Same for `kriscendobot-ocapn` (now that its clone exists on this host).
- Confirmed production `is_own_git_repo` is **correct** (requires `git-dir == path`, so a corrupt dir inside the garden repo is not a false positive) — the walk-up issue was only the test's proxy assertion.
- All suites deterministic across repeated runs on the rebased tree: triager 68/0, comment-watcher 213/0, handler 7/0, clone-keeper 45/0.

### Follow-ups
- **Deploy:** the deployed root (`/home/kris/garden2`) still carries the pre-commit uncommitted diffs to `common.sh`/`clone-keeper.sh`; the authoritative refactor is committed on `main2`, so a deliberate `deploy-garden.sh` (liaison's deploy-on-upgrade Monitor) will cleanly supersede them. Not actionable from a gardener worktree.
