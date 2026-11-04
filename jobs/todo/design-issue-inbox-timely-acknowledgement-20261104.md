---
posted_at: 2026-11-04T05:35:46Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Investigate and design timely, non-redundant acknowledgement for issue-inbox (and sibling watchers)

Role: designer (investigate first, then propose; land per designs/ conventions, bare unless the design carries open questions).

## Trigger
kriscendobot/garden#128 (dckc, a trusted maintainer): filed 2026-11-04T03:37:25Z, the issue-inbox's eyes reaction landed only 04:31:57Z (~55 min), with the job posted the same second. The poster got restless; the maintainer (kriskowal) asked for this job. A manual acknowledgement comment was posted by the liaison afterwards.

## Question
Decide when and how the garden should acknowledge an inbound maintainer issue/comment so that:
1. We do NOT post a heavy acknowledgement that an immediate answer would follow within seconds/minutes (noise).
2. We do NOT leave the poster waiting ~30 min with no sign of life.

## Candidate mechanisms the maintainer floated (evaluate, combine, or reject)
- Decide by job queue length / expected wait: if the board is short and a gardener is free, skip or defer the ack; if the queue is long, ack at once with queue position / ETA.
- A deterministic timeout: if no acknowledgement has been posted 20 minutes after the issue/comment arrived, post one (status: queued/claimed, queue depth).
- Both: ack immediately when predicted wait is long, else fall back to the 20-minute timeout.

## Investigate first
- Root cause of the ~55 min gap on #128: watcher poll cadence? stall? rate-limit cooldown latch? Look at scripts/jobs/issue-inbox-watcher.sh, its unit/timer, logs, and cursor state. Note the cheap eyes reaction vs. a substantive comment are different tiers of "sign of life"; the eyes reaction is already the instant, low-noise ack and was late, so fix lateness first.
- Existing machinery to build on, not duplicate: scripts/jobs/comment-latency-watch.sh (designs/comment-latency-watch.md) already replays a should-ack predicate and alerts on slow acks for comment/issue-inbox/mention sources; skills/issue-inbox/SKILL.md; skills/reactji-acknowledgment/SKILL.md; designs/issue-inbox.md. Determine why it did not catch or repair #128, and whether the 20-minute rule belongs there.
- How to read queue length and free-gardener availability deterministically (jobs/todo count, doin count, running gardeners, drain/brake state).
- Whether the same rule should cover the PR comment-watcher and @-mention watcher, for consistency.

## Constraints
- Deterministic, no LLM, in plain code, for the trigger and the ack text (trust gate stays before any text reaches a model; see CLAUDE.md Monitoring safety constraint). Do not widen any watched repo or sender set.
- Idempotent: at most one status comment per issue per arrival; never double-ack when the worker reply is imminent.
- Never close issues; comment back per skills/issue-inbox/SKILL.md.

## Deliverable
A short design (designs/) with the chosen rule and thresholds, the root-cause finding for #128, and a follow-on build job posted (or parked) if the design is clear. Report back by a comment on kriscendobot/garden#128 only for the root-cause finding if useful to dckc; otherwise report via the job report.
