---
ts: 2026-06-08T02:50:00Z
kind: dispatch
role: steward
host: endolinbot
project: endo-but-for-bots
to: researcher
dispatch_root: /home/kris/dispatches/researcher--c19e1e
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/404
  - https://github.com/endojs/endo-but-for-bots/pull/404#issuecomment-4641513421
  - https://github.com/endojs/endo-but-for-bots/pull/404#pullrequestreview-4415614938
---

# dispatch: researcher — refs for #404 designer (rsvp + 10 inline + 2 new sibling-design asks)

User RSVP directive (2026-06-08T02:42Z) on
`endojs/endo-but-for-bots#404` comment 4641513421 (kriskowal,
2026-06-07T05:17:11Z): *"Please rebase and ensure feedback above
is addressed."*

PR #404 is **design-only** (`designs/chat-inventory-create-menu.md`
+ `designs/README.md`), 2 files, base `llm`, head
`design/chat-inventory-create-menu` at `7b2bf91`. Two prior
reviews from kriskowal:

- COMMENTED 2026-06-03T00:04:15Z (review 4414531688): Ollama
  menu suggestion + local/remote alternatives.
- CHANGES_REQUESTED 2026-06-03T05:25:40Z (review 4415614938):
  10 inline comments across lines 289-509 of the design doc.
  Two of the inlines ask for NEW sibling designer dispatches
  (line 477: encrypted-at-rest formulas; line 484: a placeholder
  for a deferred complication).

The downstream is a **designer** dispatch. Researcher precedence
applies.

## What you should look for

- Past designer dispatches that authored sibling designs in
  response to inline review asks (precedent for the line 477
  and 484 sub-designs).
- chat-inventory-create-menu's relationship to chat-spaces /
  familiar / lal-fae-form-provisioning (line 363's "Provisioning
  becomes a dependency of the Chat application but not a
  dependency of the daemon" sets a structural intent).
- "Root host agent pet store" (line 477) — how does the daemon
  expose this? Library entries on the host-agent + pet-store
  primitive.
- "introducedNames to endow the guest" (line 495) — the daemon's
  endowment mechanism; what library coverage exists?
- Ollama / Open Router model menu UX (line 489 + COMMENTED
  review body) — any prior design coverage of the model-picker
  surface?
- The 2026-06-08 master-into-llm sync at `11a76ae6` — any
  conflict surface to flag for the rebase.

## Deliverable

Per `roles/researcher/AGENT.md`: a `result` entry with the
standard `## Library and project references` section the steward
will inline.

Five-minute wall time target.
