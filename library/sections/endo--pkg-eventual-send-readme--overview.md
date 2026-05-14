---
title: @endo/eventual-send (overview)
source: packages/eventual-send/README.md
source_repo: endojs/endo
source_commit: 14a0b631832ff516b4cafa3946a4a3c0ccbcf052
source_date: 2026-01-04
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [eventual-send]
status: current
---

> Abstract: @endo/eventual-send provides the E() and E.when family of operations for messaging objects that may be local or remote, sync or async. Backed by handled promises so E(target).method(args) can be pipelined across a network round-trip. The two operations (E and E.when) are the safe alternative to .then because Promise.prototype.then is implicitly invoked by built-in operations in ways user code cannot override.

# `@endo/eventual-send`

Eventual send: a uniform async messaging API for local and remote objects.

## Overview

The **@endo/eventual-send** package provides the `E()` proxy for asynchronous
message passing.
Whether an object is in the same vat, a different vat, or across a network,
`E()` provides a consistent API that always returns promises.

This enables:
- **Uniform communication**: Same code for local and remote objects
- **Promise pipelining**: Chain operations without waiting for resolution
- **Message ordering**: Preserve message order per target
- **Future-proof code**: Local code works when migrated to distributed systems


Source: [packages/eventual-send/README.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/packages/eventual-send/README.md) at commit `14a0b631`.
