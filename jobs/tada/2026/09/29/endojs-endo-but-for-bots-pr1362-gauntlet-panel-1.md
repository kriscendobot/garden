Round 1 of the panel on endojs/endo-but-for-bots#1362 came back **must-fix**. `panel.sh` exited 0, so this is a real verdict, not a sensor error.

**What I did**
- **Checkout:** made an isolated checkout of the PR head (`endojs:build/npm-dev-registry-serving` @ `a86bb2a546`).
- **Panel run:** ran `GARDEN_PANEL_SINGLE_ROUND=1 scripts/jobs/gardening/panel.sh` with the base SHA `3aa902d003…` (the frozen base `llm-3aa902d`) rather than the branch name. It ended "code-panel single-round — must-fix".
- **Seats:** 31 seats returned a verdict. 10 requested changes (typist, stylist, packager, prover, wire-watcher, surfacer, pruner, releaser, orthographer, reexport-auditor), 17 were comment-only and 4 approved.
- **Sample findings:**
  - typist found two inline `import()` JSDoc types in `src/server.js` (lines 23 and 83) that should be top-of-file `@import` tags.
  - assessor (a should-fix) found that a failure while reading the upstream response body in `registry.js` escapes as a generic 500 instead of a 502/504.

**Posting the verdict**
- **Size split:** the aggregate is about 85K characters, which is over GitHub's 65,536-character limit for a review body. I split it on seat boundaries: the review holds about 58K, and the rest is in a follow-up PR comment (https://github.com/endojs/endo-but-for-bots/pull/1362#issuecomment-5882619670).
- **Comment, not request-changes:** GitHub refuses a request-changes review from the author of the PR, and the bot opened this one. So the verdict went up as a COMMENTED review whose first line reads "Disposition: MUST-FIX (request-changes)". The driver advances on the stage marker below, so this shouldn't stall the gauntlet.

**Follow-ups**
- `panel.sh` and the panel stage prompt don't handle either case. Every gauntlet on a bot-authored PR will hit the request-changes refusal, and any large panel will exceed the size limit. A small helper that splits the aggregate and falls back to a comment review would stop each gardener improvising this. I haven't posted a job for it.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1362-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1028749 cached reads)
- Output: 4845 tokens
- Cost: $0.7611377999999998
- Wall-clock: 561s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
