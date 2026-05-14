---
title: Best practices
source: docs/typescript.md
source_repo: agoric/agoric-sdk
source_commit: ffed404d
source_date: 2026-02-04
source_authors: [Turadg Aleahmad]
ingested: 2026-05-14
ingested_by: scholar
project: agoric-sdk
topics: [typescript-conventions]
status: current
---

> Abstract: Exported type discipline and other best-practice rules at the top of the document. Sub-section: Exported Types (where exported types live, naming conventions).

## Best practices

### Exported types

- `.ts` for modules defining exported types
- package entrypoint(s) exports explicit types
- use `/** @import ` comments to import types without getting the runtime module


Source: [docs/typescript.md](https://github.com/agoric/agoric-sdk/blob/ffed404d/docs/typescript.md) at commit `ffed404d`.
