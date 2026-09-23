---
source: packages/import-bundle/src/compartment-wrapper.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/import-bundle/src/compartment-wrapper.js
source_path: packages/import-bundle/src/compartment-wrapper.js
section_kind: source
ingested: 2026-06-05
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
  - Brian Warner (prompted)
topics:
  - compartments
  - hardened-javascript
  - bundles
genre: §endo-source-comment-fragment §canonical-inescapable-compartment-pattern
cycle: 193
lane: chat
status: current
title: §dual-signature-compatibility (the §migration-bridge)
parent: endo--packages-import-bundle-src-compartment-wrapper-js--inescapable-compartment-wrapper-with-dual-signature-compatibility-and-propagate-the-wrapper-to-child-compartments
---

```js
// In order to facilitate migration from the deprecated signature
// of the compartment constructor,
//   new Compartent(globals?, modules?, options?)
// to the new signature:
//   new Compartment(options?)
// where globals and modules are expressed in the options bag instead of
// positional arguments, this function detects the temporary sigil __options__
// on the first argument and coerces compartments arguments into a single
// compartments object.
const compartmentOptions = (...args) => {
  if (args.length === 0) {
    return {};
  }
  if (
    args.length === 1 &&
    typeof args[0] === 'object' &&
    args[0] !== null &&
    '__options__' in args[0]
  ) {
    const { __options__, ...options } = args[0];
    assert(
      __options__ === true,
      `Compartment constructor only supports true __options__ sigil, got ${__options__}`,
    );
    return options;
  } else {
    const [
      globals = ({}),
      modules = ({}),
      options = {},
    ] = args;
    assert.equal(
      options.modules,
      undefined,
      `Compartment constructor must receive either a module map argument or modules option, not both`,
    );
    assert.equal(
      options.globals,
      undefined,
      `Compartment constructor must receive either globals argument or option, not both`,
    );
    return {
      ...options,
      globals,
      modules,
    };
  }
};
```

§The-§__options__-sigil is the §temporary-migration-marker.
§The-old-signature: `new Compartment(globals, modules, options)`
(three positional arguments). §The-new-signature: `new
Compartment(options)` (one options-bag with `globals` and
`modules` as fields). §The-`__options__: true` flag in the
first arg signals "this is the new shape" so the wrapper can
disambiguate.

§Three-detection-branches:

1. §Zero-arguments → empty options.
2. §One-argument-with-`__options__`-true → new-shape; spread
   the options.
3. §Otherwise → old-shape; pull positional `globals`, `modules`,
   `options` with defaults.

§Two-double-binding-asserts in the old-shape branch: §`options.
modules`-must-be-undefined (don't pass modules both
positionally and in options) and §`options.globals`-must-be-
undefined (same). §The-double-binding-detection prevents
ambiguous calls.

§Compare-to-cycle-183-init's §LOCKDOWN_OPTIONS-sniff-with-
JSON-parse. §Both-are-§sniff-with-discipline patterns; cycle
193's sniff is §positional-vs-options-shape; cycle 183's is
§global-vs-env-variable.

§Compare-to-cycle-180-hex-package's §transitional-alias-
pattern (re-export `toHex` as `encodeHex`). §Both-are-§two-
signatures-coexist-during-migration patterns.

§The-§assert-message-includes-the-bad-value: "got ${__options__}".
§Diagnostic-discipline (sibling to cycle 177-netstring's
§four-pieces-of-context-per-error).
