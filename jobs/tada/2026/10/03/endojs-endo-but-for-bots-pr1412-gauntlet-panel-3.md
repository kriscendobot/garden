Panel round 3 on endojs/endo-but-for-bots#1412 found problems that must be fixed. The verdict is posted to the PR.

**What I ran**
- I made an isolated checkout of the PR head (`endojs/endo-but-for-bots`, branch `build/endo-claude-backends-1357`, commit `ee861f9bea`) at `scratch/project-wt-endojs--a66936634e30-fdfbeeff`.
- I ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` against the PR's base commit `80054c34533c` (branch `llm-80054c3`), detached so it would survive a reap. All 33 seats returned without a seat error, and the last line read `code-panel single-round — must-fix`. Because the run was detached I did not capture panel.sh's exit code directly. A clean disposition line and every seat's output on disk mean it did not fail as infrastructure.

**Why it is must-fix**
- **PR description:** a deterministic check found the PR body does not follow the template. It is missing the scaling, documentation, compatibility and upgrade headings and adds an invented "platform scope" heading; this check alone forces must-fix. A separate length check also fired: the body is 842 words, against a limit of 300.
- **Request-changes seats (13):** assessor, stylist, packager, archivist, curator, breaker, purist, wire-watcher, integrator, surfacer, pruner, corner-prober and orthographer. Examples:
  - **assessor:** `buildSdkOptions` does not check `maxBudgetUsd`, though `buildCliArguments` rejects 0, negative and NaN. The SDK backend therefore runs with no budget limit where the CLI backend would refuse.
  - **stylist:** the new `CredentialGrant`/`CredentialGrantShape` field `env` should be spelled out as `environment`.
- **The other 20 seats** approved or left comments only.

**Posting the verdict**
- The full write-up is 96 KB, over GitHub's limit of about 65 KB per review, so I posted it as two reviews, as rounds 1 and 2 did:
  - Part 2/2 (approve and comment-only seats): review 5398822659.
  - Part 1 (disposition must-fix, the pre-check results and the 13 request-changes seats): review 5398822922, posted last.
- Both landed as COMMENTED, not request-changes, because GitHub refuses a request-changes review from the PR's own author account. Rounds 1 and 2 have the same state.

I made no changes to the garden repo. I did not fix anything or take the PR out of draft. The next stage is the fixer.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1412-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (975780 cached reads)
- Output: 4587 tokens
- Cost: $0.8035760000000001
- Wall-clock: 563s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
