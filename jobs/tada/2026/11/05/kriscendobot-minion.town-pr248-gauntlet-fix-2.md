Fix round 2 for kriscendobot/minion.town#248 is pushed and CI is green (6 of 6 checks passed, `ci-wait-merge` exit 0).

I worked from the latest panel review (5779515194) and applied each finding:

- **saboteur / breaker (wrong "No clips yet." title):**
  - **The bug:** a 401/403 answer, a redirect, bad JSON, a malformed `clips` shape, or entries that were all invalid each came back as `[]`. The empty pane then told the user they had no clips when we didn't actually know.
  - **The fix:** in `deploy/aws/www/shell.js`, `clipRecordsFromListing` now records which empty results came from a well-formed `{ clips: [] }` answer. `emptyPaneTitle` shows "No clips yet." only for those; every other case shows "No clip selected.".
  - **Unchanged:** all those cases still clear the gutter as before.
  - **New tests:** a unit test runs every `ClipSource.load()` outcome through `emptyPaneTitle`, and the browser gate has a new check that a 403 listing does not claim the account is empty.
- **fast-checker:** added a fast-check property (1000 runs) checking that "No clips yet." appears for exactly the well-formed empty listings and no others.
- **prover:** removed the `{ clips: [] }` assertion from `test/new-clip-daemon.test.ts`, since that endpoint isn't changed by this PR.
- **stylist:** renamed `answerListing` to `pendingListingRoute` in `test/browser/clip-frame-gate.ts`.
- **packager / changeset-auditor:** added `.changeset/empty-gutter.md` (`minion-town`, minor) describing the empty fresh gutter and the new pane titles.
- **pruner:** in the PR description, cut the paragraph about the related PRs (#201 / #179) and replaced the Verification checklist with a pointer to the CI browser-gate workflow.
- **coverage-auditor:** the PR description now says the browser coverage is the existing Playwright gate, which CI runs in Chromium, Firefox and WebKit. `dev/new-clip-browser-demo.mjs` is a dev-only demo, so it gets no `browser-test/` case.

Two commits were pushed with `safe-push-pr-head.sh` (`20a8b7fb` → `30c6ead0`): `730df4f1` (the fix, tests and rename) and `30c6ead0` (the changeset).

Before pushing, locally: `test/shell-clip.test.ts` passed 100 of 100, `tsc --noEmit` was clean, and the browser gate passed 38 of 38 in Chromium. I did not run Prettier on the changed files, because `shell.js` on main isn't Prettier-formatted either.

No follow-ups; the driver re-posts the panel for round 3.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr248-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1425092 cached reads)
- Output: 11673 tokens
- Cost: $1.1263984000000002
- Wall-clock: 682s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
