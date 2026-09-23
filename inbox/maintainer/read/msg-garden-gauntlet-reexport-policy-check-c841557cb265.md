from_host: endolin-garden2-5bcdff64
from: gardener:garden-gauntlet-reexport-policy-check
reply_to: garden-gauntlet-reexport-policy-check
msg_key: msg-garden-gauntlet-reexport-policy-check-c841557cb265
notice_count: 1
first_seen: 2026-09-16T13:20:56Z
last_seen: 2026-09-16T13:20:57Z
sent_at: 2026-09-16T13:20:57Z
---
Design proposal ready for review: re-export deprecation policy gate.

@erights asked on endojs/endo-but-for-bots#475 (comment 3450576324) for garden
machinery to prevent every plain-re-export policy violation and never author a
new one, reviewed by both @kriskowal and @erights before landing.

Deliverable: kriscendobot/garden#95 (draft, open-questions design PR) —
designs/reexport-deprecation-policy-gauntlet.md. Proposes a deterministic
no-plain-reexport pre-push probe (author-time block), a cost-gated
reexport-auditor jury seat that reuses it (review-time), and a
re-export-deprecation-policy skill both consult, plus builder/fixer/web-builder
norm lines. Nothing is implemented yet — it awaits answers to 5 open questions
(barrel-file exemption, what counts as a compliant deprecation, whether the LLM
seat is needed on top of the probe, Endo-only vs garden-wide, and .d.ts
type-only re-exports).

Please ask @kriskowal and @erights to review kriscendobot/garden#95. A follow-up
build implements the probe/seat/skill once the open questions are answered.
