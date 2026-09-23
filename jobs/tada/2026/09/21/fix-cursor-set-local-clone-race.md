Inbox empty. The work is complete, committed, and pushed to `main2`.

## Completion report

**Root cause (confirmed, more specific than the ticket's diagnosis).** `cursor-set.sh` and `cursor-get.sh` share ONE local journal-cursor clone per host (`$GARDEN_CURSOR_CLONE`, default `$GARDEN_STATE/cursors/journal`), reused by every watcher. Both run their index-touching git steps inside a subshell — `( sync_clone "$DIR" )` — to trap `sync_clone`'s offline `exit`. But `sync_clone` takes `clone_lock` and holds it for the caller's `commit_and_push` to release; wrapped in a subshell, that lock is released the instant the subshell exits — **before** cursor-set's parent-shell `git add`/commit/push (and cursor-get's `reset --hard`) run. So two overlapping invocations raced the same working-tree index → `fatal: unable to write new index file`, worsened by `_sweep_stale_git_locks` deleting a peer's live `index.lock`. (Every *other* subshell'd-`sync_clone` caller keeps its write inside the subshell or re-acquires `clone_lock` — only these two, plus one sibling, had the hole.)

**Fix (`scripts/jobs/common.sh`, `cursor-set.sh`, `cursor-get.sh`).** Added `cursor_io_lock`/`cursor_io_unlock`: a bounded `flock -w $GARDEN_CURSOR_LOCK_WAIT` (default 300s) on a per-clone **sibling** lock file `$DIR.cursor-io.lock` — outside the working tree, so it never collides with git's locks or `clone_lock`'s `$DIR.lock`. Both scripts take it in the **parent** shell and hold it across the whole critical section (a subshell inherits the fd but can't close the parent's, so the lock survives the subshell'd `sync_clone`). Per-clone keying lets distinct `GARDEN_CURSOR_CLONE` overrides serialize independently. On timeout, cursor-set **dies loud**; cursor-get **logs and skips the tick** (temporary-unavailable) — a real wedge surfaces instead of hanging forever. (One subtlety caught in testing: a `2>/dev/null` on a command-less `exec` makes the redirection *permanent* — it silently swallowed the die message; removed it, matching `clone_unlock`'s existing warning.)

**Sibling hazard found and fixed.** Audited every `( sync_clone …)` caller. `publish_fleet_health` (common.sh) had the identical subshell-drops-lock shape on the *heavily-shared producer clone* — fixed by re-acquiring `clone_lock` in the parent before its write (the idiomatic pattern `deadline-nudge.sh` already uses). All other subshell'd callers (`append-*`, `set-budget-pool`, `usage-meter`, `weekly-capacity-calibration`) correctly keep the write inside the subshell — no change needed.

**Verification (real execution).** New `scripts/jobs/test/cursor-set-concurrency-test.sh` fires N concurrent cursor-set writers + cursor-get readers at one shared clone and asserts no index-write fatal, all writes land, per-clone independence, and a bounded loud wedge. Run against **pre-fix** scripts (in an exec-allowed worktree): 2/8 writers fail, writes lost, no wedge detection. Run against the **fix**: 6/6 pass, reproducibly across multiple runs. `bash -n` and `shellcheck -S warning` clean.

**Live-cursor status — NOT recovered.** The committed cursor on `origin/journal2` is still frozen at `last_polled_at: 2026-09-20T20:30:02Z` (last advance committed `2026-09-20T20:32:05Z`, ~25h before now `2026-09-21T21:40Z`). It has not self-healed.

**Follow-ups / caveats.**
- The fix is on `main2` but the deployed root advances only via the deliberate rolling deploy, so the live `endojs-endo-but-for-bots` watcher won't pick it up until `endolin-garden-ece02cb4` deploys `ec101659`. The frozen cursor should resume on the next successful `cursor-set` after deploy.
- If it does **not** resume post-deploy, suspect a second cause independent of this race (e.g. the `garden-comment-watcher@endojs-endo-but-for-bots` unit being stopped) — I could not inspect host systemd units from inside the container.
- The new standalone test isn't wired into `run-test.sh` (neither are its peers `stale-lock-test.sh` / `cursor-outage-cooldown-test.sh`); it's run directly, consistent with those.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-cursor-set-local-clone-race.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 104 tokens (5760141 cached reads)
- Output: 59463 tokens
- Cost: $5.822781499999999
- Wall-clock: 1152s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
