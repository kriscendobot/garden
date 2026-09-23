---
section: compose-suspend-and-debug-aware-resume-via-debug-flag-with-paused-at-XS-login-break
source: endo-but-for-bots--llm-designs-daemon-debug-worker-restart
topics: [daemon, tooling, hardened-javascript]
status: current
title: The §load-bearing-gap — §too-late-by-the-time-debugger-attaches
parent: endo-but-for-bots--llm-designs-daemon-debug-worker-restart--compose-suspend-and-debug-aware-resume-via-debug-flag-with-paused-at-XS-login-break
---

The existing debugger ([daemon-xs-worker-debugger](daemon-xs-worker-debugger.md))
*hot-attaches* to a *running* worker. The §What-is-the-
Problem-Being-Solved section names what's missed:

> *It cannot catch initialization code, module-level side
> effects, or the first crank of message handling — by the
> time the debugger attaches, those have already executed.*

The §too-late-by-the-time-debugger-attaches problem: most
*surprising* bugs happen *during initialization*. Module-
level side effects, the first dispatch, eager `harden()`
calls — all execute *before* a hot-attach could fire its
first break.

The §three-invariants enumerate what the new mechanism must
guarantee:

1. **XS engine paused** before executing any code.
2. **Debugger must issue `<go/>`** before the engine takes
   its first steps.
3. **Breakpoints can be set before any code runs** —
   including module-level initialization and the first
   message dispatch.

The §enumerate-the-invariants pattern: rather than just say
"start in debug mode," the design *spells out exactly what
that means*. Each invariant is independently checkable.
