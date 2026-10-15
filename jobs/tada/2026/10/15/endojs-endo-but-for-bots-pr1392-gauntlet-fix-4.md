## Fix round 4 for endojs/endo-but-for-bots PR #1392: done, CI green

I applied the panel-4 must-fix items and pushed four follow-up commits to `build/sturdyref-pass-style-recognition` (`1dfaf54aa` → `4bb4e0cbf`) with `safe-push-pr-head.sh` in advance mode. `ci-wait-merge.sh --no-merge` returned rc 0: all 35 checks passed, none failed.

**Must-fix items**
- **Curator 1 and 2, integrator 1 (`@endo/parcel` dependency and `ParcelObject` coupling):** `@endo/pass-style` now defines `ParcelObject` itself as a structural type (`{ readonly [Symbol.toStringTag]: 'Parcel' }`). It no longer imports from `@endo/parcel`, so `@endo/parcel` moved from `dependencies` to `devDependencies` and I regenerated `tsconfig.composite.json`. `yarn.lock` did not change, so there is no lockfile commit. The type test now checks that `@endo/parcel`'s `Parcel` is still assignable to `ParcelObject` and that a plain record is not. With this change, the PR body's claim that "`@endo/parcel` is a devDependency only" is now true, so the body needed no edit.
- **Archivist 1 (dot membrane):** `dot-membrane.js` now has an explicit `'parcel'` case that throws `a "parcel" cannot be marshalled`. The existing test already showed the membrane gave that error, because marshalling runs before the switch. The new case keeps the message if that order ever changes. I also reworded the changeset to quote the exact error for both encoders and the membrane.
- **Stylist 1 (`val` exemption):** I moved the `spell-out-exempt` comment in `deeplyFulfilled.js` to line 1, where the rest of the repo puts it. `val` is the existing parameter name, so nothing was renamed.

**Should-fix items also applied**
- **`parcel.js`:** I renamed the `makeBrandCheck` parameter that shadowed the global `Parcel` to `candidateConstructor`. One use of the old name had been missed in the first pass; the typecheck caught it before the commit.
- **`Container` type:** its Parcel type parameter now has a default.
- **Wording:** the `PassByRef` comment and type-test comment no longer say a Parcel is "passed by identity", which matches the README.
- **Patterns type test:** it uses the imported `ParcelObject` and an ASCII `->`.
- **Changeset:** it now describes the new type parameter, the tighter `CopyRecordInterface`, and the `Symbol.toStringTag` added to `@endo/parcel`'s `Parcel` type. `@endo/spaces-util` is private, so it needs no changeset.

**Local checks:** `tsc` and the type tests pass for pass-style, patterns and marshal after a clean types build. The ava suites for pass-style, marshal and patterns pass. One run of `copySet.test.js` crashed with an ava-cache ENOENT; it passed when rerun. ESLint showed no errors and the composite tsconfig check is clean.

**Follow-ups:** the remaining should-fix items are not applied: the stylist's other renames in `parcel.js` (`checking`, `decisions`, `brandCheck`), the assessor's note about rank-comparison cost, and the integrator's request to restructure the commit history. The driver posts panel-5 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1392-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 92 tokens (4296765 cached reads)
- Output: 20788 tokens
- Cost: $2.1352090000000006
- Wall-clock: 2765s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
