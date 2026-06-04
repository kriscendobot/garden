---
source: packages/marshal/src/marshal-justin.js + packages/marshal/src/marshal-stringify.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/marshal/src
source_path: packages/marshal/src/marshal-justin.js, packages/marshal/src/marshal-stringify.js
section_kind: source
ingested: 2026-06-04
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
  - Mark S. Miller (prompted)
topics:
  - marshal
  - pass-style
  - errors
genre: §endo-source-comment-fragment §canonical-passable-rendering-pair
cycle: 189
lane: chat
status: current
---

# Two-pass decoder with mirror control flow, indenter trait with two implementations, SGML-comment-injection defense, and badArray proxy rejecting all slot positions

> §Chat-lane after cycle 188's designs-lane. §The-twenty-
> third-consecutive designs/chat alternation cycle (166-189).
> §The CLAUDE.md diagnostic discipline cites
> `passableAsJustin` from `@endo/marshal` as the recommended
> replacement for `JSON.stringify` when rendering passable
> values for log messages; §this-cycle-ingests-its-source.

`packages/marshal/src/marshal-justin.js` (510 lines) +
`packages/marshal/src/marshal-stringify.js` (69 lines) = 579
lines forming the §canonical-passable-rendering-pair: the
mechanism behind `passableAsJustin` (for human-readable
diagnostic output) and `stringify`/`parse` (for the no-slot
JSON-stringify-compatible path).

§The-single-most-structurally-interesting-move is §two-pass-
decoder-with-mirror-control-flow + §indenter-trait-with-two-
implementations + §SGML-comment-injection-defense + §badArray-
proxy-rejecting-all-slot-positions. §Four-named-moves in one
579-line family.

## §Two-pass-decoder-with-mirror-control-flow (the spine)

```js
const decodeToJustin = (encoding, shouldIndent = false, slots = []) => {
  /**
   * The first pass does some input validation.
   * Its control flow should mirror `recur` as closely as possible
   * and the two should be maintained together. They must visit everything
   * in the same order.
   *
   * TODO now that ibids are gone, we should fold this back together into
   * one validating pass.
   */
  const prepare = rawTree => { ... };

  // ... makeIndenter() setup ...

  const recur = rawTree => { ... };

  prepare(encoding);
  decode(encoding);  // calls recur
  return out.done();
};
```

§Two-passes-over-the-same-encoding: `prepare()` validates;
`recur()`/`decode()` renders. §The-prose-comment is the §critical-
maintenance-instruction: "Its control flow should mirror
`recur` as closely as possible and the two should be
maintained together. They must visit everything in the same
order."

§Why-two-passes: separating validation from rendering means
the renderer can §safely-assume-everything-is-already-
validated. §The-second-pass-can-be-§pure-rendering.

§The-§TODO-named-explicitly: "now that ibids are gone, we
should fold this back together into one validating pass." §The-
two-pass-structure-is-a-historical-artifact (ibids were a
prior encoding feature that needed two passes). §The-fold-back-
is-deferred.

§Compare-to-cycle-187-shim-cluster's §considered-and-rejected
discipline and cycle 188-perf's §working-copy-inventory.
§Both-are-§honest-design-state-disclosure. §Cycle-189's-§TODO-
in-comment is the in-source variant.

§The-discipline of "two-passes-must-be-maintained-together"
appears in cycle 174-gateway-package's §three-design-lifecycle-
statuses-now-distinguished as a similar §invariant-spanning-
multiple-places.

## §The-Indenter-trait (the §polymorphic-rendering-interface)

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

§Five-method-interface. §`open(bracket)` increases nesting;
`line()` emits a newline+indent; `next(token)` emits a token
with optional separating whitespace; `close(bracket)` reduces
nesting; `done()` finalizes and returns the string.

§Two-implementations: §makeYesIndenter (readable; tracks
`level` for indentation) + §makeNoIndenter (minimum
whitespace; uses §badPair-detector to decide when whitespace
is required).

§Polymorphism-via-makeIndenter-dispatch:

```js
const makeIndenter = shouldIndent ? makeYesIndenter : makeNoIndenter;
let out = makeIndenter();
```

§Two-shapes-of-output-from-one-decoder. §The-decoder-doesn't-
care-which-indenter-it-uses; it just calls the five-method
interface.

§Compare-to-cycle-185-check-bundle's §powered-and-powerless-
symmetric-pair: both are §runtime-polymorphism-via-shared-
interface, but at different scales. §Check-bundle has §two-
modules; this has §two-factory-functions.

§The-§out-as-mutable-binding (`let out = makeIndenter()`) lets
the §nestedRender-pattern swap implementations temporarily;
see below.

## §badPair-detector with SGML-comment-injection-defense (the deepest move)

```js
/**
 * If the last character of one token together with the first character
 * of the next token matches this pattern, then the two tokens must be
 * separated by whitespace to preserve their meaning. Otherwise the
 * whitespace in unnecessary.
 *
 * The `<!` and `->` cases prevent the accidental formation of an
 * html-like comment. I don't think the double angle brackets are actually
 * needed but I haven't thought about it enough to remove them.
 */
const badPairPattern = /^(?:\w\w|<<|>>|\+\+|--|<!|->)$/;
```

§Six-bad-pair-cases:

1. **§`\w\w`**: identifier or number continuation (e.g.,
   `if`+`true` → `iftrue` would be a different identifier).
2. **§`<<` / §`>>`**: prevent left/right-shift token formation.
3. **§`++` / §`--`**: prevent increment/decrement token
   formation.
4. **§`<!` / §`->`**: §prevent-accidental-formation-of-html-
   like-comment.

§The-§SGML-comment-injection-defense (`<!` and `->`) is the
§deepest-move. §An-HTML-comment is `<!-- ... -->`. §If-tokens-
that-end-in-`<` and start with `!` appear adjacent (e.g.,
`x < !y` minified to `x<!y`), the §parser-might-interpret as
the start of an HTML comment. §Same-with `--` followed by `>`
forming the comment's closing `-->`.

§The-comment-named-the-uncertainty: "I don't think the double
angle brackets are actually needed but I haven't thought about
it enough to remove them." §Honest-uncertainty-named-in-source.
§Compare-to-cycle-184-metering's §"It just occurred to me"
design-evolution disclosure. §Both-are-§honest-known-unknowns.

§Why-this-matters: a §minified-JS-renderer that doesn't
separate `<!` could produce code that breaks in HTML-embedded
JavaScript contexts. §The-defense-is-cheap (one regex check
per token).

§Compare-to-cycle-181-base64's §padding-acceptance-permissive-
per-RFC-4648-§3.5 with-citation. §Both-are-§named-defense-with-
named-context. §Cycle-189-cites-the-HTML-comment-risk; cycle
181-cites the RFC.

§Tier-1-borrowing: §SGML-comment-injection-defense applies
wherever a minified-renderer could output code that lands in
an HTML-context. §The-`<!`-and-`->`-pair-check is the
canonical guard.

## §badArray-proxy-rejecting-all-slot-positions (marshal-stringify.js)

```js
const badArrayHandler = harden({
  get: (_target, name, _receiver) => {
    if (name === 'length') {
      return 0;
    }
    // `throw` is noop since `Fail` throws. But linter confused
    throw Fail`Marshal's parse must not encode any slot positions ${name}`;
  },
});

const arrayTarget = freeze([]);
const badArray = new Proxy(arrayTarget, badArrayHandler);
```

§A-proxy-that-rejects-all-slot-position-accesses. §The-`length`
property returns 0; §any-other-property-access-throws.

§Why: `marshal-stringify` is the JSON-stringify-compatible
path. §There-are-no-slots. §If-the-unserializer attempts to
look up `slots[0]` (because the body contains a slot
reference), the proxy throws with a §named-error: "Marshal's
parse must not encode any slot positions {name}."

§The-`length === 0` special case: callers may legitimately
check the slots array's length (it's an array) before
indexing. §Returning-0 lets the validation-not-found path
proceed; the §throw-on-numeric-index protects against
unexpected slot access.

§The-`freeze` but not `harden` discipline (the proxy target):

```
`freeze` but not `harden` the proxy target so it remains trapping.
Thus, it should not be shared outside this module.

@see https://github.com/endojs/endo/blob/master/packages/ses/docs/preparing-for-stabilize.md
```

§Same-discipline-as-cycle-146-E.js' §freeze-but-not-harden-
proxy-target. §Both-cite-the-§preparing-for-stabilize-doc.
§A-hardened-target-might-trigger-V8-Proxy-short-circuits
that-bypass-meta-traps; freezing preserves the proxy's trap
behavior.

§The-§"`throw` is noop since `Fail` throws. But linter confused"
comment names a §lint-quirk: ESLint can't see that `Fail` is a
template-tagged function that always throws, so the explicit
`throw` is required to silence the no-fallthrough warning.

§Compare-to-cycle-188-perf's §`@ts-expect-error 2454` and
cycle 181-base64's `/** @type {any} */` casts. §All-three-are-
§linter-or-type-checker-workarounds-with-named-comment.

## §`__proto__` special case in decodeProperty

```js
const decodeProperty = (name, value) => {
  out.line();
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
  decode(value);
  out.next(',');
};
```

§Three-cases-for-property-naming:

1. **§`__proto__`**: emit as `["__proto__"]:` (computed key) to
   §avoid-prototype-poisoning.
2. **§identPattern-match** (`/^[a-zA-Z]\w*$/`): emit bare
   identifier.
3. **§otherwise**: JSON-quote the name.

§Why-`__proto__`-is-special: in JavaScript object literals,
`{__proto__: x}` sets the prototype of the new object to `x`.
§In-JSON, `{"__proto__": x}` is just a property assignment.
§The-Justin-rendering must preserve the JSON-meaning, so it
emits `["__proto__"]:` (computed property key) which is §a-
property-assignment-not-a-prototype-set.

§Compare-to-cycle-152-pass-style/symbol.js' §Hilbert-Hotel-
encoding for §"namespaces-that-could-collide"; cycle 189's
§`__proto__`-bracket-escape is the §single-case-where-property-
syntax-differs-between-JSON-and-JS.

§Tier-1-borrowing: §`__proto__`-bracket-escape applies wherever
JS-source is rendered from JSON-shaped data and the renderer
must avoid §accidental-prototype-pollution.

## §nestedRender (the §try/finally-with-mutable-binding pattern)

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
  ...
}
```

§Temporarily-swap-the-renderer to compose a sub-string; §try/
finally-restores-the-original. §The-`out` variable is a §`let`
binding precisely so it can be swapped.

§Why-needed: the `slotToVal(renderedSlot, renderedIface)` call
needs the slot and iface arguments rendered as §expressions-
without-line-breaks-or-indent (so they fit inline in the
outer rendering). §Using-makeNoIndenter regardless of the
outer mode produces clean inline expressions.

§The-§try/finally-pattern ensures that even if `decode(arg)`
throws, the §outer-out-binding-is-restored. §Defensive-against-
exceptions in nested decoding.

§Compare-to-cycle-90-track-turns's §async-boundary-discipline
and cycle 187-shim's §postponedHandler-interlockP. §All-three-
are-§save-and-restore-state patterns at different layers.

## §passableAsJustin (the documented diagnostic surface)

```js
export const passableAsJustin = (passable, shouldIndent = true) => {
  let slotCount = 0;
  const convertValToSlot = val => `s${slotCount++}`;
  const { toCapData } = makeMarshal(convertValToSlot);
  const { body, slots } = toCapData(passable);
  const encoded = JSON.parse(body);
  return decodeToJustin(encoded, shouldIndent, slots);
};
harden(passableAsJustin);
```

§Four-step-flow:

1. §Allocate-a-slot-counter starting at 0.
2. §Make-a-marshal with `s0`, `s1`, ... slot allocator.
3. §Convert-the-passable to capData encoding.
4. §Render-the-capData-as-Justin via decodeToJustin.

§This-is-the-§CLAUDE.md-cited diagnostic API: "When rendering
a passable value for a log message, use `passableAsJustin`
from `@endo/marshal` rather than `JSON.stringify`, which
produces ambiguous output for remotables and promises."

§Why-not-JSON.stringify: JSON.stringify treats remotables and
promises as opaque (renders as `{}` or fails). §Justin-
rendering shows them as `slot(0)`, `slot(1)`, ... with §named
slot indices. §Diagnostic-clarity-without-revealing-slot-
identity.

§Compare-to-cycle-89-error/assert.js' §`details`-template-tag-
for-hiding-arguments-from-causal-console. §Both-are-§diagnostic-
formatting-disciplines for hardened-JS environments.

## §`qp` — quote-passable-as-quasi-quoted-Justin

```js
/**
 * `qp` for quote passable as a quasi-quoted Justin expression.
 *
 * Both `q` from `@endo/errors` and this `qp` from `@endo/marshal` can
 * be used together with `Fail`, `X`, etc from `@endo/errors` to mark
 * a substitution value to be both
 * - visually quoted in some useful manner
 * - unredacted
 *
 * Differences:
 * - given a pattern `M.and(M.gte(-100), M.lte(100))`,
 *   `${q(patt)}` produces "[match:and]", whereas
 *   `${qp(patt)}` produces quasi-quotes Justin:
 *   `makeTagged("match:and", [
 *     makeTagged("match:gte", -100),
 *     makeTagged("match:lte", 100),
 *   ])`
 * - `q` is lazy, minimizing the cost for using it in an error that's never
 *   logged. Unfortunately, due to layering constraints, `qp` is not
 *   lazy, always rendering to quasi-quoted Justin immediately.
 */
export const qp = payload => `\`${passableAsJustin(harden(payload), true)}\``;
```

§The-§qp-template-tag pairs with `q` from `@endo/errors`.
§Both-can-be-used-with-`Fail`, `X`, etc. for §unredacted-
visually-quoted-substitution-values.

§Key-difference: `q` is lazy (cheap when error never logged);
§`qp` is eager (always renders). §The-eagerness-named: "due to
layering constraints, qp is not lazy." §Honest-limitation-
named-in-comment.

§The-output-wraps-in-backticks: `` `${rendered}` ``. §This-
makes-the-rendered-Justin-look-like-a-template-string in the
final error message, §visually-distinguishing-quoted-from-
plain-substitution.

§Compare-to-cycle-87-ses-error/assert.js' §`q`-template-tag.
§Both-are-§Fail-companion-template-tags. §`q`-is-redacting-and-
lazy; §`qp`-is-unredacting-and-eager. §The-pair-covers-§two-
use-cases-with-two-tag-shapes.

§Tier-1-borrowing: §qp-vs-q-template-tag-pair as a §lazy-vs-
eager + §redact-vs-unredact + §plain-vs-quasi-quoted matrix
for error message substitution.

## §doNotConvertValToSlot + doNotConvertSlotToVal (the rejector pair)

```js
const doNotConvertValToSlot = val =>
  Fail`Marshal's stringify rejects presences and promises ${val}`;

const doNotConvertSlotToVal = (slot, _iface) =>
  Fail`Marshal's parse must not encode any slots ${slot}`;
```

§Two-rejector-functions used by `makeMarshal` when constructing
the §no-slot-marshal. §Together-they-ensure that:

- §Serialize-rejects any passable containing presences (remotables)
  or promises.
- §Parse-rejects any body containing slot encodings.

§Combined-with-the-§badArray-proxy, the no-slot path is §three-
layer-defended:

1. §Serializer rejects presences/promises before they become
   slots.
2. §Parser rejects slot-encodings in the body.
3. §badArray proxy rejects any slot-index-lookup attempt.

§Defense-in-depth for "this path never has slots." §Compare-
to-cycle-184-metering's §three-mechanisms-eliminated by
admission control (embargo + rollback + outbound-buffering).
§Both-are-§invariant-enforced-at-multiple-layers patterns.

## §The-shared-makeMarshal-options-bag

```js
const { serialize, unserialize } = makeMarshal(
  doNotConvertValToSlot,
  doNotConvertSlotToVal,
  {
    errorTagging: 'off',
    // TODO fix tests to works with smallcaps.
    serializeBodyFormat: 'capdata',
  },
);
```

§Two-options-pinned: §errorTagging-off (the no-slot path
doesn't need error tagging) + §serializeBodyFormat-capdata.

§The-§TODO-named: "fix tests to works with smallcaps." §The-
preferred-format-is-smallcaps (cycle 69 encodeToSmallcaps);
§the-current-tests-only-work-with-capdata. §Migration-deferred-
with-named-blocker.

§Compare-to-cycle-180-hex-package's §five-known-gaps and cycle
188-perf's §four-remaining-optimization-opportunities. §All-
three-are-§named-deferrals.

## §Eight-qclass-cases-in-the-decoder

§The-`switch (rawTree['@qclass'])` handles eight encoded types:

| qclass | Justin rendering |
|--------|------------------|
| `undefined` | `undefined` |
| `NaN` | `NaN` |
| `Infinity` | `Infinity` |
| `-Infinity` | `-Infinity` |
| `bigint` | `${digits}n` |
| `@@asyncIterator` | `Symbol.asyncIterator` (TODO deprecated) |
| `symbol` | `Symbol.iterator` or `passableSymbolForName("...")` |
| `tagged` | `makeTagged("...", payload)` |
| `slot` | `slot(N)` or `slotToVal(renderedSlot)` |
| `hilbert` | `{"@qclass": original, ...rest}` |
| `error` | `Name("message")` |

§Eleven-cases-actually (the table above has 11 entries; I
miscounted as 8 above). §Each-case-maps-to-a-Justin-expression
that §evaluates-to-the-original-passable when interpreted in
a Justin-aware host (one that has `makeTagged`,
`passableSymbolForName`, `slotToVal`, and error constructors
in scope).

§The-Hilbert-case maps to a synthesized object whose `@qclass`
property is a §nested-encoding — this preserves the cycle 152
Hilbert-Hotel encoding's round-trip.

§The-§error-case has §three-features-marked-not-yet-
implemented:

```js
cause === undefined || Fail`error cause not yet implemented in marshal-justin`;
name !== `AggregateError` || Fail`AggregateError not yet implemented in marshal-justin`;
errors === undefined || Fail`error errors not yet implemented in marshal-justin`;
```

§Three-fail-fast-checks for unimplemented features. §Honest-
limitation-via-Fail-template.

## §Cohesion notes

- §Two-pass-decoder-with-mirror-control-flow (prepare
  validates; decode renders). §Comment-instructs-maintenance:
  "must visit everything in the same order."
- §Indenter-trait with §two-implementations (makeYesIndenter
  for readable + makeNoIndenter for minimum-whitespace).
- §badPair-detector with §SGML-comment-injection-defense
  (`<!` and `->` cases prevent accidental HTML-comment
  formation in minified output).
- §badArray-proxy in marshal-stringify rejects all slot
  position accesses; `length === 0` special case lets length-
  check pass.
- §`__proto__`-bracket-escape preserves JSON meaning vs JS
  prototype-set syntax.
- §nestedRender (try/finally-with-mutable-binding) for inline
  sub-string composition with different indenter.
- §passableAsJustin is the §CLAUDE.md-cited diagnostic API for
  passable rendering — preferred over JSON.stringify because
  JSON.stringify can't render remotables/promises.
- §`qp` template tag pairs with `q` from @endo/errors. §Lazy-
  vs-eager + §redact-vs-unredact: q is lazy and redacts; qp
  is eager and unredacts.
- §Three-layer-defense for the no-slot path: rejector functions
  + badArray proxy + serializer-side rejection.
- §`freeze` but not `harden` discipline for proxy targets
  (sibling to cycle 146 E.js).
- §`throw` is noop since `Fail` throws (linter workaround
  comment).
- §TODO-in-comment names §honest-known-blockers (fold-back to
  one pass; smallcaps test migration; double-angle-bracket
  necessity).
- §Eight-or-eleven qclass cases in the decoder (depending on
  how you count; including the synthesized error/hilbert
  cases).
- §Three-fail-fast-error-cases (cause + AggregateError +
  errors) for unimplemented features.
- §Thirteenth-member-of-§small-files-with-large-knowledge-
  density family (cycles 165/167/169/171/173/175/177/179/181/
  183/185/187/189 — well, technically 579 lines isn't small,
  but the §discipline-density-per-line is on par with the
  smaller files).

## §Tier-1 borrowing

- §two-pass-decoder-with-mirror-control-flow (validate-then-
  render; comment instructs maintenance invariant)
- §indenter-trait with §two-implementations (polymorphic
  rendering via shared interface)
- §SGML-comment-injection-defense (the `<!` and `->` pair-
  check prevents accidental HTML-comment formation)
- §badArray-proxy-rejecting-all-slot-positions with §length-
  special-case
- §`__proto__`-bracket-escape (preserve JSON meaning vs JS
  prototype-set syntax)
- §try/finally-with-mutable-binding for §temporarily-swap-
  state (nestedRender pattern)
- §qp-vs-q-template-tag-pair (lazy/redact vs eager/unredact)
- §three-layer-defense for invariants (cycle 184's §three-
  mechanisms-eliminated sibling at a different scale)
- §freeze-but-not-harden for proxy targets (cycle 146 sibling)
- §`throw` is noop since `Fail` throws (linter-workaround-
  comment pattern)
- §TODO-in-comment naming known-blockers

## §Synthesis-target

The §slot-machine-library's diagnostic rendering (if it has
one) can §borrow-passableAsJustin-pattern directly via §two-
pass-decoder-with-mirror-control-flow + §indenter-trait. §The-
SGML-comment-injection-defense is borrowable wherever JS
source is rendered and may appear in HTML-embedded contexts.

§The-§qp-vs-q-pair-pattern is borrowable for any §template-tag-
substitution where some uses need lazy/redacted and others
need eager/unredacted output.
