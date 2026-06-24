---
source: packages/check-bundle/{index,lite,src/json}.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/check-bundle
source_path: packages/check-bundle/index.js, packages/check-bundle/lite.js, packages/check-bundle/src/json.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - capability-security
  - bundles
  - hardened-javascript
genre: §endo-source-comment-fragment §canonical-powered-powerless-pair
cycle: 185
lane: chat
status: current
title: §Three-imports + §Fail-X-q from @endo/errors
parent: endo--packages-check-bundle-js--powered-and-powerless-symmetric-pair-with-frozen-bundle-assertion-and-design-boundary-migration
---

```js
import { Fail, X, q } from '@endo/errors';
```

§Three-named-imports from `@endo/errors`:

- `Fail` — template tag that throws (template form).
- `X` — `details` template tag for assert.typeof messages.
- `q` — safe-quote for embedding values in error messages.

§The-`q()` function: `assert.quote` — produces a string
representation of a value safe for error messages, escaping
non-printable characters and limiting recursion depth.

§Compare-to-cycle-89-ses-error/assert.js' §`details`-template-
tag-for-hiding-arguments-from-causal-console. §All-three-
imports are from the same family.

§Cycle-87-ses-error system is the substrate; cycle 185 check-
bundle is one of many consumers.
