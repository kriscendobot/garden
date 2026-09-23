---
section: compose-suspend-and-debug-aware-resume-via-debug-flag-with-paused-at-XS-login-break
source: endo-but-for-bots--llm-designs-daemon-debug-worker-restart
topics: [daemon, tooling, hardened-javascript]
status: current
title: The §five Design Decisions codify the structural choices
parent: endo-but-for-bots--llm-designs-daemon-debug-worker-restart--compose-suspend-and-debug-aware-resume-via-debug-flag-with-paused-at-XS-login-break
---

§Design Decisions:

1. **Compose suspend + debug-aware resume** — §compose-
   existing-not-invent-new.
2. **Debug flag on supervisor, not per-message** — §flag-
   set-before-action-not-action-with-flag.
3. **Worker paused at `<login>`, not at first user code** —
   §earliest-possible-break.
4. **CapTP connections broken** — §accept-the-cost-because-
   developer-tool.
5. **Method name `debugWorker`, not `restartWorkerInDebugMode`**
   — *Concise and discoverable. The "restart" is an
   implementation detail — from the user's perspective, they
   are debugging a worker*. §user's-perspective-not-
   implementation-detail.

The §five-decisions-form-coherent-shape: each decision
reinforces the others. *Composition* (D1) requires *minimal
protocol additions* (D2). *Earliest break* (D3) makes the
*one method* (D5) actually useful. *Accepting the connection
cost* (D4) is *consistent with* being a developer tool. The
decisions are *not independent*; they form a *coherent
design philosophy*.
