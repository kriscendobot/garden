Work complete and pushed to main2. Here's my completion report.

---

## Completion report — `garden-journal-worktree-keeper-autonomous-lossless-selfheal`

Landed on `main2` as `430ac2b82` (pushed, verified at `origin/main2`).

### Part 1 — autonomous lossless self-heal (replaced the hourly page)
Rewrote `scripts/jobs/journal-worktree-keeper.sh` so a DIVERGED (dirty and/or local-ahead) `/home/kris/journal` worktree is now **self-healed losslessly** instead of paging the maintainer and leaving it untouched (the defect: hourly pages for 11+ hours about the same superseded divergence). The new flow mirrors the watchman's established "resolve autonomously, don't page" principle:
1. **Back up first** — `git format-patch origin/journal2..HEAD` for local-ahead commits + a byte copy of every dirty tracked and untracked file, into a host-local dir outside the worktree (`$GARDEN_STATE/journal-worktree-keeper/backups/<host>-<ts>`, with a `status.txt` manifest). The backup *is* the losslessness guarantee.
2. **No-active-writer gate** — refuses to touch the tree while a live agent edits it: `/proc/*/cwd` scan for a process parked in the worktree **and** mtime-stability of the dirty set across a settle window. An active writer aborts the heal (transient; next tick heals). Injectable via `GARDEN_JW_WRITER_PROBE` for tests.
3. **Reset** — `git reset --hard origin/journal2` + targeted removal of the backed-up untracked files (never a blanket clean).
4. **Page only for genuinely unpreservable WIP** (backup itself couldn't be taken). The lossless case never pages again. `GARDEN_JW_SELF_HEAL=0` restores the old posture.

Also updated the service `Description`.

### Part 2 — root cause: stop writes landing in the shared worktree
An Explore subagent traced the two dirt classes. Fixed both at the source with the same live-worktree refusal guard `land-journal-edit.sh` already uses:
- **`journal-entry.sh`** now refuses a producer clone resolving to `$GARDEN_ROOT/journal` (source of the stray `entries/…-result-gardener-*.md`).
- **`insert-sections-table-row.sh`** (the one in-place library editor) now refuses a topic-file target under `$GARDEN_ROOT/journal` (source of the `library/sections/**` + `sources/**` dirt).
- **`roles/scholar/AGENT.md`** norm updated: author section/source/topic files in an isolated staging area, never in-place under the deployed read worktree.

### Tests (all green)
- `journal-worktree-keeper-test.sh`: **37 pass** — superseded divergence auto-healed with no page + backup captured; genuine WIP healed and recoverable from the backup; unpreservable WIP preserved-in-place + paged; active writer aborts (both injected and a **real `/proc`-cwd** background process).
- `insert-sections-table-row-test.sh`: 15 pass (added live-worktree refusal + isolated-clone acceptance).
- `journal-entry-argv-test.sh`: 23 pass (added live-worktree refusal, verifies the live tree stays clean).

### Follow-ups / notes
- The currently-diverged live `/home/kris/journal` will be healed by the deployed keeper on its next `:15/:45` tick once this lands via a deploy — I did not touch the live worktree from this job (per discipline: never operate on another checkout you didn't create).
- The guards are defense-in-depth code (fail loudly), not just role wording — per the "encode the guard in code, not just docs" principle.
