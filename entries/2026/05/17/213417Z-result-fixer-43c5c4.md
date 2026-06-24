---
ts: 2026-05-17T21:34:17Z
kind: result
role: fixer
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 239
    role: target
  - repo: endojs/endo
    pr: 1967
    role: source
refs:
  - entries/2026/05/13/213822Z-result-weaver-4672b0.md
  - entries/2026/05/15/030128Z-result-investigator-9a5955.md
---

# Result: fixer investigation on PR #239 (no push; surface to liaison)

Verdict: **the red CI is the point.** PR #239 is the mirror of endojs/endo#1967, an "**Evaluation only; do not merge**" regression test for the unfixed security blocker endojs/endo#629 (open since 2024-01-16, no production fix landed). The 8 failing matrix entries (every `test (<node>, <os>)` cell) share the same three failures inside the `compartment-mapper` test set, and all three are intended outcomes of the evaluation, not fixable test bugs.

This finding ratifies and refines the investigator's prior classification at `entries/2026/05/15/030128Z-result-investigator-9a5955.md` (which named #239 as "the regression mirror; the red is the point"). No push to `mirror/endo-1967`; no PR comments (none authorized). Next step is **not** judge.

## What failed, in three buckets

1. **`compartment-mapper › map-node-modules.test.js › mapNodeModules() should be idempotent for fixtures-policy/node_modules/app/index.js`** (snapshot mismatch).
   - Cause: PR #239 adds the `eve/node_modules/alice/` fixture (bundled dependency name collision). The fixture now legitimately surfaces an `eve>alice` compartment with `policy: {}` (no powers granted, exactly what the security test wants to demonstrate). The saved `snapshots/map-node-modules.test.js.{md,snap}` predates the fixture and omits this compartment. Locally, `ava --update-snapshots test/map-node-modules.test.js` regenerates the snapshot cleanly: a 30-line addition under the `fixtures-policy` block describing the new `eve>alice` compartment.
   - Why not push the regen: the snapshot diff is novel evidence (the regenerated content shows the bundled alice gets its own compartment with `policy: {}`, which is the security-positive outcome of the test). The maintainer's evaluation specifically wants to see this; collapsing it into a committed snapshot file removes the signal from CI's diff output. Decision deferred to liaison/maintainer.

2. **`compartment-mapper › policy.test.js › policy - attack - duplicated name via bundled dep / writeArchive / importArchive`** with error `The bundler and importer should agree on source map count but they differ by 1`.
   - Acknowledged in the upstream PR body: *"passing locally with one error from sourcemap count mismatch in archive that should not be related to this. keeping it in draft for that reason."* The fixture adds a new module (`eve/node_modules/alice/index.js`) whose source map is emitted by the bundler but not consumed by the importer (or vice versa); the source-map-pair accounting in `scaffold.js`'s `sourceMapHook` / `computeSourceMapLocation` notices the leftover. Real signal about archive source-map handling, not a test bug.

3. **`compartment-mapper › policy.test.js › policy - attack - duplicated name via bundled dep / makeArchive / parseArchive / hashArchive consistency`** with error `Archive contains extraneous files: ["myattenuator-v1.0.0/index.js"] in "memory:app.agar"`.
   - The archive emitted by `makeArchive` contains `myattenuator/index.js` (an attenuator referenced by the eve-policy used in this scaffold call), but the compartment map handed to `parseArchive` does not include the corresponding compartment, so `parseArchive` flags the file as extraneous and refuses. Same kind of "archive-vs-map disagreement" failure as #2: the new fixture's policy shape exposes a real archive/map-consistency gap in the production code path. Not a test bug.

## Local reproduction

`corepack yarn install && cd packages/compartment-mapper && corepack yarn test test/policy.test.js`:
- 2 of 2 archive failures reproduce identically to CI (`writeArchive/importArchive` source-map count, `makeArchive/parseArchive/hashArchive consistency` extraneous-file).
- The map-node-modules snapshot failure does NOT reproduce when running only `test/policy.test.js`; it reproduces in `corepack yarn test test/map-node-modules.test.js`. CI runs the full suite, which is why CI showed three failures.

Running on master without the PR's diff: 125 policy-test passes, no archive or snapshot failures. Confirms the failures are caused by the PR's new fixtures, not pre-existing fork drift.

## Why the four bucket of "decisions" all map to "surface, don't act"

Per the dispatch's decision tree:

- **Missing production fix?** Yes, but endojs/endo#629 is an open security blocker since 2024-01-16 with no upstream fix to cherry-pick. Architecting the fix from scratch is **far** beyond a fixer dispatch's scope and would defeat the evaluation's purpose (the maintainer wants to see what fails *before* a fix lands, so the eventual fix can be measured against this exact baseline).
- **Test bug?** Failure 1 (snapshot) is a snapshot regen, marginal call. Failures 2 and 3 are real signal about archive/source-map handling exposed by the new fixture; "fixing" them would mean either silencing assertions (forbidden by `roles/fixer/AGENT.md` § *"When the failing CI signal IS the PR ... do not silence the signal"*) or hand-patching production code (out of scope; would defeat the evaluation).
- **Environment issue?** No. Locally reproduces deterministically across runs.

## What the orchestrator should do next

`pr-creation-flow`'s next-stage-owed of **judge (code panel)** does not apply here, because the PR was explicitly opened as an evaluation mirror with red CI as the deliverable. Three reasonable paths for the liaison:

1. **Park.** Leave PR #239 in draft as-is; the failures *are* the deliverable. The maintainer can read the CI logs at leisure when they get to #629. Comment authorization would help (a top-level summary citing the three failure signatures + my analysis here), but the dispatch did not authorize one.
2. **Regen the snapshot and re-push.** Removes failure #1 from CI without silencing anything (the snapshot now captures the security-positive outcome: `eve>alice` compartment with `policy: {}`). Leaves the load-bearing failures #2 and #3 as the residual signal. Cleaner CI surface, slightly less self-documenting (the diff is in the snapshot file rather than the CI log).
3. **Close the PR without merging, with a maintainer-visible note that the evaluation is captured in this journal entry.** Frees the bot's PR-flow queue from churning over a permanently red draft.

My recommendation, weakly, is (1) park: the upstream PR has been sitting on the same red signal for 2 years; adding a journal-side analysis that the liaison can ferry to the maintainer in a Bulletin item is more valuable than mutating the PR.

## Files / refs

- Source PR body (verbatim "Evaluation only; do not merge"): `gh pr view 239 -R endojs/endo-but-for-bots`.
- Upstream source PR: `gh pr view 1967 -R endojs/endo` (state OPEN, draft, last touched 2024-01-16 by naugtur).
- Security issue: `gh issue view 629 -R endojs/endo` (labels: `security blocker`, `design`, `lavamoat`, `kriskowal-review-2024-01`, `metamask`).
- Prior chain entries: weaver `213822Z-result-weaver-4672b0.md` (rebase verdict), builder `212427Z-result-builder-f4b50a.md` (conflict survey), investigator `030128Z-result-investigator-9a5955.md` (CI cluster table).

## Self-improvement

Self-improvement: nothing role-level this time. One craft note worth surfacing: the fixer-role decision tree in the dispatch task ("missing production fix / test bug / environment issue") implicitly assumes the PR's red is **unintentional**, but evaluation-only mirror PRs invert that (their red IS the deliverable). The investigator skill's pattern of naming an "intentional" cluster (per `030128Z-result-investigator-9a5955.md`'s table) is the dual of this rule on the orchestrator side. If `pr-creation-flow` or the fixer role file grew a small explicit rule for "the PR was opened with the red as deliverable; the fixer's job is to confirm the red is the *intended* red and surface, not to drive it green," future fixer dispatches on evaluation mirrors would avoid the dead-end "try to fix, can't, surface" trip. Routing this as a `message` entry to liaison so the role-author can decide whether the lesson is large enough to land.
