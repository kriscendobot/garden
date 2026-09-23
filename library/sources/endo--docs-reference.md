---
source: docs/reference.md
source_repo: endojs/endo
source_commit: bffadcab8a39be8529406b22574e25cf64dec755
source_date: 2026-04-26
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
section_count: 9
status: current
notes: Significant content overlap with docs/lockdown.md. The H3 sub-sections under "lockdown Options" (regExpTaming, localeTaming, consoleTaming, errorTaming, stackFiltering, overrideTaming) cover the same option material as docs/lockdown.md's per-option H2 sections; consolidated this cycle into one "lockdown-options-summary" section with a contradicts-note pointing at the docs/lockdown.md sections. Treat docs/lockdown.md as canonical for full detail; this source is the reference-shaped quick view.
---

> Abstract: The endo programmer's reference for SES + HardenedJS. Reference-shaped (skim once, return as needed): when to use SES, what HardenedJS removes/adds, the lockdown/repairIntrinsics/hardenIntrinsics API trio, the lockdown/harden two-verb relationship, and a summary of lockdown options. Overlaps with docs/lockdown.md on per-option detail; see that source for canonical depth.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/endo--docs-reference--overview.md) | hardened-javascript | current |
| [using-ses-with-your-code](../sections/endo--docs-reference--using-ses-with-your-code.md) | hardened-javascript, getting-started | current |
| [removed-by-hardened-js](../sections/endo--docs-reference--removed-by-hardened-js.md) | hardened-javascript | current |
| [added-changed-by-hardened-js](../sections/endo--docs-reference--added-changed-by-hardened-js.md) | hardened-javascript | current |
| [lockdown-api](../sections/endo--docs-reference--lockdown-api.md) | hardened-javascript | current |
| [repair-intrinsics-api](../sections/endo--docs-reference--repair-intrinsics-api.md) | hardened-javascript | current |
| [harden-intrinsics-api](../sections/endo--docs-reference--harden-intrinsics-api.md) | hardened-javascript | current |
| [lockdown-and-harden](../sections/endo--docs-reference--lockdown-and-harden.md) | hardened-javascript | current |
| [lockdown-options-summary](../sections/endo--docs-reference--lockdown-options-summary.md) | hardened-javascript | current (overlaps with docs/lockdown.md) |

## Provenance

- File last modified 2026-04-26 by Kris Kowal.
- Captured at endo file-specific commit `bffadcab`.

## Contradiction analysis

This cycle's reading of `docs/reference.md` flagged a substantive overlap with `docs/lockdown.md`. Both documents enumerate lockdown options with descriptions, defaults, and trade-offs. The `lockdown-options-summary` section here consolidates that material; the canonical per-option detail lives in `library/sources/endo--docs-lockdown.md` (15 sections, one per option). A future contradiction-resolution pass could either: (a) drop the `lockdown-options-summary` section here and rely on docs/lockdown.md as the single source of truth, or (b) keep both with the current cross-references and acknowledge them as different shapes serving different reader needs (reference vs background). Option (b) is the default for now; the maintainer can choose otherwise.

Source: [docs/reference.md](https://github.com/endojs/endo/blob/bffadcab8a39be8529406b22574e25cf64dec755/docs/reference.md).
