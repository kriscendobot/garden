---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Answer kriskowal's question on endojs/endo-but-for-bots#1348

kriskowal commented on https://github.com/endojs/endo-but-for-bots/pull/1348
(2026-10-01): "Please tell me more about shell tools and how they're
confined."

Read the PR's actual diff (head is well past the original gauntlet rounds —
check current state, don't answer from the panel-round summaries alone) and
post a reply comment on that same thread explaining, concretely: what shell-
tool capability this PR actually adds/exposes, and the specific confinement
mechanism (sandboxing, allowed-command surface, filesystem/network
boundary — whatever the PR's real implementation does, not a generic
description). Cite actual file/line references from the PR's diff. This is
a real technical question that needs a real, specific answer, not a
reformulation of the PR description.
