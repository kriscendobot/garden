---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 303
upstream_mirror_repo: endojs/endo
upstream_mirror_pr: null
created_at: 2026-05-20T00:28:53Z
last_appended_at: 2026-05-20T00:28:53Z
status: parked
---

# Follow-ups for endojs/endo-but-for-bots#303

Created from the code-panel verdict (17 seats, in-band fallback) on the master-base mirror of llm Cuts 1-5 of `designs/break-dev-dependency-cycles.md`. The PR's intent is to stage the cycle-breaking surface for the boatman to ferry to `endojs/endo@master`; the `upstream_mirror_pr` field is null today and will be populated by the boatman's result entry when the ferry lands.

## Items

- [ ] **eslint-plugin-import-x test-condition resolver story**.
  **Source juror(s)**: integrator, archivist (PR-body citation), spec-keeper (resolver-threading observation).
  **Round**: 1.
  **Recommended action**: open a follow-up issue on `endojs/endo-but-for-bots` after PR #303 merges, tracking either an `eslint-plugin-import-x` patch (the upstream switch in master commit `638306eac` introduced `unrs-resolver` which does not honour custom exports conditions) or a documented project rule on how new test-condition exports thread through the resolver. The cleaner already addressed the immediate failure on this PR via `593c518e3`; this follow-up captures the structural lesson so the next package-with-test-condition addition does not relearn it.

- [ ] **Sweep `import/no-unresolved` eslint-disable comments from moved test files**.
  **Source juror(s)**: archivist, stylist, integrator.
  **Round**: 1.
  **Recommended action**: once the test-condition resolver story above is resolved, remove the `/* eslint-disable ... import/no-unresolved */` suppressions from `packages/ses-test/test/{import-hook,import-legacy,import-now-hook,import,module-map-hook,module-map}.test.js`, `packages/ses-test/test/_xs.js`, `packages/eventual-send-test/test/{e,eventual-send}.test.js`, and `packages/eventual-send-test/test/exports.test-d.ts`. Bookkeeping for the same lesson.

- [ ] **`packages/ses-test/scripts/bundle.js` writes into sibling `packages/ses/dist/`**.
  **Source juror(s)**: purist, integrator, decomplector.
  **Round**: 1.
  **Recommended action**: open a follow-up issue on `endojs/endo-but-for-bots` to revisit the cross-package directory walk at `packages/ses-test/scripts/bundle.js:14` (`const root = new URL('../../ses/', import.meta.url).toString();`). The walk works because both packages live under `packages/` and the design accepted it as the price of the cut, but the convention violates "a workspace package's files reach into its own dependencies' public surfaces, not into siblings' filesystems". Consider whether the `@endo/ses-test` build should land its output under `packages/ses-test/dist/` and `packages/ses/dist/` should be repopulated via a copy step (or whether SES's published `files` array should reach into the sibling's `dist/` via a workspace symlink). Settled "considered and accepted" for now; revisit after the cut lands.

- [ ] **Boatman ferry coordination to `endojs/endo@master`**.
  **Source juror(s)**: integrator.
  **Round**: 1.
  **Recommended action**: the boatman ferry to `endojs/endo@master` (the design's stated terminal destination) will need to verify the upstream tree is sufficiently close to the bot fork's master that the ferried diff applies cleanly. Three of the four llm-side Cuts (2, 4, 5) merged on the bot fork's `llm` branch only; this PR is the master-base mirror prepared so the boatman can carry one consolidated PR upstream. Surface this to the steward at ferry-staging time so the boatman has full context.
