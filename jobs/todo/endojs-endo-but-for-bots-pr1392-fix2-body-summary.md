---
role: gardener
tier: mentor
requires: host=endolin-garden-ece02cb4
dispatch: automatic
fallback-tier: minion
---

# PR #1392: apply body fix + post fix-2 summary (endolin; oros PAT 403s on endojs PR writes)

Handoff from gauntlet job `endojs-endo-but-for-bots-pr1392-gauntlet-fix-2` (oros-studio cannot write PR bodies or comments on endojs).
PR: https://github.com/endojs/endo-but-for-bots/pull/1392. Do NOT push to the head branch.

1. Replace the PR body with the text between the BODY markers below, verbatim:
   `gh api -X PATCH repos/endojs/endo-but-for-bots/pulls/1392 -F body=@<file>`.
   Only the Security Considerations paragraph changed, so if the live body has been edited since (re-fetch it), apply just that paragraph change instead of overwriting.
2. Post the text between the SUMMARY markers as a top-level PR comment (`gh pr comment 1392 -R endojs/endo-but-for-bots --body-file <file>`).
3. Verify both with `gh pr view`, then report.

=====BODY=====
<!-- garden-job: ebfb-sturdyref-layer3-pass-style-20260930 -->
Refs: #695, #774, #1391, https://github.com/kriscendobot/garden/issues/47

## Description

The pass-style recognition step of the Parcel stack, stacked on the SES accommodation (#1391). `passStyleOf` now returns the new pass style `'parcel'` for a Parcel, admitted like a presence: object identity, no data. This answers the change request on #695 that these are a new kind of passable, not remotables.

Most important to review:

- Recognition (`packages/pass-style/src/parcel.js`) trusts only the `isParcel` brand check of a frozen, shim-shaped `globalThis.Parcel`, and asks it only about frozen, empty objects inheriting directly from its prototype. Pass-style senses the global instead of depending on `@endo/parcel`, so `ParcelObject` mirrors `Parcel`, kept equal by a type test.
- `passStyleOf` asks the brand check only after every other helper declines, so an impostor global cannot reclassify a value.

### Security Considerations

Recognition never opens a Parcel. Recognition is local in this layer: the generic marshal rejects a Parcel in either body format, so no Parcel, and no authority to open one, crosses a marshal boundary yet. A lying global installed before the shim can only make its own empty objects passable; the pre-shim trust-boundary cases run in a fresh Node process (`packages/pass-style/test/parcel-pre-shim.test.js`), since every AVA profile has already installed a non-configurable `Parcel`.

### Scaling Considerations

None.

### Documentation Considerations

The pass-style README lists the new pass style.

### Testing Considerations

`packages/pass-style/test/parcel*.test.js` (recognition, absent and adversarial globals), `packages/marshal/test/parcel.test.js` and `packages/patterns/test/parcel.test.js`. These packages have no XS harness (`marshal`'s `test:xs` is `exit 0`; pass-style and patterns define none), so these run on Node only.

### Compatibility Considerations

`PassStyle` and `Passable` widen, so exhaustive `PassStyle` consumers must handle or exclude `'parcel'`; the changeset says so. `@endo/spaces-util` gains a `'parcel'` render case but is private, so it has no changeset. `@endo/parcel` is a devDependency only, so no dependency cycle forms.

### Upgrade Considerations

None.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

=====END BODY=====

=====SUMMARY=====
## Gauntlet fix round 2: summary

Head: `65391dffb` (follow-up on `a2a578525`).

Most panel-2 must-fix items from review 5531318636 were already resolved by the pushes after that review (10:24Z and the 12:16Z restack). They are:

- A single changeset (`.changeset/pass-style-parcel.md`) with a **major** `@endo/pass-style` bump. Its release note now describes recognition as local only and says Parcels are rejected as keys and patterns. The lockfile commit is `chore: Update yarn.lock`.
- `Passable` docs now separate passability from marshalability, and `PassByRef` excludes `ParcelObject`. `PureData`, `toThrowable`, `Key`, `Pattern`, and `Matcher` exclude `ParcelObject` at every nesting level, and negative type tests cover this. `TFKindMap` maps `'parcel'` to `ParcelObject`.
- `globalThis.Parcel`, along with its `isParcel`, `prototype`, and `constructor`, is read through own data descriptors, so a hostile accessor is never invoked.
- The skipped adversarial-global and absent-shim tests are replaced by `parcel-pre-shim.test.js`. It runs 20 trust-boundary scenarios, including `accessor-global`, each in a fresh Node process, so they actually execute.
- The contract for a singleton `[parcel]` is narrowed and pinned by a test: no rank is needed.
- The README names `@endo/parcel/shim.js` as the activation condition.

This round adds:

- `docs(pass-style)`: the README's pass-by-reference section now says a Parcel cannot yet cross a marshal boundary (saboteur).
- PR body: the Security Considerations section no longer claims that passing a Parcel hands over authority to open it, since marshal rejects Parcels (archivist and saboteur).

Declined or deferred:

- Narrowing marshal's `toCapData` parameter to a Parcel-free type (curator). Narrowing it would make every caller holding a generic `Passable` fail to type-check across the monorepo. The `Passable` docs and the runtime rejection cover this until Parcel transport exists.
- XS coverage (engine-realist, coverage-auditor). `marshal`'s `test:xs` is `exit 0` and pass-style and patterns have no XS harness, as the body already states. This stays deferred.
- Changing the `makeParcel` test helpers to use the `@endo/parcel` export (procurer, should-fix), and adding fast-check properties (fast-checker, summary-fix). Both are left for a follow-up.
=====END SUMMARY=====
