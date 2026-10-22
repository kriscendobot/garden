---
handed-off: endojs-endo-but-for-bots-no-any-typecheck-split
deliverable-complete: false
---
I didn't open the draft PR. GitHub refused it from this host: the bot's PAT returns `Resource not accessible by personal access token (createPullRequest)` on endojs. The work itself is finished and pushed, and opening the PR is now a parked child job pinned to a host whose token can. This attempt hit the handler time limit, so as the split protocol requires, I handed the rest off as a one-child orchestration.

**Pushed:** branch `no-explicit-any-ratchet` on endojs/endo-but-for-bots at `6b4326a11`, two commits on the frozen base `llm-54d3d2a`.
- **Lint rule:** `jsdoc/reject-any-type` and `@typescript-eslint/no-explicit-any` are now errors in `@endo/eslint-plugin`'s monorepo-only `internal` / `flat/internal` configs. The JSDoc rule catches `{any}`, `{*}` and `any` nested inside another type, including the #1393 `Map<number, any>` cast. Before this, `style` turned it off and nothing turned it back on.
  - The `recommended`, `strict` and `style` configs other projects use are unchanged, and nothing existing was weakened.
  - Config tests and a `minor` changeset are included.
- **Existing uses:** 4,976 explicit `any`s in 990 files (2,944 in source, 2,032 in tests, 94 package directories). That is too many for one rewrite, so I added a ratchet:
  - `eslint-no-explicit-any-baseline.json` lists each existing file with its count, and the root `eslint.config.js` turns both rules off for exactly those files.
  - I used a baseline file instead of ESLint's built-in suppressions file because that file only takes effect when ESLint runs from the repo root. It would be ignored by the 128 per-package lint scripts and by editors.
- **CI check:** `scripts/check-no-explicit-any.mjs` runs as `yarn lint:no-any`, now part of `yarn lint`, which CI's lint job runs. It fails if a listed file's count goes up, if any other file has an `any`, or if a count goes down without the baseline being lowered. Its `--update` will not raise any count, so the baseline can only shrink.
- **Verified here:** full-repo `yarn lint:eslint` exits 0, the baseline check passes, and the eslint-plugin tests pass (154). Adding one `any` to a listed file is rejected by both the check and `--update`. A new `any` is also caught when ESLint runs from inside a single package.

**Handoff (recorded in the journal):**
- Orchestration `endojs-endo-but-for-bots-no-any-typecheck-split`: serial, halts on child failure.
- Its single parked child, `endojs-endo-but-for-bots-no-any-typecheck-expanded-window`, has `requires: host=endolin-garden-ece02cb4` (I checked that the pin parses), a 3600s handler timeout, and a split reason saying the PR can only be opened from that host.
- The child opens the draft PR through `ensure-pr.sh`, against `llm-54d3d2a`. It reuses this job's base and PR marker so the PR stays discoverable. The PR body is stored verbatim in the child and already follows the repo's PR template.

**Open question for the maintainer, in the PR body:** this only covers `any` written out explicitly. TypeScript still infers `any` silently because `noImplicitAny` is `false` in the shared tsconfig, and the existing `type-coverage` floors are not run in CI. Closing that is a separate follow-up, and the PR asks kriskowal whether to do it and how.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-no-any-typecheck.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 24 tokens (1611708 cached reads)
- Output: 6057 tokens
- Cost: $4.1604738 (1 engagement(s) unpriced)
- Wall-clock: 2664s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
