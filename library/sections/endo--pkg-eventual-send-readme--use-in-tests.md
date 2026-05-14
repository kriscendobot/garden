---
title: Use in Tests
source: packages/eventual-send/README.md
source_repo: endojs/endo
source_commit: 14a0b631832ff516b4cafa3946a4a3c0ccbcf052
source_date: 2026-01-04
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [eventual-send, testing]
status: current
---

> Abstract: Patterns for testing eventually-sent code: the eventual-send shim is synchronous-by-default in single-threaded JS (just defers to the microtask queue), so tests can await an E() call directly. Test frameworks like ava's t.is and t.throwsAsync compose naturally with promises returned from E().

## Use in Tests

Use `E()` even in unit tests for consistency:

```javascript
import test from 'ava';
import { E } from '@endo/eventual-send';

test('counter increments correctly', async t => {
  const counter = makeCounter(0);

  // Use E() even though counter is local
  const result = await E(counter).increment(5);

  t.is(result, 5);
});
```

Benefits:
- Tests mirror production code
- Async behavior is tested
- Easy to mock remote objects
- Same code works for both local and remote targets


Source: [packages/eventual-send/README.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/packages/eventual-send/README.md) at commit `14a0b631`.
