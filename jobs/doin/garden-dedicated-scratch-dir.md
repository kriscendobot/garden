# Carve out a dedicated, gitignored scratch directory and route all job scratch/worktrees through it

Wear the **mentor/gardener** role. Jobs are leaving **ad-hoc scratch directories and worktrees
in the live `/home/kris` tree root** (observed: `mirror-3254-work/`, `mirror-3254-journal/`,
`cm-dynimport-archival/`, `cm-fix-exit-reexport/`, `cw-pr96-dtypes/`, `cask-scratch-c15/`,
`scholar-cask-c15-…/`, etc.). This clutters the tree and — when a job dirties tracked files —
**wedges the watchman** (the recurring deploy outage). Fix the root cause: a dedicated scratch
location, gitignored, that every job uses. Infrastructure on `main2` (bot identity; **isolated
worktree off `origin/main2`** — do not add to the clutter).

## What to build

1. **Dedicated scratch dir + .gitignore.** Establish `scratch/` at the garden root as the one
   place for ephemeral job scratch and ad-hoc worktrees, and add it to `.gitignore` (e.g.
   `/scratch/`). It must never be tracked, so it can never block the watchman fast-forward.
2. **A `common.sh` helper + env.** Define `GARDEN_SCRATCH="${GARDEN_ROOT}/scratch"` and a helper
   (e.g. `scratch_dir <base>` → makes and echoes `$GARDEN_SCRATCH/<base>-<short-rand>/`, created
   on demand) so a job gets a private scratch path with one call. A companion `scratch_cleanup
   <dir>` removes it (and `git worktree remove` if it is a worktree).
3. **Route job scratch/worktrees through it.** Update the conventions so jobs build there, not in
   the live tree root:
   - The **infra-job isolated-worktree discipline** (the "worktree-add off origin/main2" guidance
     in `roles/COMMON.md` and the relevant skills) must place the worktree **under
     `$GARDEN_SCRATCH/`**, not at the garden root.
   - `skills/dispatch-worktree` and any role that creates scratch dirs/worktrees (mirror/boatman,
     scholar, the compartment-mapper fix jobs, builders) reference `GARDEN_SCRATCH`.
   - State plainly in `COMMON.md`: **never create scratch files or worktrees in the live garden
     tree root; use `$GARDEN_SCRATCH/<base>/` and clean up when done.**
4. **Clean up the existing clutter — carefully.** Remove the *stale* scratch dirs from the live
   tree, but **do NOT delete a dir backed by an active job/worktree** (a fix-compartment-mapper or
   mirror-3254 job may still be using one). Detect active worktrees (`git worktree list`) and
   running-job association; only remove dirs with no live owner. Report what was removed vs left.
5. **Janitor (optional but recommended).** A periodic GC (in the reaper or a small janitor) that
   removes `$GARDEN_SCRATCH/*` entries older than N hours with no associated live process/worktree,
   so scratch self-cleans.

## Tests & verification

- `scratch_dir`/`scratch_cleanup` create/remove under `$GARDEN_SCRATCH`; `scratch/` is gitignored
   (a file under it shows nothing in `git status`); a worktree added under `$GARDEN_SCRATCH` does
   not appear as untracked at the root. `shellcheck`/`bash -n` clean.

## Definition of done

`scratch/` gitignored, `GARDEN_SCRATCH` + `scratch_dir`/`scratch_cleanup` helpers in `common.sh`,
the worktree/scratch conventions (COMMON.md + the relevant skills) routed through it, the stale
live-root scratch dirs cleaned up (active ones preserved), and optionally a janitor — committed
and pushed to `origin/main2`. Report the SHA, the helper API, what scratch dirs were removed vs
left active, and where the convention landed. If a scratch dir's ownership is unclear, leave it
and report rather than risk clobbering live work.

Posted by the liaison on behalf of the maintainer.

---
claim:
  host: endolinbot
  gardener: 57
  claimed_at: 2026-06-25T18:31:36Z
