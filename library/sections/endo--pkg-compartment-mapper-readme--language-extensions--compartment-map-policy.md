---
title: Compartment map policy
source: packages/compartment-mapper/README.md
source_repo: endojs/endo
source_commit: ee87476e0efcf8f6e412eec93eba5f3853ead6f3
source_date: 2024-12-15
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [bundles, compartments, tooling]
status: current
parent: endo--pkg-compartment-mapper-readme--language-extensions
---

The `policy` option accepted by the compartment-mapper API methods provides means to narrow down the endowments passed to each compartment independently.  
The rules defined by policy get preserved in the compartment map and enforced in the application. To explore how policies work, see [Policy Demo].

The shape of the `policy` object is based on `policy.json` from LavaMoat. MetaMask's [LavaMoat] generates a `policy.json` file that serves the same purposes, using a tool called TOFU: _trust on first use_.

> [!NOTE]
> TODO: Endo policy support is intended to reach parity with LavaMoat's
> policy.json.
> Policy generation may be ported to Endo.

  [LavaMoat]: https://github.com/LavaMoat/lavamoat
  [Compartments]: ../ses/README.md#compartment
  [Policy Demo]: ./demo/policy/README.md
  [import attributes]: https://nodejs.org/docs/latest/api/esm.html#import-attributes
  [package entry points]: https://nodejs.org/api/esm.html#esm_package_entry_points
  [`require.resolve()`]: https://nodejs.org/docs/latest/api/modules.html#requireresolverequest-options

Source: [packages/compartment-mapper/README.md](https://github.com/endojs/endo/blob/ee87476e0efcf8f6e412eec93eba5f3853ead6f3/packages/compartment-mapper/README.md) at commit `ee87476e`.
