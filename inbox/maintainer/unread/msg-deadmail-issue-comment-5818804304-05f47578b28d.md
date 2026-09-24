from_host: endolin-garden2-5bcdff64
from: gardener:deadmail-issue-comment-5818804304
reply_to: deadmail-issue-comment-5818804304
msg_key: msg-deadmail-issue-comment-5818804304-05f47578b28d
notice_count: 1
first_seen: 2026-09-24T17:28:25Z
last_seen: 2026-09-24T17:28:26Z
sent_at: 2026-09-24T17:28:26Z
---
# garden-mention-watcher is not running on the leader. Its cursor has been frozen since 2026-07-08.

dckc asked in kriscendobot/garden#112 why their @kriscendobot comments on Oros-AI/oros-ckm-data-readiness got no 👀 and no response. The comments were the PR 2 review https://github.com/Oros-AI/oros-ckm-data-readiness/pull/2#discussion_r4042354163 (2026-09-17) and the PR 3 comment https://github.com/Oros-AI/oros-ckm-data-readiness/pull/3#issuecomment-5818302372 (2026-09-24).

Root cause: Oros-AI/* is upstream, so it is not in the repos/ or comment-repos/ watch set. Only the kriscendobot fork is watched, and the PRs live upstream. That leaves the GitHub-wide mention watcher as the only path. Its journal cursor `cursors/mentions/kriscendobot` still reads `last_seen: 2026-07-08T04:43:34Z`, so it has not polled on the current leader (endolin-garden-ece02cb4). install-units.sh deliberately treats garden-mention-watcher as OMIT-ONLY (arm by hand, never auto-enabled), so it was never re-armed after the leader moved. comment-latency-watch has been raising `comment-watcher-dead-Oros-AI-oros-ckm-data-readiness` notices about this.

Ask: on the leader, run `systemctl --user enable --now garden-mention-watcher.timer`. The widening authorization from the day it was first armed still stands. Warning: on its first tick it will poll everything since 2026-07-08, and every trusted, explicitly addressed mention in that window becomes a job. That could be a large backlog. You may want to advance the cursor to about 2026-09-17 first.

Structural follow-up, your call: an armed OMIT-ONLY unit does not follow a leader handoff. Should the arming become a journal flag that follows the `leader` marker, like the foreman brake?

The 2026-09-24T16:51 comment on kriscendobot/garden#112 (5818395910) also got no 👀 from issue-inbox. The watchdog flagged it as `comment-ack-blind`. The repost at 17:19 was acked within 32s. I can't see the leader's logs from this host. fe918d22339 (cursor-advance contention retry) may be related.

The PR 2 review feedback is now job `fix-oros-ckm-pr2-pr3-review-feedback`.
