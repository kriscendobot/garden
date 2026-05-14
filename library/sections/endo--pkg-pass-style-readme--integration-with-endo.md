---
title: Integration with Endo Packages
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

> Abstract: How pass-style relates to other Endo packages: marshal uses pass-style to classify, patterns uses it to match, exo uses Far/makeTagged for declaring class instances, captp uses it to decide what crosses the wire by data vs by proxy. A short cross-cutting map; deeper detail lives in each package's own README.

## Integration with Endo Packages

- **Validation**: [@endo/patterns](../patterns/README.md) - Pattern matching to
  validate passables
- **Defensive Objects**: [@endo/exo](../exo/README.md) - Exos combine Far with
  pattern validation
- **Communication**: [@endo/eventual-send](../eventual-send/README.md) - Send
  messages using E() proxy
- **Serialization**: [@endo/marshal](../marshal/README.md) - Encode passables
  for transmission

**Complete Tutorial**: See [Message Passing](../../docs/message-passing.md) for
a comprehensive guide showing how pass-style works with patterns, exo, and
eventual-send.


Source: [packages/pass-style/README.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/packages/pass-style/README.md) at commit `14a0b631`.
