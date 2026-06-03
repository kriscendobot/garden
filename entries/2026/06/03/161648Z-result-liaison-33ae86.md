---
kind: result
role: liaison
host: endolin
dispatch_root: /home/kris/garden/dispatches/liaison--33ae86
ts: 2026-06-03T16:16:48Z
ref_id: 33ae86
---

# Cycle 161 result — filesystem-watchers.md (forty-second-comment-style design ingest)

Cycle 161 of the librarian arc. Nominally papers-lane (cycle 160 was
comments — milestone tick); papers-lane has been blocked for **55+
consecutive cycles**. Pivoted to designs-lane.

## Source

`endo-but-for-bots/designs/filesystem-watchers.md` — 486-line *Not
Started* status §parity-fix design by Kris Kowal *(prompted)*,
created 2026-05-07. Source named in metadata: **Issue #110**. Last
touch commit `b952c8bb5` 2026-05-07: `design(daemon): filesystem
watchers (closes #110)`.

## Structural moves captured

- **§Three-design-sources-lifecycle** across recent cycles: cycle
  149 sourced from Issue + repro PR; cycle 157 sourced from PR
  inline review comment; cycle 161 sourced from standalone Issue.

- **§Load-bearing-two-fold-problem**: §surface-parity (EndoMount
  lacks followNameChanges; polymorphic hub abstractions break at
  subscription edge) + §mechanism-parity (every consumer reinvents
  debounce/ordering/disposal). §multiple-independent-justifications
  (parallel to cycle 153).

- **Single most structurally interesting move**: §stat-reconciled-
  rename-events. `fs.watch` emits 'rename' for both adds and
  removes (direction-agnostic OS event); handler `stat`s the child
  to discover which direction. §in-memory-set-as-truth pattern;
  §editor-save-dance-coalescing via 50ms debounce.

- **§FilePowers-extension-not-reach-into-Node**: new
  `watchDirectory` primitive on FilePowers keeps EndoMount body
  platform-agnostic. §minimal-platform-seam.

- **§MountNameChange-vs-PetStoreNameChange asymmetry**: §interface-
  asymmetry-tracks-ownership-asymmetry (echo of cycle 157).
  §discriminant-stable-additional-fields-vary pattern.

- **§Subscription-bound-to-path-not-name** property; §matches-
  EndoDirectory-semantics.

- **§try-finally-is-load-bearing** discipline: §iterator-return-
  as-cleanup-trigger. §async-generator-finally-is-the-cleanup-hook
  idiom. §remote-cleanup-via-CapTP-propagates-to-finally chain.

- **§Confinement-flows-through-unchanged** with §silent-drop-not-
  error discipline for runtime symlinks outside root.

- **§Four-alternatives-considered**: polling-diff (use as fallback)
  / chokidar (defer §50KB-dependency-for-thin-daemon) / inotify-
  kqueue (§punt-platform-bindings-to-rust-port) / fs.watchFile (use
  as per-entry fallback). §Three-of-four-deferred; §defer-with-
  named-trigger.

- **§Captured-resolution-trail** discipline (parallel to cycle 157).

- **§Five-Design-Decisions** form §coherent-discipline. §parity-
  first-then-extend; §don't-design-for-yet-unseen-needs; §revisit-
  only-when-profiling-shows-pressure.

- **§Eight-test-plan** with §test-by-absence-of-events idiom —
  §absence-test-via-bounded-timeout.

- **§One-Open-Question** (NameHub unification — §sibling-design-
  already-dispatched).

- **§Parity-as-design-axiom**: innovation §minimized-to-what-the-
  new-substrate-strictly-requires.

## Output summary

- **Source slug**: `endo-but-for-bots--llm-designs-filesystem-watchers`
- **Sections**: 1 cohesion-honest section
  - `endo-but-for-bots--llm-designs-filesystem-watchers--EndoMount-followNameChanges-with-FilePowers-watchDirectory-and-stat-reconciled-rename-events.md`
- **Topics**: daemon, persistence, tooling
- **Library totals**: 665 sections from 206 source documents
- **Lane rotation**: nominally papers-lane (55+ consecutive blocks);
  pivoted to designs-lane

Cycle 161 closes. Schedule next wake 1500s for cycle 162.
