---
kind: result
role: liaison
host: endolin
dispatch_root: /home/kris/garden/dispatches/liaison--75645e
ts: 2026-06-03T12:28:37Z
ref_id: 75645e
---

# Cycle 154 result — captp/src/trap.js (thirty-sixth comment-fragment ingest; first @endo/captp source file)

Cycle 154 of the librarian arc. Nominally chat-lane (exhausted at
20/20); papers-lane blocked **48+ consecutive cycles**. Pivoted to
comments-lane.

## Source

`endo/packages/captp/src/trap.js` (105 lines). The file's *one-line
opening comment* declares its derivation: *Lifted mostly from
`@endo/eventual-send/src/E.js`* (cycle 146). Last touched 2025-10-09
by Kris Kowal in cycle 108's coordinated-update commit `e56bf00f`.

**First @endo/captp source file ingested** (the cluster has six
substantial source files: captp.js / atomics.js / loopback.js /
trap.js / finalize.js / index.js).

## Structural moves captured

- **§Load-bearing-relationship**: §lifted-from-X-comment discipline
  names the relationship at file top. §sibling-via-lifting + §shared-
  shape-different-semantics — same lattice (Proxy handler trio +
  freezable-not-hardened targets + callable-with-methods factory),
  different operator (synchronous-blocking vs eventual-send).

- **§Three-method-TrapImpl interface** (applyFunction / applyMethod /
  get). §narrowed-API-for-narrower-semantics — five-surface E.js →
  two-surface Trap (no SendOnly / no resolve / no when; all removed
  methods were promise-related; Trap's whole point is *no promises*).

- **Single most structurally interesting move**: §no-`this`-receiver-
  check (vs cycle 146's §this-receiver-check via concise-method-
  syntax). The returned function is an *arrow function* — no `this`
  to depend on; detach-attack vector doesn't exist. §arrow-function-
  is-already-detach-safe property emerges *for free* from closure
  semantics. No defensive code needed.

- **§baseFreezableProxyHandler + §funcTarget + §objTarget** all
  identical to E.js including §verbatim-comment-shared-across-
  derived-files JSDoc word-for-word about §preparing-for-stabilize.md.
  §code-reuse-via-duplication-not-via-shared-import preserves
  package independence — cross-package shared helper would create a
  dependency between @endo/captp and @endo/eventual-send.

- **§nearTrapImpl default**: §local-fast-path-via-trivial-impl —
  trivial dispatcher lets the same `Trap(x)` surface work in both
  near and far cases; only the *injected trapImpl* differs.
  §minimal-trampoline form (each method body one line). Parallel to
  cycle 119's §pattern of *same envelope verbs whether in-process or
  cross-process*.

- **§makeTrap factory**: §callable-with-methods (parallel to E.js's
  makeE) — Trap is function + .get property. §simpler-shape-because-
  fewer-methods (direct property assignment vs E.js's Object.assign).

- **§has-trap with §honest-TODO**: *TODO: has property is not yet
  transferrable over captp* — §honest-acknowledgment-of-API-gap with
  §cite-the-missing-feature specificity.

## How this file fits the broader picture

The captp cluster (six source files) is now opened. Future cycles
can ingest captp.js (1012 lines, the wire protocol itself),
atomics.js (170 lines, the SharedArrayBuffer + Atomics.wait
substrate that Trap blocks on), loopback.js (in-process connection),
finalize.js, and index.js.

§Sibling-files-completing-the-CapTP-surface: cycle 146's E.js
(eventual user-facing) + this file (synchronous user-facing) +
captp.js (wire protocol below both) describe the full CapTP
application interface.

## Output summary

- **Source slug**: `endo--packages-captp-src-trap-js`
- **Sections**: 1 cohesion-honest section
  - `endo--packages-captp-src-trap-js--Trap-synchronous-CapTP-proxy-lifted-from-E.js-with-three-method-TrapImpl-and-no-this-receiver-check.md`
- **Topics**: captp, eventual-send, hardened-javascript
- **Library totals**: 658 sections from 199 source documents
- **Lane rotation**: nominally chat-lane (exhausted; papers-lane
  blocked 48+ consecutive cycles); pivoted to comments-lane

## Cluster note

Coordinated-update commit `e56bf00f` cluster grows to **16 files**:
cycles 108 + 110 + 115 + 118 + 123 + 125 + 132 + 134 + 136 + 138 +
140 + 144 + 148 + 150 + 152 + 154. The @endo/harden migration
canonical-update trail.

Cycle 154 closes. Schedule next wake 1500s for cycle 155.
