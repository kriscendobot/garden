---
title: far (overview)
source: packages/far/README.md
source_repo: endojs/endo
source_commit: 8e74b579
source_date: 2023-01-28
source_authors: [Ivan Leichtling]
ingested: 2026-05-14
ingested_by: scholar
topics: [pass-style, capability-security]
status: current
---

> Abstract: @endo/far is a small package re-exporting Far() and related primitives from @endo/pass-style for convenience. Far(iface, methods) constructs a remotable (a passable object that crosses marshal boundaries as a capability reference).

# Endo Far Object helpers

The `@endo/far` package provides a convenient way to use the Endo
[distributed objects system](https://docs.agoric.com/guides/js-programming/) without  relying on the underlying messaging
implementation.

It exists to reduce the boilerplate in Hardened JavaScript vats that are running
in Agoric's SwingSet kernel,
[`@agoric/swingset-vat`](https://github.com/Agoric/agoric-sdk/tree/master/packages/SwingSet),
or arbitrary JS programs using Hardened JavaScript and communicating via
[`@endo/captp`](../captp/README.md).

You can import any of the following from `@endo/far`:

```js
import { E, Far, getInterfaceOf, passStyleOf } from '@endo/far';
```

Source: [packages/far/README.md](https://github.com/endojs/endo/blob/8e74b579/packages/far/README.md) at commit `8e74b579`.
