---
ts: 2026-05-22T01:28:44Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - jobs/claimed/20260522T011712Z--endolinbot--steward--dc1b--6ea7be--summary-fix-313.md
---

Summary-fix bundle for PR #313 (barrister-1 panel, 5 items) landed in 4 commits on `feat/patterns-explain-mismatch`.

## Commits (b633a0109 → 94ad8640a)

- `a563128c4` fix(patterns): use countLeaves for compact-format header (items 1 + 2)
- `baf494796` fix(patterns): drop unproduced TraceStep kinds (map/set/bag) (item 3)
- `44326264c` fix(patterns): drop reserved width/color from ExplainMismatchOptions (item 4)
- `94ad8640a` docs(patterns): note throw-and-catch cost on captureRejectMessage (item 5)

Items 1 and 2 share the same expression in `renderCompact`, so they ship together; items 3, 4, 5 each ship in their own commit.

## Verification

- `cd packages/patterns && yarn test test/explain-mismatch.test.js`: 42/42 pass.
- `cd packages/patterns && yarn lint`: 0 errors, 64 pre-existing warnings unchanged.
- pre-push-gates probes: all failures are pre-existing across the repo on unrelated paths (chat package, captp inline-import, missing endo/SECURITY.md, etc.); none invoked by this bundle's diff. Auto-fix stage swept Prettier / eslint nits in unrelated files (better-sqlite3-xs.js, bus-daemon-rust-xs.js, host.js, evasive-transform, hex-test, ses/compartment.js); reverted those to keep this bundle's scope tight.

## PR summary comment

<https://github.com/endojs/endo-but-for-bots/pull/313#issuecomment-4514162522>

Maps each of the 5 items to the addressing SHA, names the verification, and enumerates the out-of-scope followups (mapOf/setOf/bagOf walker, non-throwing matcher accessor, re-introducing width/color when honored).

## PR state

PR #313 remains un-drafted (judge un-drafted on barrister termination; this fixer dispatch is post-un-draft polish per the summary-fix contract). No re-request of review needed: kriscendobot authored the PR and is the steward identity, so the inline `@<login>` mention pattern doesn't apply; the comment serves as the artifact.

Self-improvement: nothing this time. The flow worked exactly as the summary-fix-job contract describes: judge surfaces summary-fix bundle, posts job, fixer claims and ships in one dispatch with no judge re-run.
