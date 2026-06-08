---
title: "@endo/marshal/marshal-justin — §Justin-as-JavaScript-subset + §dual-indenter-strategies-with-shared-Indenter-interface + §badPairPattern-prevents-html-like-comments + §two-pass-recursion (prepare + decode) + §Hilbert-Hotel-encoding-for-records-containing-@qclass + §qp-eager-vs-q-lazy + §nested-render-with-indenter-swap + §three-named-TODO-cases-acknowledged-with-Fail"
source-slug: endo--packages-marshal-src-marshal-justin
section-id: Justin-as-JavaScript-subset-and-dual-indenter-strategies-and-badPairPattern-and-two-pass-recursion-and-Hilbert-Hotel-and-qp-eager-vs-q-lazy
url: https://github.com/endojs/endo/blob/master/packages/marshal/src/marshal-justin.js
authors: [Endo contributors]
repo: endojs/endo
path: packages/marshal/src/marshal-justin.js
total-lines: 510
status: shipping
ingest-cycle: 229
ingest-date: 2026-06-08
lane: chat
---

# @endo/marshal/marshal-justin — Render Passable as a quasi-quoted Justin expression

A 510-line file that decodes a marshal CapData encoding back to a §Justin expression — a JavaScript-syntactic subset that, when evaluated, reconstructs the original Passable. Provides the §`qp`-template-literal-tag for use with `Fail` / `X` / `quote` from @endo/errors to embed §unredacted-quasi-quoted-Justin-renderings in error messages.

## §Justin-as-a-JavaScript-subset

> Since Justin is a subset of HardenedJS, neither the name `qp` nor the rendered form need to make clear that the rendered form is in Justin rather than HardenedJS.

§Justin-is-a-subset-of-HardenedJS — §the-output-IS-valid-JavaScript + §it's-just-restricted-to-the-Passable-shapes-marshal-supports. §Borrowable-pattern: §when-you-render-a-data-format-back-to-source-code, §pick-a-syntactic-subset-of-the-host-language so the output §can-be-pasted-into-a-host-program + §evaluated-without-special-tools.

§This-is-different-from-typical-pretty-printing — §the-output-is-source-code-not-just-readable-text.

## §Dual-indenter-strategies-with-shared-Indenter-interface

```js
/**
 * @typedef {object} Indenter
 * @property {(openBracket: string) => number} open
 * @property {() => number} line
 * @property {(token: string) => number} next
 * @property {(closeBracket: string) => number} close
 * @property {() => string} done
 */
```

§Five-method-Indenter-interface implemented twice:

- **§makeYesIndenter** (66 lines) — §generous-whitespace-for-readability with §level-counter + §`'  '.repeat(level)` indentation.
- **§makeNoIndenter** (33 lines) — §minimum-whitespace-needed-to-preserve-meaning; tracks the last emitted character to decide if a separator is needed.

§Borrowable-pattern: §two-implementations-of-the-same-interface-with-different-strategies + §the-caller-picks-via-named-boolean (`shouldIndent`). §The-interface-is-the-protocol; §the-strategy-is-pluggable.

§Sibling to cycle 227 pass-style helpers' §PassStyleHelper-uniform-shape — both designs §uniform-interface-with-multiple-implementations.

## §The-`badPairPattern` regex

```js
const badPairPattern = /^(?:\w\w|<<|>>|\+\+|--|<!|->)$/;
```

§Six-named-token-pair-cases that must be separated by whitespace to preserve meaning:
1. `\w\w` — two word characters (e.g., `foo bar` not `foobar`).
2. `<<` — bitwise left shift.
3. `>>` — bitwise right shift.
4. `++` — increment.
5. `--` — decrement.
6. `<!` — would form HTML-style comment start.
7. `->` — would form HTML-style comment end.

§The-honest-comment:

> The `<!` and `->` cases prevent the accidental formation of an html-like comment. I don't think the double angle brackets are actually needed but I haven't thought about it enough to remove them.

§Borrowable-pattern: §regex-encoding-token-pairs-that-must-be-separated + §honest-comment-admitting-some-cases-might-be-unnecessary-but-haven't-been-removed. §The-comment-makes-the-uncertainty-visible.

§The-`<!`-and-`->`-cases — §JavaScript-historically-treats-`<!--`-and-`-->`-as-comment-syntax in script tags for legacy HTML compatibility. §The-renderer-must-avoid-emitting-these-token-pairs-even-by-accident.

§Borrowable-pattern: §when-emitting-source-code, §enumerate-the-token-pair-cases-that-have-special-meaning-in-the-target-language + §guard-against-accidentally-emitting-them.

## §Two-pass-recursion (prepare + decode)

```js
const prepare = rawTree => {
  // ... validation traversal ...
};

const decode = rawTree => {
  // ... emission traversal ...
};

prepare(encoding);
decode(encoding);
```

§Two-passes-over-the-same-tree:
1. **§prepare** — validates input shape; throws if invalid.
2. **§decode** — emits Justin tokens; relies on prepare having validated.

§The-honest-TODO:

> TODO now that ibids are gone, we should fold this back together into one validating pass.

§Borrowable-pattern: §two-pass-with-TODO-to-fold-back-to-one — §the-passes-are-currently-separate-for-historical-reasons + §the-design-acknowledges-they-could-be-unified. §The-history-is-visible-in-the-code-comment.

§The-comment also names the §maintenance-contract:

> Its control flow should mirror `recur` as closely as possible and the two should be maintained together. They must visit everything in the same order.

§Borrowable-pattern: §when-two-passes-must-visit-the-same-tree-in-the-same-order, §document-the-co-maintenance-constraint-in-the-source. §The-comment-IS-the-API-contract-between-the-two-functions.

§Sibling to cycle 227 PassStyleHelper's §two-phase-validation (confirmCanBeValid + assertRestValid) — same shape; different layer.

## §QCLASS-discrimination switch with §nine-named-cases

```js
switch (rawTree['@qclass']) {
  case 'undefined': /* ... */
  case 'NaN': /* ... */
  case 'Infinity': /* ... */
  case '-Infinity': /* ... */
  case 'bigint': /* ... */
  case '@@asyncIterator': /* ... */
  case 'symbol': /* ... */
  case 'tagged': /* ... */
  case 'slot': /* ... */
  case 'hilbert': /* ... */
  case 'error': /* ... */
  default: assert.fail(X`unrecognized ${q(QCLASS)} ${q(qclass)}`, TypeError);
}
```

§Eleven-named-QCLASS-cases dispatched in a switch with §unrecognized-qclass-throws-TypeError default. §Borrowable-pattern: §a-string-discriminator-keyword (the `'@qclass'` field) + §explicit-switch-cases + §default-throws.

§The `'@@asyncIterator'` case has a §TODO:

```
case '@@asyncIterator': {
  // TODO deprecated. Eventually remove.
  return out.next('Symbol.asyncIterator');
}
```

§Borrowable-pattern: §TODO-deprecated-eventually-remove + §still-handles-it-for-backward-compat. §The-renderer-doesn't-emit-the-`'@@asyncIterator'`-form-anymore + §but-it-decodes-it-when-encountered.

## §The-Hilbert-Hotel-encoding for records containing `@qclass` key

§Records-that-themselves-contain-an-`@qclass`-key are §encoded-via-the-Hilbert-Hotel-pattern:

```js
case 'hilbert': {
  const { original, rest } = rawTree;
  'original' in rawTree ||
    Fail`Invalid Hilbert Hotel encoding ${rawTree}`;
  prepare(original);
  if ('rest' in rawTree) {
    // ... validate rest is non-null non-array non-QCLASS object ...
    for (const name of names) {
      typeof name === 'string' ||
        Fail`Property name ${name} of ${rawTree} must be a string`;
      prepare(rest[name]);
    }
  }
}
```

§The-Hilbert-Hotel-encoding makes room for the special `@qclass` property by §shifting it into an `'original'` slot + §everything-else into a `'rest'` slot.

§Borrowable-pattern: §the-Hilbert-Hotel-encoding for §wire-format-keys-that-collide-with-application-data-keys. §Cycle-148-symbol.js uses the same name for symbol-encoding; §cycle-229-marshal-justin uses it for record-encoding. §Two-different-instances of the same naming inspiration.

## §Nested-render-with-indenter-swap

```js
case 'slot': {
  const { iface } = rawTree;
  const index = Number(Nat(rawTree.index));
  const nestedRender = arg => {
    const oldOut = out;
    try {
      out = makeNoIndenter();
      decode(arg);
      return out.done();
    } finally {
      out = oldOut;
    }
  };
  // ...
}
```

§Closure-captures-`out`-as-mutable-reference + §temporarily-swaps-it-to-makeNoIndenter + §try-finally-restores-it. §The-`nestedRender`-helper produces a §self-contained-no-indent-string-for-embedding inside an outer indented context.

§Borrowable-pattern: §closure-captures-mutable-state + §try-finally-swap-and-restore. §When-an-inner-rendering-needs-a-different-strategy-than-the-outer-rendering, §swap-the-state + §restore-it-in-finally.

§Sibling to cycle 132 local.js's §getMethodNames-prototype-walk discipline — both designs §closure-state-with-bounded-mutation.

## §`[__proto__]:`-bracket-notation-to-preserve-JSON-meaning

```js
if (name === '__proto__') {
  // JavaScript interprets `{__proto__: x, ...}`
  // as making an object inheriting from `x`, whereas
  // in JSON it is simply a property name. Preserve the
  // JSON meaning.
  out.next(`["__proto__"]:`);
} else if (identPattern.test(name)) {
  out.next(`${name}:`);
} else {
  out.next(`${quote(name)}:`);
}
```

§Three-cases-for-property-keys:
1. §`__proto__` — §bracket-notation to avoid JS's prototype-setting interpretation.
2. §Identifier-pattern match — §unquoted-name.
3. §Anything else — §JSON.stringify-quoted-name.

§Borrowable-pattern: §when-the-host-language-treats-a-named-property-key-specially, §emit-it-in-the-bracket-notation-to-preserve-the-intended-meaning. §The-comment-IS-the-justification.

§Sibling to cycle 227 pass-style/string.js's §don't-coerce-input — both designs §emit-the-form-that-matches-the-intended-semantics-not-the-form-that-the-host-shortest-syntax-suggests.

## §`qp` — quasi-quotes-Justin-template-literal-tag

```js
export const qp = payload => `\`${passableAsJustin(harden(payload), true)}\``;
```

§A-template-literal-tag that returns the Passable rendered as a Justin expression wrapped in backticks. §Used-with-Fail-X-quote from @endo/errors:

```js
const patt = M.and(M.gte(-100), M.lte(100));
`${qp(patt)}`
// produces:
// `makeTagged("match:and", [
//   makeTagged("match:gte", -100),
//   makeTagged("match:lte", 100),
// ])`
```

§Borrowable-pattern: §a-quasi-quote-template-literal-tag-renders-domain-values-as-evaluatable-source. §The-error-message-becomes-a-snippet-that-the-reader-can-paste-into-a-REPL.

§Sibling to cycle 217 @endo/errors' §the-Rejector-three-line-idiom — both designs §template-literals-as-the-domain-API.

## §`qp`-eager-vs-`q`-lazy comparison

```
- `q` is lazy, minimizing the cost for using it in an error that's never
  logged. Unfortunately, due to layering constraints, `qp` is not
  lazy, always rendering to quasi-quoted Justin immediately.
```

§Two-template-tags-with-two-different-laziness-policies:
- `q` (from @endo/errors): §lazy-renders-only-if-the-error-is-logged.
- `qp` (from @endo/marshal): §eager-renders-immediately-because-of-layering-constraints.

§Honest-disclosure-of-layering-constraint — §unfortunately-due-to-layering-constraints. §Borrowable-pattern: §when-the-design-can't-match-an-existing-policy + §the-reason-is-architectural, §name-the-constraint + §accept-the-asymmetry.

§Sibling to cycle 220 familiar-localhttp-protocol's §honest-disclosure-of-limitations + cycle 224 daemon-web-gateway's §Caveat-emptor-disclosure. §Three-cycles-on-honest-acknowledgment-of-architectural-asymmetry now.

## §Three-named-TODO-cases-acknowledged-with-Fail

```js
case 'error': {
  const {
    name,
    message,
    cause = undefined,
    errors = undefined,
  } = rawTree;
  cause === undefined ||
    Fail`error cause not yet implemented in marshal-justin`;
  name !== `AggregateError` ||
    Fail`AggregateError not yet implemented in marshal-justin`;
  errors === undefined ||
    Fail`error errors not yet implemented in marshal-justin`;
  return out.next(`${name}(${quote(message)})`);
}
```

§Three-named-not-yet-implemented-cases for error encoding:
1. §error-cause-not-yet-implemented.
2. §AggregateError-not-yet-implemented.
3. §error-errors-not-yet-implemented.

§Borrowable-pattern: §use-Fail-with-named-not-yet-implemented-message to §refuse-to-silently-produce-wrong-output. §The-implementation-throws-when-it-encounters-these-instead-of-silently-producing-output-that-loses-information.

§Sibling to cycle 215 @endo/hex's §native-error-rerun-polyfill (both designs §refuse-silent-degradation when the implementation can't produce correct output).

## §The-co-maintain-doc-comment-and-test-module instruction

```
// The example below is the `patt1` test case from `qp-on-pattern.test.js`.
// Please co-maintain the following doc-comment and that test module.
```

§Borrowable-pattern: §co-maintain-the-doc-comment-and-the-test-module — §the-test-IS-the-example + §the-example-IS-the-test. §If-they-diverge, §the-doc-becomes-stale.

§Sibling to cycle 217 @endo/errors' §tests-as-illustrative-examples (rejector.test.js). §Two-cycles-on-tests-as-the-documentation-pattern now.

## §slotToVal-render-when-slot-is-bound + §slot-render-when-not-bound

```js
case 'slot': {
  // ...
  if (index < slots.length) {
    const renderedSlot = nestedRender(slots[index]);
    return iface === undefined
      ? out.next(`slotToVal(${renderedSlot})`)
      : out.next(`slotToVal(${renderedSlot},${nestedRender(iface)})`);
  }
  return iface === undefined
    ? out.next(`slot(${index})`)
    : out.next(`slot(${index},${nestedRender(iface)})`);
}
```

§Four-output-shapes depending on §two-binary-conditions:
- §slot-index-is-in-the-slots-array (renders as `slotToVal(...)`) vs §slot-index-is-out-of-range (renders as `slot(N)`).
- §iface-is-defined (passes iface as second argument) vs §undefined (omits it).

§Borrowable-pattern: §the-rendered-call-shape-depends-on-the-available-context — §when-slots-are-bound-render-the-bound-form + §when-slots-are-not-bound-render-the-by-index-form.

## §The-passableAsJustin convenience

```js
export const passableAsJustin = (passable, shouldIndent = true) => {
  let slotCount = 0;
  const convertValToSlot = val => `s${slotCount++}`;
  const { toCapData } = makeMarshal(convertValToSlot);
  const { body, slots } = toCapData(passable);
  const encoded = JSON.parse(body);
  return decodeToJustin(encoded, shouldIndent, slots);
};
```

§Pipeline-of-three-stages:
1. `toCapData` — marshal the Passable to CapData with §`s0`/`s1`/`s2`-style-slot-labels.
2. `JSON.parse` — re-parse the wire body.
3. `decodeToJustin` — emit Justin.

§Borrowable-pattern: §use-the-existing-marshal-to-CapData-pipeline + §re-parse + §emit-target-syntax. §Justin-emission-is-a-downstream-of-CapData-encoding; §it-doesn't-need-to-walk-the-original-tree-itself.

## §Library-scope

§Borrowable-cluster: §the-marshal-package now substantially ingested:
- Cycle 74: marshal.js (the makeMarshal constructor).
- Cycle 69: encodeToSmallcaps.js (the smallcaps wire format).
- Cycle 81: encodePassable.js (the rank-order-preserving encoder).
- Cycle 84: rankOrder.js (the in-memory rank-order regime).
- Cycle 158: marshal-stringify.js (the JSON-stringify-like surface).
- Cycle 229: marshal-justin.js (the Justin renderer).

§Six-marshal-files-now-ingested. §Cycle-229-completes-the-cluster of marshal source files (plus encodeToCapData.js still unreferenced).

## Related material in the library

- **cycle 69 encodeToSmallcaps.js**: §the-QCLASS-encoding-vocabulary that cycle 229 decodes (parses).
- **cycle 74 marshal.js**: §the-makeMarshal-constructor that cycle 229 uses (`makeMarshal(convertValToSlot)`).
- **cycle 81 encodePassable.js**: §encoding sibling; cycle 81 encodes for keyed-store keys; cycle 229 decodes for Justin rendering.
- **cycle 84 rankOrder.js**: §the-in-memory-rank-order-regime sibling.
- **cycle 158 marshal-stringify.js**: §the-JSON-stringify-like-surface; cycle 229 is the §JavaScript-expression-source-form.
- **cycle 148 symbol.js**: §the-Hilbert-Hotel-encoding sibling — same name for two different applications (symbol encoding vs record encoding with `@qclass` collision).
- **cycle 217 @endo/errors**: §the-template-literal-tag discipline; `qp` extends the `q` family.
- **cycle 215 @endo/hex**: §refuse-silent-degradation sibling.
- **cycle 227 pass-style helpers cluster**: §uniform-interface-with-multiple-implementations sibling (Indenter has makeYesIndenter + makeNoIndenter; pass-style has PassStyleHelper instances).
- **cycle 132 local.js**: §closure-captures-mutable-state sibling.
- **cycle 220 + cycle 224**: §honest-disclosure-of-architectural-asymmetry sibling — cycle 229 adds qp-eager-vs-q-lazy.

## §Library-reaches-735-sections at cycle 229 (chat-lane @endo/marshal/marshal-justin).

## §Sixty-third consecutive designs-chat alternation cycles 166-229.

## §Three-cycles-on-honest-acknowledgment-of-architectural-asymmetry

| Cycle | Source | Asymmetry |
|-------|--------|-----------|
| 220 | familiar-localhttp-protocol | §Research-needed-section as honest acknowledgment of incomplete verification |
| 224 | daemon-web-gateway | §Caveat-emptor-disclosure for the conventional-browser mode |
| 229 | marshal-justin | §qp-eager-vs-q-lazy with named layering-constraint |

§Three-different-rhetorical-shapes for §honest-disclosure-of-limitations.

## §Two-cycles-on-tests-as-the-documentation-pattern

| Cycle | Source | Shape |
|-------|--------|-------|
| 217 | @endo/errors rejector.js | §See-rejector.test.js-for-illustrative-examples |
| 229 | marshal-justin.js | §Please-co-maintain-the-following-doc-comment-and-that-test-module |

§Two-different-rhetorical-shapes for §tests-as-the-second-half-of-documentation.

## §Thirty-second-member of §small-files-with-large-knowledge-density family.
