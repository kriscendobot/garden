---
title: Follower options (proof / decode / unserializer / crasher)
source: packages/casting/README.md
source_repo: agoric/agoric-sdk
source_commit: 3b2612ff72002ac5cd7720c1cf65615e3b56fcff
source_date: 2024-09-10
source_authors: [Unknown]
ingested: 2026-05-14
ingested_by: scholar
topics: [tooling, marshal]
status: current
notes: The `proof: 'optimistic'` default has a subtle gotcha: data is released before validation, but a future proof failure can crash the follower with an already-released value. Production code should consider `proof: 'strict'` and accept the validation latency. The `unserializer: null` option turns off marshal decode — useful for raw-byte consumers.
---

> Abstract: `makeFollower(leader, key, followerOpts)` accepts a bag of options. **proof**: three modes — `strict` (release after validation, may wait one block), `optimistic` (default; release immediately, may crash later if a released value can't be proven), `none` (release without validation). **decode**: function `Uint8Array → string`; default interprets buf as utf-8 then `JSON.parse`. **unserializer**: default uses `@endo/marshal`'s `makeMarshal()`; `null` skips unserialization; or any custom object supporting `E(unserializer).fromCapData(data)`. **crasher**: default `null` propagates failures via exception; or any object supporting `E(crasher).crash(reason)`.

## Follower options

The `followerOpts` argument in `makeFollower(leader, key, followerOpts)` provides an optional bag of options:

- the `proof` option, which has three possibilities:
  - `'strict'` - release data only after proving it was validated (may incur waits for one block's data to be validated in the next block),
  - `'optimistic'` (default) - release data immediately, but may crash the follower in the future if an already-released value could not be proven,
  - `'none'` - release data immediately without validation
- the `decode` option is a function to translate `buf: Uint8Array` into `data: string`
  - (default) - interpret buf as a utf-8 string, then `JSON.parse` it
- the `unserializer` option can be
  - (default) - release unserialized objects using [@endo/marshal](https://www.npmjs.com/package/@endo/marshal)'s `makeMarshal()`
  - `null` - don't additionally unserialize data before releasing it
  - any unserializer object supporting `E(unserializer).fromCapData(data)`
- the `crasher` option can be
  - `null` (default) follower failures only propagate an exception/rejection
  - any crasher object supporting `E(crasher).crash(reason)`

Source: [packages/casting/README.md](https://github.com/Agoric/agoric-sdk/blob/3b2612ff72002ac5cd7720c1cf65615e3b56fcff/packages/casting/README.md) at commit `3b2612ff`.
