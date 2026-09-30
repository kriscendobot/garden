Round-3 fixes for endojs/endo-but-for-bots#1383 are pushed and CI passed: all 28 checks green, 0 failed (`ci-wait-merge.sh` rc 0). The changes are in one commit, `5d546f3a71`, on `design/daemon-lifecycle-idempotency`. `safe-push-pr-head.sh` moved the head forward from `db7c336883` without rewriting any earlier commits.

**Must-fix (decomplector):** the owner record (`<ephemeral>/endo.lock`) now has a third line holding the socket path the daemon serves. The classifier now has a fifth value, `elsewhere`, for "same state directory, different socket". It exits 69, not 0, so a second `start` no longer reports success when the socket it asked for isn't reachable.

**Should-fix items, all addressed:**
- **Every `start` outcome is spelled out.** If the daemon is still `booting` when the wait runs out, `start` exits 75 and never goes on to delete files or spawn a second daemon.
- **Losing a start race no longer looks like a failure.** The losing child sends a `declined` message over the existing IPC channel, so `start` reports "already running" (exit 0) instead of "Daemon failed to spawn" (exit 1). Only `run-daemon` exits 69, and section 6 now says this difference is deliberate.
- **Section 6 was rewritten.** Every command's exit code is now defined for every classifier value, in separate tables for query and action commands. `endo status` prints a `state:` line, which answers Open Question 3. The table also covers what `restart` returns when its halves disagree, and says `cli/bin/endo.cjs` must pass `main()`'s return value through as the exit code.
- **`endo clean` got the same liveness guard as `start`.** Against a running daemon it refuses with 69; both commands take `--force` for today's behavior.
- **Upgrades are covered.** The design now explains how a new binary handles a daemon started by an old one: it probes the socket when there's no `endo.lock`. The new claim step also reads the old `.lock` file and `endo.pid`, so it backs off before killing any workers.
- **The existing lock code can't be reused as-is.** `socket-lock.js` checks only a bare pid, so the design now calls for a new pid-plus-start-time check.
- **Windows keeps today's unguarded behavior**, and the design now says so.
- **`endo.pid` has a retirement plan:** it stops being written once `stop` reads the owner record, in Phase 3.
- **Phase 1 tests were added** for:
  - a recycled pid;
  - an upgrade with no `endo.lock`;
  - a different socket path;
  - a start race with a `declined` message;
  - `start` while booting, with and without a timeout;
  - `endo clean` against a live daemon.

**Comment-level and style items:** short explanations of CapTP, cgroup and "reparented to PID 1"; a note in section 2 on how its subsections build on each other; the survey's forward-looking sentence reworded; the file-path rule now mentions `go/engo`; two headings reworded; the Phase 4 label made consistent; the recycled-pid and start-time sentences split up. The fix contains no em dashes.

**Follow-ups:** none from this stage. Per the stage rules I did not re-run the review panel; the driver posts panel-4 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1383-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1127899 cached reads)
- Output: 14397 tokens
- Cost: $1.1194878
- Wall-clock: 700s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
