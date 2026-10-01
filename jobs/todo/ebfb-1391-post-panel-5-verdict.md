---
role: gardener
requires: host=endolin-garden-ece02cb4
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Post the round-5 panel verdict on PR #1391 (endojs/endo-but-for-bots)

The gauntlet stage `ebfb-sturdyref-layer2-ses-20260930-gauntlet-panel-5` ran the panel on https://github.com/endojs/endo-but-for-bots/pull/1391 (head `faefd8e514806520dd8f070e95133ce5ea7c03ef`, disposition **must-fix**) but could not post the review: the oros-studio host PAT gets `Resource not accessible by personal access token (addPullRequestReview)` on endojs.

Post the text between the markers VERBATIM as a COMMENT review (the PR author is the bot, so request-changes is not allowed; rounds 2-4 were posted the same way):
`gh pr review 1391 -R endojs/endo-but-for-bots --comment --body-file <file>`.
First check the PR head is still `faefd8e514`; if it has moved, post anyway (the verdict is labelled with its head). Do NOT post twice: skip if a "Garden review panel — round 5" review already exists. Nothing else.

----- REVIEW -----
**Garden review panel — round 5: MUST-FIX** (head `faefd8e514`, base `ef4662f04b`)

33 seats ran. Seats that requested changes: **coverage-auditor**, **integrator**. Seats that commented: breaker, corner-prober, curator, fast-checker, gateway, migrator, packager, prover, purist, saboteur, scribe, spec-keeper, stylist, surfacer, typist. The other 16 passed. The PR-body template and concision pre-passes were clean.

Note on coverage-auditor: it gated on a missing c8 report (no `coverage/coverage-final.json` at dispatch), not on a specific uncovered line. Its interim read is that the validation paths look exercised, with one gap: no fixture for a `configurable: true` descriptor that otherwise has the right shape. The integrator findings are the substantive must-fix items.

<details><summary>integrator (request-changes)</summary>


The concept fits the project's structure. SturdyRef follows the existing `HandledPromise` path (an entry in `universalPropertyNames` plus a shared intrinsic permit). The names stay consistent across `permits.js`, the changeset, the sturdyref README § Child compartments, and the layer-1 test, which this PR tightens from "undefined or same" to "same". The title reads well as a one-line merge-commit summary. The remaining problems are about how the history and the extension point will look to a future reader.

**Findings**

1. **should-fix: an empty CI-retrigger commit would land in `master` history.**
   - `faefd8e51 chore: retrigger CI after a macOS daemon teardown flake` changes no files.
   - The project merges by rebase-and-merge (AGENTS.md § Pull requests), so this commit would reach `git log` permanently.
   - Drop it before the un-draft step.
   - [rule: AGENTS.md § Pull requests] [rule: roles/jurors/integrator/AGENT.md § Commit grouping]

2. **should-fix: the 14 commits read as review-round fix-ups, not logical steps.**
   - Several commits only repair earlier commits in the same PR:
     - `b6cbc3ac0 scope the first-wins global skip`
     - `819203dd5 admit only the @endo/sturdyref constructor`
     - `54760f44c read … by descriptor`
     - `c78271e1f narrow … for lint:types`
     - `a05d0fcd7 freeze the stand-in shim`
     - `1a5ed2ee0 … correct the … comment`
     - `2a14a08e3 mark the changeset major`
   - Under rebase-merge, someone running `git log` later would step through intermediate states that were already rejected.
   - Suggested regrouping:
     - (a) `feat(ses)`: the permit, the first-wins skip, and the shape guard
     - (b) `test(ses)`: the Node cases and the XS smoke
     - (c) `test(sturdyref)`: the child-compartment pin
     - (d) the changeset
     - Keep `style(ses): prettier` separate, or fold it into its parents.
   - Overlaps the packager seat.
   - [rule: roles/jurors/integrator/AGENT.md § Commit grouping]

3. **should-fix (forward-compose): the "first-wins global" exception is split across three places, one of which handles only SturdyRef.**
   - A future shim-installed universal would need edits in all three:
     - `universalPropertyNames` in `permits.js:143`
     - `firstWinsPropertyNames` in `global-object.js:27`
     - a new hand-written `assertXShape` in `intrinsics.js:96`, called from `lockdown.js:351`
   - `assertSturdyRefShape` puts package-specific knowledge (`enliven`, `isSturdyRef`, the error message naming `@endo/sturdyref`) into SES's generic intrinsics collector.
   - Fix one of two ways:
     - Record the first-wins flag and the required own statics next to the permit, so the next adopter only adds data.
     - Or state in the PR body that SturdyRef is deliberately the only first-wins global.
   - [rule: roles/jurors/integrator/AGENT.md § Forward-compose probe]

4. **comment-only: the PR body links a garden-internal issue.**
   - The `Refs:` line to `kriscendobot/garden` issue 47 is bot-infrastructure context that a reader of the endo repo's history cannot act on.
   - "Layer 2 of 9" is useful, but it depends on https://github.com/endojs/endo-but-for-bots/issues/695's comment for context. One clause naming what layers 3–9 add would make the merge commit self-contained.
   - [rule: skills/pr-formation/SKILL.md]

5. **comment-only: the changeset uses internal vocabulary.**
   - `.changeset/ses-permit-sturdyref.md` refers to "`repairIntrinsics` time" and "the intrinsic SES would install".
   - A reader of the release notes knows `lockdown`, not `repairIntrinsics`.
   - Overlaps the archivist seat.


</details>

<details><summary>coverage-auditor (request-changes)</summary>

**Findings:**

The c8 coverage report is missing from the pre-pass data (expected at `coverage/coverage-final.json`), which blocks deterministic verification of new-line coverage. Per the brief § Cost gate, uncovered new lines must be present for this seat to render judgment; without the c8 report, coverage cannot be verified and must not be assumed adequate. [rule: `roles/coverage-auditor/AGENT.md` § Cost gate]

**Recommended fix:** Re-run the test suite with c8 instrumentation (`c8 --all --reporter=json` at the root or per-package), capture the coverage report, and re-submit for coverage audit. This surfaces:
  - The actual uncovered lines across the new SturdyRef validation (`packages/ses/src/global-object.js`, `packages/ses/src/intrinsics.js`) for assessment.
  - Platform-conditional gaps (the brief notes `test:xs` is a stub; XS-side coverage cannot be verified on Node). If XS-side code paths exist, require either a non-stub XS test or an explicit PR-body statement of why it cannot be tested on XS.

**Interim code review (not a substitute for c8 verification):** Based on test-file inspection, the primary validation paths *appear* exercised — shimmed (first-wins shape), absent, accessor, non-function, impostor, and misshapen cases all have dedicated test setups. However, only c8 data confirms whether each branch in `isFirstWinsDescriptor` and `assertSturdyRefShape` actually executes. The edge case of `configurable: true` with otherwise-correct shape has no explicit test fixture, though it is caught by the same error path as other misconfigurations.


</details>

<sub>Panel run record `a2457a2ac5c6` (single-round, gauntlet `ebfb-sturdyref-layer2-ses-20260930-gauntlet` stage panel-5).</sub>
----- END REVIEW -----
