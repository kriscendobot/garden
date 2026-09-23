---
title: '@endo/base64: src/encode.js + src/decode.js + src/common.js + index.js'
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/base64
source_paths:
  - packages/base64/src/encode.js
  - packages/base64/src/decode.js
  - packages/base64/src/common.js
  - packages/base64/index.js
authors:
  - Kris Kowal (prompted)
ingested: 2026-06-03
ingested_by: scholar
topics:
  - hardened-javascript
  - tooling
sections:
  - endo--packages-base64-src-encode-decode-js--the-canonical-leaf-package-skeleton-with-three-tier-dispatch-and-Reflect-apply-defensive-binding.md
genre: §endo-source-comment-fragment §canonical-leaf-package-pattern
cycle: 181
lane: chat
---

# @endo/base64: the canonical leaf-package skeleton (source)

## Files

| File | Lines | Role |
|------|-------|------|
| `packages/base64/src/encode.js` | 126 | Three-tier dispatch (native → legacy XS → JS) + jsEncodeBase64 |
| `packages/base64/src/decode.js` | 165 | Three-tier dispatch + jsDecodeBase64 + polyfill-as-error-oracle |
| `packages/base64/src/common.js` | 22 | alphabet64 + padding + monodu64 lookup table |
| `packages/base64/index.js` | 14 | Re-exports + Object.freeze-not-harden rationale comment |

## §Abstract

`@endo/base64` is the §canonical-leaf-package-skeleton that
cycle 180's hex-package design cloned. The package implements
RFC 4648 § 4 base64 encoding/decoding with three-tier dispatch:

1. **Native TC39** (`Uint8Array.prototype.toBase64` / `.fromBase64`)
   when present.
2. **Legacy XS** (`globalThis.Base64.encode` / `.decode`) from
   older Moddable/XS builds (Agoric chain).
3. **Pure JS** (`jsEncodeBase64` / `jsDecodeBase64`) fallback.

Each tier-binding is established by an IIFE at module load that
returns the chosen implementation as a `const`. Native intrinsics
are captured into module-private references via `Reflect.apply`
(not `Function.prototype.call`) so that pre-lockdown tampering
cannot redirect the dispatched call.

The decoder is the cleverer half: when native throws, the
polyfill is re-run to surface a precise diagnostic embedding
the caller-supplied `name` and the failing offset. If the
polyfill doesn't also throw, the original native error
propagates (safety net).

Native options are pinned to `{ lastChunkHandling: 'strict',
alphabet: 'base64' }` — the strictest semantics matching the
polyfill, so both paths agree on which inputs are valid.

Module-level exports are `Object.freeze`-d (not `harden`-ed)
because the package loads from `@endo/init/pre.js` →
`@endo/base64/shim.js` → `./atob.js` / `./btoa.js` before SES
lockdown freezes globalThis; pulling in `@endo/harden` from the
shim path would install a fallback `harden` on the
`Object[Symbol.for('harden')]` slot before lockdown could pin
the canonical one.

## §Provenance and dependencies

- §Pre-lockdown-shim-discipline interacts with cycle 175
  `make-selector.js`'s §race-to-install-at-well-known-slot.
  Object.freeze-not-harden is the safe equivalent for shims.
- §No-imports-from-other-@endo-packages (the leaf-package
  property). §Common.js + encode.js + decode.js form a closed
  trio.
- §Spec-source: RFC 4648 § 4 (base64) and § 3.5 (padding
  semantics; cited inline as authority for the
  permissive-padding choice).
- §Native-source: TC39 proposal-arraybuffer-base64 (Stage 4
  as of 2026).
- §Legacy-XS-source: Moddable/XS `globalThis.Base64` binding
  predating the TC39 intrinsic.

## §Related sources in the library

- §Cycle 180 (`endo-but-for-bots--llm-designs-hex-package.md`)
  — the design that cloned this skeleton. §This-cycle-reads-
  the-actual-source to see what the clone preserved and what
  it simplified.
- §Cycle 175 (`endo--packages-harden-make-selector-js.md`) —
  §race-to-install-at-well-known-slot pattern interacts with
  @endo/base64's pre-lockdown shim discipline.
- §Cycle 152 (`endo--packages-pass-style-src-symbol-js.md`) —
  §module-load-runtime-probe sibling (Hilbert-Hotel encoding
  detection at module init).
- §Cycle 179 (`endo--packages-lp32-reader-writer-js.md`) —
  §module-load-detection sibling (host-endian probe).
- §Cycle 177 (`endo--packages-netstring-reader-js.md`) — §four-
  pieces-of-context-per-error sibling. base64 has §three-pieces
  (no offset for invalid-char; offset for missing-padding).
- §Cycle 167 (`endo--packages-where-index-js.md`) — §don't-
  pessimize-the-boundary sibling discipline.
- §README at `packages/base64/README.md` — ingested earlier as
  `endo--pkg-base64-readme.md`.

## §Comment fragments worth preserving

```
// Capture `Reflect.apply` once at module load; we prefer it to
// `Function.prototype.call` even where `.call` is assumed to be
// primordial, so a tampered `Function.prototype.call` cannot redirect
// the dispatched native intrinsic invocation.
```

§The-discipline-named-explicitly. §Reflect.apply-survives-tampering
that `.call` does not.

```
// Capture the native TC39 `Uint8Array.prototype.toBase64` intrinsic at
// module load, before any caller can reach `encodeBase64` and before
// SES lockdown freezes the prototype.
// Post-lockdown mutation cannot redirect the dispatched binding.
```

§Three-properties-of-module-load-capture: before-callers + before-
lockdown + post-capture-immutability.

```
// We MAY reject non-zero padding bits, but choose not to.
// https://datatracker.ietf.org/doc/html/rfc4648#section-3.5
```

§Don't-over-validate-by-default-with-RFC-citation. §Closes-the-
hole-where-a-future-contributor adds the check thinking it's a
missing security hardening.

```
// Prefer the polyfill's precise diagnostic on any native throw:
// native error messages are implementation-defined and do not
// embed `name` or report the failing offset.
// jsDecodeBase64 is expected to reject anything native rejected;
// if it does not, fall back to propagating the caught native error.
```

§Polyfill-as-error-oracle discipline. §Names-the-invariant
(polyfill rejects ⊇ native rejects) and the safety net (propagate
native if polyfill doesn't throw).

```
// If an alphabet is named for the Greek letters alpha and beta, then
// clearly a monodu is named for the corresponding Greek numbers mono
// and duo.
```

§Etymology-as-vocabulary-instruction. §Names-are-explained.
