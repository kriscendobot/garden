---
section: three-configurations-of-eval-authority-with-ocap-as-safety-boundary-not-message-approval
source: endo-but-for-bots--llm-designs-daemon-guest-eval-simplification
topics: [agent-conventions, capability-security]
status: current
title: Why this matters for the daemon family
parent: endo-but-for-bots--llm-designs-daemon-guest-eval-simplification--three-configurations-of-eval-authority-with-ocap-as-safety-boundary-not-message-approval
---

The eval-proposal handshake was a *holdover from the No-eval and
Eval-with-approval* configurations. Removing it *commits the
default to capability-discipline-only safety*. Cycle 105's
`daemon-capability-bank` Design Principle 1 (*Capabilities are
objects, not configurations*) is now the *only* safety boundary
for guest eval. The simplification *aligns the implementation
with the discipline*.

The 2026-04-24 / 2026-05-04 update history (created 2026-03-21,
PR #92 merged later) shows the design's lifecycle:
*design-then-implement-then-correct*. The Status block has been
edited *after implementation* to reflect what actually happened
(the Responder preservation correction).
