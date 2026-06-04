---
source: packages/harden/make-selector.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/harden/make-selector.js
source_branch: master
source_commit: 6794777b9aae49f92b5c1e33b7dae79395be6849
source_authors: [Mark S. Miller (prompted)]
ingested: 2026-06-03
ingested_by: scholar
section_count: 1
status: current
notes: |
  Cycle 175. Chat-lane after cycle 174's designs-lane.
  §Endo-source-comment-fragment genre.

  69-line file. §The-race-to-install-harden-at-a-well-
  known-slot mechanism. **§This file is the anchor of the
  e56bf00f-coordinated-update-cluster** (cycle 108's
  §adopt-@endo/harden discipline that triggered the 15+
  file migration ingested across cycles 108/110/115/118/
  123/125/132/134/138/140/144/167/169/171/173).

  **Single most structurally interesting move**: §three-
  tier-lookup with fallthrough (Object[@harden] →
  globalThis.harden → fresh make + pin).

  §The-well-known-slot: `Object[Symbol.for('harden')]`.
  §Symbol.for(name)-as-coordination-slot — registered
  symbols cross realm boundaries cleanly. Cycle 142's
  passStyle-helpers PASS_STYLE used the same pattern.

  §Tier-1: Object[@harden] (new convention; this file's
  preferred slot). §Tier-2: globalThis.harden (HardenedJS
  legacy convention; SES's lockdown installs here).
  §Tier-3: fresh makeHardener() + §pin-on-first-install.

  §Pin-on-first-install: defineProperty with configurable:
  false + writable: false. §Non-configurable-and-non-
  writable-together prevent both delete and reassign.
  §Once-installed-the-slot-is-permanent for the realm
  lifetime.

  §Honest-warning in code comment: pinning Object[@harden]
  prevents §any-HardenedJS-lockdown-from-succeeding on
  pre-Object[@harden] versions. §Forward-compat-via-pin
  vs §backward-compat-via-non-installation — §this-file-
  chooses-forward-compat.

  §Type-check-the-existing-implementation: throw if slot
  populated but not callable. §Fail-loud-on-corruption
  with helpful diagnostic.

  §Lazy-initialization-via-IIFE-closure: §defer-to-first-
  use. selectHarden runs once; result cached in
  selectedHarden. §Race-window-handled — between module
  load and first call, another module might install
  harden.

  §Object.freeze(harden) on the wrapper: §the-selector-
  itself-cannot-be-modified. §Two-levels-of-defensiveness
  (wrapper frozen; underlying pinned).

  §Race-semantics-when-multiple-implementations-load:
  §pin-makes-the-race-resolve-once; §no-double-install;
  §all-loaders-share-the-same-harden-instance after first
  call.

  §Legacy-bridge-via-fallback: §accept-globalThis.harden-
  from-SES + §accept-Object[@harden]-from-new-convention.
  §No-need-to-rewrite-existing-code.

  §Comparison-with-cycle-138-safe-promise: §defer-to-first-
  use sibling pattern but for different reason
  (reentrancy avoidance vs install-race avoidance).

  §Sixth-member-of-the-§small-files-with-large-knowledge-
  density family (cycles 165 platform-specific 92L / 167
  where 115L / 169 atomics 170L / 171 stream 247L / 173
  promise-executor-kit 55L / 175 this 69L).

  §Mark-S.-Miller authored — fifth Miller-authored file
  ingested (cycles 90 / 96 / 106 / 150 / 175).

  §Synthesis-target: §race-to-install-at-well-known-slot
  pattern borrowable for any §singleton-service-across-
  realm need. §Slot-machine-library may need similar
  coordination.

  §Tier-1 vocabulary borrowing: §race-to-install-at-well-
  known-slot + §three-tier-lookup-with-fallthrough + §pin-
  on-first-install + §defer-to-first-use + §Symbol.for(
  name)-as-coordination-slot + §type-check-the-existing-
  implementation + §fail-loud-on-corruption-with-helpful-
  diagnostic.

  Cycle 175 was nominally chat-lane (after cycle 174's
  designs-lane). Papers-lane blocked 69+ consecutive
  cycles.
---

> Abstract: `packages/harden/make-selector.js` (69 lines)
> implements the **§race-to-install-harden-at-a-well-
> known-slot** mechanism. The single most structurally
> interesting move is the §three-tier-lookup with
> fallthrough (Object[@harden] → globalThis.harden →
> fresh make + pin).
>
> **Cycle 175 — chat-lane** after cycle 174's designs-lane.
> §Endo-source-comment-fragment genre.
>
> **§Anchor of the e56bf00f-coordinated-update-cluster**:
> the §adopt-@endo/harden migration across the @endo
> monorepo flows through this selector.
>
> §The-well-known-slot: `Object[Symbol.for('harden')]`.
> §Symbol.for-as-coordination-slot pattern (cycle 142
> sibling).
>
> §Pin-on-first-install with §non-configurable-and-non-
> writable. §Honest-warning about §forward-compat-via-pin
> vs §backward-compat-via-non-installation trade-off.
>
> §Lazy-via-IIFE-closure: §defer-to-first-use handles the
> race window between module load and first call.
>
> §Race-semantics: all loaders share the same harden
> instance after first call; §no-double-install.
>
> §Legacy-bridge-via-fallback: §accept-both-conventions
> during migration.
>
> §Sixth-member-of-the-§small-files-with-large-knowledge-
> density family (cycles 165/167/169/171/173/175).
> §Mark-S.-Miller authored — fifth Miller file.
>
> §Tier-1 borrowing: §race-to-install-at-well-known-slot,
> §three-tier-lookup-with-fallthrough, §pin-on-first-
> install, §defer-to-first-use, §Symbol.for-as-
> coordination-slot, §type-check-the-existing-
> implementation, §fail-loud-on-corruption-with-helpful-
> diagnostic.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [race-to-install-harden-at-Object-at-harden-with-three-tier-lookup-and-pin-on-first-install](../sections/endo--packages-harden-make-selector-js--race-to-install-harden-at-Object-at-harden-with-three-tier-lookup-and-pin-on-first-install.md) | hardened-javascript, patterns, tooling | current |

One cohesion-honest section. §The-three-tier-lookup-with-
pin-on-first-install is the spine.

## Provenance

- Fetched 2026-06-03 from `endojs/endo@master`
  (file last touched in commit `6794777b`).
- Author: Mark S. Miller (prompted).
- §Anchor of the e56bf00f coordinated-update cluster.
- Cycle 175 was nominally **chat-lane** (after cycle 174's
  designs-lane). Papers-lane has been blocked for **69+
  consecutive cycles**.
- One cohesion-honest section.
