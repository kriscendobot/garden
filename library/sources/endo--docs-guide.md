---
source: docs/guide.md
source_repo: endojs/endo
source_commit: fe81477bf88b00775bf135ce6cb3a7123a296e3e
source_date: 2025-09-25
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
section_count: 10
status: current
notes: 19 H2 sections consolidated to 10 by grouping closely-related themes. Significant content overlap with docs/reference.md and docs/lockdown.md (the API verbs, lockdown options, removed/added inventory) — flagged in per-section notes. Guide-shaped versus reference-shaped vs background-shaped; all kept under the soft-flag pattern established by docs/reference.md ingestion.
---

> Abstract: The comprehensive Endo / HardenedJS programming guide. Background-shaped (history, motivation, design rationale) rather than reference-shaped or tutorial-shaped. Covers definitions of HardenedJS/SES/Endo, the historical narrative, practical use (with code and with vetted shims), what lockdown removes/adds, Realms and Compartments, the API verb overview, library compatibility, and JavaScript edge cases (HTML comments, direct vs indirect eval).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [what-is-hardenedjs-ses-endo](../sections/endo--docs-guide--what-is-hardenedjs-ses-endo.md) | hardened-javascript, capability-security | current |
| [hardenedjs-story](../sections/endo--docs-guide--hardenedjs-story.md) | hardened-javascript, capability-security | current |
| [using-hardenedjs-with-your-code](../sections/endo--docs-guide--using-hardenedjs-with-your-code.md) | hardened-javascript, getting-started | current (overlap noted) |
| [using-hardenedjs-with-vetted-shims](../sections/endo--docs-guide--using-hardenedjs-with-vetted-shims.md) | hardened-javascript, tooling | current |
| [what-lockdown-does-removes-adds](../sections/endo--docs-guide--what-lockdown-does-removes-adds.md) | hardened-javascript | current (overlap noted) |
| [realms-and-compartments](../sections/endo--docs-guide--realms-and-compartments.md) | hardened-javascript, compartments | current |
| [api-overview](../sections/endo--docs-guide--api-overview.md) | hardened-javascript | current (overlap noted) |
| [library-compatibility](../sections/endo--docs-guide--library-compatibility.md) | hardened-javascript, tooling | current (overlap noted) |
| [html-comments](../sections/endo--docs-guide--html-comments.md) | hardened-javascript | current |
| [direct-vs-indirect-eval](../sections/endo--docs-guide--direct-vs-indirect-eval.md) | hardened-javascript, compartments | current |

## Provenance

- File last modified 2025-09-25 by Kris Kowal.
- Captured at endo file-specific commit `fe81477b`.

## Contradiction analysis

This source has the most overlap with prior sources of any cycle so far. Four sections explicitly overlap:

- `using-hardenedjs-with-your-code` overlaps `endo--docs-reference--using-ses-with-your-code` and `endo--docs-get-started--installing`.
- `what-lockdown-does-removes-adds` overlaps `endo--docs-reference--removed-by-hardened-js` and `endo--docs-reference--added-changed-by-hardened-js`.
- `api-overview` overlaps `endo--docs-reference--lockdown-api`, `endo--docs-reference--repair-intrinsics-api`, `endo--docs-reference--harden-intrinsics-api`, and `endo--docs-reference--lockdown-and-harden`.
- `library-compatibility` overlaps `endo--pkg-ses-readme--ecosystem-compatibility`.

All overlaps are kept as-is with `notes:` fields cross-referencing. The three shapes (guide-shaped, reference-shaped, tutorial-shaped, package-readme-shaped) serve different reader needs and the soft-flag pattern established in the docs/reference.md cycle is applied uniformly.

A future contradiction-resolution pass could either: (a) consolidate overlapping sections under a single canonical home with cross-references, or (b) maintain the current many-sources-per-topic shape and refine the topic-page indexes to call out shape distinctions. The maintainer can choose.

Source: [docs/guide.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/docs/guide.md).
