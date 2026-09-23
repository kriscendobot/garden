---
ts: 2026-05-14T01:07:04Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
refs:
  - entries/2026/05/14/005552Z-dispatch-liaison-b04e93.md
  - entries/2026/05/14/010511Z-result-builder-48a8a1.md
prs:
  - repo: endojs/ocapn-test-suite
    pr: 1
    role: related
---

# Dispatch: builder updates endo-but-for-bots to consume the patched ocapn-test-suite

Dispatch root: `dispatches/builder--consume-syrups-framed-ocapn-tests--20260514-010703--a05cbb/`. Project worktree at `endojs/endo-but-for-bots@llm`. Second stage of the syrups-framing chain; the first builder landed `endojs/ocapn-test-suite#1` (head `89e80d70cf0689fce0b92936f22a84b02e9e1aee` on branch `feat/syrups-framing`).

## Per-action authorization

Standing authorization on endo-but-for-bots (`journal/README.md` § Pre-staged authorizations, 2026-05-13): the builder may push branches and comment freely on this repo.

## Task

Update endo-but-for-bots's consumption of the ocapn-test-suite to point at the patched branch on `endojs/ocapn-test-suite`. Validate that `@endo/syrups` round-trips correctly with the patched test suite's framing.

Procedure:

1. Locate the test-suite consumption. The bot's pre-grant analysis on endo-but-for-bots#109 (visible via the journal's project-tagged entries) identified the test-suite usage path. Likely candidates:
   - A git submodule at `<some-path>/ocapn-test-suite`.
   - A git-pinned dependency in a `package.json` (`"ocapn-test-suite": "github:endojs/ocapn-test-suite#..."`).
   - A vendored copy that needs a manual sync.
   - Test fixtures referencing the upstream repo by URL.

   Inspect: `git -C project grep -l 'ocapn-test-suite' --untracked` and `find project -name '.gitmodules' -exec cat {} \;` to locate.

2. Update the consumption to pin at `endojs/ocapn-test-suite:feat/syrups-framing` at SHA `89e80d70cf0689fce0b92936f22a84b02e9e1aee`. The exact mechanism depends on what you find in step 1.

3. Run the syrups-relevant tests locally (those that round-trip messages through the test-suite vectors). The validation goal: confirm @endo/syrups handles the OCapN test vectors when both ends use the consistent framing.

4. Identity kriscendobot. Per pr-creation-flow: open in **draft**. Topic branch `feat/syrups-ocapn-framing` (or similar; conventional-commits style).

5. Open the PR against `endojs/endo-but-for-bots:llm`. Title: `feat(syrups,ocapn): consume patched ocapn-test-suite (syrups framing)` or similar. Body cites the maintainer's request, the source PR (endojs/ocapn-test-suite#1), and the end-to-end validation result. Per pr-formation skill: use the github PR template; no checklists; no file-level callouts.

## Out of scope

- No edits to `@endo/syrups` or the test suite itself.
- No new PR on endojs/ocapn-test-suite.
- No watching CI in this dispatch; shepherd handles that as a follow-up if the maintainer asks.

## Report

PR URL, the consumption mechanism you found (submodule / git-pinned dep / vendored / etc.), the local-validation outcome (which syrups tests passed / failed against the patched test vectors), and a one-line verdict: "does @endo/syrups round-trip cleanly under the new framing?".
