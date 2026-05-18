---
slot: 1
status: in-flight
design_path: designs/daemon-message-streaming.md
pr_number: null
current_stage: builder
in_flight_dispatch: 060dd6
last_update: 2026-05-18T11:12:00Z
started_at: 2026-05-18T11:12:00Z
host: endolinbot
---

Slot 1 refilled with `daemon-message-streaming` Phase 1 after
contractor-side substrate audit:
- No `openStream`/`streamMessage`/`appendStream`/`finaliseStream`
  references in packages/ on llm.
- `mail.js` exists but no streaming methods.
- Design (2026-03-26) clearly enumerates `streamReply` + StreamWriter +
  StreamReader interfaces.

Phase 1 scope: implement `streamReply` mail method with text-append,
phase-transition, end, and abort; recipient-side StreamReader async
iterable. Defer back-pressure to follow-up. Base: llm.

Dispatch root: `dispatches/builder--060dd6`.
