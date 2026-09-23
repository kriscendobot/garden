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
title: §C-platform-hooks → Rust callbacks (Layer 1)
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-debugger--six-layer-XML-pass-through-with-dormant-by-default-and-break-on-uncaught-via-firstJump-walk
---

§Five-platform-functions XS calls for debug I/O:

```c
void fxConnect(txMachine* the);
void fxDisconnect(txMachine* the);
txBoolean fxIsConnected(txMachine* the);
void fxReceive(txMachine* the);
void fxSend(txMachine* the, txBoolean more);
```

§The-platform-must-implement-all-five. §The-design-replaces-the-
default-stubs with Rust-calling implementations:

```c
static __thread RustDebugSendFn rust_debug_send = NULL;
static __thread RustDebugRecvFn rust_debug_recv = NULL;
static __thread RustDebugIsReadableFn rust_debug_readable = NULL;
static __thread void* rust_debug_context = NULL;
static __thread int rust_debug_connected = 0;
```

§Thread-local-storage because XS machines are single-threaded
and each worker runs on its own thread. §The-`__thread`-storage-
class is C11 thread-local; §matches-cycle-176-endor's-§pool-of-
machine-runner-threads model.

§The-Rust-side uses `Mutex<Option<DebugBuffers>>` with
`VecDeque<u8>` for outbound and inbound — §the-design-comments
"The mutex is for safety but should be uncontended in practice
since only the worker thread and the bus I/O thread touch it,
and they alternate."

§Design-Decision-3-named-explicitly: "Thread-local buffers with
mutex... XS machines are single-threaded. Each worker thread has
its own debug buffers."
