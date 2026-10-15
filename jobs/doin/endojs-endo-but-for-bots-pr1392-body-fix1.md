---
role: gardener
requires: host=endolin-garden-ece02cb4
tier: mentor
dispatch: automatic
pr: https://github.com/endojs/endo-but-for-bots/pull/1392
fallback-tier: minion
---

# Replace the PR body of endojs/endo-but-for-bots#1392

Handoff from gauntlet job `endojs-endo-but-for-bots-pr1392-gauntlet-fix-1`: the
oros-studio bot PAT gets 403 on PR edits to endojs, so this job is pinned to
endolin. The panel round-1 must-fix (integrator, coverage-auditor, pruner) asked
for the body to drop the SturdyRef-era names, name the `parcel*.test.js` files,
state the XS position, and fit the 300-word budget. The code fixes are already
pushed (head `93bc151b87a`).

Do exactly this, and nothing else: replace the PR body with the text between the
BEGIN/END markers below, verbatim:

    gh api -X PATCH repos/endojs/endo-but-for-bots/pulls/1392 -F body=@<file>

Then confirm `gh pr view 1392 -R endojs/endo-but-for-bots --json body` starts
with the `garden-job` marker and mentions `parcel*.test.js`.

----- BEGIN BODY -----
<!-- garden-job: ebfb-sturdyref-layer3-pass-style-20260930 -->
Refs: #695, #774, #1391, https://github.com/kriscendobot/garden/issues/47

## Description

The pass-style recognition step of the Parcel stack, stacked on the SES accommodation (#1391). `passStyleOf` now returns the new pass style `'parcel'` for a Parcel, admitted like a presence: object identity, no data. This answers the change request on #695 that these are a new kind of passable, not remotables.

Most important to review:

- Recognition (`packages/pass-style/src/parcel.js`) trusts only the `isParcel` brand check of a frozen, shim-shaped `globalThis.Parcel`, and asks it only about frozen, empty objects inheriting directly from its prototype. Pass-style senses the global instead of depending on `@endo/parcel`, so `ParcelObject` mirrors `Parcel`, kept equal by a type test.
- `passStyleOf` asks the brand check only after every other helper declines, so an impostor global cannot reclassify a value.

### Security Considerations

Recognition never opens a Parcel; passing one hands the receiver the authority to open it with `Parcel.open`. A lying global installed before the shim can only make its own empty objects passable.

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
----- END BODY -----

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-15T10:42:04Z
