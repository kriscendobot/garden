---
kind: dispatch
role: fixer
host: endolinbot
posture: liaison
short_id: c640a3
dispatch_root: dispatches/fixer--c640a3
repo: endojs/endo-but-for-bots
branch: feat/edit-message
pr_number: 125
model: sonnet
---

Fix CI test failures on PR #125 after the inbox-to-Preact port:
three `@endo/daemon` editMessage tests failed in CI even though
local `@endo/chat` tests passed:
- `endo > editMessage replaces payload and preserves history`
- `endo > editMessage rejects edits from non-senders`
- `endo > editMessage accepts edits after done and records them`

All three returned rejected promises. The prior fixer ran chat tests
but missed the daemon-side tests; these likely regressed during the
rebase port. Investigate, repair, push.
