---
source: designs/endo-bytes.md
source_repo: endojs/endo-but-for-bots
source_url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endo-bytes.md
source_branch: master
source_authors: [Designer (dispatched per kriskowal review)]
ingested: 2026-06-03
ingested_by: scholar
section_count: 1
status: current
notes: |
  Cycle 172. Designs-lane after cycle 171's chat-lane.
  §Endo-but-for-bots-design genre.

  Status: **Implemented** (PR #142). §Sourced-from-PR-
  inline-review-comment (PR 122 comment 3205507716).

  617-line design for a new `@endo/bytes` package
  extracting duplicated `Uint8Array` helpers. §Sibling-
  utility-package to cycle 167's @endo/where and cycle
  171's @endo/stream.

  **Single most structurally interesting move**: §maximal-
  power-minimal-area discipline (per user's review
  guidance): §ship-the-smallest-API-that-retires-the-
  existing-duplicates; §add-helpers-when-a-real-consumer-
  asks.

  §The-portability-problem (§three-platform-constraint):
  Buffer is Node-only; Uint8Array is cross-platform
  (Node / XS / SES-locked compartments).

  §Five-existing-duplicates audit: PR 122 triplication +
  concatUint8Arrays + concat + Buffer.concat ports.
  §Three-concrete-costs: each-new-caller-invents-another-
  copy; subtle-drift-between-copies; Buffer-ports-still-
  landing.

  §Four-helpers-MVP: concatBytes + bytesEqual +
  bytesFromText + bytesToText. §Each-helper-justified-
  with-existing-duplicates-count.

  §Six-helpers-explicitly-deferred (with named reasons):
  slice (use subarray); base64 (use @endo/base64); hex
  (use @endo/hex); compare (no current call site);
  concatInto (TC39 may standardize); fromArrayBuffer
  (one-liner). §Document-what's-not-included-and-why.

  §No-barrel-module-per-helper-surface (Decision 5): each
  export gets own surface module at package root;
  re-exports from src/. §Tree-shaking-friendliness;
  §per-helper-surface-area-easy-to-audit. Per kriskowal's
  PR 142 review.

  §Qualified-export-names (Decision 6): concat.js exports
  concatBytes (not concat). §File-name-doesn't-stutter;
  §export-name-carries-qualifier.

  §Module-scoped-TextEncoder/TextDecoder: §capture-at-
  module-load; §no-per-call-allocation; §captured-before-
  lockdown-can't-be-defeated.

  §No-input-validation-beyond-primitives: §leaf-utility-
  stays-leaf; §don't-add-pass-style-dependency.

  §Eight-Decisions recorded from PR #142 implementation
  review (§Open-Questions-resolved-during-implementation —
  a lifecycle pattern).

  §First-release-at-1.0.0 (Decision 8): §no-0.x-purgatory.
  §API-stable-from-day-one. Implemented via changeset
  major bump.

  §Four-phase migration: package creation + PR 122
  triplication + sibling duplicates + TextEncoder/Decoder.
  PR #142 shipped Phases 1+3+4. §Decoupled-rollout.

  §The-§sourced-from-PR-inline-review-comment lifecycle —
  the fourth instance in the design corpus (alongside
  cycles 149 + 157 + 161). §Healthy-design-lifecycle:
  reviewer flags duplication; design doc canonicalizes
  extraction.

  §Sibling-to-cycle-167-where-and-cycle-171-stream in the
  §family-of-small-focused-utility-packages.

  §Gap-revealing-comparison with cycles 167/171/157/149/
  161/165.

  §Tier-1 vocabulary borrowing: §maximal-power-minimal-
  area + §no-barrel-module-per-helper-surface +
  §qualified-export-names + §module-scoped-TextEncoder/
  Decoder + §first-release-at-1.0.0 + §Open-Questions-
  resolved-during-implementation + §sourced-from-PR-
  inline-review-comment lifecycle.

  §Synthesis-target: when the garden grows a utility
  package to retire duplication, follow the eight-step
  pattern. §Slot machine library can §reuse-this-pattern.

  §Complete-designs-are-the-archive of validated
  disciplines (sibling to cycle 168 daemon-checkin-
  checkout).

  Cycle 172 was nominally designs-lane (after cycle 171's
  chat-lane). Papers-lane blocked 66+ consecutive cycles.
---

> Abstract: `designs/endo-bytes.md` (617 lines) is the
> design for `@endo/bytes`, a new utility package
> extracting duplicated `Uint8Array` helpers. Status:
> **Implemented** (PR #142). §Sourced-from-PR-inline-
> review-comment.
>
> **Cycle 172 — designs-lane** after cycle 171's chat-lane.
> §Endo-but-for-bots-design genre.
>
> **Single most structurally interesting move**: §maximal-
> power-minimal-area discipline (per user's guidance).
>
> §The-portability-problem (Buffer is Node-only; Uint8Array
> is cross-platform). §Five-existing-duplicates audit with
> §three-concrete-costs.
>
> §Four-helpers-MVP (concatBytes + bytesEqual +
> bytesFromText + bytesToText) with §helper-rationale-
> table-with-existing-duplicates-counts. §Six-helpers-
> explicitly-deferred with named reasons.
>
> §No-barrel-module-per-helper-surface; §qualified-export-
> names (concat.js → concatBytes); §kebab-case-file-names-
> for-multi-word; §module-scoped-TextEncoder/Decoder;
> §no-input-validation-beyond-primitives.
>
> §Eight-Decisions from PR #142 review (§Open-Questions-
> resolved-during-implementation lifecycle).
>
> §First-release-at-1.0.0 (§no-0.x-purgatory).
>
> §Four-phase migration; §decoupled-rollout.
>
> §Sibling-utility-package to cycle 167 @endo/where and
> cycle 171 @endo/stream — §family-of-small-focused-leaf-
> utility-packages.
>
> §Synthesis-target: §eight-step-pattern for extracting a
> utility package to retire duplication.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [maximal-power-minimal-area-four-helper-package-with-no-barrel-and-qualified-export-names](../sections/endo-but-for-bots--llm-designs-endo-bytes--maximal-power-minimal-area-four-helper-package-with-no-barrel-and-qualified-export-names.md) | tooling, patterns, pass-style | current |

One cohesion-honest section. §The-maximal-power-minimal-
area-discipline-is-the-spine; §splitting-would-fragment.

## Provenance

- Fetched 2026-06-03 from `endojs/endo-but-for-bots@master`.
- Author: Designer (dispatched per kriskowal review).
- Sourced from PR 122 inline review comment 3205507716.
- Implemented via PR #142.
- Cycle 172 was nominally **designs-lane** (after cycle
  171's chat-lane). Papers-lane blocked **66+ consecutive
  cycles**.
- One cohesion-honest section.
