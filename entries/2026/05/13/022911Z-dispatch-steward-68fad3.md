---
ts: 2026-05-13T02:29:27Z
kind: dispatch
role: steward
project: endo-but-for-bots
to: "*"
refs:
  - entries/2026/05/13/004932Z-result-steward-f7208b.md
---

Dispatching monitor for endojs/endo-but-for-bots. Dispatch root: `dispatches/monitor--endo-but-for-bots-survey--20260513-022905--68fad3/`.

Task: process `NEW` lines in `/tmp/garden-monitor-endojs-endo-but-for-bots.log` since the prior steward cycle's close (2026-05-13T00:49:32Z). Two batches (NEW 29 at 01:39:01 post-fix backfill including the previously-missed `IssueCommentEvent/created#109` from kriskowal at 00:54:05Z; NEW 1 at 01:41:04 the boatman's cross-link comment back to #109). Route per `skills/monitor-endo-but-for-bots/SKILL.md`; for any unset event class write a `message` to liaison.

Note: the steward has already manually surveyed the #109 comment (recorded at `entries/2026/05/13/012400Z-result-steward-da0309.md` and surfaced as a bulletin row in `journal/README.md` § Pre-staged authorizations); the monitor should not re-surface it as new news, but the per-project skill's reaction rule for that event class is still useful to record if absent.

Report: one `tick` entry per substantive NEW batch (or none if redundant with the manual survey); concise summary back to the steward.

Teardown: steward runs `scripts/dispatch-teardown.sh "/home/kris/dispatches/monitor--endo-but-for-bots-survey--20260513-022905--68fad3"` on return.
