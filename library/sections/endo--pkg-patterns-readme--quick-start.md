---
title: Quick Start
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

> Abstract: Minimal usage of the patterns package: import M from @endo/patterns; construct patterns via M.string(), M.recordOf(), etc.; test with matches() or assert with mustMatch(). Demonstrates the common shape: declare expected structure, validate inbound passables against it.

## Quick Start

```javascript
import { M, mustMatch } from '@endo/patterns';

const specimen = harden({ foo: 3, bar: 4 });

const pattern = M.splitRecord(
  { foo: M.number() },                        // required properties
  { bar: M.string(), baz: M.number() }       // optional properties
);

mustMatch(specimen, pattern);
// throws: 'bar?: number 4 - Must be a string'
```

_For best rendering, use the
[Endo reference docs](https://endojs.github.io/endo) site._


Source: [packages/patterns/README.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/packages/patterns/README.md) at commit `14a0b631`.
