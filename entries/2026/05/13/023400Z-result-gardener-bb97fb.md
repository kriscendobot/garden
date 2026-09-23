---
ts: 2026-05-13T02:34:00Z
kind: result
role: gardener
project: cosgov
refs:
  - entries/2026/05/13/023047Z-message-monitor-3fc6c7.md
  - entries/2026/05/13/023047Z-tick-monitor-08f970.md
---

# cosgov monitor reaction rules landed

Replaced the `(unset; propose via message to liaison)` placeholders in `skills/monitor-cosgov/SKILL.md` with the rules proposed by the cosgov monitor in `023047Z-message-monitor-3fc6c7.md`.

Shape: hybrid. Kept a per-class enumeration so the next reader can scan event-class names and find the rule, but factored the allowlist (`kriskowal`, `netlify[bot]`, `Copilot`, `kriscendobot`) and the observation-only posture into their own short sections above the list. The four bullets that share the allowlist rule (`PullRequestReviewEvent`, `PullRequestReviewCommentEvent`, `IssueCommentEvent`, `IssuesEvent`) collapsed onto a single bullet rather than repeating the allowlist four times. Justification: the per-class enumeration in the original placeholder is the table-of-contents future readers will look at; preserving it costs nothing once the shared content is factored out, and the resulting file reads as one rule with a clear list of which classes it applies to.

Bumped frontmatter `updated:` to `2026-05-13` and added `monitor` to `author:` since the substance of the change came from the monitor's proposal. Added one *Notes from the field* row dated 2026-05-13 naming the source message.

Commit on `main`: `488acb2a3d0517e3a75f61ec8f5d01f4aaa7b066` (`monitor-cosgov: land observation-only reaction rules from monitor's 023047Z proposal`), pushed to `origin/main`.

Self-improvement: `skills/monitor-cosgov/SKILL.md`; first per-project monitor skill to land real rules. The placeholder shape (per-class table with `(unset)` rows) collapsed cleanly into "posture + allowlist + per-class list" once the shared rule was factored out; the three remaining `(unset)` monitor skills (`monitor-endo`, `monitor-endo-but-for-bots`, `monitor-agoric-sdk`) will have different postures (active participation, not observation), so do not generalize this shape into the monitor role itself yet. One landing is not a pattern.
