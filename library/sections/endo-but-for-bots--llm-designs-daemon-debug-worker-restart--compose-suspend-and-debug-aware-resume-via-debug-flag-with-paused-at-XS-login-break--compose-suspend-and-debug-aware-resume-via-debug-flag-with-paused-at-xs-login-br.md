---
section: compose-suspend-and-debug-aware-resume-via-debug-flag-with-paused-at-XS-login-break
source: endo-but-for-bots--llm-designs-daemon-debug-worker-restart
topics: [daemon, tooling, hardened-javascript]
status: current
title: Compose suspend and debug-aware resume via debug-flag with paused-at-XS-`<login>`-break
parent: endo-but-for-bots--llm-designs-daemon-debug-worker-restart--compose-suspend-and-debug-aware-resume-via-debug-flag-with-paused-at-XS-login-break
---

> *No new restart primitive is needed. Suspend/resume already
> exists; adding a debug flag to the resume path is minimal.
> This keeps the supervisor simple — it does not need to
> understand "restart" as a concept.*
>
> — `designs/daemon-debug-worker-restart.md` §Design Decision 1

`daemon-debug-worker-restart.md` (386 lines, *Not Started*
status, created 2026-04-17) is a **compose-existing-not-
invent-new design** by Kris Kowal *(prompted)*. Last touch
commit `100774ff` 2026-05-02 — *docs(designs): Endor
architecture, SQLite, makeArchive, and supporting designs*.

The design adds *one method* — `E(host).debugWorker('@main')`
— without any new supervisor primitive. The §minimum-protocol-
addition discipline produces a *small* design over a *large*
substrate.
