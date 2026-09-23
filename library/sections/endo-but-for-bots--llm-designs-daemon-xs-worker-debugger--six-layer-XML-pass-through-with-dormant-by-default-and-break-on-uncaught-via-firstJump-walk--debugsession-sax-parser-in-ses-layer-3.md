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
title: §DebugSession SAX parser in SES (Layer 3)
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-debugger--six-layer-XML-pass-through-with-dormant-by-default-and-break-on-uncaught-via-firstJump-walk
---

```js
packages/daemon/src/debug-session.js
```

§Maintains:
- §SAX-parser-state (minimal XML parser; ~100-line state machine
  suffices for xsbug's simple XML subset)
- §Current-breakpoint-set
- §Last-break-location (path, line)
- §Last-frames/locals/globals snapshots
- §Profile-accumulator
- §Pending-command-callbacks (request/response correlation)

§Why-hand-written-SAX-not-Saxophone-npm: "must be written in
Jessie-compatible JS (no regex literals in some contexts, no
`eval`)... The xsbug XML subset is simple enough for a hand-
written state machine parser."

§Compare-to-cycle-177-netstring/reader.js' §two-state-iterator
+ §three-character-cases-prefix-parsing. §The-DebugSession-SAX
is a §similar-state-machine-for-a-different-protocol.

§The-feed-cycle is four-step:

1. Raw XML bytes arrive (`feedXml(bytes)`).
2. SAX parser emits element events.
3. Element handlers update state + resolve pending promises.
4. Break events emit to registered listeners.

§Promise-correlation-by-pending-callbacks: e.g., `getFrames()`
returns a promise that resolves when `<frames>` arrives.

§Sixteen-command-methods enumerated (go / step / stepIn / stepOut
/ setBreakpoint / clearBreakpoint / clearAllBreakpoints /
getFrames / getLocals / getGlobals / selectFrame / toggleProperty
/ evaluate / startProfiling / stopProfiling / abort).
