---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: designer

Close the dead-letter delivery gap: a message with no living addressee.

Origin: report `deadmail-20260728T074423Z-6bee53`. It documented the anti-pattern
but deliberately did not fix the delivery gap; the mechanism was left to the
maintainer. Maintainer decision 2026-09-13 (muster): design the fix.

The gap: a botanist renders MERGE-NOW and EXITS while the approval gate still
blocks. A later correction addressed to that job's doer therefore has no living
addressee — the message is delivered into an inbox nobody will ever read. The
anti-pattern note names the shape; nothing closes it.

Design a mechanism that makes such a correction reachable. The report floats a
"standing re-addressee"; evaluate that and any alternative you find better.
Requirements to weigh:
- A message sent to a dead doer must reach SOMETHING that can act — not silently
  rot, and not spam the maintainer inbox with every routine completion.
- It must compose with the existing bus shapes: per-doer `inbox/<doer>/{unread,read}/`,
  `role/<role>`, `broadcast`, and the maintainer inbox
  (skills/message-bus/SKILL.md).
- It must not resurrect a finished job, and must not create a second addressee that
  double-answers a live one.
- Say how a sender can tell "delivered to a live reader" from "re-addressed".

Deliverable: a design on main2. Survey the existing dead-letter handling
(`.garden-state/deadmail`, whatever produces those reports) before proposing, and
cite file:line. If the design carries unresolved maintainer-facing open questions,
present it as a review PR per CLAUDE.md's open-questions carve-out.

Skills: skills/message-bus, skills/design-dependency-walk,
skills/gardener-inbox-error-reporting.
