## Fix round 2: kriscendobot/minion.town PR #182

I fixed the must-fix item from the round-2 panel and pushed it to the PR head. CI is green (3 of 3 checks passed).

**Commit `88934af`** (pushed on top of `a5376f1`), in `.github/workflows/prod-probe.yml`:

- **Must-fix: issue lookups ignored API errors.** The `report` job now has `defaults.run.shell: bash`, so its steps run with `-eo pipefail`. A failed `GET /issues` call now fails the step. Before, it looked the same as "no open issue". That meant a failing run opened a duplicate issue and a passing run never closed the stale one.
- **Should-fix: only the first 100 issues were checked.** Both report steps now use a `find_issue` helper that goes through every page until it finds an issue that is not a pull request, or reaches the last page. Every command inside the helper ends in `|| return`. Bash turns off `-e` inside `$(find_issue)`, so without this an API error would still come back looking like "no issue".
- **Comment-only note:** I changed the `CI_RUNS_ON` example in the workflow comment to `"ubuntu-latest"`, the form `DEPLOYMENT.md` and `test.yml` use. `deploy.yml` still uses the other form, `["ubuntu-latest"]`. That file is outside this PR's diff, so I left it alone.

**Checks:**
- The YAML parses.
- shellcheck passes on the extracted `run:` scripts.
- I ran the helper locally under `bash -eo pipefail`. When the API call fails, the step stops with code 22. When it succeeds, it returns the real issue number and skips pull requests.
- actionlint isn't installed here, so it wasn't run.

`ci-wait-merge.sh` returned rc 0 (CI green). Panel round 3 is the next stage; the driver posts it.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr182-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (757850 cached reads)
- Output: 6198 tokens
- Cost: $0.7373780000000001
- Wall-clock: 860s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
