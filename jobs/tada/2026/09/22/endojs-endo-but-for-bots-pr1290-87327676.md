Verified. This is a no-op completion — the work was already done durably by a prior claimant of **this same job base** (a reaper requeue after PR #1290 had merged with the file still present).

## Report

**Directive** (PR #1290, inline comment `4066300501` by kriskowal, on `packages/sha256/test/browser-entry.js`): *"This seems extraneous. The importer could import these facets directly."*

**Single ask — resolved.** Artifact: **PR endojs/endo-but-for-bots#1328** — "refactor(sha256): inline the browser test entry, drop browser-entry.js", open DRAFT, base `llm-db664fa`, head `pr1290-inline-browser-entry` @ `d9077c4d`. It carries this job's durable marker (`<!-- garden-job: endojs-endo-but-for-bots-pr1290-87327676 -->`), confirming it was opened under this exact base.

How it satisfies the ask (corroborated against the actual diff, not just the preflight hint):
- **Deletes** `packages/sha256/test/browser-entry.js` (the flagged extraneous file, −7).
- **Inlines** its two re-export lines (`sha256` from `@endo/sha256`, `sha256Async` from `@endo/sha256/async`) into `browser-test/tests/sha256.spec.js` as a virtual `entrySource`, served through the test's `read` power at `entryLocation` (never written to disk). The importer now constructs the entry directly, exactly as the directive requested, while preserving both properties (combined-arm bundle + conditional-export-selection coverage via package self-imports).

**Board/GitHub state:**
- Preflight exited 2 (HINT) — corroborated: inline reply `4067990104` announces the landing pointing at #1328.
- #1290 itself is already closed/merged; the fix correctly lives in the follow-up #1328 against `llm`.
- #1328 is DRAFT, which is correct under the manual-gauntlet-trigger regime — it awaits a maintainer **run the gauntlet #1328** for promotion.

**No changes made by me** (no worktree edits, no new PR, no duplicate reply — the thread already has the landing announcement). Nothing to commit.

**Follow-up for the maintainer:** promote #1328 with **run the gauntlet #1328** when ready to review/merge it.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1290-87327676.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 6 on 2 host(s) (3 unmetered)
- Input: 78 tokens (1892186 cached reads)
- Output: 22648 tokens
- Cost: $2.8062770000000006 (3 engagement(s) unpriced)
- Wall-clock: 1187s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
