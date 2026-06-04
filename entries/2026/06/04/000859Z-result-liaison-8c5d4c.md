---
kind: result
role: liaison
host: endolin
dispatch_root: /home/kris/garden/dispatches/liaison--8c5d4c
ts: 2026-06-04T00:08:59Z
ref_id: 8c5d4c
---

# Cycle 175: endo packages/harden/make-selector.js (race-to-install harden)

Cycle 175 — chat-lane after cycle 174's designs-lane.
§Endo-source-comment-fragment genre.

**§The anchor of the e56bf00f coordinated-update cluster**.
Cycle 108's §adopt-@endo/harden discipline that triggered
the 15-file migration ingested across cycles 108/110/115/
118/123/125/132/134/138/140/144/167/169/171/173 — all of
those `import harden from '@endo/harden'` flow through this
selector.

## Source

`endojs/endo packages/harden/make-selector.js`. Author
Mark S. Miller (prompted). 69 lines. File last-touched in
commit `6794777b`.

## Sections written (1)

`endo--packages-harden-make-selector-js--race-to-install-
harden-at-Object-at-harden-with-three-tier-lookup-and-pin-
on-first-install.md` (381 lines; commit `712ee8fa`).

## Single most structurally interesting move

**§Three-tier-lookup with fallthrough**:

1. `Object[Symbol.for('harden')]` — new convention.
2. `globalThis.harden` — HardenedJS legacy.
3. Fresh `makeHardener()` + §pin-on-first-install.

§Symbol.for-as-coordination-slot crosses realm boundaries
cleanly. §Cycle-142's-PASS_STYLE used the same pattern.

## Notable structural moves

- §Pin-on-first-install (configurable:false + writable:
  false) — §non-configurable-and-non-writable-together.
- §Honest-warning: pinning prevents §any-HardenedJS-
  lockdown-from-succeeding on pre-Object[@harden]
  versions. §Forward-compat-via-pin vs §backward-compat-
  via-non-installation trade-off.
- §Type-check-the-existing-implementation: throw if slot
  populated but not callable. §Fail-loud-on-corruption.
- §Lazy-IIFE-closure: §defer-to-first-use handles race
  window between module load and first call.
- §Object.freeze on wrapper: §two-levels-of-defensiveness.
- §Race-semantics: all loaders share same harden instance
  after first call; §no-double-install.
- §Legacy-bridge-via-fallback: §accept-both-conventions
  during migration.

## §Sixth-member-of-small-files-with-large-knowledge-density

| Cycle | File | Lines |
|-------|------|-------|
| 165 | ocap-kernel platform-specific.md | 92 |
| 167 | @endo/where/index.js | 115 |
| 169 | @endo/captp/atomics.js | 170 |
| 171 | @endo/stream/index.js | 247 |
| 173 | @endo/promise-kit/src/promise-executor-kit.js | 55 |
| 175 | @endo/harden/make-selector.js | 69 |

§Pattern-confirmed: §the-substrate-files-are-often-the-
shortest.

## §Tier-1 vocabulary borrowing candidates

§Race-to-install-at-well-known-slot, §three-tier-lookup-
with-fallthrough, §pin-on-first-install, §defer-to-first-
use, §Symbol.for-as-coordination-slot, §type-check-the-
existing-implementation, §fail-loud-on-corruption-with-
helpful-diagnostic.

## §Synthesis-target

§Race-to-install-at-well-known-slot pattern borrowable
for any §singleton-service-across-realm need.

## Files written / edited

- `library/sections/...harden-make-selector-js--race-to-
  install-harden...md` (381 lines; commit `712ee8fa`)
- `library/sources/endo--packages-harden-make-selector-js.
  md` (new source page)
- `library/sources/README.md` (cycle-175 row)
- `library/sections/README.md` (cycle-175 entry; 679/220
  → 680/221)
- `library/topics/hardened-javascript.md` (cycle-175 row)
- `library/keywords.md` (39 new keyword rows)
- `inboxes/endolin/scholar.md` (timestamp + commit hash
  bumped manually)

## Library totals

679 / 220 → **680 sections from 221 source documents**.

## Lane rotation note

Cycle 175 was nominally **chat-lane** (after cycle 174's
designs-lane). Papers-lane blocked **69+ consecutive
cycles**.

§Designs/chat-alternation maintained for ten cycles
(166-175).

## Cycle 175 — done. Schedule cycle 176.
