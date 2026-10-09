The panel finished with a must-fix verdict, but posting the review failed: this host's PAT can't write PR reviews on endojs. As the known guidance for this host says, I'll complete with the panel-error marker so the round is retried on a host that can post.

## Report: gauntlet panel round 3 for endojs/endo-but-for-bots#1433

**Outcome:** the panel produced a real **must-fix** verdict, but I couldn't post the review from this host, so this round ends as **panel-error** and the driver will retry it.

**What I did**
1. Checked out the PR head `kriscendobot/endo-but-for-bots@design/formula-identifier-indirection` at `22ed601bf` into an isolated worktree with `ensure-project-worktree.sh`. The fork doesn't have the base branch `llm-7d2eb30`, so I fetched it from `endojs/endo-but-for-bots` into `refs/remotes/origin/llm-7d2eb30`.
2. Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 1433 llm-7d2eb30`. It exited 0 with **disposition `must-fix`**. All 9 seats returned ok:
   - **Request changes (5):** skeptic, decomplector, ergonomist, pedant, novice.
   - **Comment only (2):** critic, copyeditor.
   - **Approve (2):** orthographer, thesaurus.
   - The run is saved in the journal at `panel-runs/kriscendobot-endo-but-for-bots-1433/30b1ad6a4e19.md`.
3. Main must-fix themes:
   - The staged rollout contradicts the v3->v4 migration: `r1`/`share` rows are written in stage 1, but `share()` and the control facet only arrive in stage 3.
   - There is no compatibility rule for older peers that can't parse `/r1/` locators.
   - The control facet both advances to the successor after `rotate()` and promises an idempotent `rotate()` retry; those two claims conflict.
   - The hidden default share from `locate` is durable authority with no handle to revoke it, and revoking it revokes every `locate` caller at once.
   - Line 561 uses a U+2192 arrow (`→`) where the project requires `->`.
   - There is no plain problem statement or glossary up front, and no end-to-end example of a leak and rotation.
4. **Posting failed:** `gh pr review --comment` returned `GraphQL: Resource not accessible by personal access token (addPullRequestReview)`. The bot PAT on host `oros-studio-garden-ce242c49` can't write PR reviews on endojs, which is the same 403 recorded in memory.

**Why panel-error:** I can't truthfully report must-fix as delivered when no verdict review was posted to the PR, and the next-stage heuristic depends on that review. A retry on a host that can post (for example `endolin-garden-ece02cb4`) can reuse the saved panel record instead of re-running the seats. The review body I drafted, with a must-fix summary and all 9 seat reports, is at `/Users/dom/garden/scratch/panel-run-pr1433-r3/review-body.md`. That path is in scratch, so it may not survive.

**Follow-ups**
- If the retry is claimed on oros again, it will hit the same 403. Panel stages for endojs PRs should be pinned to a host whose PAT can write, or the PAT needs Pull requests read+write on the endojs org.
- I changed nothing in the garden repo or on the project branch.

<!-- gauntlet-stage-result: panel=panel-error -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1433-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (863151 cached reads)
- Output: 5774 tokens
- Cost: $0.7551422
- Wall-clock: 640s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
