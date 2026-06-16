---
section: three-configurations-of-eval-authority-with-ocap-as-safety-boundary-not-message-approval
source: endo-but-for-bots--llm-designs-daemon-guest-eval-simplification
topics: [agent-conventions, capability-security]
status: current
title: The §What is Preserved list
parent: endo-but-for-bots--llm-designs-daemon-guest-eval-simplification--three-configurations-of-eval-authority-with-ocap-as-safety-boundary-not-message-approval
---

Five items kept:

- **Pet name resolution** in the guest's own namespace — *the
  guest still resolves names against its own pet store*.
- **`formulateEval()`** — *the actual eval formula creation in
  the daemon, which compiles and evaluates code in a compartment
  with the specified endowments*.
- **The worker constraint** — *agents can only evaluate in
  workers they can access (e.g., `@main`). The worker reference
  is still resolved as a pet name*. The *ocap-bounds-which-
  worker* invariant.
- **All other message types** — *request, package, value, and
  definition messages are unaffected*.
