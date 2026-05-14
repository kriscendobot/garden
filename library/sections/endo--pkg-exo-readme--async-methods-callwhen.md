---
title: Async Methods with M.callWhen()
source: packages/exo/README.md
source_repo: endojs/endo
source_commit: 14a0b631832ff516b4cafa3946a4a3c0ccbcf052
source_date: 2026-01-04
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [exo, eventual-send, patterns]
status: current
---

> Abstract: M.callWhen() is the pattern-language operator that converts an async method declaration into one that automatically awaits eventual-send results before passing them to the implementation. Lets a method declare arg shape against the resolved value rather than the promise, while still being callable via E().

## Async Methods with M.callWhen()

For methods that await promises, use `M.callWhen()` instead of `M.call()`:

```javascript
import { makeExo } from '@endo/exo';
import { M } from '@endo/patterns';
import { E } from '@endo/eventual-send';

const FetcherI = M.interface('Fetcher', {
  // Async method: validates and awaits arguments before calling method
  fetch: M.callWhen(M.string()).returns(M.string())
});

const fetcher = makeExo('Fetcher', FetcherI, {
  async fetch(url) {
    // url is validated, then awaited if it's a promise
    const response = await E(httpClient).get(url);
    return response.text();
  }
});
```

The `M.callWhen()` guard:
1. Validates the argument pattern
2. Awaits the argument if it's a promise
3. Validates the resolved value against the pattern
4. Then calls the method with the validated, resolved value

This enables safe eventual-send semantics: remote calls can pass promises, and
your method receives validated resolved values.


Source: [packages/exo/README.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/packages/exo/README.md) at commit `14a0b631`.
