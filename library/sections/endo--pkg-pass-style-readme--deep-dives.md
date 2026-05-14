---
title: Deep Dives
source: packages/pass-style/README.md
source_repo: endojs/endo
source_commit: 14a0b631832ff516b4cafa3946a4a3c0ccbcf052
source_date: 2026-01-04
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [pass-style, marshal]
status: current
---

> Abstract: Pointers to deeper documentation under packages/pass-style/doc/: copyArray-guarantees.md, copyRecord-guarantees.md, enumerating-properties.md. Each addresses a subtle aspect of how marshal classifies non-trivial structures and what guarantees the classification provides about iteration order, property enumeration, and similar JS-level surprises.

## Deep Dives

For implementation details:
- [CopyRecord guarantees](./doc/copyRecord-guarantees.md) - Detailed validation
  guarantees for CopyRecord
- [CopyArray guarantees](./doc/copyArray-guarantees.md) - Detailed validation
  guarantees for CopyArray
- [Enumerating properties](./doc/enumerating-properties.md) - Property
  enumeration semantics
- [Type definitions](./src/types.js) - Complete TypeScript type definitions

Source: [packages/pass-style/README.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/packages/pass-style/README.md) at commit `14a0b631`.
