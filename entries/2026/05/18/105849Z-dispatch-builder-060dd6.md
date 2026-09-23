---
kind: dispatch
role: builder
host: endolinbot
posture: liaison
short_id: 060dd6
dispatch_root: dispatches/builder--060dd6
repo: endojs/endo-but-for-bots
branch: llm
pr_number: null
slot: 1
---

Slot 1 seventh pick: `designs/daemon-message-streaming.md` Phase 1.
Contractor pre-flight audit: zero `openStream`/`streamMessage` infra
on llm; mail.js untouched by streaming work. Status: Not Started
(authored 2026-03-26 by Joshua T Corbin — note co-author distinguishes
this from the chat-features-already-shipped pattern).

Phase 1 scope: `streamReply` host/guest method + StreamWriter exo +
StreamReader async-iterable shape on the recipient side. Defer
back-pressure (the design's only marked future item).

Base: llm. Daemon-only PR.
