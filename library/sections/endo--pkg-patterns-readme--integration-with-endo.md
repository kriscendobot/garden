---
title: Integration with Endo Packages
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

> Abstract: How patterns relates to its neighbors: pass-style defines the substrate (passable values), marshal serializes them, exo uses patterns for method guards, captp transports them. Patterns occupies the validation-and-shape niche between pass-style (type discipline for transport) and exo (using shapes as guards).

## Integration with Endo Packages

- **Foundation**: [@endo/pass-style](../pass-style/README.md) - What can be
  passed (Passables)
- **Enforcement**: [@endo/exo](../exo/README.md) - Use InterfaceGuards for
  automatic validation
- **Communication**: [@endo/eventual-send](../eventual-send/README.md) - Send
  messages to validated objects

**Complete Tutorial**: See [Message Passing](../../docs/message-passing.md) for
a comprehensive guide showing how patterns work with pass-style, exo, and
eventual-send.


Source: [packages/patterns/README.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/packages/patterns/README.md) at commit `14a0b631`.
