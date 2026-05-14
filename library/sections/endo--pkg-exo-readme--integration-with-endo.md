---
title: Integration with Endo Packages
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

> Abstract: How Exo relates to neighbors: patterns provides the method-guard language, pass-style classifies the resulting remotable, marshal serializes it, eventual-send messages it, captp transports it. Most code that uses Exo also uses some subset of these.

## Integration with Endo Packages

- **Foundation**: [@endo/pass-style](../pass-style/README.md) - Remotables
  created with `Far()`
- **Validation**: [@endo/patterns](../patterns/README.md) - InterfaceGuards and
  M namespace
- **Communication**: [@endo/eventual-send](../eventual-send/README.md) - Call
  exos with `E()`

**Complete Tutorial**: See [Message Passing](../../docs/message-passing.md) for
a comprehensive guide showing how exos work with pass-style, patterns, and
eventual-send to enable safe distributed computing.


Source: [packages/exo/README.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/packages/exo/README.md) at commit `14a0b631`.
