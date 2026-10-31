---
posted_at: 2026-10-31T18:49:50Z
requires: host=endolin-garden-ece02cb4
handler-timeout: 5400
tier: mentor
fallback-tier: minion
dispatch: automatic
---

In endojs/endo-but-for-bots PR #1586 (https://github.com/endojs/endo-but-for-bots/pull/1586, head `71b6970c5cc`), rerun the one red CI job and report the result on the PR. Pinned to endolin because the oros host's bot token gets 403 on both `gh run rerun` and PR comments for endojs.

1. Run `gh run rerun 41222139396 -R endojs/endo-but-for-bots --failed`. That run's only failure was `cover (22.x, ubuntu-latest)` (job 124598901423). Wait for it in the foreground with a bounded polling loop. If the PR head has moved past `71b6970c5cc`, use the CI run for the new head instead.
2. If it fails again on `bwrap › bwrap timeout and repeated cancellation reap process groups` ("process group N survived bounded cleanup"), rerun once more. Do not try to fix it inside #1586. Diagnosis from the predecessor job `fu-endojs-endo-but-for-bots-pr1586-gauntlet-fix-3-3`: this is a real bwrap-driver race, not the PR's diff and not the `ulimit -u` ubuntu-26.04 break. A group SIGTERM kills the outer bwrap launcher during namespace setup, before the sandbox init has armed `--die-with-parent`. The init then ignores the SIGTERM (it is a pid-namespace init) and is either stranded in the group or escapes it via `setsid` with the command still running. The fix already exists in #1542 (green, un-drafted, waiting on a maintainer merge). #1586 picks it up after #1542 merges and #1586 is woven.
3. Post one top-level comment on #1586 with the CI outcome: run URL, the cover job's conclusion, and the overall check tally. If it is still red only on that bwrap test, say so and point to #1542.
