PR head matches my pushed commit. Work complete.

## Completion report

**Directive** (erights, endojs/endo-but-for-bots#475, comment 5347486117): the `passStyleOf` mutable-typed-array diagnostic also fires with a "mutable" message for a *frozen* non-`Uint8Array` typed array over an *immutable* buffer — "an error message complaining about mutability when mutability is not the problem is bad devex." Fix or verify already fixed.

**Preflight** returned exit 2 (a hint). I corroborated and found it was **not** already fixed: the branch HEAD still emitted `Cannot pass mutable typed arrays` at the fall-through guard (`passStyleOf.js:202`). No commit or reply resolved the message wording, so I proceeded.

**Root cause.** `passStyleOf`'s late guard catches a genuine `TypedArray` that no helper claimed (avoiding a confusing remotable `non-methods` error). It's reachable when the early `isFrozen` gate is bypassed — on a native Immutable-ArrayBuffer engine (XS) for a genuine frozen typed array over an immutable buffer, and on the Node shim leg under `LOCKDOWN_HARDEN_TAMING=unsafe`. It unconditionally blamed mutability, which is false for an immutable-backed typed array.

**Fix** (`packages/pass-style/src/passStyleOf.js`): discriminate at the guard on `instanceof Uint8Array`. A `Uint8Array` only reaches the guard backed by a *mutable* buffer (immutable-backed ones are always claimed by the byteArray helper) → keeps the accurate `Cannot pass mutable typed arrays`. A non-`Uint8Array` fails for its *element type* regardless of buffer mutability → now reports `Cannot pass typed arrays other than Uint8Array`, never mentioning mutability. The early `!isFrozen` gate is untouched, so the genuinely-mutable cases the marshal `stringify` tests assert keep their message.

**Changed:**
- `packages/pass-style/src/passStyleOf.js` — the discriminated diagnostic + explanatory comment.
- `packages/pass-style/test/byteArray.test.js` — regression test (gated to unsafe taming via `Object.isFrozen({})`, the only leg reaching the guard on Node): asserts the non-`Uint8Array` message omits "mutable" and the `Uint8Array` message keeps it.
- `.changeset/passstyle-typedarray-diagnostic.md` — `@endo/pass-style: patch`.

**Verification** (local, via bin-shims): `@endo/pass-style` 75 (lockdown) / 74 (unsafe) / shims-only green; `@endo/marshal` 96 × both configs green; empirically confirmed under unsafe taming the non-`Uint8Array` case now yields the corrected message and the `Uint8Array` case is unchanged. `tsc` (lint:types), ESLint (only pre-existing unrelated warnings), Prettier, and `git diff --check` clean.

**Landed:** commit `d13469b9e` pushed to `feat/narrow-bytearray-to-uint8` (PR head now matches). Posted a reply to erights (comment 5347629219) summarizing the fix; the triager's `eyes` reactji was already present.

**Follow-ups:** The exact frozen-over-immutable scenario is only constructible on a native immutable-ArrayBuffer engine (XS), so it's exercised there rather than on the Node shim leg — the `instanceof Uint8Array` discriminator produces the corrected message identically on both. I deliberately left the early `!isFrozen` gate's message unchanged (it's accurate — those arrays genuinely aren't frozen — and it's what the marshal tests assert); worth a separate look only if devex for a *non-frozen* non-`Uint8Array` typed array is later flagged. Watch CI on the PR.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr475-9fe4e7c7.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 131 tokens (6236931 cached reads)
- Output: 54705 tokens
- Cost: $5.7078935
- Wall-clock: 800s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
