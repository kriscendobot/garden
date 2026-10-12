Panel round 1 on PR #182 finished with a **must-fix** verdict. I posted the panel review on the PR, but as a comment: GitHub refused a request-changes review because the bot opened this PR itself.

**What I did**
- Checked out the PR head `17e4d3c` (`kriscendobot/minion.town`, branch `fix/prod-probe-ci-runs-on`) in an isolated project worktree.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` against base `origin/main-4bd13c8`. It exited with code 0, ending with `panel #182: code-panel single-round — must-fix`. All 33 review seats returned verdicts. The run record was saved to the journal as `panel-runs/kriscendobot-minion.town-182/f5420e817d02.md`.
- Posted the review at 2026-10-12T00:15:24Z (state `COMMENTED`). It opens with a summary headed **must-fix**, followed by every seat's findings.

**Findings**
- **Must-fix (4 seats agree: saboteur, breaker, wire-watcher, engine-realist):** the PR moves the `report` job onto the `ci-minion-town` self-hosted runner. That job runs `gh` to open and close the `prod-probe-failure` tracking issue, but the runner never installs `gh` (`deploy/aws/ci-runner/host/bootstrap.sh` installs `jq` only). As a result, the failure-tracking issue would never be opened or closed. To fix it, either keep `report` on `ubuntu-latest`, or install `gh` in `bootstrap.sh` and check for it in the runner selftest.
- **Should-fix (locksmith):** the `probe` job would now hand the production guest credential to the same host that runs `pull_request` jobs. Either keep `probe` on a hosted runner or a dedicated label, or record the accepted risk and its rotation in `DEPLOYMENT.md` § CI runner. That file's note on which jobs use the self-hosted runner is also out of date.

**Follow-ups**
- The next gauntlet stage needs to recognize a comment-state review that starts with "Panel review … **must-fix**" as this round's verdict.
- No garden repo changes.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr182-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1067278 cached reads)
- Output: 5326 tokens
- Cost: $0.8505356
- Wall-clock: 429s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
