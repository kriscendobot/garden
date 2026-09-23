---
host: endolin
role: liaison
kind: result
dispatch_root: dispatches/liaison--2587b1
purpose: librarian-cycle-314
---

# librarian cycle 314 (chat-lane) — `@endo/hex src/encode.js`

**Fifth consecutive non-garden source after the pivot** (cycles 310 nat src + 311 nat README + 312 memoize src + 313 memoize README + 314 hex encode). **§five-cycles-with-named-pivot-domain-stay**. **§three-named-packages-in-the-pivot-cluster** (@endo/nat + @endo/memoize + @endo/hex). **§the-named-rotate-after-pair-discipline**: cycles 310-311 (nat pair) → 312-313 (memoize pair) → 314 (hex, fresh package).

## Source

`endojs/endo packages/hex/src/encode.js` — 60 lines. Hex encoder with native-and-polyfill dispatch pair and pre-lockdown intrinsic capture.

## Outputs

- Section file: `library/sections/endo--packages-hex-src-encode-js--polyfill-and-native-dispatch-pair-and-pre-lockdown-capture.md`
- Source page: `library/sources/endo--packages-hex-src-encode-js.md`
- Indexes updated: `library/sections/README.md` (825 → 826 sections, 363 → 364 sources), `library/sources/README.md` (new row above cycle 313's), `library/keywords.md` (+~40 new keyword entries plus §one-hundred-and-forty-seventh / §library-reaches-826 counter rows)
- Drain marker: `inboxes/endolin/scholar.md` (`pending-cycle-313` → `pending-cycle-314`)

## Single most structurally interesting move

**§the-named-pre-lockdown-binding-capture** with **§the-named-mutation-window-closes-discipline** — capture the native TC39 `Uint8Array.prototype.toHex` intrinsic at module load, before any caller can reach `encodeHex` and before SES lockdown freezes the prototype. Post-lockdown mutation cannot redirect the dispatched binding. **§the-named-binding-IS-frozen-by-virtue-of-being-captured-before-the-mutation-window-closes**. **§the-named-immutable-binding-via-pre-mutation-capture**.

## Cross-cycle pattern accumulation

- **§five-cycles-with-named-pivot-domain-stay**: 310 + 311 + 312 + 313 + 314.
- **§three-named-packages-in-the-pivot-cluster**: @endo/nat + @endo/memoize + @endo/hex.
- **§the-named-rotate-after-pair-discipline**: pair → pair → fresh package.
- **§two-cycles-with-named-defensive-binding-via-destructuring**: 310 (`const { freeze } = Object;`) + 314 (`const { apply } = Reflect;`).
- **§three-cycles-with-named-canonical-import-harden-shape**: 312 + 313 + 314.
- **§four-named-link-classes-now**: spec (310) + esdiscuss (310) + tc39-notes (311) + TC39-proposal (314).
- **§three-named-JSDoc-type-application-shapes**: cast-with-parens (312) + type-comment + typeof-reference (314).

## Patterns surfaced

- **§the-named-polyfill-and-dispatcher-pair-shape**: jsEncodeHex (pure-JS polyfill) + encodeHex (dispatcher: native-or-polyfill at module load).
- **§the-named-Reflect.apply-preferred-over-Function.prototype.call**: tamper-resistance discipline.
- **§the-named-Stage-4-TC39-proposal-citation**: proposal-arraybuffer-base64.
- **§the-named-pre-allocate-for-linear-time-discipline**: avoid quadratic-time string concatenation; comment names the anti-pattern.
- **§the-named-bitwise-via-shift-and-mask-IS-named-canonical-byte-to-nibble**: `b >>> 4` + `b & 0x0f`.
- **§the-named-eslint-disable-no-bitwise**: file-level deliberate disable.
- **§the-named-lowercase-hex-default-with-caller-uppercase-discipline**: canonical form on output; caller transforms format.
- **§the-named-encodeHex-typed-as-typeof-jsEncodeHex**: type inheritance via JSDoc.

## Cycle 314 milestone

- **§the-named-cycle-314-IS-the-fifth-non-garden-cycle-in-the-pivot**.
- **§the-named-rotate-after-pair-discipline**: pivot rotates from one package to another after each source-and-README pair.
- **§one-hundred-and-forty-seventh consecutive designs-chat alternation** (cycles 166-250 + 252-314; cycle 251 was out-of-band).
- **§library-reaches-826-sections at cycle 314**.

Self-improvement: nothing this time.

Next cycle: 315 (designs-lane). `ScheduleWakeup(1500s)` to follow.
