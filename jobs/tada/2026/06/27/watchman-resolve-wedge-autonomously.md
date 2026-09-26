Job complete. All work landed on `origin/main2` at `ec70f0e03`.

## Completion report — watchman-resolve-wedge-autonomously

**Outcome:** The watchman (and deploy-sync) now resolve dirty-tree wedges on the shared `main2` checkout **autonomously** instead of paging the maintainer, per the 2026-06-27 directive. Built in an isolated worktree off `origin/main2`, committed with explicit pathspecs, pushed via rebase CAS (first attempt), worktree torn down.

**What changed (7 files):**
- **`scripts/jobs/wedge-resolve.sh`** (new, sourced): shared `trigger_wedge_resolution()`. On a wedge it posts an **idempotent, throttled** `resolve-wedge-<host>-<sha>-<pathhash>` job to the board instead of emailing the maintainer. Deterministic basename + a per-signature throttle marker mean watchman and deploy-sync never double-resolve, and a persistent unresolvable wedge doesn't spin (the reaper requeues the posted job by TTL).
- **`scripts/jobs/resolve-wedge.sh`** (new, executable): the deterministic finisher dance the claimed job invokes. Operates directly on the shared tree (the one correct in-place case — it's *cleaning*, not adding work) and classifies each blocking path: tracked edit byte-identical to origin → `git checkout HEAD --`; untracked file identical to its incoming copy → `rm`; **genuine WIP** (differs from both HEAD and origin) → **preserved** via `git stash` (tracked) or move into scratch (divergent untracked collision). Never a blind `reset`/`checkout .`/`clean`; touches only blocking files; exits non-zero (retry) if unexpected dirt remains.
- **`scripts/jobs/watchman.sh`** / **`deploy-sync.sh`**: both wedge call-sites now call `trigger_wedge_resolution`; removed the `notify_dirty_wedge` maintainer-paging function; updated header comments.
- **`roles/watchman/AGENT.md`**: encodes the wedge-resolution responsibility and the explicit "never page the maintainer for a wedge" norm.
- **`scripts/jobs/test/wedge-resolve-test.sh`** (new, 32 cases): lossless drop/rm, genuine-WIP-stashed-and-recoverable, non-colliding-untracked-left-alone, divergent-untracked-preserved-off-tree; watchman tracked-wedge and untracked-collision each **post a job and do NOT page the maintainer**; throttle posts once across two ticks.
- **`scripts/jobs/test/deploy-sync-test.sh`**: injected a post-job mock; DIRTY case now asserts a resolve-wedge job is posted and the maintainer is not paged.

**Verification:** CI-equivalent `bash -n` sweep over all `scripts/`+`skills/` clean; `wedge-resolve-test.sh` 32/32; `deploy-sync-test.sh` 27/27. Shellcheck clean except pre-existing codebase idioms (`GARDEN_TAG` SC2034, the shared `unset $(...)` scrub line) — matched to existing convention.

**Follow-ups:**
- The claimed resolve-wedge job's *only* non-deterministic step is deciding whether preserved/stashed WIP should land — left to the claiming gardener by design.
- Root-cause (gardeners editing the SHARED tree instead of an isolated worktree) is acknowledged in the job as a separate norm-push; this change makes the symptom self-healing but does not address the source. There is already a standing memory/norm for isolated-worktree discipline on infra jobs.
