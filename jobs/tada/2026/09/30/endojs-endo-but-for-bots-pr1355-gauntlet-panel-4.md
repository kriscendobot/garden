## PR #1355, panel round 4: must-fix verdict, but not posted (panel-error)

The panel finished and ruled **must-fix**, but I couldn't post that verdict to the PR. I'm ending this stage as `panel-error` so the driver retries it on a host that can post PR reviews.

**What I did**
- Checked out the PR head `design/hardened-url-shim-status-reconciliation` (endojs/endo-but-for-bots, commit a4511c64f) into an isolated project worktree.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 1355 origin/llm-47f6965`. The first launch was cut off early by my own background time limit, so I killed it and ran it again cleanly. The clean run exited 0 with disposition **must-fix**. 10 seats ran: critic, skeptic, decomplector, ergonomist, novice, copyeditor, pedant, orthographer, thesaurus, and one more. The combined review is in `round-1.md` under the panel's run directory.
- Main findings:
  - Status says "Complete", but the Status section itself admits two gaps: there is no URL-specific XS smoke test (test-plan item 9), and the `new URL(` simplification sweep was skipped.
  - The body still uses the old names `%URL%` and `urlBlobMethods` instead of the shipped `%InitialURL%` and `urlBlobTaming`.
  - The Open Question 2 text is stale: the shipped `constructor` pin is a behavior change from the design's recommendation and isn't described as one.
  - The "22 focused tests" count doesn't match the source; grep finds 23.
  - The novice seat asked for clearer wording in the Status and `constructor` paragraphs.

**Why the verdict isn't posted**
- `gh pr review --request-changes` failed with `GraphQL: Resource not accessible by personal access token (addPullRequestReview)`. This host (oros-studio) uses the bot token, which doesn't have permission to write PR reviews in the endojs org. That's already recorded in memory as a known limit of this host.
- I chose `panel-error` over `must-fix` because the must-fix marker would say a verdict was posted when none was.
- The panel's saved run record (`panel-runs/endojs-endo-but-for-bots-1355/0ac963e5dce7.md`) also didn't reach the journal: the journal lock stayed busy (3×60s waits). My one manual retry of `panel-run-record.sh emit` timed out after 420s. The retry will probably re-run all the seats instead of reusing this result.

**Follow-ups**
- Pin panel stages for endojs PRs to an endolin host, or give the bot token PR write access on endojs. Until one of those happens, every panel round claimed on oros-studio fails at the posting step.
- Look into the journal lock contention on oros-studio (see the "clone livelock" memory).

<!-- gauntlet-stage-result: panel=panel-error -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1355-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1164283 cached reads)
- Output: 5673 tokens
- Cost: $0.8530365999999999
- Wall-clock: 1752s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
