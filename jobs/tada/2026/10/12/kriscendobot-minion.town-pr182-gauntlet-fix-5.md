# Gauntlet fix round 5: kriscendobot/minion.town PR #182

I fixed most of the round-5 panel's must-fix and should-fix items, declined the decomplector's two items (reasons below), and pushed one commit. CI is green: `ci-wait-merge` returned rc 0, with all 3 checks (test and the amd64 and arm64 Claude harness) passing.

**Pushed:** `65dfad9` on top of `53fad66`, through `safe-push-pr-head.sh`. It is a normal fast-forward, not a force-push.

**Fixed:**
- **archivist (must-fix):** `DEPLOYMENT.md` § Production objectives probe, *Runner*, said a down runner "cannot silence a failure". That contradicted both the code and the next sentence. It now says `report` runs on the same runner as the probe, so both stop together. I corrected the same claim in the PR body.
- **corner-prober 1–2 and assessor 1–2:** the `github-script` report step no longer throws on bad input. If the summary file can't be parsed, has no `checks` list, or lists only passing checks, the step writes a generic line instead. A real probe failure therefore still opens or updates the tracking issue.
- **corner-prober 3:** `DEPLOYMENT.md` now says `PROBE_RUNS_ON` must be JSON. It explains that a bare, blank or `[]` value means neither job runs and no issue opens. It also says to check a new value with `gh workflow run prod-probe.yml`.
- **pruner:** I removed the `runs-on` comment on the `report` job, which repeated the line below it. I also cut the PR-body bullet about `github-script` internals.
- **scribe:** I posted a completion-summary comment (issuecomment-6120526309). It lists this round's fixes and declines and summarizes rounds 1–4, which the squashed history no longer shows.

**Declined, with reasons in the PR comment:**
- **decomplector 1** asked to hardcode `ubuntu-latest` and drop the new variable. That would undo the PR's purpose, which is letting the probe run through a hosted billing block. Reusing `CI_RUNS_ON` instead would send the production probe credential to the self-hosted host by default, and the gateway juror found the separate opt-in correctly scoped.
- **decomplector 2** asked to go back to `gh`. The self-hosted runner has no `gh`, which was round 1's must-fix.

**Checks:** the workflow YAML parses and the inline script passes `node --check`. `actionlint` is not installed here, so I did not run it.

**Follow-ups:**
- No real `workflow_dispatch` run of the report path has been made yet. One is recommended before merge.
- The decomplector's objection to having two runner variables may come back in panel-6. If it does, the maintainer needs to decide it.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr182-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (1013992 cached reads)
- Output: 7375 tokens
- Cost: $0.8888264000000001
- Wall-clock: 1147s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
