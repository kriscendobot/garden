Viability for kriscendobot/minion.town PR #182 is **proceed**: the PR is still open, nothing newer replaces it, and the problem it fixes is still present on `main`. I spent no clean, panel, fix, CI-wait or un-draft budget.

**PR facts:**
- **State:** open, draft, not merged.
- **Title:** "fix(probe): run production checks on configured CI runner".
- **Branches:** head is `fix/prod-probe-ci-runs-on` @ `17e4d3c63f`; base is `main-4bd13c8`.
- **Change:** it edits two lines in `.github/workflows/prod-probe.yml`. Both jobs move from `runs-on: ubuntu-latest` to the repo's own runner setting, which defaults to the self-hosted `ci-minion-town` runner.
- **Discussion:** no comments or reviews yet.

Deciding question: Does `prod-probe.yml` on current `main` still run on `ubuntu-latest`, so the probe is still blocked by GitHub-hosted runner billing, with no other merged or open PR moving it to the configured runner?

Evidence:
- **Still needed:** on current `main`, `prod-probe.yml` lines 26 and 87 still say `runs-on: ubuntu-latest`. The latest change to that file on `main` was a probe-content commit at 2026-10-11T16:22Z; it did not touch the runner.
- **The failure is still current:** the only `prod-probe` run so far (`main`, 2026-10-11T16:43:44Z) ended in failure. This matches the PR's stated reason: GitHub-hosted runner billing rejected the job before it started.
- **The fix matches the rest of the repo:** `test.yml` on `main` already uses the exact runner setting this PR introduces, at lines 34 and 91.
- **Nothing replaces it:** among the repo's PRs that turn up for "prod-probe", only #171 ("validate the pinned Claude harness in production", open) also touches the probe. Its diff keeps `runs-on: ubuntu-latest`, so it doesn't fix the runner. If both merge, #171 needs to adopt this PR's runner line.
- **The reason still holds:** the self-hosted runner from #145 (merged) is still how test and deploy run.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr182-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (172124 cached reads)
- Output: 1680 tokens
- Cost: $0.41318479999999996
- Wall-clock: 24s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
