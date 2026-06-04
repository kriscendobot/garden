---
source: packages/base64/src/{encode,decode,common}.js + index.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/base64
source_path: packages/base64/src/encode.js, packages/base64/src/decode.js, packages/base64/src/common.js, packages/base64/index.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - hardened-javascript
  - tooling
genre: §endo-source-comment-fragment §canonical-leaf-package-pattern
cycle: 181
lane: chat
status: current
---

# The canonical leaf-package skeleton with three-tier dispatch, Reflect.apply defensive binding, and native-error fallback via polyfill rerun

> §Chat-lane after cycle 180's designs-lane. §Endo-source-
> comment-fragment genre. §The-fifteenth-consecutive designs/
> chat alternation cycle (166-181). §Cycle-180's hex-package
> design named `@endo/base64` as the §canonical-leaf-package-
> skeleton; §this-cycle-reads-the-actual-source to see what
> *makes* it canonical.

`packages/base64/src/encode.js` (126 lines) + `decode.js` (165
lines) + `common.js` (22 lines) + `index.js` (14 lines) =
327 lines. §The-package-that-`@endo/hex`-cloned-file-for-file.
§This-cycle's-ingest-reveals-which-disciplines-the-clone-
preserved and which it §simplified-because-hex-doesn't-need-
them.

§The-single-most-structurally-interesting-move is §three-tier-
dispatch-with-Reflect.apply-defensive-binding combined with
§native-error-fallback-via-polyfill-rerun (decoder side). §The-
hex-package-clone-omits-the-middle-tier (no legacy XS hex
binding exists) and §uses-error-rewrapping-instead-of-polyfill-
rerun for stable diagnostics.

## §Three-tier-dispatch (the spine)

```js
export const encodeBase64 = (() => {
  if (nativeToBase64 !== undefined) return nativeEncodeBase64;
  if (xsEncodeBase64 !== undefined) return xsEncodeBase64;
  return jsEncodeBase64;
})();
Object.freeze(encodeBase64);
```

§Three-tier-priority-IIFE-bound-at-module-load:

1. **§Tier-1 — TC39 native** (`Uint8Array.prototype.toBase64`)
   when present.
2. **§Tier-2 — legacy XS native** (`globalThis.Base64.encode`)
   from older Moddable/XS builds (Agoric chain).
3. **§Tier-3 — pure-JS fallback** (`jsEncodeBase64`).

§The-IIFE-returns-the-chosen-implementation-bound-to-a-const.
§Module-load-time-decision. §No-runtime-branching-per-call.
§Compare-to-cycle-180-hex-package-design's-§two-tier-dispatch
(only native + JS); hex omits the §legacy-XS-tier because no
legacy XS hex binding exists.

§The-decoder-mirrors-the-encoder's-three-tier-structure:

```js
export const decodeBase64 = (() => {
  if (nativeFromBase64 !== undefined) return nativeDecodeBase64;
  if (xsDecodeBase64 !== undefined) return xsDecodeBase64;
  return jsDecodeBase64;
})();
Object.freeze(decodeBase64);
```

§Symmetric-pattern. §IIFE-returns-bound-const. §Object.freeze-
on-the-final-export.

## §Reflect.apply-captured-at-module-load (the defensive binding)

```js
// Capture `Reflect.apply` once at module load; we prefer it to
// `Function.prototype.call` even where `.call` is assumed to be
// primordial, so a tampered `Function.prototype.call` cannot redirect
// the dispatched native intrinsic invocation.
const { apply } = Reflect;
```

§The-comment-justifies-the-discipline-explicitly. §Even-though-
`.call`-is-assumed-primordial (SES will freeze it), the captured
`Reflect.apply` survives any pre-lockdown tampering of
`Function.prototype.call`.

§Compare-to-cycle-180-hex-package's `nativeToHex.call(bytes)`
which uses `.call` directly. §This-is-a-deliberate-simplification
in the hex clone — §the-three-files-omitted (atob.js / btoa.js /
shim.js) were §deliberate-omission-not-oversight, but the
§use-of-`.call`-vs-`Reflect.apply` is §a-different-defensive-
stance that the hex design did not call out as a deviation.

§Native-dispatch-via-Reflect.apply:

```js
const nativeEncodeBase64 = data =>
  apply(
    /** @type {typeof Uint8Array.prototype.toBase64} */ (nativeToBase64),
    data,
    [],
  );
```

§Three-argument-apply: function reference + thisArg + args
array. §The-`data`-is-the-thisArg because `toBase64` is a
prototype method invoked on the Uint8Array; the args array is
empty.

§Compare-to-the-xs-tier:

```js
const xsEncodeBase64 = data => apply(encode, undefined, [data]);
```

§Different-thisArg-and-args-shape because legacy XS
`globalThis.Base64.encode` is a static function (no `this`),
taking the bytes as an argument.

§Same-Reflect.apply-discipline-across-both-tiers. §The-discipline-
is §all-native-paths-go-through-captured-Reflect.apply.

## §Native-intrinsic-captured-once-at-module-load

```js
// Capture the native TC39 `Uint8Array.prototype.toBase64` intrinsic at
// module load, before any caller can reach `encodeBase64` and before
// SES lockdown freezes the prototype.
// Post-lockdown mutation cannot redirect the dispatched binding.
const nativeToBase64 = /** @type {any} */ (Uint8Array.prototype).toBase64;
```

§The-comment-names-three-properties-of-the-discipline:

1. **§Before-any-caller-can-reach-encodeBase64** — capture
   before consumers can observe a tampered state.
2. **§Before-SES-lockdown-freezes-the-prototype** — capture
   while the prototype is still mutable (so the captured value
   is the *real* native method, not a SES tamed version).
3. **§Post-lockdown-mutation-cannot-redirect-the-dispatched-
   binding** — the const reference is immutable after capture.

§The-three-properties-form-the-§module-load-detection-window
discipline. §Cycle-180-hex-package-named-this as §native-
fallthrough-detection-bound-once-at-module-load; §reading-this-
source shows the exact pattern.

## §nativeFromBase64Options-pinned-to-strictest-semantics (decoder)

```js
const nativeFromBase64Options = Object.freeze({
  lastChunkHandling: 'strict',
  alphabet: 'base64',
});
```

§Two-options-pinned:

- **`lastChunkHandling: 'strict'`** — rejects unpadded / short
  final chunks. §Comment: "The proposal default `'loose'` would
  silently accept them."
- **`alphabet: 'base64'`** — rejects URL-safe characters (`-_`).
  §Comment: "pins forward compatibility against any future spec
  drift."

§Strict-by-default-discipline. §The-jsDecodeBase64-polyfill
implements RFC 4648 § 4 base64 strictly; the native-dispatch
options pin the same strictness so the two paths agree on which
inputs are valid.

§The-options-object-is-Object.frozen — the dispatched native
call cannot accidentally observe a mutated options bag.

§Cycle-180-hex-has-no-options-bag (TC39 `Uint8Array.fromHex` is
case-insensitive and the encoder is fixed-lowercase); §the-
options-pinning-discipline-does-not-port-to-hex because there's
no equivalent option to pin. §This-is-a-§clean-clone-because-
the-platform-already-pinned-the-semantics.

## §Native-error-fallback-via-polyfill-rerun (the decoder's clever move)

```js
const nativeDecodeBase64 = (string, name) => {
  try {
    return apply(
      /** @type {typeof Uint8Array.fromBase64} */ (nativeFromBase64),
      Uint8Array,
      [string, nativeFromBase64Options],
    );
  } catch (err) {
    // Prefer the polyfill's precise diagnostic on any native throw:
    // native error messages are implementation-defined and do not
    // embed `name` or report the failing offset.
    // jsDecodeBase64 is expected to reject anything native rejected;
    // if it does not, fall back to propagating the caught native error.
    jsDecodeBase64(string, name);
    throw err;
  }
};
```

§This-is-different-from-cycle-180-hex-package's-§error-
rewrapping. §Hex-rewraps-the-native-error-message:

```js
// (hex)
} catch (e) {
  throw Error(`Invalid hex in string ${name}: ${e.message}`);
}
```

§Base64-instead-re-runs-the-polyfill-to-get-a-better-diagnostic:

1. §Native-throws — caught.
2. §Run-jsDecodeBase64(string, name) — expected to also throw,
   with a §precise-diagnostic embedding `name` and the failing
   offset.
3. §If-polyfill-throws — that exception propagates (the polyfill's
   error, not the native's).
4. §If-polyfill-doesn't-throw (the safety net) — propagate the
   caught native error so we don't silently succeed.

§The-design-is §use-polyfill-as-error-oracle: the JS path knows
how to produce a useful error message; the native path is faster
but its error messages are implementation-defined. §So-call-
both-on-the-error-path.

§Why-doesn't-hex-do-this? §The-native-Uint8Array.fromHex throws
`SyntaxError` consistently across engines and the polyfill's
extra diagnostic value is smaller (hex has no padding semantics
to disagree on). §Cycle-180-hex-package's Design Decision 6
named the §error-rewrapping cost (try/catch + allocation) vs
benefit (stable contract); base64 makes a different cost/benefit
trade — it pays §two-decode-runs-on-the-error-path for the
§best-possible-diagnostic.

§Both-are-valid §native-vs-polyfill-error-shape-discipline; the
choice depends on what the polyfill knows that the native
doesn't.

## §adaptDecoder-for-legacy-XS-ArrayBuffer-return

```js
// The legacy XS `Base64.decode` may return ArrayBuffer (not
// Uint8Array); adapt it.
const adaptDecoder =
  nativeDecoder =>
  (...args) => {
    const decoded = nativeDecoder(...args);
    if (decoded instanceof Uint8Array) {
      return decoded;
    }
    return new Uint8Array(decoded);
  };
```

§Adapter-curried-once: `adaptDecoder` takes a `nativeDecoder`
and returns a wrapper that normalizes the result to
`Uint8Array`.

§Why-needed: older Moddable/XS builds returned `ArrayBuffer`
from `globalThis.Base64.decode`. §The-jsDecodeBase64-polyfill
returns `Uint8Array`. §The-three-tier-dispatch returns one of
{native | xs | js}; §callers-expect-a-Uint8Array-uniformly.

§The-adapter-runs-only-on-the-XS-tier:

```js
const xsDecodeBase64 =
  globalThis.Base64 !== undefined
    ? adaptDecoder(globalThis.Base64.decode)
    : undefined;
```

§Conditional-wrap. §Native-and-JS-tiers-need-no-adaptation
because both return Uint8Array natively. §Defensive-shape-
normalization-at-the-legacy-XS-boundary.

§Cycle-180-hex-has-no-adaptDecoder because it has no legacy XS
tier. §This-is-§another-discipline-the-hex-clone-omits-because-
the-platform-doesn't-need-it.

## §Bit-register-quantum-accumulator (the JS fallback algorithm)

```js
export const jsEncodeBase64 = data => {
  let string = '';
  let register = 0;
  let quantum = 0;

  for (let i = 0; i < data.length; i += 1) {
    const b = data[i];
    register = (register << 8) | b;
    quantum += 8;
    if (quantum === 24) {
      string +=
        alphabet64[(register >>> 18) & 0x3f] +
        alphabet64[(register >>> 12) & 0x3f] +
        alphabet64[(register >>> 6) & 0x3f] +
        alphabet64[(register >>> 0) & 0x3f];
      register = 0;
      quantum = 0;
    }
  }
```

§Two-variable-state-machine: `register` (32-bit accumulator) +
`quantum` (bits accumulated, 0–24).

§The-algorithm-per-byte: shift 8 bits in from the right; when
quantum reaches 24 (= 3 bytes = 4 base64 chars), emit four
6-bit slices and reset.

§Bit-arithmetic: `(register >>> 18) & 0x3f` extracts the
topmost 6 bits as a 0–63 index into `alphabet64`.

§Compare-to-cycle-180-hex-package's-§byte-wise-nibble-lookup:

```js
// (hex)
const b = bytes[i];
string += alphabet[b >>> 4] + alphabet[b & 0x0f];
```

§Hex-has-no-bit-accumulator-because byte boundaries align with
character boundaries (1 byte = 2 hex chars = 8 bits). §Base64-
needs-one-because 1 base64 char = 6 bits, not aligned with bytes.

§The-comment-explains-the-string-concatenation-choice:

```js
// A cursory benchmark shows that string concatenation is about 25% faster
// than building an array and joining it in v8, in 2020, for strings of about
// 100 long.
```

§Benchmarked-decision-not-style-preference. §Cycle-180-hex
uses the same string-concatenation idiom; §the-discipline-
ported-cleanly.

## §Three-class-padding-switch (end of encode)

```js
switch (quantum) {
  case 0:
    break;
  case 8:
    string +=
      alphabet64[(register >>> 2) & 0x3f] +
      alphabet64[(register << 4) & 0x3f] +
      padding +
      padding;
    break;
  case 16:
    string +=
      alphabet64[(register >>> 10) & 0x3f] +
      alphabet64[(register >>> 4) & 0x3f] +
      alphabet64[(register << 2) & 0x3f] +
      padding;
    break;
  default:
    throw Error(`internal: bad quantum ${quantum}`);
}
```

§Three-cases corresponding to the three possible remainders
(0, 1, 2 bytes = 0, 8, 16 bits remaining).

- **§Quantum-0** — no remainder, no padding.
- **§Quantum-8** — 1 byte left; emit 2 base64 chars + 2 `=`
  padding chars.
- **§Quantum-16** — 2 bytes left; emit 3 base64 chars + 1 `=`
  padding char.
- **§Default-internal-bad-quantum** — defensive throw; should be
  unreachable because `quantum` only takes values 0/8/16/24
  through the loop.

§The-§internal-bad-quantum-throw is §sanity-check-for-invariant-
holds. §Compare-to-cycle-178-daemon-xs-worker-snapshot's
§sanity-check-for-the-invariant pattern.

## §Padding-acceptance-permissive (decoder choice)

```js
while (quantum > 0) {
  if (i === string.length || string[i] !== padding) {
    throw Error(`Missing padding at offset ${i} of string ${name}`);
  }
  // We MAY reject non-zero padding bits, but choose not to.
  // https://datatracker.ietf.org/doc/html/rfc4648#section-3.5
  i += 1;
  quantum -= 2;
}
```

§The-comment-cites-RFC-4648-§3.5: implementations MAY reject
non-zero padding bits. §This-impl-chooses-not-to-reject.

§Why-name-the-choice: an LLM reader or new contributor might
otherwise add the check as a "missing security hardening". §The-
inline-comment-with-RFC-citation closes that hole — §reject-or-
accept-is-the-RFC's-choice, not ours, and the choice is named in
the source.

§Cycle-89-error/assert.js had a §§don't-let-error-paths-reveal-
too-much sibling discipline; §base64-decoder-here-has-§don't-
over-validate-by-default with the citation as justification.

## §Three-class-decode-error (trailing garbage / missing padding / invalid char)

```js
// Invalid char (in main loop):
if (number === undefined) {
  throw Error(`Invalid base64 character ${string[i]} in string ${name}`);
}

// Missing padding:
throw Error(`Missing padding at offset ${i} of string ${name}`);

// Trailing garbage:
throw Error(
  `Base64 string has trailing garbage ${string.substr(i)} in string ${name}`,
);
```

§Three-distinct-error-shapes for three failure modes. §All-
embed-`name` for caller-context. §Compare-to-cycle-177-netstring/
reader.js' §four-pieces-of-context-per-error.

§Cycle-180-hex-package's §error-rewrapping-at-the-native-
boundary tries to preserve this shape when delegating to native
TC39 `fromHex`. §Base64-instead-uses-the-§polyfill-rerun
approach to get this exact shape from the polyfill itself.

## §Object.freeze-not-harden (the index.js discipline)

```js
// (index.js comment)
// Re-exports the package's named bindings.  Each source module
// (`./src/encode.js`, `./src/decode.js`, `./atob.js`, `./btoa.js`)
// applies `Object.freeze` to its export at module-evaluation time, so
// the bindings are hardened on both the public path through this
// module and on the pre-lockdown shim path that `@endo/init/pre.js`
// uses (`@endo/base64/shim.js` -> `./atob.js` / `./btoa.js`).  Using
// `Object.freeze` rather than `@endo/harden` keeps the shim path free
// of any module that would install a fallback `harden` before SES
// `lockdown()` freezes the well-known properties of `globalThis`.
```

§This-is-the-§canonical-design-choice that cycle 180 hex-package
did NOT explicitly name. §Why-Object.freeze-instead-of-harden:

- §`@endo/base64`-loads-pre-lockdown via `@endo/init/pre.js` →
  `@endo/base64/shim.js` → `./atob.js` / `./btoa.js`.
- §If-the-shim-path-imported-`@endo/harden`, it would install a
  fallback `harden` before SES lockdown freezes globalThis.
- §That-fallback-install would be on the §race-to-install-at-
  well-known-slot path (cycle 175 make-selector.js) and would
  fire before lockdown could pin the canonical `harden`.
- §Object.freeze-is-primordial-and-doesn't-touch-globalThis,
  so it's safe to call from a pre-lockdown shim.

§This-is-§pre-lockdown-shim-discipline that cycle 175's race-
to-install-harden mechanism interacts with. §Object.freeze-at-
module-init-is-§the-safe-equivalent-of-harden-for-pre-lockdown-
shims.

§Cycle-180-hex-package omits `atob.js` / `btoa.js` / `shim.js`,
so hex doesn't need to participate in the pre-lockdown shim
path; §but-it-still-uses-Object.freeze-on-its-exports (per the
SES considerations in its design) to match @endo/base64's
discipline for consistency.

## §common.js — monodu64 + alphabet64 + padding

```js
const { freeze } = Object;

export const padding = '=';

export const alphabet64 =
  'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

export const monodu64 = {};
for (let i = 0; i < alphabet64.length; i += 1) {
  const c = alphabet64[i];
  monodu64[c] = i;
}
freeze(monodu64);
```

§The-naming-comment explains `monodu64`:

> If an alphabet is named for the Greek letters alpha and beta,
> then clearly a monodu is named for the corresponding Greek
> numbers mono and duo.

§Etymology-as-comment. §The-name-monodu evokes §alphabet-of-
numerals; §the-table-maps-character-to-its-numeric-value (the
inverse of `alphabet64`).

§Module-load-time-construction: the for-loop populates `monodu64`
once at import; §`freeze`-pins-the-table after construction.

§Compare-to-cycle-180-hex-package's-§module-load-time-alphabet-
constant pattern with `hexAlphabetLower` / `hexAlphabetUpper`
— hex doesn't need the reverse table because hex digits can be
decoded by formula (`hexDigitValue(charCode)`); §base64-needs-a-
lookup-table because the alphabet is non-contiguous (`A-Z` then
`a-z` then `0-9` then `+/`).

§Same-discipline-different-implementation: both freeze constants
at module-init.

## §Cohesion notes

- §The-canonical-leaf-package-skeleton revealed: three-tier
  dispatch (native → legacy XS → JS), Reflect.apply defensive
  binding, native intrinsic captured before lockdown,
  Object.freeze-not-harden for pre-lockdown shim safety,
  alphabet+monodu lookup tables frozen at module init.
- §Cycle-180-hex-package-design-cloned-this-skeleton but
  simplified at three points: (1) no legacy XS tier; (2) no
  options-bag (TC39 fromHex has no equivalent); (3)
  error-rewrapping instead of polyfill-rerun.
- §Two-disciplines-the-hex-clone-could-have-borrowed but did
  not explicitly: (1) §Reflect.apply-captured-once-at-module-
  load (hex uses `.call` directly); (2) §pre-lockdown-shim-
  Object.freeze-discipline (hex follows it by convention, not
  by named decision).
- §The-native-error-fallback-via-polyfill-rerun in the decoder
  is the §single-cleverest-move: §use-polyfill-as-error-oracle.
  Different cost/benefit trade than hex's §error-rewrapping.
- §The-padding-acceptance-RFC-citation is §don't-over-validate-
  by-default-with-the-RFC-as-source-of-authority — closes the
  hole where a future contributor would add the check thinking
  it was a missing security hardening.
- §monodu-etymology is §code-comment-as-vocabulary-instruction
  — names are explained for future readers.
- §Bit-register-quantum-accumulator is the §canonical-non-byte-
  aligned-encoding-algorithm; §hex-was-byte-aligned so the hex
  clone simplified to nibble lookup.

## §Tier-1 borrowing

- §three-tier-dispatch-with-IIFE-bound-at-module-load (native →
  legacy → fallback)
- §Reflect.apply-captured-at-module-load (defensive against
  Function.prototype.call tampering)
- §native-intrinsic-captured-before-lockdown
- §strict-options-pinning-via-frozen-bag (lastChunkHandling +
  alphabet)
- §native-error-fallback-via-polyfill-rerun (use polyfill as
  error oracle)
- §adapter-for-legacy-platform-shape-normalization (legacy XS
  ArrayBuffer → Uint8Array)
- §bit-register-quantum-accumulator (non-byte-aligned codec
  algorithm)
- §three-class-padding-switch with §internal-bad-quantum
  sanity-throw
- §padding-acceptance-RFC-citation (§don't-over-validate-by-
  default-with-named-authority)
- §three-class-decode-error-shapes (invalid char / missing
  padding / trailing garbage; all embed `name`)
- §Object.freeze-not-harden-for-pre-lockdown-shim-safety
- §monodu-etymology-as-comment (§code-comment-as-vocabulary-
  instruction)

## §Synthesis-target

The §slot-machine-library's leaf utility packages (when
extracted from monolith) can §reuse-the-three-tier-dispatch
pattern if any of them have a native-platform-binding to
delegate to. §The-§polyfill-as-error-oracle-discipline applies
wherever a native intrinsic exists alongside a polyfill — the
polyfill knows what makes a good error message; the native
doesn't.
