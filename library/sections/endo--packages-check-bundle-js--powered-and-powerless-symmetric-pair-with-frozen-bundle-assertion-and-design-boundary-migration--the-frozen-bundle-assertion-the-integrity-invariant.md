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
title: §The-frozen-bundle-assertion (the integrity invariant)
parent: endo--packages-check-bundle-js--powered-and-powerless-symmetric-pair-with-frozen-bundle-assertion-and-design-boundary-migration
---

```js
Object.isFrozen(bundle) ||
  Fail`checkBundle cannot vouch for the ongoing integrity of an unfrozen object, got ${q(
    bundle,
  )}`;
```

§Why-frozen-required: a non-frozen bundle could mutate between
the hash check and the use site. §Even-worse, the bundle could
be a Proxy with §get-traps that return different bytes each
time `endoZipBase64` is read. §Without-freezing, the hash check
proves nothing about future reads.

§Compare-to-cycle-181-base64's-§Object.freeze-not-harden in
index.js: that was about §pre-lockdown-shim-safety. §This-is-
about-§bundle-integrity. §Both-use-Object.freeze-discipline but
for different reasons.

§The-error-message embeds the offending bundle via `q(bundle)`
(cycle 87 ses-error/assert.js' template tag). §Diagnostic-
discipline preserved.
