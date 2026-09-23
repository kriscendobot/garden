---
source: designs/daemon-mount.md
source_repo: endojs/endo-but-for-bots
source_url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/daemon-mount.md
source_branch: master
source_authors: [Kris Kowal (prompted)]
ingested: 2026-06-03
ingested_by: scholar
section_count: 1
status: current
notes: |
  Cycle 166. **Breaks the §ocap-kernel-mini-series streak**
  (cycles 162-165 were ocap-kernel docs). Designs-lane pick
  for genre variety. §Endo-but-for-bots-design genre.

  §Direct-prerequisite-design for cycle 161's filesystem-
  watchers.md — that design's `followNameChanges` on PR #277
  extends EndoMount, which this doc defines. §Read-the-base-
  first-then-the-extension.

  708-line design doc. Status: **In Progress** (Phases 1-3 +
  5 shipped 2026-03-21 in commit `e22f71327`; Phases 4 and 6
  open as PRs #135 / #127 / #277).

  §Live-mutable-filesystem-as-capability primitive for the
  daemon. §AI-coding-agent-as-motivating-use-case (read
  project files, write generated code, create build
  artifacts — all confined).

  §Naming-the-shape-of-the-gap: three pre-existing shapes
  (readable-tree immutable, directory pet-name namespace,
  none for live-mutable-filesystem) — §mount-bridges-the-gap.
  §Today's-two-bad-options were ambient-host-permissions
  (violates least authority) or everything-through-store/
  checkin (no incremental edits).

  **Single most structurally interesting move**: §two-
  formula-type-split (`mount` external-host-managed; `scratch-
  mount` daemon-managed) sharing one exo interface.
  §Lifecycle-asymmetry-vs-implementation-symmetry as a
  §design-pattern.

  §Five-method-groupings on the exo: reads (has/list/lookup,
  ReadableTree-compatible) + mutation (write/remove/move/
  makeDirectory) + attenuation (readOnly) + snapshot
  (bridge to immutable readable-tree) + help.

  §Polymorphism-by-interface: code that walks ReadableTree
  walks Mount the same way.

  §Snapshot-as-round-trip-to-immutable. §Combined-with-endo-
  checkin: §complete-round-trip mount ↔ snapshot.

  **Security spine**: §realpath-at-operation-time-
  confinement. §Every-filesystem-operation-must-verify-
  resolved-path-remains-within-confinement-root. §TOCTOU-
  mitigation: §checking-symlinks-at-lookup-time-and-caching-
  creates-window. §Cycle-161's-stat-reconciled-rename-events
  has the same §operation-time-verification discipline.

  §Read-soft-write-hard discipline for escaping symlinks:
  list() silently excludes; has() returns false; lookup()/
  write()/remove()/move() throw. §Hidden-not-rejected-for-
  reads-doesn't-leak-existence; §explicit-mutation-on-
  imaginary-state-is-incoherent. Cycle-89's eventual-send
  has a §don't-let-error-paths-reveal-too-much sibling.

  §Eight-Design-Decisions enumerated:
  1. Two-formula-types-rather-than-one
  2. No-mount-method-on-the-exo (host atomic via deferred-task)
  3. readOnly-IS-on-the-exo (no new formula)
  4. lookup-returns-transient-exos (formula-store hygiene)
  5. Symlink-confinement-at-operation-time
  6. ..-is-clamped-not-rejected
  7. Scratch-mount-directories-survive-cancellation
  8. Path-based-not-inode-based with named openat-future-work

  §Load-bearing-symmetry between Decisions 2 and 3: the
  axis is §does-this-operation-create-a-new-formula.
  Creates → host with deferred-task atomicity. Doesn't
  create → exo method.

  §Transient-exos-from-lookup() relies on §weak-value-map-
  GC pattern from cycle 156's finalize.js.

  §Path-based-not-inode-based is §honest-limitation-
  disclosure. §POSIX-`*at`-family (openat, renameat,
  fstatat, mkdirat) enables §inode-pinning on supporting
  platforms; named as future-hardening-target.

  §Scratch-mount-survives-cancellation: §intentional-
  deletion-requires-removing-all-pet-name-references —
  §single-mistake-cannot-destroy-state (sibling to cycle
  164's §resetStorage-conflict-guard).

  §Phased-implementation: 6 phases, 4 complete + 1 partial.

  §Five-design-dependencies: platform-fs, daemon-capability-
  filesystem, daemon-checkin-checkout, daemon-agent-tools,
  daemon-content-store-gc.

  §Speculative-vision-realized-as-concrete-subset: daemon-
  capability-filesystem.md is the wider design; mount is
  the §concrete-mergeable-slice.

  §Gap-revealing-comparison with cycles 161/156/164/162/105/
  89.

  §Synthesis-target: future daemon capabilities with two
  lifecycle modes (host-provided vs daemon-provided) could
  borrow the §two-formula-type-split. Cycle 105's daemon-
  capability-bank might benefit.

  §Reference-not-substrate stance contrast: cycles 162-165
  were §read-for-comparison; this is §our-design — we *are*
  the substrate.

  Cycle 166 was nominally designs-lane (after 5-cycle
  comments-lane streak). Papers-lane blocked 60+ cycles.
---

> Abstract: `designs/daemon-mount.md` (708 lines) defines
> the **§live-mutable-filesystem-as-capability** primitive
> for the daemon — the §direct-prerequisite-design for
> cycle 161's filesystem-watchers.md.
>
> Status: **In Progress** — Phases 1-3 + 5 shipped 2026-03-
> 21; Phases 4 and 6 open as PRs #135 / #127 / #277.
>
> **Breaks the §ocap-kernel-mini-series streak** (cycles
> 162-165) for genre variety. Designs-lane.
>
> **Single most structurally interesting move**: §two-
> formula-type-split (`mount` external + `scratch-mount`
> daemon-managed) sharing one exo interface. §Lifecycle-
> asymmetry-vs-implementation-symmetry as a §design-pattern.
>
> §Security-spine: §realpath-at-operation-time-confinement
> with §TOCTOU-mitigation. §Read-soft-write-hard discipline
> for escaping symlinks.
>
> §Load-bearing-symmetry: §readOnly()-on-exo (no new
> formula) vs §sub-mount-via-host (creates formula, needs
> deferred-task atomicity).
>
> §Path-based-not-inode-based with §POSIX-`*at`-family as
> §future-hardening-target. §Honest-limitation-disclosure.
>
> §Scratch-mount-survives-cancellation; §intentional-
> deletion-requires-removing-all-pet-name-references.
>
> §Eight-Design-Decisions enumerated with named-rationales.
> §Phased-implementation with shipped + open state.
>
> §Synthesis-target: §lifecycle-asymmetry-vs-implementation-
> symmetry pattern; §two-formula-type-split applicable to
> future daemon capabilities with two lifecycle modes.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [two-formula-type-split-with-shared-exo-interface-and-realpath-at-operation-time-confinement](../sections/endo-but-for-bots--llm-designs-daemon-mount--two-formula-type-split-with-shared-exo-interface-and-realpath-at-operation-time-confinement.md) | daemon, capability-security, patterns | current |

One cohesion-honest section. §The-two-formula-type-split-is-
the-spine; security mechanism and lifecycle are tightly
cross-linked; splitting would fragment.

## Provenance

- Fetched 2026-06-03 from `endojs/endo-but-for-bots@master`.
- Author: Kris Kowal (prompted).
- Cycle 166 was nominally **designs-lane** (breaking the
  §ocap-kernel-mini-series after 5 consecutive cycles).
  Papers-lane blocked **60+ consecutive cycles**.
- One cohesion-honest section.
