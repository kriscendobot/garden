All asks in the directive are already resolved by a peer's follow-up PR. Corroboration below.

## Completion report

**Directive (single ask):** kriskowal's inline comment (`discussion_r4066300501`) on `packages/sha256/test/browser-entry.js` — "This seems extraneous. The importer could import these facets directly." → drop the committed entry file and have the importer import the two sha256 facets directly.

**Preflight:** exit 2 (HINT). Corroborated, not taken as a licence to close.

**Context:** PR #1290 (`feat(sha256): @endo/sha256/async`) **merged** 2026-09-21T23:57 with `browser-entry.js` still present, so the fix could not be a branch update to #1290 — it had to be a follow-up against `llm`.

**Artifact resolving the ask — PR #1328** (`refactor(sha256): inline the browser test entry, drop browser-entry.js`), verified live via the GitHub API:
- head `pr1290-inline-browser-entry`, base `llm-db664fa` (pinned frozen base), open draft, author kriscendobot, created 2026-09-22T02:25.
- Diff exactly matches the ask: `packages/sha256/test/browser-entry.js` → **removed** (−7); `browser-test/tests/sha256.spec.js` → **modified** (+12/−1), inlining the two re-export lines into the browser test's `read` power as a virtual entry, preserving the `@endo/sha256` / `@endo/sha256/async` self-import resolution the file existed to prove.

**Thread already answered:** the latest inline reply on the same thread (comment id `4067990104`, in_reply_to `4066300501`) posts the resolution and names #1328, describing the identical diff. (An earlier reply `4067459383` had cited "#1326 / 5458bf21d9"; the authoritative final reply corrected it to #1328, which is the PR that actually exists.)

**Conclusion:** genuine no-op. The single ask is satisfied by an existing, verified PR (#1328), and the maintainer's thread already carries the resolution reply. Nothing to build, edit, or push. Inbox empty.

**Follow-up (not owned by this job):** #1328 is an open draft on a pinned base; it still needs a gauntlet + merge to actually land on `llm`. That is ordinary downstream PR lifecycle for #1328, not part of this attention directive.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1290-87327676.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 14 on 2 host(s) (3 unmetered)
- Input: 196 tokens (4352025 cached reads)
- Output: 61070 tokens
- Cost: $8.858991499999998 (3 engagement(s) unpriced)
- Wall-clock: 2140s
- Model(s): claude-opus-4-8 ×11

<!-- garden-usage-end -->
