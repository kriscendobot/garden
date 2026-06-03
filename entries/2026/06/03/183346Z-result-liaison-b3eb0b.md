---
kind: result
role: liaison
host: endolin
dispatch_root: /home/kris/garden/dispatches/liaison--b3eb0b
ts: 2026-06-03T18:33:46Z
ref_id: b3eb0b
---

# Cycle 165: ocap-kernel docs/platform-specific.md (fifth ocap-kernel ingest; contributor-onboarding for Node/browser split)

Cycle 165 continues the §ocap-kernel-mini-series (cycles
161 / 162 / 163 / 164 / 165). §Queued-doc-4 from cycle
161's plan: `docs/platform-specific.md` (92 lines).

This is the **smallest doc** in the queue so far and
distinctively §about-the-development-workflow rather than
§about-the-system. The §two-audience-surface observation
emerges: ocap-kernel docs split into user-targeted (cycle
164's identity-backup-recovery.md) and contributor-
targeted (this doc).

## Source

`MetaMask/ocap-kernel docs/platform-specific.md` from the
bare clone at `/home/kris/garden/worktrees/metamask-ocap-
kernel.git/`. HEAD `a3eff0efb` 2026-05-28; file last-
touched in same commit. 92 lines. Dual Apache-2.0 + MIT.

## Sections written (1)

`metamask-ocap-kernel--docs-platform-specific-md--platform-
obvious-vs-platform-implicit-exports-with-six-step-
contributor-guide-for-Node-browser-split.md` (299 lines;
commit `05825f9a`).

**§Cohesion-honest section count**: One. §The-six-step-
flow-is-the-spine-of-the-doc; splitting would fragment
the §contributor-onboarding-shape.

## Single most structurally interesting move

**§Six-step-development-guideline** — a numbered flow for
adding a platform-specific feature:

1. Package Creation
2. Platform-Agnostic Implementation
3. Platform-Specific Implementation
4. Package Configuration
5. Platform Integration
6. End-to-End Testing

§Steps-are-ordered-with-explicit-dependency. §Abstraction-
first-then-platforms-then-integration-then-tests. §Tests-
come-last-not-out-of-laziness-but-because-they-validate-
the-prior-five-steps.

## Other notable structural moves

- **§Layered-architecture**: §core-packages-contain-both-
  abstraction-and-platform-impls; §runtime-packages-
  orchestrate-by-choosing. §Single-source-of-truth-for-the-
  abstraction.
- **§Platform-obvious-vs-platform-implicit-exports**: the
  naming convention tells platform. §Obvious (`nodejs`,
  `browser`); §implicit (`wasm` mechanism implies browser).
  §Reader-literacy-prerequisite acknowledged as §discipline-
  by-disclosure.
- **§Two-directory-structure-choices** (simple vs feature-
  then-platform). §Convention-with-justified-flexibility.
- **§Directory-structure-becomes-export-paths** discipline.
  §No-mismatch-between-filesystem-and-package-graph;
  §reduce-cognitive-overhead-by-removing-renames.
- **§Integration-points-named-explicitly**: vat-worker.ts +
  make-kernel.ts (Node); kernel-worker.ts + iframe.ts
  (browser). §Don't-leave-the-contributor-guessing.
- **§Per-platform-e2e-package** (extension for browser,
  kernel-test for Node) amortizes platform setup.

## §Gap-revealing-comparison with garden cycles

| Cycle | Observation |
|-------|-------------|
| 145 (formula-inspector) | UI surface; browser-side; cycle 145's discipline doesn't name a §platform-specific-development-guide |
| 147 (workers-panel) | Daemon-observability; cross-platform concern |
| 137 (daemon-message-streaming) | Straddles Node and browser |
| 161 (overview) | Named ocap-kernel's 30-package layout; this doc tells contributors how to add to it |
| 164 (identity-backup-recovery) | User-targeted doc; this is contributor-targeted — §two-audience-surface |

## §Tier-1 vocabulary borrowing candidates

§Core-vs-runtime-package-layering, §platform-obvious-vs-
platform-implicit-exports, §six-step-development-flow,
§directory-structure-becomes-export-paths, §canonical-per-
platform-test-package, §name-the-integration-file.

§Tier-2: §two-audience-surface, §doc-as-contract-with-
future-contributors.

## §Reference-not-substrate stance (continued)

§Borrow-the-shape-not-the-names: kernel-browser-runtime +
nodejs + extension + kernel-test are ocap-kernel-specific
package names. The vocabulary and structural patterns are
borrowable; the names are not.

## Files written / edited

- `library/sections/metamask-ocap-kernel--docs-platform-
  specific-md--platform-obvious-vs-platform-implicit-
  exports-with-six-step-contributor-guide-for-Node-
  browser-split.md` (299 lines; commit `05825f9a`)
- `library/sources/metamask-ocap-kernel--docs-platform-
  specific-md.md` (new source page)
- `library/sources/README.md` (cycle-165 row added under
  "External code repositories (sibling implementations)"
  above cycle-164 row)
- `library/sections/README.md` (cycle-165 entry; totals
  bumped 669/210 → 670/211)
- `library/topics/daemon.md` (cycle-165 row)
- `library/topics/tooling.md` (cycle-165 row)
- `library/topics/getting-started.md` (cycle-165 row;
  contributor-onboarding fits getting-started)
- `library/keywords.md` (44 new keyword rows)
- `inboxes/endolin/scholar.md` (timestamp + commit hash
  bumped manually)

## Library totals

669 / 210 → **670 sections from 211 source documents**.

## Lane rotation note

Cycle 165 was nominally papers-lane in the rotation;
papers-lane has been blocked **59+ consecutive cycles**.
Pivoted gracefully to comments-lane and continued the
ocap-kernel queue.

The §ocap-kernel-mini-series now spans five cycles:
- Cycle 161: monorepo overview (user-directed; off-rotation)
- Cycle 162: ken-protocol-assessment.md
- Cycle 163: glossary.md
- Cycle 164: identity-backup-recovery.md
- Cycle 165: platform-specific.md

Remaining §queued-doc items from cycle 161's plan:
kernel-guide.md (689 lines), usage.md (691 lines). After
these, the queue moves into per-package READMEs and code-
comment fragments.

## §Reflection-on-mini-series-pacing

Five consecutive cycles on ocap-kernel docs is the longest
genre-streak in the autonomous era. The maintainer's
stated interest ("ongoing comparison and contrast") plus
the queue's natural priority order has driven this. The
next cycle could reasonably:

- Continue with kernel-guide.md (689 lines; substantial
  architecture doc), or
- Break for genre variety with a non-ocap-kernel source.

Leaving the choice to cycle 166's judgment.

## Cycle 165 — done. Schedule cycle 166.
