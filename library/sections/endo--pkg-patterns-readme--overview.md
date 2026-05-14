---
title: @endo/patterns (overview)
source: packages/patterns/README.md
source_repo: endojs/endo
source_commit: 14a0b631832ff516b4cafa3946a4a3c0ccbcf052
source_date: 2026-01-04
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [patterns]
status: current
---

> Abstract: The @endo/patterns package defines the M namespace: a declarative shape-matching language for passable values. Used as method guards in Exo, as data-validation predicates, and as composition primitives across Endo. Patterns describe shapes, not transport semantics; distinct from marshal/pass-style which describe how values cross a serialization boundary.

# `@endo/patterns`

Pattern matching and validation for passable data, with copy-collections and
interface guards.

## Overview

The **@endo/patterns** package provides the `M` namespace for creating pattern
matchers that validate passable data and describe behavioral contracts.
This is the validation layer above [@endo/pass-style](../pass-style/README.md),
enabling you to check that data matches expected shapes before using it.

Patterns enable:
- **Data validation**: Check that values match expected types and structures
- **Interface contracts**: Describe method signatures with InterfaceGuards
- **Copy collections**: CopySet, CopyBag, CopyMap for passable data structures
- **Key comparison**: Distributed equality for comparing values across vats


Source: [packages/patterns/README.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/packages/patterns/README.md) at commit `14a0b631`.
