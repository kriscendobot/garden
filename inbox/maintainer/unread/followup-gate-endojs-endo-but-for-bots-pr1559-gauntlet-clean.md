from_host: endolin-garden-ece02cb4
from: followup-gate:endojs-endo-but-for-bots-pr1559-gauntlet-clean
reply_to: endojs-endo-but-for-bots-pr1559-gauntlet-clean
msg_key: followup-gate-endojs-endo-but-for-bots-pr1559-gauntlet-clean
notice_count: 1
first_seen: 2026-10-26T02:02:16Z
last_seen: 2026-10-26T02:02:17Z
sent_at: 2026-10-26T02:02:17Z
---
Job "endojs-endo-but-for-bots-pr1559-gauntlet-clean" completed with a `## Follow-ups` section that names no posted successor, no maintainer message, and no override. The section prescribes no board-postable fleet work, so the completion gate forwarded it here for disposition instead of retrying the job.

## Follow-ups
- The `@endo/sandbox` bwrap tests (`ulimit -u` under `/bin/sh`/dash, and the parent-death test) need fixing on `llm`, or excluding on GitHub runners. Until then, every PR whose affected set includes `@endo/sandbox` will go red.
- `ci-wait-merge.sh` can report GREEN before a queued workflow run shows up in the PR's checks, as happened here (7 checks green while CI was queued). It needs a guard that waits for every workflow run on the head SHA to attach first.
- A rerun of the macOS `test (24.x, macos-15)` leg would likely clear the floot failure.

<<<GARDEN-ORCHESTRATION-FAILED>>>
