---
title: 'endo-but-for-bots designs/daemon-xs-worker-debugger.md — XS Worker Debugger for Endo Rust'
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-xs-worker-debugger.md
source_paths:
  - designs/daemon-xs-worker-debugger.md
authors:
  - Kris Kowal (prompted)
created: 2026-04-14
updated: 2026-04-15
status_at_ingest: In Progress
ingested: 2026-06-03
ingested_by: scholar
topics:
  - daemon
  - capability-security
  - hardened-javascript
sections:
  - endo-but-for-bots--llm-designs-daemon-xs-worker-debugger--six-layer-XML-pass-through-with-dormant-by-default-and-break-on-uncaught-via-firstJump-walk.md
genre: §endo-but-for-bots-design §sibling-design-trio
cycle: 182
lane: designs
---

# XS Worker Debugger for Endo Rust (design)

## §Abstract

1211-line design enabling interactive debugging — breakpoints,
stepping, frame inspection, profiling — for Endo's Rust-
supervised XS workers. Status: **In Progress** (Phases 1-5
done; Phase 6 UI shell done, with `attachDebugger` CapTP
exposure, `followBreaks` live notification, source-view, and
profiling format remaining).

§Six-layer-stack: C platform hooks → Rust callbacks → envelope
bus verbs → DebugSession SAX → Debugger exo → Chat panel.

§The-architecture chooses XML pass-through (stock xsbug
protocol from Moddable) over translation or JSON forking. The
Rust supervisor ferries opaque XML bytes; a JS-side SAX parser
inside SES handles the protocol. The Debugger is exposed as a
CapTP-remotable exo with sixteen methods plus `followBreaks`
async iterator subscription.

§Hot-attach is enabled by §always-compiled-dormant-by-default:
every worker binary in dev/self-hosted builds carries the debug
subsystem, but the hooks are no-ops until a `"debug-attach"`
envelope arrives for that worker. A cargo feature `debug` gates
the compile flag for size-constrained production deployments.

§The-deepest-move is the §break-on-uncaught-exceptions
augmentation (lines 922-1166): a small protocol extension (new
pseudo-breakpoint path `"uncaughtExceptions"`) exploits XS's
pre-jump throw hook to walk the active exception-handler linked
list at throw time. §Zero-cost-if-the-answer-is-don't-break:
the `fxDebugThrow` callback runs before `fxJump` does the
longjmp, so the decision is made with full stack + locals
still live, with no need to backtrack.

§Forward-compatible: older xsbug clients that don't send
`"uncaughtExceptions"` breakpoints see no change in behavior.
The augmentation is contained in `fxDebugThrow` + `fxSet/
ClearBreakpoint` — < 30 lines of XS source change.

## §Files and identifiers

| File | Lines | Role |
|------|-------|------|
| `designs/daemon-xs-worker-debugger.md` | 1211 | The design being ingested |
| `rust/endo/xsnap/src/powers/debug.rs` | — | Debug I/O buffers + C callbacks (new) |
| `rust/endo/xsnap/src/cesu8.rs` | — | CESU-8 ↔ UTF-8 codec (new) |
| `packages/daemon/src/debug-session.js` | — | xsbug XML SAX parser + structured API (new) |
| `packages/daemon/src/debugger.js` | — | Debugger exo (CapTP-remotable; new) |
| `packages/chat/debugger-panel.js` | — | Chat debugger panel UI (new) |
| `c/moddable/xs/sources/xsDebug.c` | — | `fxDebugThrow` augmentation (modified for uncaught-only mode) |
| `c/moddable/xs/sources/xsAll.h` | — | `breakOnUncaughtExceptionsFlag` added to txMachine |

## §Dependencies and lineage

- §Builds-on cycle 176 (daemon-endor-architecture) — the Rust
  supervisor substrate this design lives within.
- §Sibling-design-pair to cycle 178 (daemon-xs-worker-snapshot)
  — both extend xsnap engine exposure with non-obvious
  mechanism over envelope-bus.
- §Third-sibling (un-ingested): `daemon-xs-worker-metering.md`
  (828 lines) — the §xs-worker-capability-trio observability
  member.
- §Spec-source: Moddable XS's xsbug protocol (reference impl in
  `c/xsnap-pub/xsnap/xsbug-node/xsbug-machine.js`).
- §Cycle-167 (`endo--packages-where-index-js.md`) — `mxDebug` /
  `mxInstrument` / `mxMetering` are compile-time flags in the
  XS engine; the cargo `debug` feature gates `mxDebug` +
  `mxInstrument` (not `mxMetering`, which is always on).

## §Related sources in the library

- §Cycle 178 (`endo-but-for-bots--llm-designs-daemon-xs-worker-
  snapshot.md`) — §sibling-design-pair. Both in xs-worker-*
  family; both In Progress; both extend xsnap with envelope-
  based control plane.
- §Cycle 176 (`endo-but-for-bots--llm-designs-daemon-endor-
  architecture.md`) — the Rust supervisor that this design's
  Layer 1-2 live inside. Names CESU-8-surrogate-pair-encoding
  as XS string quirk; this design's `cesu8.rs` is part of the
  same family.
- §Cycle 135 (`endo-but-for-bots--llm-designs-daemon-locator-
  reference.md`) — §followNameChanges-subscription-pattern
  sibling to this design's `followBreaks` async iterator.
- §Cycle 161 (`endo-but-for-bots--llm-designs-filesystem-
  watchers.md`) — `followNameChanges` extension on EndoMount;
  same §async-iterator-subscription-pattern.
- §Cycle 170 (`endo-but-for-bots--llm-designs-daemon-capability-
  filesystem.md`) — §caretaker-facet-separation sibling
  (DebuggerView / DebuggerControl / DebuggerAdmin as natural
  facets of this design's Debugger exo).
- §Cycle 108 (`endo--packages-exo-src-exo-makers-js.md`) — the
  `makeExo` + `M.interface` substrate that the Debugger exo
  uses.
- §Cycle 177 (`endo--packages-netstring-reader-js.md`) —
  §state-machine-parser sibling. DebugSession's SAX parser is
  the same shape for xsbug XML.

## §Comment fragments worth preserving (from the design prose)

```
In dev/self-hosted environments, mxDebug is always defined at
compile time.  This means every worker binary carries the XS
debug subsystem.  However, the debug hooks start as no-ops —
debug_enable() is never called until a "debug-attach" envelope
arrives for a specific worker.
```

§The-§dormant-by-default discipline named. §One-binary; per-
worker activation; eliminates the §two-binaries problem.

```
The xsbug protocol supports a single exception breakpoint
mode... This is noisy and unusable in practice. Endo code
throws and catches exceptions constantly as part of normal
control flow.
```

§The-problem-named-honestly. §Why-the-augmentation-is-needed,
not just §what.

```
XS calls fxDebugThrow before fxJump, not after.  The decision
to break or not can be made at throw time with zero cost if the
answer is "don't break."
```

§The-architectural-property-named-explicitly. §The-pre-jump-
window-as-the-decision-point. §A-deep-fact-about-the-XS-
exception-machinery is exposed as a §design-affordance.

```
There is no need to "undo" anything because execution has not
left the throw site yet.
```

§The-zero-cost-property-named. §No-backtracking-needed because
the decision is made before the irreversible action.

```
This is the Endo way: everything is a capability.  The debugger
can be granted, delegated, and revoked like any other
capability.  A guest could debug its own sub-workers if given
the debugger capability.
```

§Decision-5-named-explicitly. §The-meta-discipline that pervades
Endo applies to the debugger too.
