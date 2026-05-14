---
title: Introspection with GET_INTERFACE_GUARD
source: packages/exo/README.md
source_repo: endojs/endo
source_commit: 14a0b631832ff516b4cafa3946a4a3c0ccbcf052
source_date: 2026-01-04
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [exo, patterns]
status: current
---

> Abstract: Every exo carries a GET_INTERFACE_GUARD symbol-keyed method returning the exo's methodsGuard pattern. Lets external code inspect the declared interface for documentation, code-generation, or runtime API discovery without invoking implementation methods. The symbol-keyed access avoids name collisions with the method record.

## Introspection with `GET_INTERFACE_GUARD`

Every exo with an InterfaceGuard has a meta-method to retrieve its interface at
runtime:

```javascript
import { GET_INTERFACE_GUARD } from '@endo/exo';
import { getInterfaceMethodKeys } from '@endo/patterns';

const counter = makeCounter();

// Get the interface guard (works with E() too)
const interfaceGuard = await E(counter)[GET_INTERFACE_GUARD]();

// Inspect available methods
const methodNames = getInterfaceMethodKeys(interfaceGuard);
console.log(methodNames);  // ['increment', 'getValue']

// Build dynamic clients, generate documentation, etc.
```

This enables:
- Runtime interface discovery
- Dynamic client generation
- Documentation generation
- Protocol negotiation

**Note:** The interface can change across vat upgrades, so clients caching it
may become stale.


Source: [packages/exo/README.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/packages/exo/README.md) at commit `14a0b631`.
