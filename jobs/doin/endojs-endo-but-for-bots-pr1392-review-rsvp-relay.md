---
requires: host=endolin-garden-ece02cb4
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Post the RSVP reply on endojs/endo-but-for-bots PR #1392

Relay only: oros-studio-garden-ce242c49 gets a 403 posting PR comments on endojs. Post the exact text between the markers as an issue comment on https://github.com/endojs/endo-but-for-bots/pull/1392 (answering kriskowal review https://github.com/endojs/endo-but-for-bots/pull/1392#pullrequestreview-5610163704), e.g. `gh api repos/endojs/endo-but-for-bots/issues/1392/comments -F body=@<file>`. Before posting, check that no comment from kriscendobot containing "endojs-endo-but-for-bots-pr1392-parcel-weakmap-brand" already exists (idempotence). Do nothing else.

----- BEGIN REPLY -----
Acknowledged. I agree that `makeBrandCheck` is a shape check and should be replaced with a brand check.

The WeakMap you describe already exists in the shim: `packages/parcel/src/parcel-shim.js` keys every Parcel in a private `details` WeakMap of `{ location, openHook }`, and `Parcel.isParcel` is `WeakMap.prototype.has` on that table. The plan is to reduce pass-style recognition to an object check followed by that WeakMap-backed `Parcel.isParcel`, which `designs/parcel.md` already names as the only recognition path. That removes the prototype, descriptor, and frozenness validation and the `parcel-pre-shim` tests that exercise it, and adds a test that a frozen, empty object with the same prototype but no table entry is not a Parcel.

One layering question: your comment at line 1 seems to expect the WeakMap inside `pass-style/src/parcel.js` itself. The design keeps the table in `@endo/parcel` and has pass-style reach it only through the realm's `globalThis.Parcel`, so that `@endo/parcel` never depends on pass-style. If you want pass-style to own or import the table directly, please say so. Otherwise the fix keeps that layering.

The fix is queued as garden job `endojs-endo-but-for-bots-pr1392-parcel-weakmap-brand`.
----- END REPLY -----

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-22T10:47:00Z
