---
kind: result
role: liaison
host: endolin
dispatch_root: /home/kris/garden/dispatches/liaison--9fc181
ts: 2026-06-03T19:08:07Z
ref_id: 9fc181
---

# Cycle 166: endo-but-for-bots designs/daemon-mount.md (breaks ocap-kernel-mini-series; designs-lane)

Cycle 166 **breaks the §ocap-kernel-mini-series streak**
after five consecutive comments-lane cycles (162-165) on
ocap-kernel docs. Cycle 165's result entry explicitly
named this option ("Break for genre variety with a non-
ocap-kernel source"); cycle 166 takes it.

The §direct-prerequisite-design choice: cycle 161's
filesystem-watchers.md ingest added `followNameChanges` to
EndoMount via PR #277, but EndoMount itself was defined by
this earlier design. §Read-the-base-first-then-the-
extension. The library now has both.

## Source

`endojs/endo-but-for-bots designs/daemon-mount.md` from the
endo-but-for-bots monitor worktree. Author Kris Kowal
(prompted). Status **In Progress** — Phases 1-3 + 5
shipped 2026-03-21 in commit `e22f71327`; Phases 4 and 6
open as PRs #135 / #127 / #277. 708 lines.

## Sections written (1)

`endo-but-for-bots--llm-designs-daemon-mount--two-formula-
type-split-with-shared-exo-interface-and-realpath-at-
operation-time-confinement.md` (350 lines; commit
`0cd7323d`).

**§Cohesion-honest section count**: One. §The-two-formula-
type-split-is-the-spine; security mechanism and lifecycle
are tightly cross-linked; splitting would fragment.

## Single most structurally interesting move

**§Two-formula-type-split with shared exo interface**:
`mount` (external host-managed) and `scratch-mount`
(daemon-managed) share one exo implementation but differ in
how the mount root path is derived. §Lifecycle-asymmetry-vs-
implementation-symmetry as a §design-pattern-not-just-this-
design.

## Structural moves captured

- **§Naming-the-shape-of-the-gap**: three pre-existing
  shapes (readable-tree immutable / directory pet-name
  namespace / nothing for live-mutable-filesystem) →
  §mount-bridges-the-gap.
- **§AI-coding-agent-as-motivating-use-case**: read project
  files, write generated code, create build artifacts, all
  confined.
- **§Five-method-groupings**: reads + mutation + attenuation
  + snapshot + help.
- **§Polymorphism-by-interface**: code that walks
  ReadableTree walks Mount the same way.
- **§Realpath-at-operation-time-confinement** (security
  spine): §TOCTOU-mitigation. Cycle 161's §stat-reconciled-
  rename-events shares the same §operation-time-
  verification discipline.
- **§Read-soft-write-hard** for escaping symlinks: list
  silently excludes; has returns false; lookup/write/
  remove/move throw. §Hidden-not-rejected-for-reads-
  doesn't-leak-existence (cycle 89 eventual-send sibling).
- **§Eight-Design-Decisions**: each a named rationale.
- **§Load-bearing-symmetry between Decisions 2 and 3**:
  axis is §does-this-operation-create-a-new-formula. Yes
  → host method with deferred-task atomicity (GC-race
  prevention). No → exo method.
- **§Transient-exos-from-lookup()** relies on §weak-value-
  map-GC pattern from cycle 156 finalize.js.
- **§Path-based-not-inode-based** is §honest-limitation-
  disclosure. §POSIX-`*at`-family (openat / renameat /
  fstatat / mkdirat) named as §future-hardening-target on
  supporting platforms.
- **§Scratch-survives-cancellation**: §intentional-
  deletion-requires-removing-all-pet-name-references.
  §Single-mistake-cannot-destroy-state (sibling to cycle
  164's §resetStorage-conflict-guard).

## §Gap-revealing-comparison with garden cycles

| Cycle | Connection |
|-------|------------|
| 161 (filesystem-watchers) | Direct sibling — followNameChanges on PR #277 extends EndoMount; same §operation-time-verification |
| 156 (finalize.js) | §Transient-exos-from-lookup() relies on §weak-value-map-GC |
| 164 (identity-backup-recovery) | §Single-mistake-cannot-destroy-state shared discipline |
| 162 (ken-protocol-assessment) | §Atomic-checkpoint analog (cranks atomic-execution; host methods atomic-creation) |
| 105 (daemon-capability-bank) | Sister daemon-capability design; both use exo/host axis |
| 89 (eventual-send pipeline) | §Read-soft-write-hard sibling |

## §Synthesis-target

§Lifecycle-asymmetry-vs-implementation-symmetry as a
§reusable-design-pattern for future daemon capabilities
with two lifecycle modes (host-provided vs daemon-
provided). Cycle 105's daemon-capability-bank is a
candidate for borrowing the shape.

## §Reference-not-substrate stance contrast

Cycles 162-165 ingested ocap-kernel docs under §read-for-
comparison stance. This cycle is §our-design — we *are*
the substrate, this is how we're building it. §Distinct-
reading-mode-for-our-own-designs-vs-sibling-implementations.

## Files written / edited

- `library/sections/endo-but-for-bots--llm-designs-daemon-
  mount--two-formula-type-split-with-shared-exo-interface-
  and-realpath-at-operation-time-confinement.md` (350
  lines; commit `0cd7323d`)
- `library/sources/endo-but-for-bots--llm-designs-daemon-
  mount.md` (new source page)
- `library/sources/README.md` (cycle-166 row added in the
  endo-but-for-bots designs section, near daemon-message-
  streaming + filesystem-watchers)
- `library/sections/README.md` (cycle-166 entry; totals
  bumped 670/211 → 671/212)
- `library/topics/daemon.md` (cycle-166 row)
- `library/topics/capability-security.md` (cycle-166 row;
  the §realpath-at-operation-time-confinement + §read-soft-
  write-hard moves justify capability-security cross-
  listing)
- `library/topics/patterns.md` (cycle-166 row; §two-formula-
  type-split is the reusable design pattern)
- `library/keywords.md` (47 new keyword rows)
- `inboxes/endolin/scholar.md` (timestamp + commit hash
  bumped manually)

## Library totals

670 / 211 → **671 sections from 212 source documents**.

## Lane rotation note

Cycle 166 was nominally **designs-lane** (after 5-cycle
comments-lane streak). Papers-lane blocked **60+
consecutive cycles**.

Lane sequence over the last 10 cycles:
- 157: designs (exo-zip-package)
- 158: chat (loopback.js)
- 159: designs (daemon-debug-worker-restart)
- 160: chat (marshal-stringify.js)
- 161: designs (filesystem-watchers) + user-directed off-rotation
- 162-165: comments (ocap-kernel docs, five consecutive)
- 166: designs (daemon-mount) — break

The §ocap-kernel-mini-series may resume in future cycles
(remaining §queued-doc items from cycle 161: kernel-guide.md
689 lines, usage.md 691 lines, plus per-package READMEs
and code-comment fragments).

## Cycle 166 — done. Schedule cycle 167.
