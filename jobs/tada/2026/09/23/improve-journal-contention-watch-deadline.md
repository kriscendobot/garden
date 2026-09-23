The journal contention checker now stops itself before systemd's 240s timeout: it always writes its heartbeat and pushes any unfinished clone work to the next tick. Shellcheck is clean, the extended test passes, and the change is pushed to `main2` as `a4befb2be4`.

**What changed**
- **Time budget** (`scripts/jobs/journal-contention-watch.sh`): each tick gets 210s (`GARDEN_CONTENTION_TICK_BUDGET`), and the last 20s (`GARDEN_CONTENTION_RESERVE`) are kept back. Once only the reserve is left, the checker stops starting clone analysis. It still writes the outage check and the heartbeat, so it exits before systemd kills it.
- **Object count** (`scripts/jobs/journal-contention-lib.sh`): the `count-objects` read on a clone is now cut off when the remaining time runs out. A cut-off clone is deferred rather than recorded as a healthy 0-byte clone, which could otherwise have closed an oversized-clone notice by mistake. The read-only probe doesn't set the time limit, so it behaves as before.
- **Clone rebuilds**: a rebuild only starts if at least 120s are left (`GARDEN_CONTENTION_REMEDY_MIN`), and its fetch retries are reduced to fit the time remaining. Otherwise it records `remedy: deferred-deadline` without starting the 6h backoff, so the next tick tries again.
- **Deferred clones**:
  - Their names are saved to `$GARDEN_STATE/journal-contention-watch/deferred`, and they are checked first on the next tick so the same slow clones aren't skipped every time.
  - Their open notices and confirmation counts are left as they were.
  - The heartbeat now shows `outcome: partial-poll|full-poll`, `deferred_clones` and `tick_elapsed_s`. Its `epoch` still updates on a partial tick, so the bulletin keeps reporting the checker as healthy.
- **New notice**: `journal-contention-watch-overrun` opens after two partial ticks in a row, meaning this host's clones no longer fit in the time budget. It closes after the next full tick.
- **Design doc**: `designs/journal-contention-watch.md` §6 now describes the deadline.

**Tests** (`scripts/jobs/test/journal-contention-watch-test.sh`) now also cover:
- three clones against a simulated budget, checking which are deferred, the order they run in next tick, the overrun notice opening and closing, and the heartbeat fields;
- a stand-in `git` whose `count-objects` hangs, which gets deferred after about 2s;
- a rebuild that is skipped for lack of time, with no backoff recorded.

**Not covered:** once a rebuild has started, a slow re-clone can still run past the deadline. The 120s minimum and reduced retries make that unlikely, and an interrupted clone is repaired by the next `ensure_clone`. The change takes effect on each host at its next deploy.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-journal-contention-watch-deadline.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1120033 cached reads)
- Output: 18590 tokens
- Cost: $1.1957106000000002
- Wall-clock: 198s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
