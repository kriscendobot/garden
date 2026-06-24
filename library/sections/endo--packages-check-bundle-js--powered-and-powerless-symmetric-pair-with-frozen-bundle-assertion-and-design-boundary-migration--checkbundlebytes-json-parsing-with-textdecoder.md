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
title: §`checkBundleBytes` — JSON parsing with TextDecoder
parent: endo--packages-check-bundle-js--powered-and-powerless-symmetric-pair-with-frozen-bundle-assertion-and-design-boundary-migration
---

```js
export const checkBundleBytes = async (bytes, name = '<unknown-bundle>') => {
  const text = textDecoder.decode(bytes);
  const bundle = await parseLocatedJson(text, name);
  harden(bundle);
  return powerlessCheckBundle(bundle, computeSha512, name);
};
```

§Four-step-flow: bytes → text → bundle (JSON) → harden →
checkBundle.

§The-`harden(bundle)` step is critical: the powerless
`checkBundle` requires `Object.isFrozen(bundle)` (the frozen-
bundle assertion). §JSON.parse-produces-fresh-mutable-objects;
harden makes them frozen-deep before passing to checkBundle.

§Compare-to-cycle-183-init/pre.js' §shim-assembly-order — the
ordering of operations matters: parse → harden → check, in
that order, with no chance for the bundle to mutate between
harden and check.

§The-`textDecoder` is module-scoped:

```js
const textDecoder = new TextDecoder();
```

§Captured-at-module-load (cycle 172 @endo/bytes called this
§module-scoped-TextEncoder-and-TextDecoder + §captured-before-
lockdown-can't-be-defeated).

§Compare-to-cycle-181-base64's §Reflect.apply-captured-at-
module-load. §Both-are-§capture-primitives-at-module-load
patterns — distinct from the lazy IIFE patterns in cycle 175.
