The feedback on PR #1290 has already been fully resolved by peers. I've corroborated the single ask against concrete artifacts rather than inferring from the preflight hint.

**Directive (single ask):** kriskowal's inline comment (`4066300501` on `packages/sha256/test/browser-entry.js`) — *"This seems extraneous. The importer could import these facets directly."* → remove the extraneous fixture module.

**Corroboration — artifact that resolves it:**
- **PR #1328** (open, `endojs/endo-but-for-bots`, head `pr1290-inline-browser-entry` @ `d9077c4`, base `llm-db664fa`) deletes `packages/sha256/test/browser-entry.js` (−7) and inlines its two re-export lines into `browser-test/tests/sha256.spec.js`'s `read` power (+12/−1), serving the entry from a virtual location under `packages/sha256/test/`. Verified via `gh api pulls/1328/files`: the file is `status: removed`. This directly does what kriskowal asked — the importer now pulls the `@endo/sha256` / `@endo/sha256/async` facets directly through the test's read hook, with no committed fixture module.
- The follow-up route (rather than a branch update) is correct: **#1290 already merged** with the file present, so the fix could not land on its branch.
- An earlier attempt, **#1326** (base `llm-38cce7e`), made the same change but is now **closed** (superseded by #1328 against the newer pinned base).
- The inline thread already carries the peer's resolution reply **`4067990104`** (`in_reply_to=4066300501`): *"Landed as endojs/endo-but-for-bots#1328 … browser-entry.js is deleted, its two re-export lines inlined into the browser test's read power."*

Because the ask is fully satisfied by an existing, open, correctly-scoped follow-up (#1328) and the maintainer-facing inline reply is already posted, this attention directive is a no-op — no further edit, PR, or reply is warranted (a duplicate reply would be noise).

**Follow-up (not owned by this job):** #1328 is open and pending its own review/merge on the `llm` line; that lands through its normal gauntlet, independent of this attention directive.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1290-87327676.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 9 on 2 host(s) (3 unmetered)
- Input: 126 tokens (2911183 cached reads)
- Output: 39801 tokens
- Cost: $5.2950985 (3 engagement(s) unpriced)
- Wall-clock: 1607s
- Model(s): claude-opus-4-8 ×6

<!-- garden-usage-end -->
