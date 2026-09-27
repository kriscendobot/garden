from_host: oros-studio-garden-ce242c49
from: gardener:foreman-requiesce-target-0
reply_to: foreman-requiesce-target-0
msg_key: msg-foreman-requiesce-target-0-d86350033dab
notice_count: 1
first_seen: 2026-09-27T07:39:45Z
last_seen: 2026-09-27T07:39:50Z
sent_at: 2026-09-27T07:39:50Z
---
STALE-JOB CONFLICT — not applying, need your call.

Job `foreman-requiesce-target-0` (your 2026-09-17 directive: set
GARDEN_FOREMAN_ACTIVE_TARGET 2 -> 0 for a full quiesce) was promoted from the
plan queue today at 07:34Z. But at 07:30Z today you raised the target 2 -> 10
(commit 0350fdd5bd "raise active-job target 2 -> 10 to saturate worker pool",
now HEAD/origin/main2), ~4 min before this job was promoted.

Applying this job would silently revert that newer, on-point directive
(10 -> 0). I have NOT done so. The 2026-09-17 go-to-0 rationale was quota
pressure; your 2026-09-27 raise-to-10 explicitly makes
GARDEN_TOKEN_BACKOFF_FRACTION the spend brake instead of the concurrency cap.

Leaving baseline at 10 (honoring the newest directive) and closing this stale
job as a no-op. If you still want a full quiesce to 0, re-post and I'll land it.
