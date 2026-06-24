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
title: §The-six-layer-stack
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-debugger--six-layer-XML-pass-through-with-dormant-by-default-and-break-on-uncaught-via-firstJump-walk
---

| Layer | Component | Where it lives |
|-------|-----------|----------------|
| 1 | C platform hooks → Rust callbacks | `xsnap-platform.c/h` + `powers/debug.rs` |
| 2 | Envelope bus verbs `debug` / `debug-attach` / `debug-detach` | `proc.rs`, `inproc.rs` |
| 3 | DebugSession (xsbug XML SAX parser + structured API) | `packages/daemon/src/debug-session.js` |
| 4 | Debugger exo (CapTP-remotable) | `packages/daemon/src/debugger.js` |
| 5 | Daemon bus handler + `attachDebugger` | `packages/daemon/src/bus-daemon-rust-xs.js` |
| 6 | Chat debugger panel + `/debug` command | `packages/chat/debugger-panel.js` |

§Six-layer-strict-stratification. §Each-layer-only-talks-to-the-
layer-above-and-below. §Compare-to-cycle-176-daemon-endor-
architecture which has §three-worker-platforms decomposition;
§this-design-has §six-layers-across-language-boundaries (C → Rust
→ JS → SES → CapTP-remotable → UI).

§The-traffic-flow per debugger action:

```
UI button click
  ↓ [Layer 6]
E(debugger).setBreakpoint(path, line)
  ↓ [Layer 5: daemon bus handler]
DebugSession command method
  ↓ [Layer 4]
xsbug XML written to outbound buffer
  ↓ [Layer 3]
envelope verb "debug" + XML payload
  ↓ [Layer 2: envelope bus]
worker's debug.rs inbound buffer
  ↓ [Layer 1: C callback rust_debug_recv]
XS engine's fxRunDebugger reads command
  ↓
breakpoint registered in XS internals
  ↓ (response XML)
... same path reversed back to UI
```
