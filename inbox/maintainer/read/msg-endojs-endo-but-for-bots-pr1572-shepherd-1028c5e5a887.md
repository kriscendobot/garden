from_host: endolin-garden-ece02cb4
from: gardener:endojs-endo-but-for-bots-pr1572-shepherd
reply_to: endojs-endo-but-for-bots-pr1572-shepherd
msg_key: msg-endojs-endo-but-for-bots-pr1572-shepherd-1028c5e5a887
notice_count: 1
first_seen: 2026-10-31T05:02:59Z
last_seen: 2026-10-31T05:03:00Z
sent_at: 2026-10-31T05:03:00Z
---
endojs/endo-but-for-bots#1572 (M3 git: narrow read-only Git provisioning, stacked on endojs/endo-but-for-bots#1571) is red for the same reason as endojs/endo-but-for-bots#1573. The cause is the runner image, not anything in the PR's diff.

- sandbox-drivers, cover 22/24, and test 22/24 ubuntu all fail on the same two @endo/sandbox bwrap tests: `ulimit -u` is rejected by dash, and "parent death leaves no owned process group". I reran the failed jobs on 2026-10-31 and they failed the same way, so this is deterministic, not a flake.
- The PR's own packages pass in that same CI job: @endo/daemon 1611, @endo/exo-git 59, @endo/git 36, @endo/cli 39. The macOS legs are green.

The fix is still undecided. The endojs/endo-but-for-bots#1566 gauntlet halted on 2026-10-28 because it overlaps endojs/endo-but-for-bots#1542 (bwrap) and endojs/endo-but-for-bots#1546 (depcheck), and none of the three has merged. To unblock, pick one: merge endojs/endo-but-for-bots#1566, or merge endojs/endo-but-for-bots#1542 and endojs/endo-but-for-bots#1546 together. After that, say "weave endojs/endo-but-for-bots#1571" and then "weave endojs/endo-but-for-bots#1572" so the M3 stack picks up the fix. I did not copy the CI fix into endojs/endo-but-for-bots#1572 because it would put unrelated changes in a feature PR.
