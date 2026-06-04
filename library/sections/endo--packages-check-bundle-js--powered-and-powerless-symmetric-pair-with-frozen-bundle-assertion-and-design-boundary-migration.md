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
---

# Powered and powerless symmetric pair with frozen-bundle assertion, three-public-function progression, and design-boundary migration observed in source

> §Chat-lane after cycle 184's designs-lane. §The-nineteenth-
> consecutive designs/chat alternation cycle (166-185). §Cycle-180-
> hex-package design's §audit-table named check-bundle/index.js
> as a §boundary-site §retained-as-is; §the-actual-source-uses-
> encodeHex-from-@endo/hex which means §the-§boundary-site-was-
> migrated-despite-the-design-saying-it-shouldn't-be. §A-rare-
> opportunity to record a §gap-between-design-and-implementation
> through library cross-reference.

`packages/check-bundle/` is a small 158-line package across
three files:

- `index.js` (43 lines) — the §powered shim with `fs` +
  `crypto` imports.
- `lite.js` (93 lines) — the §powerless core taking
  `computeSha512` as a parameter.
- `src/json.js` (22 lines) — `parseLocatedJson` helper that
  wraps `SyntaxError` with file location.

§The-single-most-structurally-interesting-move is §powered-
and-powerless-symmetric-pair-where-powered-is-a-thin-shim-over-
powerless-core. §Two-`checkBundle`-functions-share-a-name-but-
differ-by-power-axis: the powered version provides crypto +
fs; the powerless core accepts cryptography as an explicit
parameter. §The-§ocap-discipline-via-explicit-power-injection
pattern in its most distilled form.

## §Two-file-symmetric-pair (the spine)

```js
// index.js (powered)
import * as fs from 'fs';
import * as crypto from 'crypto';
import { checkBundle as powerlessCheckBundle } from './lite.js';

const computeSha512 = bytes => {
  const hash = crypto.createHash('sha512');
  hash.update(bytes);
  return encodeHex(hash.digest());
};

export const checkBundle = async (bundle, name = '<unknown-bundle>') => {
  return powerlessCheckBundle(bundle, computeSha512, name);
};
```

```js
// lite.js (powerless)
export const checkBundle = async (
  bundle,
  computeSha512,
  bundleName = '<unknown-bundle>',
) => { ... };
```

§Powered-checkBundle = §powerless-checkBundle + §computeSha512-
factory. §The-power (crypto + fs) flows into the powerless
core via §explicit-parameter-injection.

§Why-this-pattern-matters:

- `@endo/check-bundle/lite.js` runs in §any-SES-realm because
  it has no `fs` or `crypto` imports.
- `@endo/check-bundle/index.js` is §node-only because it
  depends on `node:fs` and `node:crypto`.
- A browser-side consumer can §import-lite-and-provide-its-
  own-WebCrypto-based-`computeSha512`.
- An Agoric-XS-side consumer can §import-lite-and-provide-its-
  own-XS-native-hash.

§Compare-to-cycle-183-@endo/init's-§tolerance-ladder (index <
debug < legacy < unsafe-fast). §Different-axis: cycle 183
ladders along §strictness; cycle 185 ladders along §powered-
ness.

§Compare-to-cycle-181-base64's-§three-tier-dispatch (native →
legacy XS → JS). §Different-mechanism: base64 dispatches
internally at module-load; check-bundle separates externally
into two files (powerless core vs powered shim).

## §Three-public-functions in index.js — progression of poweredness

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

## §The-frozen-bundle-assertion (the integrity invariant)

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

## §The-three-class-property-rejection (defense against accessor attacks)

```js
const properties = Object.entries(Object.getOwnPropertyDescriptors(bundle));
const nonValues = properties.filter(
  ([, property]) => typeof property.get === 'function',
);
const nonStrings = properties.filter(
  ([, property]) => typeof property.value !== 'string',
);
(nonValues.length === 0 && nonStrings.length === 0) ||
  Fail`checkBundle cannot vouch for the ongoing integrity of a bundle ${q(
    bundleName,
  )} with getter properties (has ${nonValues.map(
    ([name]) => name,
  )}) or non-string value properties (has ${nonStrings.map(
    ([name]) => name,
  )})`;
```

§Two-defensive-checks: §nonValues (getter properties) +
§nonStrings (non-string values). §A-bundle-must-be-a-frozen-
record-of-strings — nothing else.

§Why-getters-are-rejected: even on a frozen object, a getter
function could return different values across calls. §A-getter-
defeats-the-frozen-vouch.

§Why-non-string-values-are-rejected: the bundle protocol
specifies string-valued fields (`moduleFormat` / `endoZipBase64`
/ `endoZipBase64Sha512`). §Non-string-values-indicate-tampering-
or-format-error.

§The-error-message names the offending property names via
`.map(([name]) => name)`. §Diagnostic-discipline names the
specific properties at fault, not just "has nonValues."

§Compare-to-cycle-178-daemon-xs-worker-snapshot's §append-only-
callback-table. §Both-are-§structural-defenses-against-mutation-
or-replacement-attacks; both rely on the §frozen-state of the
substrate.

§Compare-to-cycle-87-pass-style/safe-promise.js' §safe-promise-
predicate: both filter for §shape-conformance-as-precondition.

## §The-three-moduleFormat-cases (and the two rejections)

```js
if (moduleFormat === 'endoZipBase64') {
  // ... extract bytes, parseArchive, verify sha512
} else if (
  moduleFormat === 'getExport' ||
  moduleFormat === 'nestedEvaluate'
) {
  Fail`checkBundle cannot determine hash of bundle with ${q(
    moduleFormat,
  )} moduleFormat because it is not necessarily consistent`;
} else {
  Fail`checkBundle cannot determine hash of bundle with unrecognized moduleFormat ${q(
    moduleFormat,
  )}`;
}
```

§Three-cases: §accept-endoZipBase64 + §reject-getExport-and-
nestedEvaluate-with-named-reason + §reject-unknown-with-named-
reason.

§Why-getExport-and-nestedEvaluate-are-rejected: "it is not
necessarily consistent." §The-design-decision-named-explicitly:
those module formats produce JavaScript-source bundles whose
hash depends on subtle textual choices (whitespace, source-map
encoding, ordering of properties), so the hash is §unstable-
across-toolchain-versions.

§endoZipBase64 is the §hash-stable-format: a zip archive of
modules + manifest, encoded as base64, whose sha512 covers the
zip bytes. §Stable-across-toolchain-versions because zip
ordering and zip header conventions are canonical.

§Compare-to-cycle-174-gateway-package's §three-design-lifecycle-
statuses-now-distinguished. §Both-are-§explicit-discrimination-
of-cases-each-with-named-rationale.

## §`parseArchive` integration (the hash-of-hashes verification)

```js
const bytes = decodeBase64(endoZipBase64);
const { sha512: parsedSha512 } = await parseArchive(bytes, bundleName, {
  computeSha512,
  expectedSha512: endoZipBase64Sha512,
});
assert(parsedSha512 !== undefined);
```

§Three-step-verification:

1. `decodeBase64(endoZipBase64)` produces the zip bytes.
2. `parseArchive` from `@endo/compartment-mapper/import-archive.js`
   reads the zip, verifies the manifest, **and computes the
   sha512 of the bytes**.
3. The `expectedSha512: endoZipBase64Sha512` parameter tells
   parseArchive what hash to verify against; if it doesn't
   match, parseArchive throws.

§The-`assert(parsedSha512 !== undefined)` is §belt-and-
suspenders: parseArchive should only return undefined if it
didn't compute the hash, which only happens when neither
`computeSha512` nor `expectedSha512` is provided — but both
are provided here, so the assert defends against future
parseArchive changes.

§Compare-to-cycle-181-base64's §safety-net (propagate native
error if polyfill doesn't also throw). §Both-are-§belt-and-
suspenders-against-future-implementation-drift.

§Cycle-181-base64's-§decodeBase64 is called here for the
`endoZipBase64` field. §Direct-dependency-chain: check-bundle
→ base64 → (potentially) native TC39.

## §The-§gap-between-design-and-implementation (cycle 180 boundary site migration)

§Cycle-180-hex-package-design's-§audit-table-row-23:

> `packages/check-bundle/index.js` line 14 `hash.digest()
> .toString('hex')` — SHA-512 digest at the Node powers
> boundary. **Retained as-is**: the hash digest already
> returns a hex string directly from Node; converting through
> `encodeHex` would require `digest()` + conversion with no
> benefit. Marked as "boundary" — not a migration target.

§The-actual-current-source:

```js
import { encodeHex } from '@endo/hex';
// ...
const computeSha512 = bytes => {
  const hash = crypto.createHash('sha512');
  hash.update(bytes);
  return encodeHex(hash.digest());
};
```

§The-design's-prediction-was-overturned-by-implementation:
the line was migrated to use `encodeHex(hash.digest())` despite
the design's audit explicitly marking it as §retained-at-
boundary.

§Three-possible-readings:

1. **Migration-happened-anyway**: someone (maybe even Kris)
   noticed that even though `digest('hex')` returns hex
   directly, using `digest()` + `encodeHex` gives a cleaner
   policy boundary — "all hex encoding goes through @endo/hex"
   — and the marginal allocation cost was acceptable.
2. **Design-was-honest-about-uncertainty**: cycle 180's design
   text said "Could migrate for consistency; low priority, not
   on the critical migration path" for some sites. §The-
   actual-migration-was-low-priority-but-eventually-done.
3. **Forgetting-the-design**: the migrator may not have
   consulted the design's audit table; just saw `digest()`
   returning bytes and naturally reached for `encodeHex`.

§The-§honest-design-evolution-record discipline (cycles 178/
180/183/184) extends to §the-design-doesn't-always-predict-
where-the-line-ends-up. §Cycle-180-design-was-a-prediction-at-
2026-04-23; §the-implementation-state at cycle 185 (2026-06-03)
differs.

§This-is-not-a-criticism — the design did its job (named the
migration policy + identified the boundary candidates). §The-
boundary-sites-table-was-a-guide, not a contract. §The-§gap-
itself-is-the-honest-design-implementation-relationship: not
1:1 binding, but mostly-aligned-with-room-for-evolution.

§Tier-1-borrowing: §audit-tables-in-designs-are-guides-not-
contracts; §allow-the-implementation-to-diverge-with-good-
reason; §consult-the-source-not-the-design when verifying
current state.

## §`checkBundleBytes` — JSON parsing with TextDecoder

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

## §`parseLocatedJson` (src/json.js) — error-wrapping with location

```js
const q = JSON.stringify;

export const parseLocatedJson = (source, location) => {
  try {
    return JSON.parse(source);
  } catch (error) {
    if (error instanceof SyntaxError) {
      throw SyntaxError(`Cannot parse JSON from ${q(location)}, ${error}`);
    }
    throw error;
  }
};
```

§Twenty-two-line-helper. §The-discipline: wrap JSON.parse with
SyntaxError-rewrapping that adds the file location to the
error message.

§Three-cases:

1. §JSON.parse-succeeds → return result.
2. §JSON.parse-throws-SyntaxError → rewrap with location.
3. §JSON.parse-throws-non-SyntaxError → propagate (shouldn't
   happen for JSON.parse, but defensive).

§Compare-to-cycle-181-base64's §error-rewrapping-at-the-native-
boundary. §Same-pattern-applied-here for JSON instead of TC39
base64. §The-§stable-error-contract-with-caller-context is the
shared discipline.

§The-`q = JSON.stringify` shorthand at module top is a §local
alias that gives the rewrapper a §safe-quote-of-the-location
(filenames with special characters get JSON-escaped).

## §`await null` discipline at the start

```js
export const checkBundle = async (bundle, computeSha512, bundleName) => {
  await null;
  assert.typeof(...);
  // ...
};
```

§The-`await null` at the very first line of the async function.

§Why-required: without `await null`, synchronous `assert.typeof`
throws would propagate immediately to the caller (before any
microtask boundary), which can violate caller-expectation of
"all errors come as promise rejections."

§With-`await null`: the function returns a promise immediately;
any subsequent throw (from assert.typeof) becomes a rejection
on that promise rather than a synchronous exception.

§Compare-to-cycle-90-eventual-send/track-turns.js' §async-
boundary-discipline. §Same-shape-different-context: ensure the
function's effect on the call stack matches its declared async
nature.

§Cycle-100-unhandled-rejection.js's GC-driven tracking depends
on this discipline being followed widely — if some async
functions throw synchronously, the lost-rejection tracking
becomes confused.

## §The-`@ts-check` + `<reference types="ses"/>` header (lite.js)

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

## §Three-imports + §Fail-X-q from @endo/errors

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

## §The-tiny-package-with-big-discipline-density

§158-lines-across-three-files-implementing:

- §Powered-powerless-symmetric-pair (the §ocap-discipline-via-
  explicit-power-injection canonical example).
- §Three-public-function-progression (most-domain-typed to
  most-platform-typed).
- §Frozen-bundle-assertion (defense against post-hash
  mutation).
- §Three-class-property-rejection (defense against accessor
  attacks).
- §Three-moduleFormat-cases (accept-endoZipBase64 + reject-
  getExport-and-nestedEvaluate + reject-unknown).
- §parseArchive-integration (hash-of-hashes verification via
  compartment-mapper).
- §parseLocatedJson-helper (error-rewrapping with location).
- §await-null-async-discipline (ensure all errors come as
  rejections).
- §Module-scoped-TextDecoder + §encodeHex from @endo/hex.

§Eleventh-member-of-§small-files-with-large-knowledge-density
family (cycles 165/167/169/171/173/175/177/179/181/183/185).

## §Cohesion notes

- §Powered-and-powerless-symmetric-pair is the §canonical-
  pattern for crypto/fs separation in @endo. The powerless
  core runs in any SES realm; the powered shim provides
  Node-specific affordances.
- §Three-public-function-progression makes the §powered-ness-
  axis explicit in the API surface, not just in the file
  layout.
- §Frozen-bundle-assertion + §three-class-property-rejection
  form a §defense-in-depth for bundle integrity. A frozen
  object alone isn't enough if it has getters; a record-of-
  strings is the minimum verifiable shape.
- §Three-moduleFormat-cases enumerate §which-formats-have-
  stable-hashes (endoZipBase64) and §why-others-don't
  (getExport / nestedEvaluate are §not-necessarily-consistent
  across toolchain versions).
- §`parseArchive` integration delegates hash-of-hashes
  verification to compartment-mapper; check-bundle is the
  §thin-orchestrator.
- §The-§gap-between-design-and-implementation: cycle 180 hex-
  package design marked check-bundle/index.js as §retained-at-
  boundary; the actual source migrated. §Designs-are-guides-
  not-contracts.
- §await-null discipline + §module-scoped-TextDecoder + §`@ts-
  check` + `<reference types="ses"/>` are §SES-specific-
  conventions that recur across many @endo packages.
- §parseLocatedJson is a §error-rewrapping-with-location
  helper (22 lines); sibling to cycle 181-base64's error
  rewrapping for native boundary.

## §Tier-1 borrowing

- §powered-and-powerless-symmetric-pair (powerless core takes
  cryptography as parameter; powered shim provides it)
- §ocap-discipline-via-explicit-power-injection
- §three-public-function-progression-along-powered-ness-axis
- §frozen-bundle-assertion (Object.isFrozen-required for
  vouching integrity)
- §three-class-property-rejection (no getters + no non-string
  values)
- §three-moduleFormat-cases-with-named-reject-reasons (some
  formats §not-necessarily-consistent across toolchain
  versions)
- §parseArchive-as-hash-of-hashes-via-compartment-mapper
- §parseLocatedJson (wrap SyntaxError with file location)
- §await-null-at-function-start (force async-rejection
  discipline)
- §designs-are-guides-not-contracts (audit tables can be
  overtaken by implementation evolution)

## §Synthesis-target

The §slot-machine-library's content-verification surface (if
it has one) can §borrow-the-powered-powerless-pair: a
powerless `verifyBundle(bundle, computeHash, name)` that
accepts cryptography as a parameter, and a powered
`verifyBundleFile(path)` that injects Node's crypto + fs. §The-
three-public-function-progression-along-powered-ness-axis
makes the boundary explicit in the API.

§The-§gap-between-design-and-implementation observation is a
§meta-tier-1 finding: when consulting library memory for what
the current state of a codebase is, §verify-against-source not
§verify-against-design. Designs decay; source is authoritative.
