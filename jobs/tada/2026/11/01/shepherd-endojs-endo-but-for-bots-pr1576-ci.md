I'm not emitting a failure or handoff signal: CI on PR #1576 is green, and the cancelled checks are stale duplicates that the gauntlet's gate already ignores.

## Shepherd report: endojs/endo-but-for-bots#1576

**Result: no CI repair needed.** CI is green on the current head, `02dbd31bf297e77c03582c614b7717fd88a28b6d`. The 31 CANCELLED checks are not failures. A concurrency group cancelled them when a second set of runs on the same head replaced them.

**What I found:**
- **Twelve workflow runs on the head, six cancelled.** The head has two `pull_request` runs of each of six workflows: CI, Floot Android, OCapN Guile interop, IronHorse oracle sanitizers, Workflow security audit, and Test project mutual dependency versions. In each pair, the older run was cancelled and the newer one succeeded.
- **Every cancelled check has a passing twin.** Each of the 31 cancelled checks has a SUCCESS or SKIPPED twin under the same workflow and name on the same head.
- **The gauntlet's gate reads it as green.** I ran `ci-wait-merge.sh`'s own `LATEST_CHECKS_JQ` filter on the live rollup and got **7 SUCCESS, 24 SKIPPED, 0 failures**. That filter already drops cancelled runs that a newer run replaced (the #1483 fix).
- **The PR is already through the gauntlet.** `endojs-endo-but-for-bots-pr1576-gauntlet-02dbd31` finished on 2026-10-29 with a clean panel on this exact head. The PR is open, mergeable and not a draft. The head has not moved since, so there is nothing to hand back and no new gauntlet to start.

**What I tried:** I tried to re-run the six cancelled runs so the raw rollup would show no CANCELLED entries. This host's PAT was refused ("Resource not accessible by personal access token"), which is the known endojs write limit on oros-studio. I didn't pin a re-run job to endolin, because the gate already reads the PR as green and a re-run would only change how the rollup looks.

**Changes:** none to the PR, the garden repo, or the board.

**Follow-ups:**
- The producer that posted this job (arc `minion-town-claude-api`, automatic dispatch) seems to have counted CANCELLED entries in the raw `statusCheckRollup` instead of applying the dedupe that `ci-wait-merge.sh` uses. That will raise false-positive shepherd jobs for any PR whose runs were cancelled this way. It's worth making that producer use `LATEST_CHECKS_JQ` before it posts.

**next: none** — the cancellations were superseded runs; the newer runs on the same head are green (for example, CI run https://github.com/endojs/endo-but-for-bots/actions/runs/40846731659).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/shepherd-endojs-endo-but-for-bots-pr1576-ci.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (843117 cached reads)
- Output: 5362 tokens
- Cost: $0.6721994000000001
- Wall-clock: 156s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
