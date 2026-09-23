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
title: §Three-public-functions in index.js — progression of poweredness
parent: endo--packages-check-bundle-js--powered-and-powerless-symmetric-pair-with-frozen-bundle-assertion-and-design-boundary-migration
---

```js
export const checkBundle      = (bundle, name)  => ...;
export const checkBundleBytes = (bytes,  name)  => ...;
export const checkBundleFile  = (path)          => ...;
```

§A-progression-from-most-domain-typed-to-most-platform-typed:

| Function | Input | Power required |
|----------|-------|----------------|
| `checkBundle(bundle, name)` | Pre-parsed bundle object | crypto (sha512) |
| `checkBundleBytes(bytes, name)` | Uint8Array | crypto + TextDecoder + JSON.parse |
| `checkBundleFile(path)` | File path | crypto + TextDecoder + JSON.parse + fs |

§Each-function-adds-one-power. §checkBundle-needs-only-crypto;
checkBundleBytes-adds-text-decoding-and-JSON-parsing;
checkBundleFile-adds-filesystem-access.

§The-most-restricted-entry-point should be preferred: callers
that already have a bundle should use `checkBundle`; callers
that have bytes from an unknown source should use
`checkBundleBytes`; only callers with a known-trusted file path
should use `checkBundleFile`.

§Compare-to-cycle-167-where/index.js' §four-state-domains
(durable / ephemeral / sock / cache). §Both-are-§named-
progression-axes that make the design space explicit. §Cycle-
185 ladders along §powered-ness; cycle 167 ladders along
§state-lifetime.
