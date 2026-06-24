---
section: three-configurations-of-eval-authority-with-ocap-as-safety-boundary-not-message-approval
source: endo-but-for-bots--llm-designs-daemon-guest-eval-simplification
topics: [agent-conventions, capability-security]
status: current
title: The §three-configurations-of-eval-authority taxonomy
parent: endo-but-for-bots--llm-designs-daemon-guest-eval-simplification--three-configurations-of-eval-authority-with-ocap-as-safety-boundary-not-message-approval
---

The §Motivation enumerates the three eval-authority configurations:

1. **No eval** — *the agent advises on code but cannot execute it*.
   *Mark Miller proposed this model early in Endo Familiar's
   development: reasoning about capability composition is
   tractable, so agents should be able to *advise* on code without
   running it.* The §canonical-Mark-Miller-advisory-model.
   *Remains useful for advisory-only roles.*

2. **Eval with approval** — *the agent proposes code, the user
   reviews and grants execution. This is the current `EndoGuest`
   behavior* (at design time). *In practice, the proposal/approval
   handshake for eval fatigues users. The hypothesis that approval
   adds safety has not been borne out — users approve reflexively,
   gaining neither security nor productivity.* The §reflexive-
   approval-without-security observation is the design's
   single-most-consequential empirical claim.

3. **Eval with authority** — *the agent evaluates freely, bounded
   only by reachable capabilities. This is the current `EndoHost`
   behavior and the model that `lal-fae-form-provisioning` agents
   already use via direct eval. Object-capability discipline
   already constrains what evaluated code can do. This is the
   practical default.*

The §discipline-not-approval claim:

> *Ocap discipline is the safety boundary, not message approval.*

This is the design's *thesis*. The eval-proposal flow added
*ceremony* without adding *safety*. Object-capability discipline
(cycle 105's `daemon-capability-bank` codifies this as Design
Principle 1: *Capabilities are objects, not configurations*)
already bounds what eval'd code can reach. If the agent only has
a `Dir` for `/project`, eval'd code only has that `Dir`. *Approval
adds nothing.*
