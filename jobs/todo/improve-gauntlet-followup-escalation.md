---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gardener.sh
Before the follow-up completion gate, deterministically forward actionable non-driver `## Follow-ups` from completed gauntlet clean/fix stages to the maintainer inbox with `reply_to` set to the child job and a stable coalescing key; retry on a delivery failure. This moves the non-board-postable maintainer-decision escalation out of the stage agent and prevents the recurring rc=1 requeue when a fix correctly identifies an open decision but omits `message-user.sh`.
