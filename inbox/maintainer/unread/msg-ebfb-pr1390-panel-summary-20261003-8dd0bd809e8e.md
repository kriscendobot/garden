from_host: endolin-garden-ece02cb4
from: gardener:ebfb-pr1390-panel-summary-20261003
reply_to: ebfb-pr1390-panel-summary-20261003
msg_key: msg-ebfb-pr1390-panel-summary-20261003-8dd0bd809e8e
notice_count: 1
first_seen: 2026-10-03T05:25:12Z
last_seen: 2026-10-03T05:25:23Z
sent_at: 2026-10-03T05:25:23Z
---
endojs/endo-but-for-bots#1390 — recommendation: **merge after one named small fix**, `fix: complete evaluate and mention edge path adaptation`; no redesign.

**Must-fix before merge**
- `lal` and `fae` still pass bare worker/endowment names to array-only `evaluate`; non-empty real calls now throw. Wrap each external name as a one-segment path and add non-empty regression coverage.
- A slash-joined channel mention still becomes an invalid slash-containing `edgeName`, so nested auto-notification is rejected (and its catch hides it). Derive a valid leaf/unique edge consistently with the reply hint and validate it in the test.
- `agent-tools` passes its freshly built result path across `E()` unhardened; a real marshalled daemon boundary rejects it although the local `Far` test does not. Harden it and exercise a guarded/marshalled boundary.
- The changeset should add one sentence that the numbered mention-edge collision repair is an intentional secondary behavior change; it is small but release-visible.

**Follow-up-worthy**
- The 0.x package bump dispute is policy, not a clear defect: the current panel's migrator says major while packager says minor is the established 0.x breaking bump. Resolve/document that convention separately rather than blocking this fix.
- The 85-commit undo/redo history and duplicated UI `.split('/')` parsing merit a cleanup/squash and shared parser follow-up; neither changes the green head's merge correctness.
- Remove the PR body's promised landing order with endojs/endo-but-for-bots#1343 when convenient; it will become stale.

**Taste/noise**
- Rename `ri` to `recapIndex`, and add the `namePathLabel` invariant comment if desired; these are readability/future-proofing only.

CI is green at `18d8207af1`; no open inline review threads were returned. The latest panel is still must-fix because of the concrete path/marshalling regressions above.
