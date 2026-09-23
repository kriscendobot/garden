---
source: designs/daemon-xs-worker-debugger.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-xs-worker-debugger.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - capability-security
  - hardened-javascript
status_at_ingest: In Progress
genre: §endo-but-for-bots-design §sibling-design-trio
cycle: 182
lane: designs
status: current
title: §Hot-attach via `"debug-attach"` envelope (Layer 6)
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-debugger--six-layer-XML-pass-through-with-dormant-by-default-and-break-on-uncaught-via-firstJump-walk
---

```js
const debugger = await attachDebugger(workerHandle);
```

§Six-step-attach-flow:

1. Daemon sends `"debug-attach"` envelope to worker's supervisor
   handle.
2. Rust supervisor calls `debug_enable()` for the worker's
   thread, activating the debug hooks.
3. XS calls `fxConnect` on the next `fxRunDebugger` cycle;
   `fxIsConnected` now returns true.
4. XS emits a `<login>` response with machine name and tag.
5. Daemon receives login, creates a `Debugger` exo + formula
   for the worker.
6. Returns the debugger capability to the caller.

§Detach-flow-symmetric: drop the Debugger exo (or send
`"debug-detach"`); supervisor calls `debug_reset()`; XS calls
`fxDisconnect`; worker resumes normal execution.

§Compare-to-cycle-178-suspend/resume which has §two-state-
machine Live ↔ Suspended; §this-design's §two-state-machine is
Dormant ↔ Active. §The-active-state-is-the-§debugger-attached
state; the dormant state is the default.

§No-CLI-command: "There is no `endo debug` CLI command. The
primary entry point is the daemon's `attachDebugger` method,
callable from any CapTP peer." §The-CLI-is-not-the-API; CapTP-
attachment-is-the-API. §A-Chat-worker-can-debug-another-worker;
the gateway can debug a worker; Familiar can debug a worker.
