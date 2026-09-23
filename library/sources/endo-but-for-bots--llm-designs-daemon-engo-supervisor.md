---
title: 'endo-but-for-bots designs/daemon-engo-supervisor.md — Engo: Go Supervisor (unrealized predecessor of cycle 176)'
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-engo-supervisor.md
source_paths:
  - designs/daemon-engo-supervisor.md
authors:
  - Kris Kowal (prompted)
created: 2026-02-25
status_at_ingest: Not Started
ingested: 2026-06-05
ingested_by: scholar
topics:
  - daemon
  - capability-security
sections:
  - endo-but-for-bots--llm-designs-daemon-engo-supervisor--three-architecture-diagrams-platform-pair-convention-and-progressive-syscall-migration-as-unrealized-predecessor.md
genre: §endo-but-for-bots-design §unrealized-predecessor-of-cycle-176
cycle: 192
lane: designs
---

# Engo: Go Supervisor for Endo Daemon (unrealized predecessor)

## §Abstract

481-line **Not Started** design (Created 2026-02-25) for a
Go supervisor process ("engo") that would wrap the existing
Node.js Endo daemon and manage all workers as peers.

§The-design-never-shipped: the team pivoted to Rust. §Cycle-
176-endor-architecture (Created 2026-04-16, Status Active) is
the §canonical-supervisor that shipped instead.

§The-key-mechanisms-that-engo-pioneered (and endor inherited):

- §Handle-rewriting on forwarded messages.
- §Spawn-tree-deadlock-prevention with §canBlock check.
- §CBOR-envelope-framing on fd 3/4.
- §Byte-identical-envelopes-across-platforms.
- §Cooperative-not-preemptive-scheduling.

§What-changed-in-the-pivot:

1. §Rust-instead-of-Go (performance + memory-safety + Cargo
   alignment).
2. §Endor-supports-shared-in-process-XS-worker as a co-
   resident option; engo only contemplated subprocess
   workers.
3. §Endor-uses-include_str!-for-embedded-JS; engo would have
   needed a different mechanism.

§Neither-design-explicitly-marks-engo-as-superseded. §An-
§implicit-supersedes that future maintainers would need to
discover by reading both designs.

§Key-disciplines:

- §Three-architecture-diagrams (current / target / future) —
  visualize-the-transition.
- §-platform.js + §-platform-powers.js naming convention (a
  §four-file-quadruple per platform — daemon + daemon-powers
  + worker + worker-powers).
- §Near-copies-with-channel-adapted as the migration-path.
- §Progressive-syscall-migration in §named-priority-order
  (fs first, net second, crypto third — most-impactful-first;
  Phase 4 is §unbounded).
- §Incrementalism-as-the-key-constraint (existing Node.js
  daemon must continue to work unmodified; engo is additive,
  not replacement).
- §Rollback-trivial: `-node` modules remain alongside `-go`
  modules.
- §Five-phase-incremental-implementation with §Validation-
  per-phase including §process-tree-inspection-via-`ps`.
- §Out-of-scope-but-architecture-supports-it for subprocess-
  isolation (macOS sandbox-exec / Linux namespaces+seccomp /
  supervisor-syscall-confinement).
- §Web-future-architecture-pair with §dashes-for-worker-
  entries (named-but-not-built).

## §Files and identifiers

| File | Lines | Role |
|------|-------|------|
| `designs/daemon-engo-supervisor.md` | 481 | This design (Not Started) |
| `packages/engo/` (not created) | — | Would have held Go supervisor source |
| `daemon-go.js` (not created) | — | Daemon entry under engo |
| `daemon-go-powers.js` (not created) | — | Daemon powers under engo |
| `worker-go.js` (not created) | — | Worker entry under engo |
| `worker-go-powers.js` (not created) | — | Worker powers under engo |

## §Dependencies and lineage

- §Predecessor-of-cycle-176-endor-architecture (Active). §The-
  Rust-supervisor that shipped instead. §Neither-design-marks-
  the-supersedes-relationship-explicitly.
- §Cites-`endo-engo`-prototype (an earlier Go prototype that
  established the envelope protocol, handle table, and
  deadlock prevention).
- §Built-on Endo daemon's existing `-node.js` / `-node-
  powers.js` platform-pair convention.
- §CBOR-libraries: `fxamacker/cbor/v2` (Go); `cbor-x` or
  `@ipld/dag-cbor` (Node.js).

## §Related sources in the library

- §Cycle 176 (`endo-but-for-bots--llm-designs-daemon-endor-
  architecture.md`) — §the-Rust-successor that shipped
  instead. Inherits substantial DNA (handle-rewriting +
  spawn-tree-deadlock-prevention + CBOR-envelopes + three-
  worker-platforms).
- §Cycle 178 (`endo-but-for-bots--llm-designs-daemon-xs-
  worker-snapshot.md`) — §xs-worker-trio-member that
  presumes endor's architecture.
- §Cycle 182 (`endo-but-for-bots--llm-designs-daemon-xs-
  worker-debugger.md`) — §xs-worker-trio-member sharing
  §`"debug"`-verb-same-in-both-directions / §handle-
  rewriting-distinguishes-sender pattern.
- §Cycle 184 (`endo-but-for-bots--llm-designs-daemon-xs-
  worker-metering.md`) — §xs-worker-trio-member with §custom-
  fxAbort + §three-phase-drain-loop.
- §Cycle 188 (`endo-but-for-bots--llm-designs-daemon-rust-xs-
  performance.md`) — §performance-investigation of the
  shipped Rust supervisor.
- §Cycle 190 (`endo-but-for-bots--llm-designs-endo-posix-
  sandbox.md`) — §sandboxing-plugin that delivers the
  §out-of-scope-but-architecture-supports-it sandboxing from
  cycle 192. §Cycle-190-explicitly-supersedes daemon-os-
  sandbox-plugin with named improvements; cycle-192 does not
  do this with cycle-176.
- §Cycle 186 (`endo-but-for-bots--llm-designs-break-dev-
  dependency-cycles.md`) — §supersedes-record-pattern
  example. Cycle 192/176 lack this pattern.
- §Cycle 167 (`endo--packages-where-index-js.md`) — §per-
  platform-naming-conventions sibling at the runtime-
  discovery layer.
- §Cycle 179 (`endo--packages-lp32-reader-writer-js.md`) —
  §host-byte-order-as-deliberate-IPC-marker. §Cycle-192-uses-
  big-endian-instead because of §cross-language-IPC need.

## §Comment fragments worth preserving

```
The key constraint is **incrementalism**: the existing Node.js
daemon must continue to work unmodified under `endo start`.
Engo is an alternative supervisor that hosts the daemon as a
subprocess and manages all workers as peers.
```

§Incrementalism-as-the-key-constraint named-explicitly. §The-
§must-continue-to-work-unmodified property is the load-bearing
discipline.

```
This phase is unbounded — it proceeds as far as is useful
without requiring completion.
```

§Phase-4-unbounded named. §The-§progressive-syscall-migration
has no completion-criterion; each syscall ships when ready.

```
Engo does not modify the `endo` CLI.  Users can run
`engo start` instead of `endo start` to use the Go
supervisor.
```

§The-§scope-boundary-with-named-future-direction. §Initial-
scope: engo is a separate command. §Future-direction: CLI
could detect engo or engo could subsume CLI commands.

```
Because engo wraps the existing daemon without modifying it,
rolling back is trivial: stop the engo-managed daemon and
start one directly with `endo start`.  No state migration is
needed.
```

§Rollback-trivial-discipline. §Preserve-existing-alongside-
new. §Two-implementations-coexist; the user-or-CLI chooses.

```
Engo's value proposition includes the ability to apply OS-
level sandboxing to workers it spawns directly.  This is out
of scope for the initial phases but the architecture supports
it.
```

§Out-of-scope-but-architecture-supports-it. §Cycle-190-endo-
posix-sandbox eventually delivered this (under a different
supervisor, the Rust endor).
