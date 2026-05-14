---
title: @endo/pass-style (overview)
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

> Abstract: @endo/pass-style defines the type discipline by which marshal classifies values for serialization. Establishes the eight pass styles (string, number, bigint, boolean, undefined, null, symbol, remotable, copyArray, copyRecord, tagged, error, promise) and the discipline that every value crossing a marshal boundary must have exactly one pass style.

# `@endo/pass-style`

Defines what data can be passed between vats in an object-capability system.

## Overview

The **@endo/pass-style** package defines the `Passable` type and provides the
`passStyleOf()` function for classifying JavaScript values according to their
`PassStyle`.
This classification determines how values can safely be passed between isolated
compartments or across network boundaries.

Every passable value has exactly one pass style from a fixed set of
possibilities.
The key distinction is between **pass-by-copy** (the value itself is copied)
and **Pass-by-reference**.


Source: [packages/pass-style/README.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/packages/pass-style/README.md) at commit `14a0b631`.
