---
source: designs/filesystem-watchers.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: b952c8bb54769f4e12d3e1c780d669341d572d55
source_date: 2026-05-07
source_authors: [Kris Kowal (prompted)]
ingested: 2026-06-03
ingested_by: scholar
section_count: 1
status: current
notes: |
  Forty-second-comment-style design ingest (cycle 161). 486-
  line *Not Started* status §parity-fix design by Kris Kowal
  *(prompted)*, created 2026-05-07. Source named in metadata:
  Issue #110. Last touch commit `b952c8bb5` 2026-05-07:
  `design(daemon): filesystem watchers (closes #110)`.

  §Design-from-sourced-issue lifecycle. §Three-design-sources-
  lifecycle observed across recent cycles: cycle 149 sourced
  from Issue + repro PR; cycle 157 sourced from PR inline
  review comment; cycle 161 sourced from standalone Issue.

  §Load-bearing-two-fold-problem: §surface-parity (EndoMount
  lacks followNameChanges; polymorphic hub abstractions break
  down at the subscription edge) + §mechanism-parity (every
  consumer reinvents debounce/ordering/disposal); §multiple-
  independent-justifications discipline (parallel to cycle
  153's supply-chain+reproducibility+correctness framing).

  Single most structurally interesting move: §stat-reconciled-
  rename-events. `fs.watch` emits 'rename' for both adds and
  removes — direction-agnostic OS event. Handler must `stat`
  the child path to discover which direction. §in-memory-set-
  as-truth pattern: snapshotSet tracks what's been emitted;
  comparing current existence to that set yields the diff.
  §editor-save-dance-coalescing via 50ms debounce — §bookkeeping-
  over-in-memory-entry-set-not-timer-per-event.

  §FilePowers-extension-not-reach-into-Node: new
  `watchDirectory` primitive on FilePowers; EndoMount stays
  §platform-agnostic-body. §minimal-platform-seam discipline.
  §polling-fallback-inside-FilePowers (where fs.watch
  unavailable). §interface-shaped-to-allow-future-
  implementations.

  §MountNameChange-vs-PetStoreNameChange shape asymmetry:
  §interface-asymmetry-tracks-ownership-asymmetry (echo of
  cycle 157) — EndoMount has no formula identifiers; second
  field carries stat-derived kind instead of value: IdRecord.
  §discriminant-stable-additional-fields-vary pattern lets
  polymorphic code mostly work.

  §Subscription-bound-to-path-not-name property: watcher
  holds OS-level handle to the directory, not a name-table
  entry. Moving the name binding doesn't move the handle.
  §matches-EndoDirectory-semantics observation.

  §try-finally-is-load-bearing discipline: §iterator-return-
  as-cleanup-trigger. Async generator's finally block runs
  when return() is called on it (JS spec guarantee). §remote-
  cleanup-via-CapTP-propagates-to-finally chain: remote
  subscriber drops → makeIteratorRef releases → return() fires
  → finally runs → watcher.cancel() releases OS handle.

  §Confinement-flows-through-unchanged: assertConfined +
  isConfinedPath at both setup and event time. §silent-drop-
  not-error discipline for runtime symlinks pointing outside
  root.

  §Four-alternatives-considered: polling diff (use as
  fallback) / chokidar (defer; §50KB-dependency-for-thin-
  daemon) / inotify-kqueue direct bindings (§punt-platform-
  bindings-to-rust-port) / fs.watchFile (use as per-entry
  fallback). §three-of-four-deferred observation. §defer-with-
  named-trigger discipline (chokidar revisit *if hand-rolled
  wrapper accumulates platform-specific bug fixes*; inotify/
  kqueue *track on Rust-port roadmap*); §deferred-not-rejected-
  distinction. §wait-for-the-natural-home (future Rust daemon
  is the natural home for native bindings).

  §Captured-resolution-trail discipline (parallel to cycle
  157): *resolved in maintainer review on 2026-05-07.
  Captured here for traceability rather than relitigation*.

  §Five-Design-Decisions form §coherent-discipline: (1) fan-
  out multiplexing — one watcher per subscriber first; (2)
  recursive subscriptions — shallow only matching
  EndoDirectory; (3) file-content changes — parity-first
  defer; (4) coalescing window — hard-coded 50ms (§tuning-
  is-premature); (5) polling fallback default — silent +
  console.error diagnostic. §Parity-first-then-extend
  discipline. §don't-design-for-yet-unseen-needs. §revisit-
  only-when-profiling-shows-pressure (Decision 1's explicit
  trigger).

  §Eight-test-plan items including §test-by-absence-of-events
  for disposal: *use t.timeout(2000) and a bounded "expect
  zero events" probe* — §absence-test-via-bounded-timeout
  idiom. §external-mount-parity test is the §parity-
  assertion.

  §One-Open-Question (rare for design this size): NameHub-
  interface-unification — *A sibling design has been
  dispatched to address hub-interface unification on its
  own*. §sibling-design-already-dispatched observation;
  §don't-let-this-design-grow. §future-cross-reference-as-
  TODO-anchor pattern (*cross-link here once that design
  lands*).

  §Three-Dependencies with §dependency-typology: daemon-mount
  (defines EndoMount) / platform-fs (owns FilePowers) /
  daemon-content-store-gc (§runtime-cleanup-pairs-with-GC).

  §Parity-as-design-axiom: the whole design is an exercise in
  §parity-first. Multiple aspects (shape / pattern /
  semantics / interface) all match EndoDirectory; innovation
  is §minimized-to-what-the-new-substrate-strictly-requires.

  Cycle 161 was nominally papers-lane (cycle 160 was
  comments — milestone tick). Papers-lane blocked 55+
  consecutive cycles. Cycle 161 pivoted to designs-lane.
---

> Abstract: `filesystem-watchers.md` (486 lines, *Not
> Started*) is a §parity-fix design by Kris Kowal
> *(prompted)*. **Source: Issue #110.** Adds
> `followNameChanges` to EndoMount so polymorphic hub
> abstractions stop breaking at the subscription edge.
>
> §Load-bearing-two-fold-problem (§surface-parity +
> §mechanism-parity); §multiple-independent-justifications.
>
> **Single most structurally interesting move**: §stat-
> reconciled-rename-events — `fs.watch` emits 'rename' for
> both adds and removes (direction-agnostic); handler uses
> stat to discover which direction. §in-memory-set-as-truth
> pattern. §editor-save-dance-coalescing via 50ms debounce.
>
> §FilePowers-extension-not-reach-into-Node (§minimal-
> platform-seam); §polling-fallback-inside-FilePowers.
>
> §MountNameChange-vs-PetStoreNameChange asymmetry
> (§interface-asymmetry-tracks-ownership-asymmetry; echo of
> cycle 157). §discriminant-stable-additional-fields-vary.
>
> §Subscription-bound-to-path-not-name property; §matches-
> EndoDirectory-semantics.
>
> §try-finally-is-load-bearing with §iterator-return-as-
> cleanup-trigger; §remote-cleanup-via-CapTP-propagates-to-
> finally.
>
> §Confinement-flows-through-unchanged.
>
> §Four-alternatives-considered with §three-of-four-deferred
> and §defer-with-named-trigger. §punt-platform-bindings-to-
> rust-port.
>
> §Captured-resolution-trail (parallel to cycle 157). §Five-
> Design-Decisions form §coherent-discipline. §parity-first-
> then-extend.
>
> §Eight-test-plan with §test-by-absence-of-events idiom
> (§absence-test-via-bounded-timeout).
>
> §Parity-as-design-axiom: innovation §minimized-to-what-
> the-new-substrate-strictly-requires.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [EndoMount-followNameChanges-with-FilePowers-watchDirectory-and-stat-reconciled-rename-events](../sections/endo-but-for-bots--llm-designs-filesystem-watchers--EndoMount-followNameChanges-with-FilePowers-watchDirectory-and-stat-reconciled-rename-events.md) | daemon, persistence, tooling | current |

Tight 486-line *Not Started* parity-fix design. One cohesion-
honest section.

## Provenance

- Fetched 2026-06-03 from `endojs/endo-but-for-bots@
  b952c8bb5` (branch `origin/llm`) via the local bare-clone.
- Created 2026-05-07 / status *Not Started*. Author Kris
  Kowal *(prompted)*.
- Last touch commit `b952c8bb5` 2026-05-07: `design(daemon):
  filesystem watchers (closes #110)`.
- **Source: Issue #110**.
- **Forty-second-comment-style design ingest.**
- Cycle 161 was nominally **papers-lane** (cycle 160 was
  comments — milestone tick). Papers-lane has been blocked
  for **55+ consecutive cycles**. Cycle 161 pivoted to
  designs-lane.
- One cohesion-honest section.
