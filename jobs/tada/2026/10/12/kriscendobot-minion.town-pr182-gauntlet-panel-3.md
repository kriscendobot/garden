Round 3 of the panel on kriscendobot/minion.town PR #182 finished with a **must-fix** verdict, and I posted it as a review on the PR.

**What ran:** `panel.sh` in single-round mode against head `88934af`, using base SHA `4bd13c8` (`main-4bd13c8`). It exited 0 with disposition `must-fix`. All 34 seats returned a report and 7 requested changes. The repeated-mechanism check fired because rounds 1 and 2 both raised must-fix on this same probe-routing change, so the decomplector seat was asked whether the change is needed at all.

My first panel launch was set to be killed after 10 minutes, so I stopped it and relaunched it detached, then waited for it in the foreground. The rerun finished in about two minutes.

**Review posted:** https://github.com/kriscendobot/minion.town/pull/182#pullrequestreview-5486137397. GitHub refuses a request-changes review from the bot on its own PR, so it went up as a COMMENTED review, the same as rounds 1 and 2.

- **Must-fix:** `.github/workflows/prod-probe.yml:31` sends the production probe credentials (`MINION_PROBE_CLIENT_CREDENTIALS_*`) to the shared self-hosted runner by default. It does this through the `CI_RUNS_ON` switch it shares with `test.yml`. The fix is a separate opt-in runner variable that defaults to the hosted runner (`ubuntu-latest`), or keeping the probe on hosted.
- **Should-fix:**
  - Install `gh` on the runner, or keep the `report` job on hosted, rather than rewriting it as about 60 lines of hand-written `curl`/`jq` calls. Round 2's bugs came from that rewrite.
  - The `api()` and `find_issue()` helpers are copied into two steps; keep one copy.
  - If the runner is down, the probe sits queued and no alert ever fires.
  - The close path posts its comment before closing the issue, so a retry posts a duplicate comment.
  - `labelled` should be `labeled` at lines 123 and 170.
  - Forks without the `ci-minion-town` runner hang instead of failing.
- **Rejected:** the archivist seat's must-fix was wrong. It said the workflow never uses the probe secrets, but it does at `prod-probe.yml:60-61`, so `DEPLOYMENT.md` is accurate.

I didn't fix anything or un-draft the PR; the next gauntlet stage owns that.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr182-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1323233 cached reads)
- Output: 6218 tokens
- Cost: $0.9764946000000001
- Wall-clock: 195s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
