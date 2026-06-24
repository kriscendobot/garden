---
title: Overview
source: doc/design/cells.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [content-addressed-storage, capability-security]
status: current
---

Abstract: CASK provides two orthogonal naming systems that compose. **Immutable Merkle trees** are content-addressed and hash-propagating: the root hash names the entire tree state, and any change ripples up to a new root. The **mutable cell graph** is capability-addressed and non-propagating: each cell has a stable cryptographic identity independent of its content, so a mutation does not change the cell's identity and does not ripple up. The two compose into a "named mutable reference to an immutable snapshot": a cell points to a Merkle root. This is the design idea the rest of `cells.md` elaborates (cell bank, weak cell references in trees, retention, mode field, capability model, GC).

## Overview

CASK provides two orthogonal systems:

1. **Immutable Merkle trees** - Content-addressed, hash-propagating. The root hash
   names the entire tree state. Changes propagate up to the root.

2. **Mutable cell graph** - Capability-addressed, non-propagating updates. Each
   cell has a stable cryptographic identity independent of its content. Changes
   don't ripple up.

These compose: a cell points to a Merkle root, giving "named mutable reference
to immutable snapshot."

Source: [doc/design/cells.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/cells.md) at commit `cdb975d8`.
