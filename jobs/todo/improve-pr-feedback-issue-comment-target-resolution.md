---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gardening/pr-feedback-preflight.sh
Resolve PR conversation-comment IDs through the issues-comments API in addition to review and inline-comment APIs, and build the appropriate evidence metadata. The current preflight queries an issue-comment ID on the wrong surfaces and fails open.
