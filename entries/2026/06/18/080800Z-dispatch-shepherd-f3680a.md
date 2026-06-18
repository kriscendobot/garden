---
ts: 2026-06-18T08:08:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: shepherd
dispatch_root: /home/kris/dispatches/shepherd--f3680a
model: sonnet
prs:
  - repo: endojs/endo-but-for-bots
    pr: 357
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/357
  - https://github.com/endojs/endo-but-for-bots/pull/357#issuecomment-4576127231
---

# dispatch: shepherd — #357 prettier-markdown (kriskowal directive 2026-05-29)

User (kriskowal) at 2026-05-29 (revisited 2026-06-18 via rsvp):
"@kriscendobot Please try this again. It has a stamp, so when
it passes CI, please pass to the conductor."

PR #357 is APPROVED (the "stamp") but has 4 persistent CI
failures. User wants the bot to fix them, then conductor merges.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#357`, OPEN, reviewDecision
  APPROVED, base `llm-5b1361d` (frozen), head
  `chore/prettier-markdown` at `c24457346`.
- **mergeable**: MERGEABLE, mergeStateStatus: UNSTABLE.
- **Failing**: lint (x2), test (22.x macos), test-xs.

## Task

Standard shepherd: classify failures per A/B/C/D, fix tractable
cases, push, verify CI re-runs, post summary at-mentioning
@kriskowal. **Recommend `next: conductor` if CI goes green**
(per kriskowal's pre-authorization).

End your turn with a concise summary back to the orchestrator.
