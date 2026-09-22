Inbox empty. The work is complete.

## Completion report

**Directive:** kriskowal's inline review on endojs/endo-but-for-bots #1290 ([discussion_r4066300501](https://github.com/endojs/endo-but-for-bots/pull/1290#discussion_r4066300501)): *"This seems extraneous. The importer could import these facets directly."* — re `packages/sha256/test/browser-entry.js`.

**Preflight:** exited 2 (HINT). I corroborated rather than trusting it.

**What I found (corroborated against real artifacts):**
- #1290 already **MERGED** (as `38cce7ebba`) with the fixture file still present, so the resolution had to land as a follow-up against `llm`.
- The single ask — drop the extraneous `browser-entry.js`, let the importer pull the facets directly — was **already resolved**, and in fact **twice in parallel** by two peer gardeners on different hosts:
  - **#1326** (`sha256-browser-entry-inline-1290-followup`, other host, created 00:05Z)
  - **#1328** (`pr1290-inline-browser-entry`, this host, created 02:25Z)
- I read both diffs: each deletes `packages/sha256/test/browser-entry.js` and inlines its two re-export lines (`sha256` from `@endo/sha256`, `sha256Async` from `@endo/sha256/async`) into `browser-test/tests/sha256.spec.js`, served via the bundle's `read` power at a **virtual** location under `packages/sha256/test/`. Both preserve the package self-imports (so the bundle still proves `browser`-condition selection) and both were **MERGEABLE / CLEAN**. Functionally identical.

**Residual issue = the duplicate.** The real work-to-route was consolidation, not re-doing a resolved fix. #1290's review thread already announces **#1328** as the landing PR (reply id 4067990104), so I kept #1328 and **closed #1326** as a duplicate with an explanatory comment (thread-consistent, reversible; noted the diffs are equivalent and to reopen if #1328 should be the one closed instead).

**Net state:** feedback resolved by open, clean, mergeable **#1328**; duplicate #1326 closed. No third duplicate exists. I opened no new PR (a third would have compounded the problem).

**Follow-ups:** #1328 awaits maintainer review/merge — normal course, no action owed by this job.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1290-87327676.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 7 on 2 host(s) (3 unmetered)
- Input: 102 tokens (2448666 cached reads)
- Output: 31695 tokens
- Cost: $3.7838070000000004 (3 engagement(s) unpriced)
- Wall-clock: 1391s
- Model(s): claude-opus-4-8 ×4

<!-- garden-usage-end -->
