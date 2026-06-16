---
section: compose-suspend-and-debug-aware-resume-via-debug-flag-with-paused-at-XS-login-break
source: endo-but-for-bots--llm-designs-daemon-debug-worker-restart
topics: [daemon, tooling, hardened-javascript]
status: current
title: The §three-implementation-phases with tests
parent: endo-but-for-bots--llm-designs-daemon-debug-worker-restart--compose-suspend-and-debug-aware-resume-via-debug-flag-with-paused-at-XS-login-break
---

| Phase | Scope | Test |
|-------|-------|------|
| **1** | Rust supervisor debug flag | `take_debug_flag` returns true once, false thereafter |
| **2** | JS manager `debugWorker` | call on running worker → returned Debugger is connected and worker is paused |
| **3** | Chat integration | manual: `/debug-restart @main` opens the debugger panel |

The §phased-with-tests pattern: each phase has an *acceptance
test*. The §independent-phases-with-clear-handoffs property:
Phase 1 can land alone (test passes); Phase 2 builds on
Phase 1's landed support; Phase 3 is UI on top of Phase 2.

The §manual-test-OK-for-UI-phase concession: Phase 3's test
is manual. Chat integration is hard to automate without a
running daemon + chat UI; *manual is acceptable* given the
small surface area of the new command.
