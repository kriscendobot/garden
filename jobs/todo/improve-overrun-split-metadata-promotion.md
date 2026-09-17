---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/promote-plan.sh
Preserve an orchestrated indivisible child’s `split-indivisible-reason` in the promoted outer frontmatter (with a parseable scalar form). The current promotion strips it, causing `assert-overrun-split-posted.sh` to reject an already-durable valid handoff and requeue the completed split job. Add regression coverage for plan→todo promotion of an expanded-window child.
