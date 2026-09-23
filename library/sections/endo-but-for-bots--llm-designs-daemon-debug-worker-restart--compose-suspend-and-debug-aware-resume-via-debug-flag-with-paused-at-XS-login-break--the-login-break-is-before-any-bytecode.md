---
section: compose-suspend-and-debug-aware-resume-via-debug-flag-with-paused-at-XS-login-break
source: endo-but-for-bots--llm-designs-daemon-debug-worker-restart
topics: [daemon, tooling, hardened-javascript]
status: current
title: The §<login>-break is before any bytecode
parent: endo-but-for-bots--llm-designs-daemon-debug-worker-restart--compose-suspend-and-debug-aware-resume-via-debug-flag-with-paused-at-XS-login-break
---

§Design Decision 3:

> *XS enters the debug loop immediately after `fxConnect`
> during machine creation/restoration. The `<login>` break is
> before any bytecode executes. This gives the caller a
> window to set breakpoints before any code runs.*

The §XS-debug-loop-fires-at-machine-creation observation: XS
itself has the *paused-at-construction* hook. The design
*uses* it; doesn't invent it.

The §`<login>`-not-first-user-code distinction matters: a
naive *first-user-code* hook would have to identify "user
code" (vs runtime / module-loader code). XS's `<login>` is
*before any of that* — even module-loader bytecode hasn't
run yet. §earliest-possible-break.
