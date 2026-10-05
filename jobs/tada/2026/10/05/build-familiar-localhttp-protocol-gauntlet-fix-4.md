Fix round 4 for endojs/endo-but-for-bots#1426 is pushed and CI is green: all 32 checks passed on the new head `418e769679` (`ci-wait-merge` rc 0).

**What I fixed** (one follow-up commit, pushed with `safe-push-pr-head.sh` as a fast-forward from `0b87f8828a`):
- **archivist (must-fix):** `designs/familiar-localhttp-protocol.md` said the Chat-page URL match ignores only the fragment. It now says it ignores the query and the fragment, which matches what `pageIdentity` does.
- **pruner (must-fix):** the JSDoc on `makeSecurityWarningBanner` only repeated the types. It now explains how the dismissal state survives page-body replacements and why the document is passed in as a parameter.
- **scribe (must-fix):** none of the four fix pushes had a top-level summary comment. I posted one covering all four rounds, listing what was fixed, what was deferred and what was verified: https://github.com/endojs/endo-but-for-bots/pull/1426#issuecomment-5996287237
- **Smaller panel suggestions I also took:**
  - `designs/README.md`: bumped the design's Updated date to 2026-10-05.
  - `preload.mjs`: added a comment on why the channel name is written out rather than imported. The existing test checks the two names match.
  - New banner test: after a dismissal, a completely new set of warnings replaces the old set and is shown.

Locally, the chat banner tests (10) and the familiar security-warnings and preload tests (13) pass, and Prettier is clean. ESLint skips `preload.mjs` because of an ignore pattern, so that file wasn't linted.

**Deferred** (none of these were must-fix; all are listed in the PR comment):
- Regrouping the commits into logical commits before un-drafting. This needs a history rewrite, so it belongs to the un-draft or retcon step.
- Building the Chat URL with `pathToFileURL`, plus a test with a Windows drive-letter path. That bug predates this PR.
- fast-check property tests, which would add a new devDependency to two packages.
- A replay test for an empty warning list in the preload. The main process never sends an empty list.

I did not re-run the panel; the driver posts panel-5 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-familiar-localhttp-protocol-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1173432 cached reads)
- Output: 6682 tokens
- Cost: $0.8710703999999998
- Wall-clock: 596s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
