Panel round 1 on endojs/endo-but-for-bots#1426 came back **must-fix**. `panel.sh` exited 0, so this is a real verdict, not a panel error.

- **Setup:** I made an isolated project checkout of head `feat/familiar-security-warning-banner` @ `d9acaed022` and ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` against the frozen base `llm-395c485`. I passed the explicit base SHA `395c48558460c12a553f17ecde15fbfe095e4715`.
- **Seats asking for changes (8 of 33):**
  - **typist:** `security-warning-banner.test.js` uses an inline JSDoc `import()` type where it should use a top-of-file `@import`.
  - **coverage-auditor:** no test checks that the two new `deliverSecurityWarnings` calls in `electron-main.js` actually happen.
  - **locksmith, integrator, changeset-auditor, pruner** (it reviewed the PR description for concision), **corner-prober** and **releaser** also asked for changes.
  - The other 25 seats approved or left comments only. Assessor's comment is worth acting on: a stale code sample remains at `designs/familiar-localhttp-protocol.md:520`.
- **Review posted:** https://github.com/endojs/endo-but-for-bots/pull/1426#pullrequestreview-5414624070
  - It went up as a **COMMENTED** review, not a request-changes one, because GitHub won't let the bot request changes on its own PR. The body says "must-fix" plainly and ends with `<!-- garden-panel-verdict: must-fix round=1 -->`. If the next-stage heuristic only looks at the review state, it will miss that; it needs to read the body.
  - The full verdict text ran to about 76KB, over GitHub's limit for a review body. The blocks for all 8 seats asking for changes are posted first, in full. I left out 10 blocks from seats that approved or only commented, and the review names them. The full text is in `$TMPDIR/garden-panel-project-wt-build-f-4fc7dff91a9e-e07ec699-1426/round-1.md`, which is scratch.

**Follow-up for the garden:** panel stages on bot-authored PRs can't post a request-changes review. Either the instructions this stage receives should say to post a comment review, or the fix stage should be confirmed to read the verdict from the body. A shared helper that posts a size-capped panel review would also stop each gardener from having to trim the text by hand.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-familiar-localhttp-protocol-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (925559 cached reads)
- Output: 4994 tokens
- Cost: $0.7674718000000001
- Wall-clock: 547s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
