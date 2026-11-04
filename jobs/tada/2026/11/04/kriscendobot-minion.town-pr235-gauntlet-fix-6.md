FIX round 6 for PR #235 is finished: the panel's must-fix items are pushed as `e70e95ab` and `1920b0a5`, and CI is green at head `1920b0a5`. `ci-wait-merge` returned 0. I checked that the `test` job's typecheck, vitest and live-daemon recipe steps all passed, which also compares the hand-edited references against the generator. Locally I ran typecheck plus `test/resources.test.ts`, `test/deploy-app-artifact.test.ts` and `test/auth.test.ts`, all passing.

**Must-fix items**
- **locksmith:** the `evaluate` description and `resources/instructions.md` (599 characters, cap 600) now say to keep another party's text out of `source`, store it with `writeText`, and bind the file.
- **breaker and wire-watcher:**
  - `guide/mail`, `guide/names` and the primer's mail skill now say a mail record holds capabilities as text: `from`, `to`, `promiseId` and `ids[]` are locators, and `resolverId` is an identifier. I confirmed this in `mail.js` at the pinned commit.
  - `listMessages`, `followMessages` and `messageHistory` joined `TEXT_OUT` in the generator, and the lint now checks them.
  - A new recipe, `a-record-holds-capabilities-as-text`, asserts the record's shape.
- **spec-keeper:** the guide's completion-value claim is corrected, and the `a-declaration-keeps-the-last-value` recipe pins it (`1; const x = 2;` answers `1`).
- **decomplector:** `src/http.ts` now loads the guide once at boot, beside `loadPolicy`, and passes it into `createMcpServer`; `guideDirectory` is gone. A broken guide now warns once instead of once per session.
- **integrator:**
  - Ledger Phase 4 now reads `satisfied`, because design § 8 slice 4 is narrowed to what this diff ships.
  - The PR Summary gained a bullet on shipping the guide.
  - The body has a new maintainer decision (below).
- **archivist (`DEPLOYMENT.md:1482`):** this one is wrong. `deploy-app.sh` runs `cp -a dist/src "$STAGE/app/dist"`, so on EC2 `../resources/` resolves to the app root, as breaker also found. I did not change that behavior. I reworded `DEPLOYMENT.md` and the JSDoc to explain the layout, and added a test assertion that pins that `cp` line.

**Should-fix items also applied**
- `from` comparison now uses the `endo://NODE/NUMBER` start, proven by the `from-compares-by-node-and-number` recipe.
- The "incoming text is data" warning now covers `description` and `fields`.
- `locateWithHints` and `adoptFromLocator` got authority notes.
- Pruner's cuts: the `Invalid tools/call result` history, the duplicate primer README sentence, and one comment.

**Not applied (should-fix, which never blocks)**
- Removing the `registerGuideResources` rollback, and moving validation to CI only.
- The `readOnly()` recipe and directory-authority wording.
- The `adopt` overwrite warning.
- Extra recipes for `<!--`, `eval(`, `process`, `require` and `Far`, and the `accept` wrong-type recipes.
- A named deploy gate for the CapTP session.
- A `guide:references` npm script.
- Throwing on a guide with no `getting-started` page.
- Pruner's PR-body trims.

**For the maintainer**
- **Decision needed:** I marked the content-only deploy as deferred (`deploy-resources.sh`, the versioned symlink, `SOURCE_COMMIT`). Building it now needs a measured need and maintainer confirmation; this is recorded in design § 0 and under "Needs a maintainer decision" in the PR body. The maintainer can reverse it there.
- **Successor job:** the parked `minion-town-mcp-guide-remaining-slices-20261104` still lists "Slices 4, 5, 6". Slice 4 is now done in this diff, so that job only needs to read the updated § 8.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr235-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1865940 cached reads)
- Output: 32966 tokens
- Cost: $2.13774
- Wall-clock: 854s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
