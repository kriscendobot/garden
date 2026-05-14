---
title: @endo/exo (overview)
source: packages/exo/README.md
source_repo: endojs/endo
source_commit: 14a0b631832ff516b4cafa3946a4a3c0ccbcf052
source_date: 2026-01-04
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [exo]
status: current
---

> Abstract: Exo is endo's class API for capability-bearing remotable objects with declarative method guards (patterns) and per-instance state. Three forms: makeExo (single instance, no state), defineExoClass (single facet with state via init()), defineExoClassKit (multiple facets sharing one state via init()). All produce remotables that pass-style classifies as pass-by-presence.

# `@endo/exo`

Create defensive remotable objects by combining Far objects with
InterfaceGuards.

## Overview

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
