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
title: §Always-compiled-dormant-by-default (Design Decision 1)
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-debugger--six-layer-XML-pass-through-with-dormant-by-default-and-break-on-uncaught-via-firstJump-walk
---

```
In dev/self-hosted environments, mxDebug and mxInstrument
are always defined at compile time.  This means every worker
binary carries the XS debug subsystem.  However, the debug
hooks (fxConnect, fxIsConnected, etc.) start as no-ops —
debug_enable() is never called until a "debug-attach"
envelope arrives for a specific worker.
```

§Two-binaries-eliminated. §The-pre-design-state had to choose
between debug-build (full subsystem, every binary larger) and
release-build (no debug ever available). §This-design-folds-both-
into-one: §always-compiled + §dormant-hooks.

§The-cost-named-explicitly: "modest increase in binary size and
a negligible per-instruction branch (the mxDebug bookkeeping
checks fxIsConnected, which returns false when dormant)."
§Honest-overhead-disclosure.

§The-cargo-feature-`debug`-gates the compile flag for
size-constrained production deployments. §Three-deployment-shapes
emerge:

1. **§Dev / self-hosted** — `debug=on`; debug subsystem present,
   dormant by default, activated per-worker via envelope.
2. **§Production-size-constrained** — `debug=off`; debug code
   compiled out entirely; hot-attach not available.
3. **§Production-with-on-demand-debug** — `debug=on`; binary
   larger but any worker debuggable on demand.

§Compare-to-cycle-178-daemon-xs-worker-snapshot's §suspend-only-
when-idle which avoids the CapTP reconnection problem entirely;
§this-design's §dormant-by-default avoids the §two-binaries
problem entirely. §Both-are-§avoid-the-problem-by-design-not-
by-handling-it patterns.
