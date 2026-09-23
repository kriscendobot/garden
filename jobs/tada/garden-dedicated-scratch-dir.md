Done. Here is my completion report.

---

## Completion report: `garden-dedicated-scratch-dir`

**Pushed to `origin/main2` as `d6eb03aa`** (parent `73f21ceb`), built in an isolated worktree off `origin/main2` (bot identity `endolinbot`), torn down on completion — no new clutter added to the live tree.

### What changed (5 files, +121/−3)

1. **`.gitignore`** — added `/scratch/` (the `GARDEN_SCRATCH` tree), with a comment explaining it can never be tracked so it can never block the watchman fast-forward.
2. **`scripts/jobs/common.sh`** — the helper API:
   - `GARDEN_SCRATCH` env, defaulting to `$GARDEN_ROOT/scratch` (overridable).
   - `scratch_dir <base>` → creates and echoes a fresh private `$GARDEN_SCRATCH/<base>-<short-rand>/` (random suffix so concurrent jobs sharing a base don't collide; base sanitized for a well-formed path; `openssl` with a `$RANDOM` fallback so no hard dependency).
   - `scratch_cleanup <dir>` → deregisters it via `git worktree remove --force` if it's a worktree, then `rm -rf`. **Refuses to remove anything outside `$GARDEN_SCRATCH`**, so a bad argument can never delete a live tree. Best-effort, never fails its caller.
3. **`scripts/jobs/reaper.sh`** — a `gc_scratch` janitor (called each reaper tick alongside the stuck-fetch janitor) that GCs `$GARDEN_SCRATCH/*` entries whose whole subtree has been untouched for `GARDEN_SCRATCH_GC_AGE` hours (default 24) — mtime-quiescence as the "no live owner" proxy — deregistering any worktree first. So a job that dies mid-flight self-cleans.
4. **`roles/COMMON.md`** — new **§ Scratch discipline**: *never create scratch files or ad-hoc worktrees in the live garden tree root; use `$GARDEN_SCRATCH` via `scratch_dir`/`scratch_cleanup`*, including the isolated-infra-worktree-off-`origin/main2` case (`git worktree add --detach "$(scratch_dir infra-<slug>)" origin/main2`).
5. **`skills/worktree-per-pr/SKILL.md`** — the baseline `git worktree add --detach` trick now routes its temp worktree through `scratch_dir`.

### Verification
- `bash -n` clean on both scripts; `shellcheck -S warning` introduces no new warnings (pre-existing `SC2034`/`SC2010` in untouched code left alone).
- Functional: `scratch_dir` creates under `$GARDEN_SCRATCH` ✓; `scratch_cleanup` removes ✓; refusal guard preserves a live tree outside scratch ✓.
- gitignore: a file under `scratch/` shows nothing in `git status` ✓ (`git check-ignore` → `/scratch/`); a worktree added under `scratch/` does not appear as untracked at root ✓.
- Confirmed both `scratch_dir` and `/scratch/` are present on `origin/main2` after the push.

### Clutter cleanup — **left all, removed none** (deliberate, per the job's caution)

The seven root-level scratch dirs were all touched within ~3 hours (the reaper's own death threshold is 24h quiescence, so none qualify as dead), and most have a plausibly-active owner:

| dir | nature | mtime | decision / why |
|---|---|---|---|
| `cm-dynimport-archival` | **registered worktree** of `endo-but-for-bots.git` | 18:00 | leave — compartment-mapper, `finish-ebfb-pr96`/`port-ebfb-pr57` active in `doin` |
| `cm-fix-exit-reexport` | **registered worktree** of `endo-but-for-bots.git` | 18:01 | leave — same |
| `scholar-cask-c15-endolinbot-g24` | **registered worktree** of garden `.git` | 17:32 | leave — `scholar-ingest-cask` active in `doin` |
| `cask-scratch-c15` | plain clone | 15:32 | leave — scholar-cask job active |
| `scholar-cask-scratch` | plain dir | 17:02 | leave — scholar-cask job active |
| `mirror-3254-journal` | plain dir | 17:08 | leave — job explicitly names mirror-3254 as possibly-live; recent mtime |
| `mirror-3254-work` | plain dir | 17:04 | leave — same |

No process currently holds any of them as cwd, but a gardener blocked on its LLM holds no cwd, so that is not proof of death — and three are registered worktrees whose removal would disrupt the active `cm-*`/`scholar` jobs. Deleting them is irreversible and risks clobbering live work, which the job tells me to avoid when ownership is unclear. So I left them and reported rather than risk it.

### Follow-ups
- These seven legacy dirs predate the convention and live at the **root**, not under `$GARDEN_SCRATCH`, so the new janitor will not auto-collect them. Once they go quiescent past 24h (and their owning jobs leave `doin`), a one-time sweep can remove any still present — or, better, a small extension to `gc_scratch` could also sweep known legacy root patterns. I did not do this now to avoid touching live work; flagging it for a future low-risk pass.
- Inbox drained at checkpoints (empty). No structural lesson worth a `message` to the liaison beyond what's already encoded in `COMMON.md` § Scratch discipline.
