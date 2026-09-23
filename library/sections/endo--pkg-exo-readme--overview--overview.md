---
title: Overview
source: packages/exo/README.md
source_repo: endojs/endo
source_commit: 14a0b631832ff516b4cafa3946a4a3c0ccbcf052
source_date: 2026-01-04
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [exo]
status: current
parent: endo--pkg-exo-readme--overview
---

An **Exo** is a remotable object (created with `Far` from
[@endo/pass-style](../pass-style/README.md)) protected by an
**InterfaceGuard** (from [@endo/patterns](../patterns/README.md)).
The guard automatically validates all method arguments and return values,
providing the first layer of defense against malformed input.

This package provides three patterns for creating exos:
- **makeExo** - Single instance with minimal state management
- **defineExoClass** - Multiple instances with per-instance state
- **defineExoClassKit** - Multiple facets (related objects) sharing state

Source: [packages/exo/README.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/packages/exo/README.md) at commit `14a0b631`.
