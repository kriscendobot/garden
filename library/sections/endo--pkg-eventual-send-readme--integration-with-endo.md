---
title: Integration with Endo Packages
source: packages/eventual-send/README.md
source_repo: endojs/endo
source_commit: 14a0b631832ff516b4cafa3946a4a3c0ccbcf052
source_date: 2026-01-04
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [eventual-send]
status: current
notes: This section catalogs the Endo packages eventual-send composes with at the marshal/captp/exo/patterns level. The narrower endo--pkg-eventual-send-readme--integration-with-exo zooms into the Exo-class composition specifically; read this one for the broad cross-cutting map, then that one for the Exo-call details.
---

> Abstract: Cross-cutting map: marshal serializes promises by reference; captp transports E() calls over the wire; exo provides the class API for remotable targets; patterns provides M.callWhen() for async method guards. eventual-send is the application-facing surface that all of these compose under.

## Integration with Endo Packages

- **Foundation**: [@endo/pass-style](../pass-style/README.md) - What can be
  sent as arguments
- **Validation**: [@endo/patterns](../patterns/README.md) - Describe method
  signatures with InterfaceGuards
- **Defensive Objects**: [@endo/exo](../exo/README.md) - Exos are ideal targets
  for `E()`
- **Network Transport**: [@endo/captp](../captp/README.md) - Real network
  communication using CapTP

**Complete Tutorial**: See [Message Passing](../../docs/message-passing.md) for
a comprehensive guide showing how eventual-send works with pass-style, patterns,
and exo to enable safe distributed computing.


Source: [packages/eventual-send/README.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/packages/eventual-send/README.md) at commit `14a0b631`.
