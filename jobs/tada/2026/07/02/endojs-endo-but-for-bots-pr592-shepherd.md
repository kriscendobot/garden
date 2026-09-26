Empty inbox. My shepherd work is complete: diagnosed, attributed, escalated. Nothing to push (no shepherd-scope fix exists for this impasse).

## Shepherd report — endojs/endo-but-for-bots PR #592

**Live CI state (re-fetched):** 24 of 25 checks green. One red: `lint` (CI workflow), a COMPLETED FAILURE with **5 errors, 2551 warnings** (warnings don't fail; the 5 errors do).

**Root cause — the documented lint-infra projectService scaling ceiling, not this PR:**
All 5 errors are identical parsing errors on the alphabetically-last package `packages/zip` (`reader.js`, `src/deflate.js`, `src/inflate.js`, `test/zip.test.js`, `writer.js`): *"ESLint was configured to run … using `parserOptions.project` … none of those TSConfigs include this file."* This is the exact typescript-eslint `useProjectService` ceiling signature previously investigated on #548/#590.

Attribution (confirmed it is NOT the PR's diff):
- PR #592 is **6 files**, based **directly on `llm`** (1 commit, not stacked), touching only `packages/platform` + `packages/daemon`. It touches **nothing** in `packages/zip`.
- The `platform/package.json` change adds only an export subpath (`./fs/node/watch-directory`) — **no new cross-package dependency**.
- Even this tiny addition tips `zip` over the whole-repo `eslint .` ceiling ⇒ the **`llm` baseline is already at the ceiling**. The same failure is live on #590 (the ~250-file `@endo/far` repoint) and #593; smaller PRs (#586/#588/#589) remain green.

**Why no fix was pushed:** This is a hard impasse per the shepherd's *structural decision* escalation and the standing lint-infra guidance. Config knobs were tried and reverted in the prior investigation (pointing `defaultProject` at `tsconfig.eslint-full.json` had no effect; a single explicit `project` traded these errors for a broader "file not found" set). The real fix is lint-infra scope (consolidate per-package lint projects into one program, or raise/bypass the ceiling) and must not be bundled into a refactor PR. PR #592 was left untouched — its substance is sound and there is no shepherd-scope repair.

**Escalation:** `next: liaison` — needs a human/lint-infra decision. Surfaced once to the maintainer inbox via the liaison (delivered `20260702T004314Z-b798c5`), noting it now blocks at least 3 open bot PRs (#590/#592/#593) and likely wants its own lint-infra job.

**Follow-ups:** No existing journal job tracks the projectService ceiling specifically; a dedicated lint-infra job to consolidate/raise the projectService program limit is the durable fix. Until then, large-ish bot PRs against `llm` will keep going red on the `packages/zip` parsing errors.
