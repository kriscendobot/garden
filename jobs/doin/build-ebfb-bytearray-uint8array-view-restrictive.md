---
gate: none
priority: normal
posted_by: gardener
posted_at: 2026-06-30T13:55:00Z
---

# build: fresh view-based byteArray implementation per design #572 (restrictive whole-buffer-span)

Map: **build** → implement the OCapN `byteArray` data-model pivot designed in
endojs/endo-but-for-bots **#572** (`designs/bytearray-uint8array-view.md`).

## Authority

erights directed the pivot on #429 and reviewed/approved the direction on #572;
erights' #572 review carries **maintainer authority** (kriskowal, 2026-06-30;
erights is now on `maintainers/allowlist`). This build is the authorized next
step after the design landed. Standing authorization covers this repo
(endo-but-for-bots) for comments and PRs.

## Deliverable

A **fresh** view-based `byteArray` implementation that replaces the bare-buffer
model the now-closed PRs carried:

- `passStyleOf` attaches the `byteArray` passStyle to a **plain frozen
  `Uint8Array` view** backed by a **plain frozen immutable `ArrayBuffer`** — not
  to a bare immutable `ArrayBuffer`.
- A **bare** immutable `ArrayBuffer` is **no longer** a `byteArray`; it falls
  through to remotable and `passStyleOf` **throws** (not passable). No new
  passStyle for it.
- JS boundary: collapse `uint8ArrayToByteArray` / `byteArrayToUint8Array` to
  `frozenBytes(view)` / `thawnBytes(bytes)`; re-cast `byteArrayToHex` /
  `hexToByteArray` to `Uint8Array`.
- **Wire forms stay byte-for-byte identical** (capdata `{"@qclass":"byteArray",
  "data":"<hex>"}`, smallcaps `*<hex>`, encode-passable `a<encodeBigInt(byteLength)>
  :<hex>`, marshal-justin `hexToByteArray("<hex>")`) — only the reconstructed JS
  value flips to the view. Add/keep tests proving wire stability.

## The restrictive decision (issue #573)

Implement the **restrictive** whole-buffer-span option per **#573** (Decision 3,
assigned to erights): `passStyleOf`'s `byteArray` detection **requires**
`byteOffset === 0 && length === buffer.byteLength`, **rejecting sub-views**. This
closes the data-reachability hazard of a sub-view exposing a buffer that carries
more data than the view intends to reveal. (#573 tracks revisiting the permissive
sub-view form later; do not admit it now.)

Guards table (from #572 § passStyleOf): frozen view, `Uint8Array.prototype`,
backing buffer immutable + plain, no own non-index properties, indexed values
agree with the underlying bytes, **whole-buffer span (restrictive)**, and the two
well-formed shapes (0 own indices on the emulated-shim wrapper, exactly `length`
own indices on the native exotic).

## Existing prototype to build from

The implementation already lives largely on the **`feat/narrow-bytearray-to-uint8`**
branch (base of the now-closed #57, head of the still-open **#475**, draft +
CHANGES_REQUESTED against `master`): its `packages/pass-style/src/byteArray.js`,
`to-bytes.js` (`frozenBytes`), `from-bytes.js` (`thawnBytes`), and the
`read byteArray bytes through a genuine Uint8Array for rank compare` marshal fix
carry the view detection and JS boundary. **Ground every change against that
prototype.** Note the prototype is currently **permissive** (admits sub-views) —
this build must tighten it to the **restrictive** span check per #573.

Coordinate with the in-flight **#475**: prefer carrying #475's
`feat/narrow-bytearray-to-uint8` to the finished restrictive form (it is already
under erights review) rather than opening an unrelated parallel branch, unless the
gardening machine finds that infeasible. Fold in the marshal/pass-style
byteArray-through-codecs delta that the closed #57 carried.

## Superseded / out of scope

- **#429, #57** (endo-but-for-bots): CLOSED by erights citing #572. Their
  bare-buffer premise is gone; do not revive. Branches preserved (reversible).
- **endojs/endo#3226** (upstream): **NOT in scope for this bot host** — it stays
  with kriskowal / the boatman path (no upstream-Endo credentials here). Do not
  touch it.
- **Helper naming** (dual `frozenBytes`/`thawnBytes` vs hex helpers): deferred to
  @kriskowal; do **not** unify naming in this build.

## Verification

Run `@endo/pass-style` and `@endo/marshal` ava + tsc + eslint locally; keep
`chore: Update yarn.lock` as a separate commit if the lock moves. Post a top-level
summary comment on the resulting PR (and on #475 if that is the vehicle) naming
the head SHA and what changed; tag @erights.

---
claim:
  host: endolinbot2
  gardener: 19
  claimed_at: 2026-06-30T13:58:54Z
