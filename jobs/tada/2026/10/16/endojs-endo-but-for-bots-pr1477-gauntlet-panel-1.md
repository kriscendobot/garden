Panel round 1 on endojs/endo-but-for-bots#1477 (`feat(ocapn): key .np location IDs on network and designator`) finished with a **must-fix** verdict.

- **Run:** I ran `panel.sh` in single-round mode against an isolated checkout of `feat/ocapn-np-identity-location-id`, with base `llm-61cd656`. All 33 seats returned ok. `panel.sh` exited 0 and printed `code-panel single-round — must-fix`.
- **Seats:** 4 voted request-changes (typist, changeset-auditor, pruner, coverage-auditor). The other 29 voted approve or comment-only.
- **Blocking items:**
  - **No test:** nothing covers the new `Unsupported network` error in `packages/ocapn/src/netlayers/websocket.js` `connect`. A mismatched-network case belongs in `netlayer-websocket.test.js`.
  - **Typing:** the `locationNetworkId` `Pick<…>` / `@returns {string}` typing and the test helper's literal both need checking against the `OcapnLocation` typedef with `lint:types`.
  - **Changeset and description cleanups:** the changeset needs one sentence per line. The PR body should be trimmed, and the duplicated or migration-narrating JSDoc removed. Whether `minor` is the right bump depends on whether the `np` location-ID change breaks existing users.
- **Posted:** the verdict is a **COMMENT** review, not request-changes. GitHub refuses a request-changes review on the bot's own PR. The review body is tagged `<!-- garden-panel-verdict: round=1 disposition=must-fix -->` and says plainly that the verdict is request-changes. The 4 blocking seats are in the review. The other 29 seats' write-ups were too long for one review, so they went in two follow-up comments (issuecomment-6223926158 and issuecomment-6223926539).
- **Follow-up:** if the next-stage heuristic only counts a `CHANGES_REQUESTED` review state, it won't recognize this verdict on bot-authored PRs. It needs to also read the comment review or its marker.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1477-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1169794 cached reads)
- Output: 6230 tokens
- Cost: $0.8839347999999999
- Wall-clock: 193s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
