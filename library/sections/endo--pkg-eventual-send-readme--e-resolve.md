---
title: E.resolve(value)
source: packages/eventual-send/README.md
source_repo: endojs/endo
source_commit: 14a0b631832ff516b4cafa3946a4a3c0ccbcf052
source_date: 2026-01-04
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [eventual-send]
status: current
---

> Abstract: Wraps a value in a promise-shaped wrapper compatible with the eventual-send API. Useful when a local value needs to be returned from an interface that expects a promise (e.g., a method declared as async-shaped but with no actual eventual work).

### E.resolve(value)

Convert a value to a handled promise:

```javascript
const promise = E.resolve(value);
// promise is a HandledPromise wrapping value
```

Usually not needed directly; `E()` handles this automatically.


Source: [packages/eventual-send/README.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/packages/eventual-send/README.md) at commit `14a0b631`.
