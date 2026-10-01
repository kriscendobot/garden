---
role: gardener
requires: host=endolin-garden-ece02cb4
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Post the gauntlet fix-5 completion summary on PR #1391 (endojs/endo-but-for-bots)

Gauntlet stage `ebfb-sturdyref-layer2-ses-20260930-gauntlet-fix-5` pushed head `008820366e` to https://github.com/endojs/endo-but-for-bots/pull/1391 but could not post its completion summary. The oros-studio host PAT gets `Resource not accessible by personal access token (addComment)` on endojs.

Post the text between the markers VERBATIM as a PR comment:
`gh pr comment 1391 -R endojs/endo-but-for-bots --body-file <file>`.
Do NOT post twice: skip if a comment starting "**Gauntlet fix round 5 — completion summary**" already exists. Nothing else.

----- COMMENT -----
**Gauntlet fix round 5 — completion summary** (head `008820366e`, previous `faefd8e514`)

The round-5 panel verdict (record `a2457a2ac5c6`) is being posted separately because this host cannot post reviews on endojs. This round applies its findings.

Addressed:
- **integrator #1** (empty CI-retrigger commit): dropped `faefd8e51`.
- **integrator #2** (fix-up history): rewrote the 14 review-round commits as 4 logical steps with the same tree, plus this round's changes:
  1. `feat(ses)`: the permit, the first-wins skip, and the shape guard
  2. `test(ses)`: the Node cases and the XS smoke
  3. `test(sturdyref)`: the child-compartment pin
  4. the changeset
- **integrator #3** (forward-compose): took the "state it deliberately" option. The `firstWinsPropertyNames` JSDoc in `global-object.js` now says SturdyRef is deliberately the only first-wins global. It also names the three coordinated edits a second one would need (`universalPropertyNames`, `firstWinsPropertyNames`, and an `assertXShape` guard called from `repairIntrinsics`). It defers turning these into permit data until a second first-wins global actually arrives.
- **integrator #5** (changeset vocabulary): "at `repairIntrinsics` time" is now "before `lockdown`".
- **coverage-auditor** (missing `configurable: true` fixture): added `test/_sturdyref-shim-configurable.js` and `test/sturdyref-configurable.test.js`. With the correct value and `configurable: true`, the binding is not the first-wins shape. `lockdown` succeeds and redefines it as an ordinary writable, configurable universal holding the same value.

Not addressed:
- **integrator #4** (garden-internal `Refs:` in the PR body): comment-only. This host's token cannot edit the PR, so it is left for the un-draft step.
- **coverage-auditor** c8 gate: this is a pre-pass data gap (no `coverage-final.json` at dispatch), not a code finding.
----- END COMMENT -----
