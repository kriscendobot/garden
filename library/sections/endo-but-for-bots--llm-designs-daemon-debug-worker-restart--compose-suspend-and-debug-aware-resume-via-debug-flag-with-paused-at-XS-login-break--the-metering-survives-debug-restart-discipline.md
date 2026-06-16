---
section: compose-suspend-and-debug-aware-resume-via-debug-flag-with-paused-at-XS-login-break
source: endo-but-for-bots--llm-designs-daemon-debug-worker-restart
topics: [daemon, tooling, hardened-javascript]
status: current
title: The §metering-survives-debug-restart discipline
parent: endo-but-for-bots--llm-designs-daemon-debug-worker-restart--compose-suspend-and-debug-aware-resume-via-debug-flag-with-paused-at-XS-login-break
---

§Interaction with metering:

> *When a worker is restarted in debug mode, its metering
> state is preserved through the suspend/resume cycle (Phase
> 6 of the metering design). The debug session does not
> affect metering — computrons are still counted during
> debugger-driven stepping. This is correct: debugging a
> worker should not grant it unlimited computation.*

The §debug-doesn't-grant-unlimited-computation discipline.
Debugging is *observation*; it doesn't *bypass* the
substrate's resource discipline. Otherwise, a developer
could *exhaust* the budget during a step-through that's
indistinguishable from normal execution.

The §existing-mechanism-handles-escape-hatch observation:

> *If the caller wants to temporarily disable metering during
> a debug session, they can use the existing `meterSetQuota`
> to set measurement mode (hard_limit = 0).*

The §escape-hatch-exists-elsewhere pattern: the *temporary
disable* is the existing `meterSetQuota` knob, not a new
"debug doesn't meter" flag. The principle stays clean; the
escape hatch is *named and reusable*.
