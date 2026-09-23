---
kind: result
role: gardener
host: endolinbot
at: 2026-06-25T14:45:17Z
---
---
ts: 2026-06-25T14:45:00Z
kind: result
role: gardener
repo: endojs/endo-but-for-bots
project: endo
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/503#issuecomment-4794208524
---

Attention directive on PR #503 (kriskowal, 2026-06-24T22:32Z, "Please apply this feedback"). Read the directive as data and routed it. Verdict: the actionable part was already applied and is CI-green; the rest is affirmation.

Point 1 (packages dealing in Uint8Array should copy emulated frozen views to a mutable Uint8Array before platform handoff, reading via `at`, preferring poor performance over forbidding frozen views): APPLIED in commit daaf8ffe1 ("fix(bytes): tolerate emulated frozen Uint8Array in ponyfills", endolinbot, 22:58Z, 26 min after the directive). Adds `@endo/bytes/src/to-genuine.js#toGenuineBytes`: genuine views pass through uncopied; an emulated freezable wrapper (plain object that `ArrayBuffer.isView` rejects) is copied byte-by-byte through `%TypedArrayPrototype%.at` into a fresh mutable `Uint8Array`. Routed through `bytesToText`/`bytesEqual`/`concatBytes`. Carries a `@endo/bytes: patch` changeset and a dedicated "Emulated-frozen-Uint8Array tolerance" test section (helper builds a wrapper via the immutable-arraybuffer shim and exercises all three operators). Faithful to the directive, including the `at`-instead-of-indexing guidance.

Point 2 (immutable-arraybuffer "first-initializer wins" shim): "No changes requested." No action.

Point 3 (may not need wrappers for every ByteArray operator at the pass-style layer, since ponyfills tolerate every variant): pass-style/src/byteArray.js is a brand-CHECK (validation), not per-operator wrappers, so there is nothing to remove. The current minimal approach already matches the directive's release-from-obligation. No action.

All 15 CI checks pass on daaf8ffe1 (build, lint, cover, test 22.x/24.x ubuntu+macos, test262, test-xs, test-hermes, ...). The directive is fully addressed.

Follow-ups (not blocking this directive):
- PR #503 remains DRAFT, staged for boatman ferry to endojs/endo. The natural next step is the gauntlet / un-draft, gated on maintainer + boatman; not part of this feedback-apply job.
- The broader "packages dealing in Uint8Array" set (compartment-mapper, ocapn, zip, captp, daemon, cli all use TextDecoder/TextEncoder) was deliberately left out of scope: those operate on genuine views from disk/network and do not receive emulated frozen Uint8Arrays in current data flows. The `@endo/bytes` ponyfill layer is the one that actually receives passable byte arrays. A wider sweep would be a separate effort if/when the maintainer wants it.
