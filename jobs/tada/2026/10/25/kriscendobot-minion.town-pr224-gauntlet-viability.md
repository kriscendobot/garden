I checked PR #224 (`kriscendobot/minion.town`) and found nothing that displaces it. **Verdict: proceed.** This stage only checked viability; it spent no budget on clean, panel, fix, CI-wait or un-draft.

**PR facts:** The PR is open and still a draft, opened 2026-10-25T00:58Z. It has no comments or reviews yet. The head is `fix/daemon-redeploy-restarts-clients` at `10bc4c6af8`, and the base is the frozen branch `main-c104813`, which is the current tip of `main`. It changes two files: it adds `systemctl try-restart minion-mcp endo-gateway` to `deploy-endo-daemon.sh` (after the daemon is healthy, and after the in-deploy rollback) and to `rollback-endo-daemon.sh tree`.

**Deciding question:** Does current `main` still redeploy or roll back the Endo daemon without restarting its CapTP clients (`minion-mcp` and `endo-gateway`), with no newer PR or commit that already fixes this?

**Evidence:**
- **No newer work on `main`.** The tip of `main` is still `c104813b9`, the #218 merge from 2026-10-24T21:39Z, which is the PR's own base. Nothing has landed since.
- **The gap is still there.** `main`'s `deploy/aws/scripts/deploy-endo-daemon.sh` has no `try-restart` and never restarts `minion-mcp` or `endo-gateway`. The only mention of `minion-mcp` is the `usermod` group grant.
- **No competing PR.** No later PR covers this. The only nearby one is #222 (the revert of #218), and #224's body explains that it is independent of it: the revert alone would not bring back the two failing prod-probe checks.
- **The motivating problem holds.** The incident is recent: the daemon redeploy at 21:40:50 dropped both CapTP clients, and they never reconnected. A manual restart at 00:55Z fixed it, and the PR records that as recovery. The same gap exists today on the `endo-daemon`-only deploy path and on the `tree` rollback path, which is what this PR fixes.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr224-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (120368 cached reads)
- Output: 1274 tokens
- Cost: $0.4003136
- Wall-clock: 26s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
