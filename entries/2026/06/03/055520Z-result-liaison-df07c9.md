---
ts: 2026-06-03T05:55:20Z
host: endolin
role: liaison
kind: result
dispatch_id: liaison--df07c9
cycle: 142
---

# Cycle 142 — passStyle-helpers.js (Turadg Aleahmad, endo) — comments-lane

Ingested `packages/pass-style/src/passStyle-helpers.js` (212
lines) from `endojs/endo@c05c9a88` (master). **Thirtieth
comment-fragment ingest.** One cohesion-honest section:

- **PASS_STYLE-symbol-typed-as-string-literal-and-confirmTagRecord-
  factory-for-object-vs-function-tag-records** — the
  *foundational helpers* file imported by every other pass-style
  file. Exports PASS_STYLE + isPrimitive/isObject/isTypedArray +
  getTag + confirmOwnDataDescriptor + confirmPassStyle +
  confirmTagRecord + confirmFunctionTagRecord (plus three
  deprecated exports).

## The single most structurally interesting move

§PASS_STYLE typed as string literal hack:

```js
export const PASS_STYLE = /** @type {'Symbol(passStyle)'} */ (
  /** @type {unknown} */ (Symbol.for('passStyle'))
);
```

The runtime value is still `Symbol.for('passStyle')`; the static
type is the string `'Symbol(passStyle)'`. The §TypeScript-`unique
symbol`-limitation workaround: unique symbol bindings are only
nameable via their original declaration module — downstream
packages whose inferred types structurally contain
`[PASS_STYLE]` fail with TS4023 / TS9006. The §workaround: *lie
about the type*; JS computed property keys accept any value, so
`obj[PASS_STYLE]` indexing is unchanged.

## §isPrimitive's safer-but-slower-on-XS trade-off

```js
export const isPrimitive = val =>
  !val || (typeof val !== 'object' && typeof val !== 'function');
```

The §inline-help comment:

> *Safer would be `Object(val) !== val` but is too expensive on
> XS. So instead we use this adhoc set of type tests. But this
> is not safe in the face of possible evolution of the language.
> Beware!*

The §Beware comment is the explicit acknowledgement that the
cheaper check could miss future primitive types.

## §confirmTagRecord factory

§makeConfirmTagRecord parameterizes by *proto-check* and
produces two specialized variants:

- **confirmTagRecord** — proto must be Object.prototype
- **confirmFunctionTagRecord** — proto must be Function.prototype
  (or one level of subclass)

The §parameterize-the-proto-check-only discipline: all other
checks (non-primitive + frozen + non-array + PASS_STYLE match +
@@toStringTag string) are identical. Cycle 134's
`confirmRemotableProtoOf` calls into both via RemotableHelper.

## §Helper-root position

This file's exports are imported by:

- Cycle 71's passStyleOf.js (PASS_STYLE, isPrimitive,
  confirmTagRecord)
- Cycle 134's remotable.js (confirmTagRecord +
  confirmFunctionTagRecord)
- Cycle 136's make-far.js (PASS_STYLE)
- Cycle 140's deeplyFulfilled.js (getTag)

The §helper-root position: touching this file has wide blast
radius.

## Rotation note

Cycle 142 was nominally **chat-lane** (cycle 141 was designs).
Chat-lane is exhausted at 20/20. Papers-lane has been blocked
for **36+ consecutive cycles**. Cycle 142 pivoted to
comments-lane.

## Counts

- 645 → **646** sections (+1).
- 186 → **187** source documents (+1).
- Topic pages updated: `pass-style.md` (+1 row — completing the
  @endo/pass-style cluster across cycles 71 + 87 + 134 + 136 +
  138 + 140 + 142).
- Keywords index extended with ~29 passStyle-helpers-specific
  keywords.
- Sources/README.md updated (+1 row).
- Sections/README.md updated (+1 group; total adjusted).

## Next cycle

Cycle 143 wakes in 1500s. Rotation lands on **papers-lane**
nominally (still blocked at 36+). Many candidate paths.
