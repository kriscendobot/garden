Clean stage for endojs/endo-but-for-bots#1613: done. CI is green after one rerun, and nothing needed to be pushed.

- **Starting state:** the PR is a draft at head `4066142fc5`. It moves the two XS oracle CI jobs onto `ubuntu-24.04` (`ci.yml` and `ironhorse-sanitizers.yml`) and adds a paragraph to `rust/engine/DETERMINISM-METERING.md`. 37 checks passed and 1 failed.
- **Coverage and dead code:** there was nothing to do. The diff only changes CI config and docs, with no JS or Rust source, so there's nothing to cover and nothing orphaned.
- **The red check:** `cover (24.x, ubuntu-latest)` failed in the `@endo/sandbox` tests. One test, `bwrap timeout and repeated cancellation reap process groups`, reported "process group 13349 survived bounded cleanup", which is a cleanup-timing failure. That job wasn't touched by this PR, which only changes the two oracle jobs. Memory records bwrap CI reds as already happening before this PR, with #1566 as the fix.
- **CI result:** I reran only the failed job (`gh run rerun 41303140011 --failed`). The bounded `ci-wait-merge.sh --no-merge` wait then returned rc 0, with all 38 checks done and 0 failed.

**Follow-up:** the bwrap cleanup test is flaky and can fail any PR's `cover` job. It's worth checking that #1566 lands.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1613-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (1015373 cached reads)
- Output: 3599 tokens
- Cost: $0.8370145999999999
- Wall-clock: 1520s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
