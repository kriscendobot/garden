---
section: compose-suspend-and-debug-aware-resume-via-debug-flag-with-paused-at-XS-login-break
source: endo-but-for-bots--llm-designs-daemon-debug-worker-restart
topics: [daemon, tooling, hardened-javascript]
status: current
title: How this design fits the @endo-but-for-bots cluster
parent: endo-but-for-bots--llm-designs-daemon-debug-worker-restart--compose-suspend-and-debug-aware-resume-via-debug-flag-with-paused-at-XS-login-break
---

Three explicit Dependencies:

| Design | Relationship |
|--------|-------------|
| `daemon-xs-worker-debugger` | Requires (debug infrastructure) |
| `daemon-xs-worker-snapshot` | Requires (suspend/resume) |
| `daemon-xs-worker-metering` | Composes (meter state preserved) |

The §dependency-typology — *Requires* vs *Composes*:

- **Requires**: the design *cannot ship* without this.
- **Composes**: the design *interacts* with this; both must
  understand each other.

The §two-required-pieces-make-the-substrate observation:
this design *adds one thin layer* on top of two substrates
(debugger + snapshot). Without either, the design is
inoperable. §thin-layer-on-thick-substrate.
