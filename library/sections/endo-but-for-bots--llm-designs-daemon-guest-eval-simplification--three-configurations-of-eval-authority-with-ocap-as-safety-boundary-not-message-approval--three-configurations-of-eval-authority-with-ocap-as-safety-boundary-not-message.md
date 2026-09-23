---
section: three-configurations-of-eval-authority-with-ocap-as-safety-boundary-not-message-approval
source: endo-but-for-bots--llm-designs-daemon-guest-eval-simplification
topics: [agent-conventions, capability-security]
status: current
title: Three configurations of eval authority with ocap as safety boundary (not message approval)
parent: endo-but-for-bots--llm-designs-daemon-guest-eval-simplification--three-configurations-of-eval-authority-with-ocap-as-safety-boundary-not-message-approval
---

> *`evaluate` is a "tool of tools" — having it drastically reduces
> the need for special-purpose tools.*
> *Ocap discipline is the safety boundary, not message approval.*
>
> — `designs/daemon-guest-eval-simplification.md` §Motivation

`daemon-guest-eval-simplification.md` (160 lines, *Implemented*
status, created 2026-03-21 / updated 2026-05-04, PR #92) is a
**design retrospective**: the eval-proposal handshake was removed
from the daemon in commit `90f8e910f9` (*Guests can eval without
permission*) on the `llm` branch. Guest `evaluate` now calls
`formulateEval` directly with endowments resolved in the guest's
own pet store, *structurally identical to the host path*.
