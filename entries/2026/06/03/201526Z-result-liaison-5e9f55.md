---
kind: result
role: liaison
host: endolin
dispatch_root: /home/kris/garden/dispatches/liaison--5e9f55
ts: 2026-06-03T20:15:26Z
ref_id: 5e9f55
---

# Cycle 168: endo-but-for-bots daemon-checkin-checkout.md (pair-design to cycle 166 daemon-mount)

Cycle 168 — designs-lane after cycle 167's chat-lane.
§Endo-but-for-bots-design genre. §Pair-design to cycle
166's daemon-mount.md.

The §pair-design choice: cycle 166's daemon-mount provides
§live-mutable filesystem access; this design provides the
§point-in-time-snapshot-and-restore bridge to immutable
formula representation. §Mount.snapshot()-produces-a-
readable-tree connects them. §Reading-the-pair-together
clarifies the §two-shapes-of-FS-access.

## Source

`endojs/endo-but-for-bots designs/daemon-checkin-checkout.md`
from the endo-but-for-bots monitor worktree. Author Kris
Kowal (prompted). Status **Complete** (shipped 2026-03-20
commit `d60ba38b2`; zip support 2026-04-17 commit
`a6e20c5e2`; verb unification 2026-05-18 PR #153 commit
`8a8e872d4`). 578 lines.

## Sections written (1)

`endo-but-for-bots--llm-designs-daemon-checkin-checkout--
bidirectional-bridge-between-local-FS-and-formula-store-
with-CLI-side-formulation.md` (331 lines; commit
`eb91dca6`).

**§Cohesion-honest section count**: One. §The-single-
substrate-four-modes pattern is the spine; the seven
Design Decisions reinforce it; splitting would fragment.

## Single most structurally interesting move

**§Single-substrate-four-modes**: directory mode + zip mode
for both checkin and checkout, all producing the same
`readable-tree` / `readable-blob` hierarchy. §Six-modes-
from-four-axes (input-or-output × dir-or-zip × file-or-
stream). §Same-formula-tree-from-two-input-sources
(Decision 4): `endo ci ./dist -n app` and `endo ci -z
dist.zip -n app` produce *structurally identical* formula
trees.

## Structural moves captured

- **§Seven-Design-Decisions** enumerated:
  1. §CLI-side-formulation-not-daemon-side
  2. §Checkout-entirely-CLI-side (zero new daemon methods)
  3. §readable-tree-stores-formula-IDs-not-content-hashes
  4. §Zip-mode-reuses-tree-formulation
  5. §No-metadata-preservation (§content-only)
  6. §Symlinks-skipped-with-warning
  7. §.endoignore-not-new-flag (.gitignore syntax)
- **§CLI-side-formulation** as §capability-security-at-
  architectural-axis. Cycle 166's §realpath-at-operation-
  time-confinement is the *operation-time* discipline;
  this is the *architectural-time* discipline.
- **§Type-discrimination-via-locator** reuses cycle 135's
  daemon-locator-reference §locator-encodes-formula-type.
- **§Decomposition-of-bundled-verbs**: zip extraction
  extracted from mkweblet into standalone command.
  §Refactor-discipline applied to authority boundaries.
- **§Roadmap-calibration-via-git-blame**: 62 days,
  three discrete bursts, long unattended gaps. Same shape
  as cycle 95 + 149.

## §Gap-revealing-comparison with garden cycles

| Cycle | Connection |
|-------|------------|
| 166 (daemon-mount) | §Pair-design — mount = live; this = snapshot; §mount.snapshot()-produces-readable-tree |
| 141 (daemon-cas-management) | §Content-store-keyed-by-sha256 substrate |
| 135 (daemon-locator-reference) | §Locator-encodes-formula-type used for type discrimination |
| 157 (exo-zip-package) | §Sibling — programmatic API vs CLI API |
| 161 (filesystem-watchers) | §Cousin design — FS-daemon boundary |

## §Synthesis-target

§Bidirectional-bridge-pattern (two symmetric commands not
one bigger thing). §CLI-side-formulation discipline
applies beyond this design: when adding daemon
capabilities, §ask-does-the-daemon-actually-need-the-
authority.

## §Tier-1 vocabulary borrowing candidates

§Single-substrate-four-modes, §CLI-side-formulation,
§bidirectional-bridge-pattern, §locator-encodes-formula-
type, §reuse-familiar-discipline, §don't-bake-metadata-in-
yet, §decomposition-of-bundled-verbs.

## Files written / edited

- `library/sections/endo-but-for-bots--llm-designs-daemon-
  checkin-checkout--bidirectional-bridge-between-local-FS-
  and-formula-store-with-CLI-side-formulation.md` (331
  lines; commit `eb91dca6`)
- `library/sources/endo-but-for-bots--llm-designs-daemon-
  checkin-checkout.md` (new source page)
- `library/sources/README.md` (cycle-168 row added in the
  Ingested section above cycle-166's daemon-mount row)
- `library/sections/README.md` (cycle-168 entry; totals
  bumped 672/213 → 673/214)
- `library/topics/daemon.md` (cycle-168 row)
- `library/topics/tooling.md` (cycle-168 row)
- `library/topics/capability-security.md` (cycle-168 row;
  §CLI-side-formulation = §capability-security-at-
  architectural-axis)
- `library/keywords.md` (52 new keyword rows)
- `inboxes/endolin/scholar.md` (timestamp + commit hash
  bumped manually)

## Library totals

672 / 213 → **673 sections from 214 source documents**.

## Lane rotation note

Cycle 168 was nominally **designs-lane** (after cycle
167's chat-lane). Papers-lane blocked **62+ consecutive
cycles**.

Lane sequence over the last 12 cycles:
- 157: designs
- 158: chat
- 159: designs
- 160: chat
- 161: designs + user-directed off-rotation
- 162-165: comments (ocap-kernel mini-series)
- 166: designs (mini-series break)
- 167: chat
- 168: designs

§Steady-rotation-discipline since cycle 165's break from
the comments-lane streak. The §designs/chat alternation
has returned.

## Cycle 168 — done. Schedule cycle 169.
