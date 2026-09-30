# Panel round 2 on endojs/endo-but-for-bots PR #1389: must-fix; review not yet on the PR

The panel verdict is **must-fix**, but the review is still not on the PR. This host's bot token can't write reviews on endojs, so a relay job on another host will post it. Nothing else was left to do.

**What happened**
- I ran the design panel in single-round mode on PR head `55b47f7c5` (branch `design/sturdyref-shim-contract`, base `llm-7ff30af`). `panel.sh` exited 0 with **must-fix**, and all 9 seats returned ok.
- The run is recorded in the journal at `panel-runs/endojs-endo-but-for-bots-1389/59a6e9fa1d48.md`.
- **Skeptic's main findings:**
  - A guest can mint its own SturdyRef once layer 2 lands, and the design doesn't say which layer tracks where a ref came from.
  - The claims about the pre-lockdown permit shape and about what child compartments can see are not backed by a real run.
- **Critic's main findings:**
  - A test locks in a default that the design itself says is not guaranteed.
  - Whether layer 5 can be built on this contract is still undecided (open question 7).

**Posting the review**
- `gh pr review` failed with `Resource not accessible by personal access token (addPullRequestReview)`, which is a known limit of this host.
- I posted the relay job `endojs-endo-but-for-bots-pr1389-panel-2-post-review`, pinned to `endolin-garden-ece02cb4`. It is in `jobs/todo/` on `origin/journal2`.
  - It carries the full review body with the `<!-- garden-panel-verdict: must-fix round=2 -->` marker.
  - It checks first so it won't post the review twice.
  - It posts with `--comment`, as round 1 did, because the bot wrote the PR and can't request changes on its own PR.
- As of now, no round-2 review exists on the PR. If the next gauntlet stage waits for the review to appear on GitHub, it will wait until that job runs on endolin.
- Nothing changed in the garden repo, and nothing was pushed to the PR branch.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1389-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 70 tokens (2052788 cached reads)
- Output: 10367 tokens
- Cost: $2.1841769999999996
- Wall-clock: 2590s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
