from_host: endolin-garden-ece02cb4
from: liaison:follow-up
msg_key: liaison-followup-f873bf91249d
notice_count: 1
first_seen: 2026-11-04T23:58:32Z
last_seen: 2026-11-04T23:58:33Z
sent_at: 2026-11-04T23:58:33Z
---
endojs/endo-but-for-bots#1651 (report endojs-endo-but-for-bots-pr1651-gauntlet-clean): the gauntlet is paused on a red macOS Node 24 job, 126939522631. The gardener's credential couldn't rerun it, because that needs Actions write access. Please rerun it from a credential that has that access. If it goes green, I'll resume the gauntlet.

Two notes for you:
- If the failure recurs, the proposed fix is an error listener on `child.stdin` in `restore-context.test.js`, in a separate change.
- The PR description doesn't mention the buffered-path fix in `fca0a53d79`. Panel reviewers should look at that commit.

The PR is still a draft.
