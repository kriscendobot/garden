# design: byteArray maps a frozen Uint8Array view, not a bare immutable ArrayBuffer

Map: **design** → produce a design document (designer role) on `endojs/endo-but-for-bots`, landing as a DRAFT PR against the `llm` roadmap branch per `journal/projects/endo-but-for-bots/README.md`.

## Origin

erights directed @kriscendobot on PR #429 ([comment](https://github.com/endojs/endo-but-for-bots/pull/429#issuecomment-4840086579), routed via attention job `endojs-endo-but-for-bots-pr429-248d107b`). On `endojs/endo-but-for-bots` every commenter is maintainer-equivalent, and erights additionally holds topic authority on `pass-style` / `marshal` / OCapN. The directive:

> Our current intent is to map only a plain frozen `Uint8Array` backed by a plain frozen immutable `ArrayBuffer` to an ocapn `byteArray`. The current PRs ("admit immutable ArrayBuffer through codecs") are based on the earlier assumption that we map a plain frozen immutable `ArrayBuffer` to a `byteArray`. Produce an alternative reflecting the current intent.

A reply acknowledging this and promising the design was posted on #429 ([comment](https://github.com/endojs/endo-but-for-bots/pull/429#issuecomment-4840118510)); this job is that promised follow-up.

## The pivot

- **Old premise (current PRs #429 llm-base, #57 master-base, upstream endojs/endo#3226):** a bare plain frozen immutable `ArrayBuffer` has passStyle `byteArray` and is admitted through the `capdata` / `smallcaps` / `encode-passable` codecs.
- **New intent:** the value with passStyle `byteArray` is a **plain frozen `Uint8Array` whose backing buffer is a plain frozen immutable `ArrayBuffer`** (the typed-array view), and a bare immutable `ArrayBuffer` is **not** itself a `byteArray`.

## Scope of the design

1. `@endo/pass-style` `passStyleOf`: attach `byteArray` to the frozen-`Uint8Array`-over-immutable-buffer case; define how a bare immutable `ArrayBuffer` is treated now (rejected / not-passable / pass-by-copy-as-something-else — the design decides and justifies). Cover the guards (frozen view, frozen+immutable buffer, byteOffset/length spanning the whole buffer or not, no detachment surface).
2. The `@endo/pass-style` hex helpers (`byteArrayToHex`, `hexToByteArray`, `byteArrayToUint8Array`, `uint8ArrayToByteArray`): re-cast the boundary so `Uint8Array` is the JS-side type. The wire forms (`capdata` qclass `byteArray` hex; smallcaps `*<hex>`; encode-passable `a<encodeBigInt(byteLength)>:<hex>` Elias-delta prefix) should stay unchanged; confirm and state that explicitly.
3. `marshal-justin` rendering and the smallcaps cheatsheet: unchanged on the wire; confirm the JS reconstruction now yields the `Uint8Array` view.
4. Relationship to the existing PRs: the design supersedes #429 / #57 (and the upstream #3226 premise). State whether those are withdrawn or retargeted; surface the call for the maintainer.

## Deliverable

A `designs/<slug>.md` design document and a DRAFT design PR against `llm`. Researcher precedes the designer per the standard process; ground the data-model claims in `@endo/pass-style` and the OCapN byteArray definition. Post a top-level summary comment on the design PR, and follow up on #429 with a link to the design PR (standing authorization covers commenting on this repo).

## Authority note

This is a roadmap-direction pivot affecting three open PRs and an upstream subsystem. The direction (view-based mapping) is set by erights' directive; the *disposition* of #429 / #57 / #3226 (withdraw vs retarget) is a maintainer call the design surfaces rather than executes.

---
claim:
  host: endolinbot2
  gardener: 26
  claimed_at: 2026-06-30T05:13:54Z
