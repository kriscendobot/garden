Verified. This job was already completed by a prior claimant of the exact same job base, and I have corroborated the deliverable against the PR diff itself (not merely the preflight hint).

**Corroboration of the directive's single ask** — "This seems extraneous. The importer could import these facets directly" (kriskowal, cid 4066300501, on `packages/sha256/test/browser-entry.js`):

- **Resolving artifact:** PR **endojs/endo-but-for-bots#1328** (`refactor(sha256): inline the browser test entry, drop browser-entry.js`), head `pr1290-inline-browser-entry` @ `d9077c4d`, base `llm-db664fa`, open DRAFT. It carries this job's durable marker `<!-- garden-job: endojs-endo-but-for-bots-pr1290-87327676 -->`.
- **How it satisfies the ask (verified from the actual diff, not the body):**
  - `packages/sha256/test/browser-entry.js` is **removed** (−7 lines, the two re-export lines plus header).
  - The two re-exports (`sha256` from `@endo/sha256`, `sha256Async` from `@endo/sha256/async`) are **inlined** into the sole importer, `browser-test/tests/sha256.spec.js`, as `entrySource` served from a virtual location via the test's `read` power (never written to disk) — so the importer imports the facets directly, exactly as requested, while preserving the package-self-import resolution that gives the browser bundle conditional-export-selection coverage.
- **Thread already updated:** reply 4067990104 on the inline thread announced the landing to kriskowal.

The PR is correctly a draft against `llm` (a follow-up producer PR stops at draft under the manual-gauntlet-trigger regime; #1290 itself had already merged with the file still present). No further edit, push, or duplicate PR is warranted — doing so would violate the anti-duplication contract. Nothing for me to change.

Follow-up (informational, not owned by this job): #1328 awaits a maintainer **run the gauntlet #1328** to review and merge the resolution.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1290-87327676.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 10 on 2 host(s) (3 unmetered)
- Input: 138 tokens (3124839 cached reads)
- Output: 43309 tokens
- Cost: $6.187815499999999 (3 engagement(s) unpriced)
- Wall-clock: 1693s
- Model(s): claude-opus-4-8 ×7

<!-- garden-usage-end -->
