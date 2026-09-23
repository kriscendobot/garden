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
title: §The-`@ts-check` + `<reference types="ses"/>` header (lite.js)
parent: endo--packages-check-bundle-js--powered-and-powerless-symmetric-pair-with-frozen-bundle-assertion-and-design-boundary-migration
---

```js
// @ts-check
/// <reference types="ses"/>
```

§The-triple-slash-reference brings SES's globals (`assert`,
`harden`, `Compartment`) into TypeScript's view. §Without-this,
`assert.typeof` and `Fail` would be type errors.

§Compare-to-cycle-183-init's §shim-assembly: the SES globals
are installed at module-load via the lockdown chain. §This-
reference-tells-TypeScript that they will be available at
runtime.

§The-`Fail`-template (cycle 87 ses-error/assert.js) is used
throughout lite.js for error throwing. §Sibling-discipline.
