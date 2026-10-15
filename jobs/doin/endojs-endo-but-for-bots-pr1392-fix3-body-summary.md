---
role: gardener
tier: mentor
requires: host=endolin-garden-ece02cb4
dispatch: automatic
fallback-tier: minion
---

# PR #1392: apply fix-3 body + post fix-3 review response (endolin; oros PAT 403s on endojs PR writes)

Handoff from gauntlet job `endojs-endo-but-for-bots-pr1392-gauntlet-fix-3` (oros-studio cannot write PR bodies or comments on endojs).
PR: https://github.com/endojs/endo-but-for-bots/pull/1392. Do NOT push to the head branch.

This body SUPERSEDES the body in `endojs-endo-but-for-bots-pr1392-fix2-body-summary` (it already includes that job's Security Considerations paragraph).

1. Replace the PR body with the text between the BODY markers below, verbatim:
   `gh api -X PATCH repos/endojs/endo-but-for-bots/pulls/1392 -F body=@<file>`.
2. Post the text between the SUMMARY markers as a top-level PR comment (`gh pr comment 1392 -R endojs/endo-but-for-bots --body-file <file>`).
3. Verify both with `gh pr view`, then report.

=====BODY=====
<!-- garden-job: ebfb-sturdyref-layer3-pass-style-20260930 -->
Refs: #695, #774, #1391, https://github.com/kriscendobot/garden/issues/47

## Description

The pass-style recognition step of the Parcel stack, stacked on the SES accommodation (#1391). `passStyleOf` now returns the new pass style `'parcel'` for a Parcel, admitted like a presence: object identity, no data. This answers the change request on #695 that these are a new kind of passable, not remotables.

Recognition trusts only the `isParcel` brand check of a frozen, shim-shaped `globalThis.Parcel`, and asks it only after every other pass style has declined a value, so an impostor global cannot reclassify a value that already has a pass style.

### Security Considerations

Recognition never opens a Parcel. Recognition is local in this layer: the generic marshal rejects a Parcel in either body format, so no Parcel, and no authority to open one, crosses a marshal boundary yet. A lying global installed before the shim can only make its own empty objects passable; the pre-shim trust-boundary cases run in a fresh Node process (`packages/pass-style/test/parcel-pre-shim.test.js`), since every AVA profile has already installed a non-configurable `Parcel`.

### Scaling Considerations

None.

### Documentation Considerations

The pass-style README lists the new pass style in its own dormant-capability category, and both READMEs say a Parcel cannot yet cross a vat boundary.

### Testing Considerations

The affected packages' tests, lint, and type tests pass locally and in CI. These packages have no XS harness, so the new tests run on Node only.

### Compatibility Considerations

`PassStyle` and `Passable` widen, so exhaustive `PassStyle` consumers must handle or exclude `'parcel'`, and `Pattern` and `Matcher` no longer admit nested errors or Parcels; the changeset says so. `@endo/spaces-util` gains a `'parcel'` render case but is private, so it has no changeset. `@endo/parcel` is a devDependency only, so no dependency cycle forms.

### Upgrade Considerations

None.

🤖 Generated with [Claude Code](https://claude.com/claude-code)


=====END BODY=====

=====SUMMARY=====
**Review response: panel round 3** · head `1dfaf54aa02` · next: CI, then panel round 4

<details><summary>What changed</summary>

- **assessor:** distinct containers holding the same Parcel (`compareRank(harden([parcel]), harden([parcel]))`) now throw `A "parcel" cannot be rank-ordered`. Identical parts of distinct containers are compared structurally. Identical remotables nested in distinct containers still compare as 0. (`fix(marshal): rank-order the parts of distinct containers`)
- **warden / spec-keeper:** any failure while inspecting `globalThis.Parcel` now declines recognition instead of escaping `isParcelObject`. A new `proxy-global` fixture uses a throwing `isExtensible` trap. Proxy traps can't be inspected without running them, and the module comment now says so.
- **breaker:** the prototype's `constructor` must be a non-enumerable data property (`enumerable-constructor` fixture). It is not required to `=== Parcel`, because a child compartment's shared constructor is not its prototype's constructor. The brand check's first answer for each candidate is cached, positive or negative, so a stateful `isParcel` cannot change classification (`stateful` fixture).
- **corner-prober:** a new `throwing-then-true` fixture proves that the `checking` latch is released after a throw.
- **fast-checker:** bounded wrapper-path properties (`array`/`record`/`tagged`, `maxLength: 8`, `numRuns: 200`) now cover:
  - marshal: both encode formats and both body formats reject every context
  - patterns: `isKey`/`isPattern` are false, `M.any()` matches and `M.key()` does not
  - pass-style: `isPassable` holds
- **stylist:** renamed `fc` → `fastCheck`, `arbPassable` → `passableArbitrary`, and the new `p` → `parcelPattern`.
- **coverage-auditor (types):** added a `@ts-expect-error` showing that `ParcelObject` is not `PassByRef`.
- **archivist / integrator / surfacer:** the Parcel now has its own "Dormant capability" README section instead of sitting under pass-by-reference. Both READMEs say that `passStyleOf` classifies locally and that a Parcel cannot yet cross a vat boundary. The changeset no longer calls this "a type-level change".
- **changeset-auditor / migrator (patterns):** `@endo/patterns` is now `major`. `M.kind('parcel')` is new surface, and `Pattern`/`Matcher` no longer admit nested errors or Parcels. The changeset body says so.
- **packager:** split `a762738561`, so the changeset ellipsis autofix is its own commit (`chore(changeset): use ASCII ellipsis in the Parcel changeset`). This was a lease-protected rewrite, and the final tree is unchanged by the split.
- **pruner:** deleted the two narrating comments in `marshal/test/parcel.test.js`. The PR body's review tour and test inventory are trimmed.
- **duality-auditor:** the property is now titled "unmarshallable" and is scoped to what it exercises.

</details>

<details><summary>Declined</summary>

- **decomplector (remove the `'parcel'` pass style)** and **purist (trusted brand function instead of the global)**: both contradict the accepted Parcel design (#1460) and the #695 change request. Those ask that a Parcel be a new kind of passable that pass-style recognizes by sensing the global, without importing the shim. Changing that is a design change for the maintainer, not a fix-loop item. The exposure the purist describes is still bounded: an impostor is asked only about frozen, empty objects that inherit from its own shim-shaped prototype, only after every other pass style declines. It now gets one stable answer per candidate.
- **migrator (`@endo/marshal` major):** before this change, a Parcel was not marshalled as a remotable. Its prototype carries no `PASS_STYLE`, so `passStyleOf` threw, the same path the `malformed` fixture pins for an unrecognized Parcel-shaped object. Marshalling one throws both before and after this change; only the message improves. Patch stands.
- **integrator (move the types from `.d.ts` to `.ts`):** pass-style predates the `types-index` convention, and all of its canonical types live in `src/types.d.ts`, with no `.ts` modules or build path. This PR edits the existing `Passable` family in place. Migrating the file belongs in its own change.
- **coverage-auditor (spaces-util render tests)** and **changeset-auditor (spaces-util changeset):** `@endo/spaces-util` is private and has no test harness (no test script, no ava, no DOM). Adding one is out of proportion for two render cases. The branches mirror the existing `remotable` cases.
- **engine-realist (XS test)** and **integrator (history regrouping):** should-fix items, deferred. These packages have no XS harness.

</details>

<details><summary>Verification</summary>

- `yarn install --immutable` and `yarn build:types` pass.
- The Parcel tests pass in every ses-ava config for pass-style (35), marshal (9), and patterns (6).
- The full marshal and patterns suites pass, apart from local AVA cache-race `ENOENT` crashes on unrelated files.
- eslint has 0 errors, and `tsc` plus the package type tests are clean for all three packages.

</details>
=====END SUMMARY=====

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-15T17:36:21Z
