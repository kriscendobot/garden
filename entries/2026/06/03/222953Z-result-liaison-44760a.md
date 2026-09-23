---
kind: result
role: liaison
host: endolin
dispatch_root: /home/kris/garden/dispatches/liaison--44760a
ts: 2026-06-03T22:29:53Z
ref_id: 44760a
---

# Cycle 172: endo-but-for-bots endo-bytes.md (maximal-power-minimal-area utility-package design)

Cycle 172 — designs-lane after cycle 171's chat-lane.
§Endo-but-for-bots-design genre.

§Sourced-from-PR-inline-review-comment (PR 122 comment
3205507716) — fourth instance of this design lifecycle in
the corpus (alongside cycles 149, 157, 161).

§Sibling-utility-package design to cycle 167 @endo/where
and cycle 171 @endo/stream — §family-of-small-focused-leaf-
utility-packages.

## Source

`endojs/endo-but-for-bots designs/endo-bytes.md`. Author
Designer (dispatched per kriskowal review). Status
**Implemented** (PR #142). 617 lines.

## Sections written (1)

`endo-but-for-bots--llm-designs-endo-bytes--maximal-power-
minimal-area-four-helper-package-with-no-barrel-and-
qualified-export-names.md` (427 lines; commit `b16c3117`).

**§Cohesion-honest section count**: One. §The-maximal-
power-minimal-area-discipline-is-the-spine.

## Single most structurally interesting move

**§Maximal-power-minimal-area** discipline (per user's
review guidance): §ship-the-smallest-API-that-retires-
the-existing-duplicates; §add-helpers-when-a-real-
consumer-asks.

## Notable structural moves

- **§Audit-first-design-second**: §five-existing-duplicates
  documented with counts before deciding what to include.
- **§Four-helpers-MVP** with §helper-rationale-table-with-
  existing-duplicates-counts.
- **§Six-helpers-explicitly-deferred** with named reasons.
  §Document-what's-not-included-and-why. §Negative-space-
  is-load-bearing.
- **§No-barrel-module-per-helper-surface** (Decision 5):
  §tree-shaking-friendliness; §per-helper-surface-area-
  easy-to-audit.
- **§Qualified-export-names** (Decision 6): file name
  doesn't stutter; export carries qualifier.
- **§Module-scoped-TextEncoder-and-TextDecoder**: §capture-
  at-module-load; §no-per-call-allocation; §captured-
  before-lockdown-can't-be-defeated.
- **§No-input-validation-beyond-primitives** (Decision 4):
  §leaf-utility-stays-leaf.
- **§Eight-Decisions** recorded from PR #142 review —
  §Open-Questions-resolved-during-implementation lifecycle
  pattern (distinct from cycle 149's three open and cycle
  170's seven open).
- **§First-release-at-1.0.0** (Decision 8): §no-0.x-
  purgatory; §API-stable-from-day-one.
- **§Decoupled-rollout**: package shipped first;
  migrations independent.

## §The §sourced-from-PR-inline-review-comment lifecycle

Four cycles in the corpus follow this lifecycle:
- Cycle 149: Issue + repro PR
- Cycle 157: PR inline comment
- Cycle 161: standalone Issue
- Cycle 172: PR inline comment (this one)

§Healthy-design-lifecycle: reviewer flags duplication;
design doc canonicalizes the extraction.

## §Synthesis-target — eight-step-pattern

For monorepo deduplication via utility-package extraction:

1. Audit existing duplicates with counts.
2. Apply §maximal-power-minimal-area.
3. Per-helper-surface, no barrel.
4. Qualified export names.
5. Module-scoped captured globals.
6. No peer deps unless absolutely required.
7. Start at 1.0.0.
8. Resolve Open Questions during implementation.

§Slot machine library can §reuse-this-pattern.

## §Gap-revealing-comparison with garden cycles

| Cycle | Connection |
|-------|------------|
| 167 (where/index.js) | §Sibling-utility-package |
| 171 (stream/index.js) | §Sibling-utility-package |
| 157 (exo-zip-package) | §PR-comment-sourced lifecycle |
| 149 (unhandled-rejection-display) | §Issue-sourced lifecycle |
| 161 (filesystem-watchers) | §Issue-sourced lifecycle |
| 165 (ocap-kernel platform-specific) | §Cross-platform-portability discipline |
| 168 (daemon-checkin-checkout) | §Complete-designs-are-archive-of-validated-disciplines |

## §Tier-1 vocabulary borrowing candidates

§Maximal-power-minimal-area, §no-barrel-module-per-helper-
surface, §qualified-export-names, §module-scoped-
TextEncoder-and-TextDecoder, §first-release-at-1.0.0,
§Open-Questions-resolved-during-implementation, §sourced-
from-PR-inline-review-comment lifecycle.

## Files written / edited

- `library/sections/endo-but-for-bots--llm-designs-endo-
  bytes--maximal-power-minimal-area-four-helper-package-
  with-no-barrel-and-qualified-export-names.md` (427
  lines; commit `b16c3117`)
- `library/sources/endo-but-for-bots--llm-designs-endo-
  bytes.md` (new source page)
- `library/sources/README.md` (cycle-172 row added in
  Ingested section above cycle-170's daemon-capability-
  filesystem)
- `library/sections/README.md` (cycle-172 entry; totals
  bumped 676/217 → 677/218)
- `library/topics/tooling.md` (cycle-172 row)
- `library/topics/patterns.md` (cycle-172 row)
- `library/topics/pass-style.md` (cycle-172 row;
  Uint8Array is the canonical byteArray pass-style)
- `library/keywords.md` (58 new keyword rows)
- `inboxes/endolin/scholar.md` (timestamp + commit hash
  bumped manually)

## Library totals

676 / 217 → **677 sections from 218 source documents**.

## Lane rotation note

Cycle 172 was nominally **designs-lane** (after cycle
171's chat-lane). Papers-lane blocked **66+ consecutive
cycles**.

§Designs/chat-alternation maintained for seven cycles
(166-172). §Steady-rotation-discipline.

## §The §family-of-small-focused-leaf-utility-packages

Recent cycles have built up a §family of leaf-utility-
package observations:
- Cycle 167: @endo/where (115 lines; path resolution)
- Cycle 171: @endo/stream (247 lines; async streams)
- Cycle 172: @endo/bytes (design; Uint8Array helpers)

§Pattern-emerging-in-the-library: §small-files-with-large-
knowledge-density + §minimal-leaf-utility + §narrow-
surface + §no-peer-deps-when-avoidable.

## Cycle 172 — done. Schedule cycle 173.
