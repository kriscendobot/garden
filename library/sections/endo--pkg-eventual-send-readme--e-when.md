---
title: E.when(promiseOrValue, onFulfilled?, onRejected?)
source: packages/eventual-send/README.md
source_repo: endojs/endo
source_commit: 14a0b631832ff516b4cafa3946a4a3c0ccbcf052
source_date: 2026-01-04
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [eventual-send, errors]
status: current
---

> Abstract: The eventual-send analog of .then: schedules onFulfilled/onRejected callbacks against a promise or local value, but does so in a future turn. Unlike Promise.prototype.then, E.when does not require monkey-patching Promise; it is safe to use under SES.

### E.when(promiseOrValue, onFulfilled?, onRejected?)

Shorthand for promise handling with turn tracking:

```javascript
E.when(
  E(counter).getValue(),
  value => console.log('Value:', value),
  error => console.error('Error:', error)
);

// Equivalent to:
E(counter).getValue().then(
  value => console.log('Value:', value),
  error => console.error('Error:', error)
);
```

Primarily useful in contexts that need explicit turn tracking for debugging.


Source: [packages/eventual-send/README.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/packages/eventual-send/README.md) at commit `14a0b631`.
