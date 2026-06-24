---
title: Far(iface, methods)
source: packages/pass-style/README.md
source_repo: endojs/endo
source_commit: 14a0b631832ff516b4cafa3946a4a3c0ccbcf052
source_date: 2026-01-04
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [pass-style, marshal, capability-security, exo]
status: current
notes: Far() and makeExo() are alternative ways to construct a remotable. Far() is the minimal-overhead path (no methodsGuard, no interface enforcement); makeExo() adds patterns-language argument typing and the exo lifecycle. See endo--pkg-exo-readme--makeexo-single-instance for the heavier-weight path.
---

> Abstract: Constructs a remotable: a passable object that crosses marshal boundaries as a capability reference. Takes an interface name (for error messages and debugging) and a record of methods. Frozen by construction; the recommended way to create a capability-bearing object that does not need the full Exo apparatus.

### Far(iface, methods)

Creates a remotable object that can be passed by reference.

```javascript
import { Far } from '@endo/pass-style';

const counter = Far('Counter', {
  increment() { return count += 1; },
  getValue() { return count; }
});

passStyleOf(counter);  // 'remotable'
```

**Note:** Far objects are remotable but don't validate their inputs.
For defensive objects with automatic input validation, see
[@endo/exo](../exo/README.md).


Source: [packages/pass-style/README.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/packages/pass-style/README.md) at commit `14a0b631`.
