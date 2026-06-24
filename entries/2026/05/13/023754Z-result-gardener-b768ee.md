---
ts: 2026-05-13T02:37:54Z
kind: result
role: gardener
project: endo-but-for-bots
refs:
  - entries/2026/05/13/023053Z-message-monitor-b8bb4a.md
---

# Result: endo-but-for-bots monitor reaction rules landed

Commit: `19490da` on `main` (rebased on top of a concurrent gardener push for `monitor-endo`).

Replaced the six `(unset)` rows in `skills/monitor-endo-but-for-bots/SKILL.md` with the per-event-class rule table proposed by the monitor in `entries/2026/05/13/023053Z-message-monitor-b8bb4a.md`. Added a Posture section above the per-class rules framing the repo as the active bot-evolution surface, with the operative axis "does this event change which role the steward should dispatch next?" Frontmatter updated to `updated: 2026-05-13` with `author: liaison, monitor`. One Notes-from-the-field row dated 2026-05-13 names the source message and summarizes the framing.

Shape choice: landed the proposal largely as written, preserving the conditional structure for `PushEvent`, `IssueCommentEvent`, and `IssuesEvent` rather than collapsing to a single rule (cosgov's observation-only frame collapses cleanly, but this repo is the active surface and the routing fan-out is the point). Did not factor out an `authorization-grant-detection` skill; per dispatch, the pattern waits for more examples.

Self-improvement: when a per-project monitor skill's bootstrap proposal is structurally richer than its peer (here: cosgov collapses to one rule, endo-but-for-bots fans out across seven event classes with conditional fallbacks), do not flatten it on landing. The richness reflects a real difference in the project's role in the garden, and the Posture section is the right place to record that difference for future readers.
