---
source: packages/pass-style/README.md
source_repo: endojs/endo
source_commit: 14a0b631832ff516b4cafa3946a4a3c0ccbcf052
source_date: 2026-01-04
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
section_count: 11
status: current
notes: "Core Functions" H2 was thin (just a heading + intro paragraph) but each of its 4 H3 sub-sections (passStyleOf, isPassable, Far, makeTagged) is substantively distinct and self-contained — so the source was split at H3 within that H2 rather than kept consolidated. "Pass-by-Copy vs Pass-by-Presence" was kept consolidated since its two H3s are a contrastive pair.
---

> Abstract: The @endo/pass-style package README. Defines the type discipline marshal uses: the enumeration of pass styles (primitives, container types, error, promise, remotable), the four core functions (passStyleOf, isPassable, Far, makeTagged), the rules for passable values, the pass-by-copy vs pass-by-presence distinction, type guards (passable vs pure-data), how pass-style integrates with other Endo packages, and pointers to deeper documentation under packages/pass-style/doc/.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/endo--pkg-pass-style-readme--overview.md) | pass-style, marshal | current |
| [pass-styles](../sections/endo--pkg-pass-style-readme--pass-styles.md) | pass-style, marshal | current |
| [passstyleof](../sections/endo--pkg-pass-style-readme--passstyleof.md) | pass-style, marshal | current |
| [ispassable](../sections/endo--pkg-pass-style-readme--ispassable.md) | pass-style, marshal | current |
| [far](../sections/endo--pkg-pass-style-readme--far.md) | pass-style, marshal, capability-security, exo | current |
| [maketagged](../sections/endo--pkg-pass-style-readme--maketagged.md) | pass-style, marshal | current |
| [passable-values](../sections/endo--pkg-pass-style-readme--passable-values.md) | pass-style, marshal | current |
| [pass-by-copy-vs-presence](../sections/endo--pkg-pass-style-readme--pass-by-copy-vs-presence.md) | pass-style, marshal, capability-security | current |
| [type-guards](../sections/endo--pkg-pass-style-readme--type-guards.md) | pass-style, marshal | current |
| [integration-with-endo](../sections/endo--pkg-pass-style-readme--integration-with-endo.md) | pass-style, marshal | current |
| [deep-dives](../sections/endo--pkg-pass-style-readme--deep-dives.md) | pass-style, marshal | current |

## Provenance

- File last modified 2026-01-04 by Kris Kowal.
- Captured at endo file-specific commit `14a0b631`.

Source: [packages/pass-style/README.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/packages/pass-style/README.md).
