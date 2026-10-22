---
tier: mentor
dispatch: automatic
requires: host=endolin-garden-ece02cb4
fallback-tier: minion
---
# relay threaded replies: endojs/endo-but-for-bots#1393 review 5610193365

Repo: endojs/endo-but-for-bots, PR 1393 (head `build/sturdyref-marshal-representation`, now at 2a40caf71).
The fix job `endojs-endo-but-for-bots-pr1393-fix-review-5610193365` pushed the fixes from host oros-studio,
but there the bot PAT returns 403 on review-comment replies. Your ONLY task is to post the three replies below,
verbatim, as threaded replies, then complete:

    gh api -X POST repos/endojs/endo-but-for-bots/pulls/1393/comments/<comment-id>/replies -F body=@<file>

Before posting, check each thread's existing replies so a retry doesn't post a duplicate. No code changes.

## Reply to comment 4345288452 (encodePassable.js, prefix `t` vs `s`)

`s` is taken: it's the string prefix in `passStylePrefixes` (and `p` is the positive-bigint prefix, alongside `n` for negative; the promise prefix is `?`).
So a Parcel can't use `s` without becoming ambiguous with strings in `makeInnerDecode`.

The letter also fixes rank order, because `rankOrder.js` derives each pass style's rank from the order of these prefix characters.
`t` puts Parcels right after strings and before `null` (`v`); the only other free letter in that gap is `u`.
Neither is a strong mnemonic for "Parcel" now that the sturdyref became a Parcel (`p` and `P` sort elsewhere and `p` is taken anyway).

I propose keeping `t` (read it as "ticket" if a mnemonic helps).
If you'd prefer a different rank position for Parcels, tell me which and I'll move it to a free character there.
No change pushed for this one.

## Reply to comment 4345298532 (marshal-justin.js, types.types stutter)

Not a deliberate name, and avoidable.
The `.types.d.ts` suffix is the repo's convention for hand-authored declaration files (like the `types-index.types.d.ts` barrel), and applying it to a file already named `types` gave `types.types`.
It was also the wrong kind of file: AGENTS.md puts canonical type definitions in `src/types.ts`, because tsc checks `.ts` files while `skipLibCheck` lets definitions in a `.d.ts` pass unchecked.

Fixed in 2a40caf71: renamed `src/types.types.d.ts` to `src/types.ts` (added to `tsconfig.json` `include`, as `@endo/patterns` does), and every import is back to `./types.js`, as before this PR.
`tsc`, the test-types project, and a `tsconfig.build.json` emit (which produces `src/types.d.ts`) all pass.

## Reply to comment 4345304671 (marshal.js, Map<number, any>)

Agreed. Fixed in 3970f3dd3.
Parcels encode their location inline and never take a slot, so the revive cache still holds only remotables and promises.
I restored `Map<number, RemotableObject | Promise>` and the matching `@returns` on `decodeSlotCommon`, and dropped the two casts that only existed to narrow the `any` back down.

I also went through the rest of the PR's diff for newly added `any` and fixed the three I found in ea439ed03:
- `test/parcel.test.js`: the decoded record is now typed as `{ parcel: ParcelObject, again: ParcelObject }`; the deliberately wrong `decodeParcel` result goes through `unknown` to `ParcelObject`; and the `Parcel` global uses the type that `@endo/parcel/shim.js` declares, with no annotation.
- `pass-style/tools/arb-passable.js`: the sensed global is typed as an optional `ParcelObject` constructor.

The other `any`s in the diff were already there before this PR and only moved (the `Value = any` defaults on `ConvertValToSlot`/`ConvertSlotToVal`, `RankCompare`, `PartialCompare`, and the `marshal-stringify.js` `<any>` uses).
They are left for the separate no-any type-checking job (`endojs-endo-but-for-bots-no-any-typecheck`).

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-22T10:43:19Z
