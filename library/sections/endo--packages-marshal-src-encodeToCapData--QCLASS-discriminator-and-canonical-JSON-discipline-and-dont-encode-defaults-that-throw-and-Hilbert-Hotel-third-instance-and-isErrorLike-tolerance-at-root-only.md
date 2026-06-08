---
title: "@endo/marshal/encodeToCapData — §QCLASS-discriminator-as-special-property-name + §dont-encode-defaults-that-throw + §canonical-JSON-discipline-with-property-name-sorting + §Hilbert-Hotel-third-instance + §isErrorLike-tolerance-at-root-only + §implementation-restriction-promise-vs-remotable-must-be-same-function + §explicit-BEWARE-comment-for-deprecation"
source-slug: endo--packages-marshal-src-encodeToCapData
section-id: QCLASS-discriminator-and-canonical-JSON-discipline-and-dont-encode-defaults-that-throw-and-Hilbert-Hotel-third-instance-and-isErrorLike-tolerance-at-root-only
url: https://github.com/endojs/endo/blob/master/packages/marshal/src/encodeToCapData.js
authors: [Endo contributors]
repo: endojs/endo
path: packages/marshal/src/encodeToCapData.js
total-lines: 443
status: shipping
ingest-cycle: 231
ingest-date: 2026-06-08
lane: chat
---

# @endo/marshal/encodeToCapData — encode Passable to JSON-representable CapData

A 443-line file that encodes a Passable to §CapData — a JSON-representable structure that `marshal.js` then stringifies. Provides the §makeEncodeToCapData factory + §makeDecodeFromCapData factory + the §QCLASS-discriminator-keyword.

§Companion-to cycle 229's marshal-justin.js — cycle 229 decodes CapData to Justin source; cycle 231 encodes Passable to CapData. §The-pair-is-now-complete.

## §QCLASS-as-special-property-name

```js
const QCLASS = '@qclass';
export { QCLASS };
```

§Single-named-discriminator-string-used-throughout-the-wire-format. §Borrowable-pattern: §pick-a-special-property-name-that-couldn't-collide-with-user-data + §export-it-as-a-named-constant + §use-it-consistently.

§The-`@qclass`-prefix is §JSON-illegal-for-user-data-keys (`@` is permitted but uncommon and conventionally reserved); §the-Hilbert-Hotel-encoding rescues data that does collide.

§Sibling to cycle 217 @endo/errors' §`__HIDE_`-prefix-protocol and cycle 219 @endo/ses-ava's §registered-symbol-on-globalThis — §three-cycles-on-protocol-via-name-prefix.

## §The-dont-encode-defaults-that-throw

```js
const dontEncodeRemotableToCapData = rem => Fail`remotable unexpected: ${rem}`;
const dontEncodePromiseToCapData = prom => Fail`promise unexpected: ${prom}`;
const dontEncodeErrorToCapData = err => Fail`error object unexpected: ${err}`;
```

§Three-named-default-handlers-that-throw. §Borrowable-pattern: §the-default-is-rejection-not-silent-acceptance — §if-the-caller-doesn't-provide-an-encoder-for-a-class, §the-encoder-rejects-rather-than-encoding-null. §The-caller-must-explicitly-opt-in-to-encoding-remotables-or-promises-or-errors.

§Borrowable-pattern: §strict-by-default-with-opt-in-extension. §Sibling to cycle 226 endoclaw-cluster's §two-facet-control-pair — both designs §the-default-is-the-safe-shape.

§Three-cycles-on-strict-by-default-with-opt-in-extension:
- Cycle 226 endoclaw-cluster: two-facet-control-pair (capability granted only via host).
- Cycle 230 endor-npm-registry-proxy: intentionally-omitted-pre/post-install-scripts (default rejection).
- Cycle 231 encodeToCapData: dont-encode-defaults-that-throw.

§The-discipline: §don't-silently-accept-what-you-don't-know-how-to-handle.

## §The-canonical-JSON-discipline

> Must encode `val` into plain JSON data *canonically*, such that `JSON.stringify(encode(v1)) === JSON.stringify(encode(v1))`.

§The-load-bearing-architectural-property of CapData encoding. §Canonical-encoding-means: §the-same-input-always-produces-the-same-output-bytes. §This-matters-because: §`JSON.stringify(encode(v1)) === JSON.stringify(encode(v2))` must hold when v1 and v2 are equivalent.

The §honest-disclosure-about-non-determinism-mitigation:

> Readers must not care about this order anyway. We impose this requirement mainly to reduce non-determinism exposed outside a vat.

§Borrowable-pattern: §reduce-non-determinism-exposed-outside-the-vat by §making-encoding-canonical + §but-don't-require-readers-to-rely-on-the-order.

### §The-load-bearing-mechanism: §sort-copyRecord-property-names

```js
case 'copyRecord': {
  // ...
  const names = ownKeys(passable).sort();
  return fromEntries(
    names.map(name => [name, encodeToCapDataRecur(passable[name])]),
  );
}
```

§The-only-case-where-order-is-not-implicit-in-the-code is copyRecord (where the natural enumeration order can differ between equivalent records). §sort()-the-property-names + §encode-in-sorted-order — §canonical-JSON-via-sorted-keys.

The §TODO-noting-could-use-canonical-JSON-encoder-for-modular-encapsulation:

> Encoding with a canonical-JSON encoder would also solve this canonicalness problem in a more modular and encapsulated manner. [...] TODO perhaps we should indeed switch to a canonical JSON encoder, and not delicately depend on the order in which these object literals are written.

§Borrowable-pattern: §the-design-acknowledges-its-fragility + §names-the-alternative-architecture-that-would-fix-it + §carries-the-TODO. §The-other-record-properties-are-visited-in-the-order-in-which-they-are-literally-written; §that-IS-the-fragility.

§Sibling to cycle 229 marshal-justin's §TODO-to-fold-back-to-one-validating-pass — both designs §carry-a-TODO-naming-a-better-architecture.

## §The-eleven-cases of the encode-switch

```
case 'null' | 'boolean' | 'string': pass through to JSON
case 'undefined': { [QCLASS]: 'undefined' }
case 'number': three special cases (NaN, Infinity, -Infinity) + -0 → 0 + pass through
case 'bigint': { [QCLASS]: 'bigint', digits: String(passable) }
case 'symbol': { [QCLASS]: 'symbol', name }
case 'copyRecord': hilbert check + sort keys + recurse
case 'copyArray': passable.map(encodeToCapDataRecur)
case 'byteArray': TODO Fail not yet implemented
case 'tagged': { [QCLASS]: 'tagged', tag, payload: recurse(payload) }
case 'remotable': encodeRemotableToCapData callback + validate result has slot
case 'promise': encodePromiseToCapData callback + validate result has slot
case 'error': encodeErrorToCapData callback + validate result has error
default: throw TypeError on unrecognized passStyle
```

§Eleven-named-cases. §Borrowable-pattern: §switch-on-the-typed-discriminator + §validate-each-callback's-return-shape. §The-callback-returns-an-Encoding + §the-encoder-validates-its-shape-via-`qclassMatches`. §Defense-in-depth-against-callback-misbehavior.

§The-`-0`-special-case: §`return is(passable, -0) ? 0 : passable;`. §Borrowable-pattern: §normalize-`-0`-to-`0`-because-JSON-doesn't-distinguish-them-anyway + §canonical-encoding-requires-they-encode-the-same.

## §The-Hilbert-Hotel encoding (third instance in library)

```js
case 'copyRecord': {
  if (hasOwn(passable, QCLASS)) {
    // Hilbert hotel
    const { [QCLASS]: qclassValue, ...rest } = passable;
    const result = {
      [QCLASS]: 'hilbert',
      original: encodeToCapDataRecur(qclassValue),
    };
    if (ownKeys(rest).length >= 1) {
      result.rest = encodeToCapDataRecur(freeze(rest));
    }
    return result;
  }
  // ...
}
```

§Third-instance-of-Hilbert-Hotel-naming-in-library:

| Cycle | Source | Purpose |
|-------|--------|---------|
| 148 | @endo/pass-style/symbol.js | shift well-known symbols into `@@`-prefix space |
| 229 | @endo/marshal/marshal-justin.js | decode @qclass-bearing records |
| 231 | @endo/marshal/encodeToCapData.js | encode @qclass-bearing records |

§Three-different-applications-of-the-same-naming-inspiration. §Cycle-148-is-at-the-symbol-encoding-layer; cycles-229+231-are-at-the-record-encoding-layer + §cycle-229-decodes + §cycle-231-encodes.

§The-`freeze(rest)`-note in the comment names §why-the-explicit-freeze-is-needed:

> The `freeze` here is needed anyway, because the `rest` is freshly constructed by the `...` above, and we're using it as input in another call to `encodeToCapData`.

§Borrowable-pattern: §when-spreading-a-frozen-object-into-a-new-object-the-result-is-not-frozen + §the-explicit-freeze-restores-the-invariant.

## §isErrorLike-tolerance at root only

```js
const encodeToCapData = passable => {
  if (isErrorLike(passable)) {
    // We pull out this special case to accommodate errors that are not
    // valid Passables. For example, because they're not frozen.
    // The special case can only ever apply at the root, and therefore
    // outside the recursion, since an error could only be deeper in
    // a passable structure if it were passable.
    //
    // We pull out this special case because, for these errors, we're much
    // more interested in reporting whatever diagnostic information they
    // carry than we are about reporting problems encountered in reporting
    // this information.
    return harden(encodeErrorToCapData(passable, encodeToCapDataRecur));
  }
  return harden(encodeToCapDataRecur(passable));
};
```

§The-root-error-special-case is the §design-bet:
- §An-error-at-the-root-might-be-non-frozen / non-Passable / etc.
- §We-want-the-diagnostic-information + §we-don't-want-to-fail-while-trying-to-report-an-error.
- §The-special-case-can-only-ever-apply-at-the-root because §deeper-errors-must-already-be-Passable (and so are handled by the regular case).

§Borrowable-pattern: §lenient-at-the-root + §strict-deeper. §Borrowable-pattern: §when-the-design-is-about-error-reporting, §be-extra-tolerant-of-malformed-inputs-at-the-error-reporting-path.

§Sibling to cycle 217 @endo/errors' §two-channels-for-two-audiences (thrown-error redacted + console-log full) — both designs §error-reporting-is-extra-tolerant.

## §The-`@@asyncIterator` deprecated-qclass

```js
case '@@asyncIterator': {
  // Deprecated qclass. TODO make conditional
  // on environment variable. Eventually remove, but after confident
  // that there are no more supported senders.
  //
  return Symbol.asyncIterator;
}
```

§Deprecated-qclass-with-TODO-to-make-conditional-on-environment-variable + §named-removal-policy (only after confident no more supported senders).

§Borrowable-pattern: §three-phase-deprecation: (1) currently still accepted; (2) TODO make conditional on environment variable; (3) eventually remove. §The-deprecation-policy-is-explicit + §the-precondition-for-removal-is-named.

§Sibling to cycle 227 @endo/pass-style/string.js's §env-option-gated-strictness-with-named-three-phase-plan (default-disabled → default-enabled → switch-removed). §Cycle-227-is-the-mirror-image — cycle 227 phases in stricter behavior; cycle 231 phases out a deprecated feature. §Same-three-phase-shape-different-direction.

## §The-explicit-BEWARE-comment for the slot-decode

```js
case 'slot': {
  // See note above about how the current encoding cannot reliably
  // distinguish which we should call, so in the non-default case
  // both must be the same and it doesn't matter which we call.
  const decoded = decodeRemotableFromCapData(
    jsonEncoded,
    decodeFromCapData,
  );
  // BEWARE: capdata does not check that `decoded` is
  // a promise or a remotable, since that would break some
  // capdata clients. We are deprecating capdata, and these clients
  // will need to update before switching to smallcaps.
  return decoded;
}
```

§Explicit-BEWARE-comment that names the §known-vulnerability + §the-deprecation-rationale-for-not-fixing-it-immediately. §Borrowable-pattern: §when-a-design-has-a-known-vulnerability-that-can't-be-fixed-yet, §a-BEWARE-comment-with-the-reason-and-future-plan.

§Sibling to cycle 224 daemon-web-gateway's §Caveat-emptor-disclosure — both designs §honest-acknowledgment-of-named-trade-off + §named-future-path.

§Four-cycles-on-honest-acknowledgment-of-architectural-asymmetry now (cycles 220 + 224 + 229 + 231).

## §The-implementation-restriction: promise-vs-remotable

```js
decodeRemotableFromCapData === decodePromiseFromCapData ||
  Fail`An implementation restriction for now: If either decodeRemotableFromCapData or decodePromiseFromCapData is provided, both must be provided and they must be the same: ${q(
    decodeRemotableFromCapData,
  )} vs ${q(decodePromiseFromCapData)}`;
```

§Implementation-restriction-named-as-such + §rationale-comment-with-issue-link:

> The current encoding does not give the decoder enough into to distinguish whether a slot represents a promise or a remotable. As an implementation restriction until this is fixed, if either is provided, both must be provided and they must be the same.
> See https://github.com/Agoric/agoric-sdk/issues/4334

§Borrowable-pattern: §implementation-restriction-with-explicit-failure-mode + §named-issue-tracker-link-as-source-of-future-work. §The-issue-IS-the-roadmap-entry; §the-comment-points-to-it.

§Sibling to cycle 228 daemon-os-sandbox-plugin's §Roadmap-calibration-via-git-blame — both designs §reference-external-tracking-as-the-source-of-truth-for-future-work.

## §The-`ibid`-removed-but-still-rejected case

```js
// @ts-expect-error This is the error case we're testing for
case 'ibid': {
  throw Fail`The capData protocol no longer supports ${q(QCLASS)} ${q(
    qclass,
  )}`;
}
```

§A-former-qclass-now-explicitly-rejected-with-named-message. §Borrowable-pattern: §don't-silently-ignore-removed-protocol-features + §explicit-rejection-with-named-error + §the-protocol-IS-versioned-by-which-qclasses-it-accepts.

§The-`@ts-expect-error` comment names §this-is-the-error-case-we're-testing-for — §the-TypeScript-compiler-rejection-IS-the-test-coverage-hint.

§Borrowable-pattern: §use-@ts-expect-error-as-a-marker-for-error-cases-that-must-throw. §When-the-compiler-says-this-can't-happen + §the-code-handles-the-case-anyway-via-Fail, §the-`@ts-expect-error`-acknowledges-the-tension.

## §The-don't-harden-since-we're-not-done-mutating-it (hilbert decode)

```js
case 'hilbert': {
  const { original, rest } = jsonEncoded;
  hasOwn(jsonEncoded, 'original') ||
    Fail`Invalid Hilbert Hotel encoding ${jsonEncoded}`;
  // Don't harden since we're not done mutating it
  const result = { [QCLASS]: decodeFromCapData(original) };
  if (hasOwn(jsonEncoded, 'rest')) {
    // ... validate rest ...
    defineProperties(result, getOwnPropertyDescriptors(restObj));
  }
  return result;
}
```

§Named-comment §don't-harden-since-we're-not-done-mutating-it. §The-result-is-built-incrementally + §harden-too-early-would-prevent-defineProperties.

§Borrowable-pattern: §when-an-object-is-built-incrementally-with-defineProperties, §don't-harden-until-the-build-is-complete + §a-comment-makes-the-discipline-visible. §Otherwise-readers-might-add-harden-thinking-it's-safe.

§Sibling to cycle 219 @endo/ses-ava's §pre-lockdown-freeze-with-named-correctness-argument family — both designs §the-comment-IS-the-protocol-against-premature-hardening.

§Seven-cycles-now-using-freeze-or-don't-harden-with-named-correctness-argument: cycles 132 + 146 + 154 + 199 + 219 + 223 + 231.

## §Library-scope (the marshal-package-now-substantially-ingested across seven cycles)

| Cycle | File | Layer |
|-------|------|-------|
| 69 | encodeToSmallcaps.js | smallcaps wire format |
| 74 | marshal.js | makeMarshal constructor |
| 81 | encodePassable.js | rank-order-preserving encoder |
| 84 | rankOrder.js | in-memory rank-order regime |
| 158 | marshal-stringify.js | JSON-stringify-like surface |
| 229 | marshal-justin.js | Justin renderer (decode CapData → JS source) |
| 231 | encodeToCapData.js | CapData encoder (encode Passable → CapData) |

§Seven-marshal-files-now-ingested. §Cycle-231-completes-the-encode-decode-pair with cycle 229. §The-marshal-package-is-now-comprehensively-ingested.

## Related material in the library

- **cycle 229 marshal-justin.js**: §companion that decodes CapData to Justin source.
- **cycle 74 marshal.js**: §the-makeMarshal-constructor that wraps both encodeToCapData and decodeFromCapData.
- **cycle 69 encodeToSmallcaps.js**: §sibling-wire-format (cycle 231 is CapData; cycle 69 is smallcaps).
- **cycle 81 encodePassable.js**: §sibling-encoder for keyed-store keys.
- **cycle 217 @endo/errors**: §protocol-via-name-prefix sibling + §two-channels-for-two-audiences sibling for error-reporting tolerance.
- **cycle 219 @endo/ses-ava + cycles 132+146+154+199+223**: §freeze-or-don't-harden-with-named-correctness-argument family.
- **cycle 148 @endo/pass-style/symbol.js**: §Hilbert-Hotel-encoding sibling (first instance).
- **cycle 226 endoclaw-cluster + cycle 230 endor-npm-registry-proxy**: §strict-by-default-with-opt-in-extension siblings.
- **cycle 220 + cycle 224 + cycle 229**: §honest-acknowledgment-of-architectural-asymmetry family (cycle 231 adds the fourth member with §explicit-BEWARE-comment).
- **cycle 227 @endo/pass-style/string.js**: §three-phase-deprecation policy sibling (mirror image: cycle 227 phases in strictness; cycle 231 phases out feature).
- **cycle 228 daemon-os-sandbox-plugin**: §reference-external-tracking-as-source-of-truth-for-future-work sibling.

## §Library-reaches-737-sections at cycle 231 (chat-lane @endo/marshal/encodeToCapData).

## §Sixty-fifth consecutive designs-chat alternation cycles 166-231.

## §Three-cycles-on-protocol-via-name-prefix family

| Cycle | Source | Prefix |
|-------|--------|--------|
| 217 | @endo/errors | §`__HIDE_` for stack-trace censoring |
| 219 | @endo/ses-ava | §`MAKE_CAUSAL_CONSOLE_FROM_LOGGER_KEY_FOR_SES_AVA` registered symbol |
| 231 | @endo/marshal/encodeToCapData | §`@qclass` for wire-format discrimination |

§Three-different-applications-of-the-protocol-via-name-prefix discipline.

## §Three-instances-of-Hilbert-Hotel-encoding family

| Cycle | Source | Application |
|-------|--------|-------------|
| 148 | @endo/pass-style/symbol.js | shift well-known symbols into `@@`-prefix space |
| 229 | @endo/marshal/marshal-justin.js | decode @qclass-bearing records |
| 231 | @endo/marshal/encodeToCapData.js | encode @qclass-bearing records |

§Three-different-applications of the same naming inspiration. §Cycle-229-and-cycle-231-are-the-encode-decode-pair.

## §Four-cycles-on-honest-acknowledgment-of-architectural-asymmetry

| Cycle | Source | Shape |
|-------|--------|-------|
| 220 | familiar-localhttp-protocol | §Research-needed-section |
| 224 | daemon-web-gateway | §Caveat-emptor-disclosure |
| 229 | marshal-justin.js | §qp-eager-vs-q-lazy with named layering-constraint |
| 231 | encodeToCapData.js | §explicit-BEWARE-comment for known vulnerability + deprecation rationale |

§Four-different-rhetorical-shapes for §honest-disclosure-of-limitations.

## §Thirty-third-member of §small-files-with-large-knowledge-density family.
