Panel round 2 on kriscendobot/minion.town PR #182 finished cleanly, and the verdict is **must-fix**. I posted it as a review on the PR.

**What I did**
- Checked out the PR head (`kriscendobot:fix/prod-probe-ci-runs-on` @ `a5376f12`) in an isolated project worktree and ran `panel.sh` in single-round mode against the real merge base `4bd13c8`. It exited 0 with disposition `must-fix`, and all 33 seats completed OK.
  - My first launch would have been killed by the shell's 10-minute cap, so I stopped it and its one leftover seat process before relaunching. Only the second run fed the verdict, and its run record is `panel-runs/kriscendobot-minion.town-182/5e97adf73c87.md`.
- Posted the review: https://github.com/kriscendobot/minion.town/pull/182#pullrequestreview-5486015101
  - It went up as a COMMENT review, not request-changes, because GitHub rejects request-changes from the account that opened the PR. Round 1 was posted the same way.
  - The body contains the must-fix items, every seat's verdict, the breaker seat's full review, and a `garden-panel-verdict: must-fix` marker.

**Must-fix items**
1. **API failures are silently ignored in `.github/workflows/prod-probe.yml`.** The workflow doesn't set a shell, so its steps run as `bash -e` without `pipefail`. In the issue lookups (`number="$(api … | jq …)"`, lines 129–130 and 150–151), a failed `GET /issues` therefore gives an empty result instead of failing the step.
   - On a failing run, that opens a duplicate tracking issue.
   - On a green run, the stale issue never gets closed and the step still passes.
   - I confirmed in the head checkout that no `shell:` or `defaults` is set. The assessor seat said the steps run with `-eo pipefail`, which is wrong.
2. **Smaller fix: pagination.** Both lookups read only the first 100 results, so with more than 100 open items under the label they could miss the real issue.

Comment-only notes: the default for the `CI_RUNS_ON` variable is written two ways (`["ubuntu-latest"]` in the workflow, `"ubuntu-latest"` in `DEPLOYMENT.md`), and the close path now makes two separate calls. The round-1 must-fix (`gh` isn't installed on the self-hosted runner) is resolved.

No fixes were made and the PR is still a draft. The fix stage comes next.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr182-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1551590 cached reads)
- Output: 7766 tokens
- Cost: $1.0860860000000003
- Wall-clock: 261s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
