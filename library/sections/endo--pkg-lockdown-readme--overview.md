---
title: "@endo/lockdown (overview)"
source: packages/lockdown/README.md
source_repo: endojs/endo
source_commit: dd24b13d838f045d8d54354a8d704af83718e0a8
source_date: 2022-12-08
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [hardened-javascript, tooling]
status: current
---

> Abstract: The thin @endo/lockdown shim package. Importing it ensures SES has both initialized AND locked down the environment, so subsequent imports can rely on a hardened environment. Use @endo/init for a more comprehensive upgrade beyond just lockdown.

# `@endo/lockdown`

We often need to upgrade a JavaScript environment to HardenedJS as a side
effect of importing a module, so that later modules can rely on the hardened
environment.
The `@endo/lockdown` package simply ensures that SES has both initialized
and locked down the environment.

```js
import '@endo/lockdown'
import 'hardened-modules...';
```

The HardenedJS environment is a subset of the Endo environment.
Use [`@endo/init`](../init) for a more comprehensive upgrade.

Source: [packages/lockdown/README.md](https://github.com/endojs/endo/blob/dd24b13d838f045d8d54354a8d704af83718e0a8/packages/lockdown/README.md) at commit `dd24b13d`.
