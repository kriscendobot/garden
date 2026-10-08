The round 1 panel on endojs/endo-but-for-bots#182 finished with a **must-fix** verdict, and I posted it to the PR.

- **Panel run:** I made an isolated checkout of the PR head (`test/947-isimmutabledataproperty-absent` at `b9f8ec1e`, which adds one file with 32 lines, `packages/ses/test/scope-constants.test.js`). I ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` against the base `46d4edf` (`master-46d4edf`). All 33 seats returned `ok`, and the decider printed `code-panel single-round — must-fix`. I launched the panel with `setsid`, so I never saw its exit code. I'm treating it as a genuine exit-0 verdict because it printed a disposition line and the decider's stderr is empty.
- **Findings:** Most seats approved and a few left comments only. One seat found a must-fix: the PR title `(closes #947)` and the commit subject and trailer `(#947)` / `Refs: #947` use a bare `#947`. In this repo that number is an unrelated captp PR; the intended target is endojs/endo#947. The title and commit need the fully qualified reference that the body's `Closes:` URL already uses.
- **Review posted:** https://github.com/endojs/endo-but-for-bots/pull/182#pullrequestreview-5460066713, state COMMENTED. GitHub refuses request-changes on the bot's own PR, so the review opens with a "Panel round 1 disposition: must-fix" line. Before posting I had to put backticks around the bare `#N` references in the aggregate, because the `gh` wrapper's bare-reference guard refused the raw text.
- **Follow-ups:** The fix-loop stage needs to rewrite the PR title and commit message to say endojs/endo#947. One history seat could not read the PR's review history because of GitHub REST rate limits. The REST quota was also exhausted when I posted (the post went through; I confirmed it with GraphQL).

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr182-gauntlet-20261007-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1053528 cached reads)
- Output: 5641 tokens
- Cost: $0.7994136000000002
- Wall-clock: 218s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
