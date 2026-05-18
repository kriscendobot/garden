---
slot: 1
status: in-flight
design_path: designs/daemon-message-streaming.md
pr_number: 287
current_stage: cleaner
in_flight_dispatch: b026a1
last_update: 2026-05-18T11:58:00Z
started_at: 2026-05-18T11:12:00Z
host: endolinbot
---

Builder shipped PR #287 (daemon-message-streaming Phase 1, llm base):
new `mail-stream.js` with StreamWriter exo + buffered StreamReader,
`streamReply` mail method on host/guest interfaces, recipient-side
async-iterable. 12 files, +939/-6, 16 new tests. Builder flagged a
**non-obvious trap**: adding methods to GuestInterface requires
matching stubs in `least-authority` guest exo at daemon.js (else
seven unrelated tests fail in subtle ways). Builder added the stub;
self-improvement note recorded for `roles/builder/AGENT.md` operating
norms.

Phase 2+ (back-pressure, CLI/Genie integration, persistent stream
state, cross-peer streams) deferred. Now in cleaner stage.

Dispatch root: `dispatches/cleaner--b026a1`.
