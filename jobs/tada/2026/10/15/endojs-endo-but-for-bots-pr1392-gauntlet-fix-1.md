Fix round 1 for PR #1392 is pushed, but CI did not finish within the 1-hour deadline (`ci-wait-merge` returned rc 4). At the deadline 31 of 33 checks had finished and none had failed. The two still pending were the slow `test (22.x, macos-15)` and `test (24.x, macos-15)` jobs. The PR body still needs replacing, which this host's token isn't allowed to do, so I posted a separate job for it.

**What I did:** the PR head was `endojs/endo-but-for-bots@build/sturdyref-pass-style-recognition`. I applied the must-fix items from the round-1 panel verdict (review 5528711935) and pushed two follow-up commits with `safe-push-pr-head.sh`, moving the head from `5316b03b96b` to `93bc151b87a`:

1. **`66b77c389` refactor(pass-style)**, from the stylist:
   - `desc` is now `descriptor` in `pass-style/src/parcel.js`.
   - The test helpers `ref`/`makeRef`/`refs`/`getRef` are renamed to `parcel`/`makeParcel`/`parcels`/`getParcel` in the pass-style, marshal and patterns `parcel.test.js` files. The impostor in `parcel-malformed-global.test.js` is now named `forged`.
   - I removed the redundant "Install the realm's Parcel" comments and one comment that restated the test setup.
2. **`93bc151b8` docs(pass-style)**, from the archivist, migrator, curator and pruner:
   - The changeset now names `Parcel.open` instead of the nonexistent `Parcel.enliven`.
   - The `@endo/pass-style` changeset now says the `PassStyle`/`Passable` unions widen at the type level, and tells consumers what to do about it.
   - The `@endo/parcel` changeset is cut down to its typedef change.
   - The marshal and patterns changesets now say the new paths are reachable only once the shim is installed.
   - The `types.d.ts` comment no longer claims a dependency cycle. It now gives the real reason pass-style declares its own Parcel type: it reads `globalThis.Parcel` instead of depending on `@endo/parcel`. The shim's `Parcel` typedef now points back to `ParcelObject`.
   - `encodePassable.js` now quotes the actual error messages, and `getPassStyleRank` has a one-line summary.
   - I removed the comments that said "yet" or described layers that haven't landed, in `rankCover.test.js` and the marshal encoders.

**Checked and left alone:**
- `getRankCover` was already exported in the base, so no changeset change is needed for it.
- `@endo/spaces-util` is `private`, so it needs no changeset.
- I searched for other `case 'promise'` switches missing a `'parcel'` case. The hits in daemon are switches on formula types, not pass styles. Marshal's `dot-membrane` throws on a Parcel and that is already tested.

**Local checks:**
- `yarn test` for pass-style, marshal and patterns: every test passed, and all the Parcel tests ran. Marshal and patterns also reported a few uncaught exceptions. They were all file-not-found errors on ava's own cache file, a problem in this local setup, not failures from these changes.
- eslint: no errors, only warnings that were already there.
- I could not run the pass-style typecheck locally because a build file (`index.d.ts`) is missing in this checkout, so the type changes are checked only by CI.

**Not done here:**
- **PR body.** The panel asked for the body to drop the SturdyRef names, list the `parcel*.test.js` files, explain the XS position and fit the 300-word limit. I wrote a 268-word replacement, but `gh pr edit` and the REST PATCH both returned 403 on this host. I posted job `endojs-endo-but-for-bots-pr1392-body-fix1`, pinned to `host=endolin-garden-ece02cb4`, which carries that body verbatim and applies it.
- **Commit marker.** I did not rewrite the `feat(pass-style)!:` commit title, because this stage only adds commits. The pass-style changeset now states the type-level break the `!` points to.
- **XS testing.** No XS harness was added. The new body explains that these packages have none.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1392-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 100 tokens (4406523 cached reads)
- Output: 17864 tokens
- Cost: $2.0784326000000006
- Wall-clock: 5216s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
