I added a low-frequency stale-PR sweep to `scripts/jobs/ci-watcher.sh`. A completed-red bot PR whose head is older than the activity window will now get its automatic shepherd job, which is the gap that left #1646 waiting for a manual post. The change is pushed to main2 as `cf5a399d638`, and `ci-watcher-test.sh` passes 125 of 125.

**How it works**
- **Collecting stale PRs:** a cheap first pass applies the existing checks (bot author, head the bot can push to, activity window) and makes no API calls. It now remembers the PRs it skips as too old instead of discarding them.
- **Pacing:** the sweep runs at most once every `GARDEN_CI_STALE_SWEEP_INTERVAL` (default 1800s). A timestamp file in host state per repo records the last sweep.
- **Staying inside the API budget:** when the sweep is due and stale PRs exist, it takes `GARDEN_CI_STALE_SWEEP_BUDGET` reads (default 2) out of the existing per-tick `GARDEN_CI_ROLLUP_BUDGET`, never on top of it. It never takes more reads than there are stale PRs, and the normal scan always keeps at least one read. When there are no stale PRs nothing is held back, so existing pacing is unchanged.
- **Rotation:** a separate per-repo cursor rotates through the stale list, so every stale PR gets a CI read within about (number of stale PRs ÷ sweep budget) intervals.
- **Same shepherd job:** a red result goes through a new shared function, `post_red_shepherd`, which the normal scan also uses. It posts the same `<slug>-pr<N>-shepherd` job, with one added line in the body saying the sweep found it, and skips posting if that job already exists in any state.
- **Safeguards kept:** hitting GitHub's hourly quota stops the tick as before. If too many reads fail at the start of a tick, the tick aborts before the sweep runs. A read that can't be interpreted is logged and skipped. Setting the sweep budget to 0 or leaving the interval empty turns the sweep off.

**Tests**
- New case W covers:
  - a stale red PR getting its shepherd;
  - no second sweep inside the interval;
  - rotation through three stale PRs, wrapping round to the first;
  - the sweep's reads fitting inside a per-tick budget of 2;
  - a quota error stopping the sweep before any further read or post.
- Case I now turns the sweep off, so it still checks the activity-window skip on its own.
- I ran the suite from a temporary copy with its scratch directory moved to `$TMPDIR`, because the hard-coded `~/.garden-ciw-test` path is read-only in this sandbox. The committed test file still uses the hard-coded path.
- I ran the suite before rebasing onto the latest main2, not after.

**Follow-ups**
- A PR whose earlier shepherd job is already finished still won't get a new one when it goes red again, because the job name is reused and posting is skipped if it exists. That was true before this change and is outside its scope.
- The fix takes effect on each host only after the normal rolling deploy.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-ci-watcher-stale-red.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1936211 cached reads)
- Output: 19756 tokens
- Cost: $1.5519542
- Wall-clock: 340s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
