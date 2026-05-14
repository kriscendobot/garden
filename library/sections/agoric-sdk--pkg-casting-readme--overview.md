---
title: Agoric Casting (overview + worked mailbox example)
source: packages/casting/README.md
source_repo: agoric/agoric-sdk
source_commit: 3b2612ff72002ac5cd7720c1cf65615e3b56fcff
source_date: 2024-09-10
source_authors: [Unknown]
ingested: 2026-05-14
ingested_by: scholar
topics: [tooling, eventual-send]
status: current
---

> Abstract: `@agoric/casting` follows ocap broadcasts flexibly. The `yarn demo` script demonstrates; the CLI `npx agoric follow` provides the same. The example creates a leader from the devnet network-config URL, makes a casting spec for a mailbox address, makes a follower, and iterates via `for await of iterateLatest(follower)`. Requires Hardened JS via `@endo/init` (with `pre-remoting.js` first if using `for await of`).

# Agoric Casting

This [Agoric](https://agoric.com) Casting package follows ocap broadcasts in a flexible, future-proof way.

TL;DR: You can run `yarn demo`, or to follow a mailbox castingSpec do:

```sh
npx agoric follow -Bhttp://devnet.agoric.net/network-config :mailbox.agoric1foobarbaz -otext
```

An example of following an on-chain mailbox in code (using this package) is:

```js
// First, obtain a Hardened JS environment via Endo.
import '@endo/init/pre-remoting.js'; // needed only for the next line
import '@endo/init';

import {
  iterateLatest,
  makeFollower,
  makeLeader,
  makeCastingSpec,
} from '@agoric/casting';

// Iterate over a mailbox follower on the devnet.
const leader = makeLeader('https://devnet.agoric.net/network-config');
const castingSpec = makeCastingSpec(':mailbox.agoric1foobarbaz');
const follower = makeFollower(castingSpec, leader);
for await (const { value } of iterateLatest(follower)) {
  console.log(`here's a mailbox value`, value);
}
```

Source: [packages/casting/README.md](https://github.com/Agoric/agoric-sdk/blob/3b2612ff72002ac5cd7720c1cf65615e3b56fcff/packages/casting/README.md) at commit `3b2612ff`.
