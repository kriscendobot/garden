---
section: compose-suspend-and-debug-aware-resume-via-debug-flag-with-paused-at-XS-login-break
source: endo-but-for-bots--llm-designs-daemon-debug-worker-restart
topics: [daemon, tooling, hardened-javascript]
status: current
title: The §single most structurally interesting move — §compose-existing-not-invent-new
parent: endo-but-for-bots--llm-designs-daemon-debug-worker-restart--compose-suspend-and-debug-aware-resume-via-debug-flag-with-paused-at-XS-login-break
---

§Design Decision 1:

> *No new restart primitive is needed. Suspend/resume already
> exists; adding a debug flag to the resume path is minimal.
> This keeps the supervisor simple — it does not need to
> understand "restart" as a concept.*

The §compose-existing-not-invent-new discipline. The
mechanism is *two existing operations* (suspend + resume)
*plus one new flag*:

1. **Suspend** the worker — snapshot to CAS (existing).
2. **Set `debug-flag`** on the worker's handle (one new
   verb).
3. **Trigger resume** — the supervisor checks the flag and
   calls `debug_enable()` before machine restoration
   (existing path + one branch).

The §don't-invent-restart-as-a-concept observation: the
supervisor doesn't need a `restart` opcode. *Restart* is *just
suspend + resume* with the debug flag set in between.

The §preserve-identity-across-snapshot property:

> *The worker keeps its handle, its bus identity, its pending
> messages in the inbox, and its metering state.*

Because the restart *is* suspend+resume, all the invariants
of the suspend+resume cycle hold. §invariant-preserved-by-
composition.
