I finished the partly addressed review on endojs/endo-but-for-bots#599: the browser tests are enabled and pass in a real browser, and CI is green on the new head `8080dac5e5`.

**What I found.** The `window.__testHarness` that the formula-inspector e2e spec relied on had never been built. That is why all ten cases, including the four retention-path ones, were marked `test.fixme`. The fixture also couldn't have worked as written:
- Its `eval-id-1`-style ids are not real formula ids, so the back face can't build the `endo://` locator it asks the host for.
- `keypair` is not a type a locator accepts, so the "unretained" case would have shown an error instead of the empty state.
- Opening a named value focuses the rename input, which swallows the `F` key.

**What I changed** (pushed to `formula-inspector-retention-paths-table`, three commits from `d9395b31aa` to `8080dac5e5`):
- **Harness page** (`packages/chat/test/e2e/harness/formula-inspector.{html,js}`): mounts the real Value modal with the app's lockdown and stylesheet, against a fake host built from a fixture. `setFixture({ names, formulas, retentionPaths })` loads the data, and `calls` records every host call. Each fixture row's inspect button opens the value the same way the inventory does.
- **Runner**: a plain Vite server (`harness/serve.mjs`) and a separate `playwright.harness.config.ts`, run with `yarn test:e2e:harness`. No Endo daemon is needed. The daemon-backed `playwright.config.ts` now skips this spec.
- **Spec**: uses well-formed ids, an `eval` value for the empty state, and moves focus off the rename input before pressing `F`. It also checks that the table requested the `endo://…?type=eval` locator, not the bare id. All ten cases are enabled (the four retention ones plus the six earlier back-face ones), and the e2e README documents the harness.
- **Lint**: CI lints the merge with `llm`, which rejects declaring built-in globals. I removed a redundant `/* global globalThis */` from this PR's `retention-paths-view.test.js` (lint was already failing on it before my change) and the `process` declaration from my `serve.mjs`.

**Evidence.**
- Headless Chromium: 10 passed.
- Mutation checks: the count case fails when given a wrong expected count, and the scroll case fails when the list's `max-height` is removed.
- Rendered DOM after flipping to the back face:
  - `my-eval`: count badge 1, one path, pet edge `"my-eval"`, inspected id highlighted, list height 119/119 px.
  - `my-hub`: count badge 12, twelve paths, list 240 px tall with 1196 px of content, so it scrolls.
- I checked a screenshot, and posted the evidence table on the PR: https://github.com/endojs/endo-but-for-bots/pull/599#issuecomment-6242108103
- No changes to the garden repo, so nothing was pushed to `main2`. The arc/milestone classification (unallocated, M9) is unchanged.

**Follow-ups:**
- CI does not run `packages/chat`'s e2e suites (`browser-test.yml` only runs `browser-test/`), so this suite currently runs only locally, like its siblings. Wiring `yarn test:e2e:harness` into CI would be a separate change.
- This branch still uses the older ESLint config while `llm` (which CI merges with) uses the newer one, so local lint on the branch head disagrees with CI about global declarations.
- To run Playwright 1.59.1 locally I installed Chromium build 1217 into the shared Playwright cache.
- The existing `test:item-actions` runner fails with an HTTP 500. I didn't investigate it.

## Manual gauntlet handoff

The completion guard found https://github.com/endojs/endo-but-for-bots/pull/599 ready without gauntlet coverage. A deduplicated review-docket decision was recorded; the PR was not re-drafted and no gauntlet was staged.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr599-address-review-20261007.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 162 tokens (10288007 cached reads)
- Output: 39681 tokens
- Cost: $4.157645400000001
- Wall-clock: 2410s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
