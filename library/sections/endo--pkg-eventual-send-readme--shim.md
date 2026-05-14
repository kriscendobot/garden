---
title: Shim
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

> Abstract: The package installs a HandledPromise shim that adds the eventual-send methods to all promises. Once imported, every promise gains the ability to be eventually-sent. The shim must load before any promise-handling code that depends on these methods.

## Shim

Eventual send relies on an Endo environment.
Programs running in an existing Endo platform like an Agoric smart contract or
an Endo plugin do not need to do anything special to set up HardenedJS,
HandledPromise and related shims.
To construct an environment suitable for Eventual Send requires the
`HandledPromise` shim:

```js
import '@agoric/eventual-send/shim.js';
```

The shim ensures that every instance of Eventual Send can recognize every other
instance's handled promises.
This is how we mitigate, what we call, "eval twins".


Source: [packages/eventual-send/README.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/packages/eventual-send/README.md) at commit `14a0b631`.
