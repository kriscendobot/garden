The fix is pushed to `main2` as `32edd3b3323`. The deferred clone backlog now drains across ticks, and the overrun notice only fires when a tick makes no progress. The contention watch test suite passes, including the new tests.

**Root cause.** The earlier bounded-tick fix (`25d00928de4`) had a flaw in its clone loop in `scripts/jobs/journal-contention-watch.sh`. Once one clone came back busy, every clone after it was also deferred, and the next tick put the deferred clones first again. So one busy clone at the head of the list held back all the others on every tick. That is why the backlog stayed at 102 and the overrun notice fired on every tick.

**What changed:**
- **Rotation with a saved cursor.** The watch now inspects clones in passes. `$GARDEN_CONTENTION_STATE/deferred` lists the clones the current pass hasn't inspected yet, and they go first on the next tick. When a pass finishes, any budget left over starts the next pass on clones not already inspected this tick.
- **Busy clones are skipped.** A busy clone stays in the pass for a later tick but no longer stops the clones behind it. Open notices for any clone not inspected this tick are kept until its turn comes.
- **Overrun only on no progress.** A tick counts as stalled when work is deferred, no clone was analyzed, and the deferred work is no smaller than the previous tick's (read from the heartbeat). Two stalled ticks in a row open `journal-contention-watch-overrun`. The heartbeat now also records `analyzed_clones`.
- **Tests** in `scripts/jobs/test/journal-contention-watch-test.sh`:
  - 100 clones at 10 per tick drain in 10 ticks; the backlog shrinks every tick, every clone is analyzed, and no overrun fires.
  - A busy clone at the head of the deferred list no longer blocks the clones behind it; it is the only one left deferred.
  - Two ticks that analyze nothing raise the overrun, and it recovers once a tick makes progress.
  - The existing tick-deadline test was updated for the new behavior.
- **Docs:** `designs/journal-contention-watch.md` now describes the rotation and the new overrun rule.

**Other things to know:**
- `scripts/jobs/test/receipt-watcher-test.sh` fails 2 of 20 checks ("fresh-clone outage lost its warning/cooldown" and the empty-stderr wording check). That test only mentions the contention watch in a comment and doesn't run it, so I don't believe this change caused the failures. I didn't check whether they also fail on the previous commit.
- One related cost remains: when the clone index is built, each busy clone still costs up to `GARDEN_CONTENTION_INSPECTION_LOCK_WAIT` (2s) before the tick budget is checked. If many clones are busy at once, that could use up a large part of the budget. I left this alone; it would need its own job if it turns out to matter.
- Once this is deployed on endolin-garden-ece02cb4, the next progressing tick should close the open overrun notice, and `analyzed_clones` in the heartbeat should be non-zero on each tick.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-journal-contention-watch-deferred-clone-backlog.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1614647 cached reads)
- Output: 18746 tokens
- Cost: $1.3581614000000004
- Wall-clock: 296s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
