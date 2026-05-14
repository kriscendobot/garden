---
source: packages/ses/README.md
source_repo: endojs/endo
source_commit: fe81477bf88b00775bf135ce6cb3a7123a296e3e
source_date: 2025-09-25
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
section_count: 9
status: current
notes: 964-line source with deeply nested H2 > H3 > H4 structure. Usage H2 (lines 62-692) consolidated into 3 H2-level library sections (core, modules, error-handling) rather than 10+ H3 sections because the H3 sub-groupings under Usage form coherent themes. Security claims H2 (5 H3 sub-sections) kept consolidated as one section with H3 boundaries preserved inline; future cycle could split at H3 if the consolidated section becomes a navigation bottleneck.
---

> Abstract: The flagship @endo/ses package README. Covers the entire SES surface: lockdown/harden/Compartment core verbs, Compartment module loading (descriptors, redirects, hooks, virtual sources, compiled modules, transforms), error-handling integration, the security claims (single-guest and multi-guest isolation, endowment protection, caveats, trusted compute base), audit history, bug disclosure, and ecosystem compatibility. The most comprehensive single-source-document for SES.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/endo--pkg-ses-readme--overview.md) | hardened-javascript | current |
| [install](../sections/endo--pkg-ses-readme--install.md) | hardened-javascript, tooling | current |
| [usage-core](../sections/endo--pkg-ses-readme--usage-core.md) | hardened-javascript, compartments, capability-security | current |
| [usage-modules](../sections/endo--pkg-ses-readme--usage-modules.md) | hardened-javascript, compartments, bundles | current |
| [usage-error-handling](../sections/endo--pkg-ses-readme--usage-error-handling.md) | hardened-javascript, errors | current |
| [security-claims-and-caveats](../sections/endo--pkg-ses-readme--security-claims-and-caveats.md) | hardened-javascript, capability-security, compartments | current |
| [audits](../sections/endo--pkg-ses-readme--audits.md) | hardened-javascript, security-disclosure | current |
| [bug-disclosure](../sections/endo--pkg-ses-readme--bug-disclosure.md) | hardened-javascript, security-disclosure | current |
| [ecosystem-compatibility](../sections/endo--pkg-ses-readme--ecosystem-compatibility.md) | hardened-javascript, tooling | current |

## Provenance

- File last modified 2025-09-25 by Kris Kowal.
- Captured at endo file-specific commit `fe81477b`.
- Two ingest-source messages for this file landed (cycle 1 re-queue + 2026-05-14 priming batch); both pointed at the same source. Idempotency check resolves duplicates at the source-index level.

## A new topic emerges

The Usage > Modules section's content (module descriptors, redirects, lookup hooks, virtual sources, compiled modules) is the most substantive coverage so far of the `bundles` topic — which had been seed-but-not-populated until this cycle. The `usage-modules` section now populates that topic; the topic page will be created.

Source: [packages/ses/README.md](https://github.com/endojs/endo/blob/fe81477bf88b00775bf135ce6cb3a7123a296e3e/packages/ses/README.md).
