I fixed all four panel round-4 items for kriscendobot/minion.town#182 and pushed the result. CI is green (`ci-wait-merge` rc 0, 3 of 3 checks passed).

**What changed** (the branch is now one commit, `53fad66`):

1. **Must-fix: `actions/github-script` replaces the hand-written REST client.** The "Open, update, or close the tracking issue" step is now a single `github-script` step, with no shell `api()`/`find_issue()`/`comment()` and no `gh`.
   - It finds the open issue with `github.paginate(issues.listForRepo)`.
   - A failed API call fails the step.
   - Creating the label only tolerates a 422 ("already exists"); any other error fails the step.
   - The issue is still closed before the "pass again" comment, so a retried run doesn't post twice.
   - Before pushing, I syntax-checked the script with node and ran both the failure and green paths against a stubbed `github` object.
2. **Should-fix: an offline self-hosted runner can no longer hide a production failure.** `report` now runs where `probe` runs (`PROBE_RUNS_ON`, default hosted `ubuntu-latest`) instead of following `CI_RUNS_ON`.
   - The trade-off: during a hosted billing block with `PROBE_RUNS_ON` unset, neither job starts and no issue opens. The billing block is then the alert. DEPLOYMENT.md § Production objectives probe, *Runner*, says this.
3. **Should-fix: duplicated runner text trimmed.** Each `runs-on` comment is now a one-line pointer to DEPLOYMENT.md. I removed:
   - the probe sentence from the CI runner intro
   - the "`gh` absent / `bootstrap.sh`" clause
   - the comment that only restated `|| true`
   - the "labelled" spelling and the ellipsis character, which went with the old comments

   The fork sentence stays only in the rollback-table row. The note after the table now says CD shares `CI_RUNS_ON` with test.yml and that the probe has its own switch.
4. **Should-fix: commit history.** I squashed the four fix-up commits into one commit whose title matches what the head does: "fix(probe): opt-in runner for the prod probe; report via github-script". I pushed it with `safe-push-pr-head.sh --mode rewrite` (`94f3ae2` → `53fad66`), using a lease against the freshly fetched head.

I also updated the PR title and body to describe the new design.

**CI:** the self-hosted runner queue was slow, so the first bounded wait ended still pending (rc 4). I re-ran it in the foreground and it ended green (rc 0).

**Follow-ups:** none from this stage. The driver re-posts panel-5.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr182-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1411559 cached reads)
- Output: 12091 tokens
- Cost: $1.1459558
- Wall-clock: 2153s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
