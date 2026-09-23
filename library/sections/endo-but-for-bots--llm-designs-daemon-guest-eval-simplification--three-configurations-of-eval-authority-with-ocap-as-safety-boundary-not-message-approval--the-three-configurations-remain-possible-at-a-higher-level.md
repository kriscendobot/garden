---
section: three-configurations-of-eval-authority-with-ocap-as-safety-boundary-not-message-approval
source: endo-but-for-bots--llm-designs-daemon-guest-eval-simplification
topics: [agent-conventions, capability-security]
status: current
title: The §three-configurations-remain-possible-at-a-higher-level
parent: endo-but-for-bots--llm-designs-daemon-guest-eval-simplification--three-configurations-of-eval-authority-with-ocap-as-safety-boundary-not-message-approval
---

defense

The §Design Decision 3 names the *don't-eliminate-the-other-
configurations* discipline:

> *An attenuating proxy could withhold `evaluate` from a guest's
> facet, restoring the "no eval" or "eval with approval"
> configurations. But `EndoGuest` itself does not impose approval
> by default.*

The §attenuation-via-proxy-not-via-default discipline: the design
*removes the approval flow from the default*; users who want
approval can build an attenuating proxy that withholds eval (or
implements its own approval). The capability discipline is the
*mechanism*; the choice is the *policy*. Endo's default is
*authority*; attenuation is *opt-in*.
