I applied the round-3 panel fixes to kriscendobot/minion.town PR #182 and pushed them. CI is green on the new head, but I confirmed that through the Actions runs API, not through `ci-wait-merge.sh`. On this host, `ci-wait-merge.sh` failed on `gh pr view` every minute and never reached a result, so I stopped it.

**Pushed:** commit `94f3ae2` (from `88934af`, the round-3 review head), via `safe-push-pr-head.sh --mode advance`. It is still the PR head.

**CI:** the only workflow on this head is `test (typecheck + vitest)`, and it completed with success (run 38199049598). That matches the previous head, which also ran only that workflow.

**Changes, against the round-3 review:**
1. **Must-fix (probe secrets on the self-hosted runner):** the `probe` job no longer follows `CI_RUNS_ON`. It now uses a new repo variable, `PROBE_RUNS_ON`, and runs on hosted `ubuntu-latest` unless that variable is set. So moving test and deploy runs to the shared runner no longer moves the production probe credential with them.
   - The `report` job holds no secret, so it still follows `CI_RUNS_ON` and keeps reporting through a hosted billing block.
   - Trade-off: during a billing block the probe itself won't run until someone sets `PROBE_RUNS_ON` to `["self-hosted","ci-minion-town"]`, which accepts the credential exposure.
2. **`gh` vs. calling the REST API directly:** I kept `curl` and `jq` and explained why in DEPLOYMENT.md and the PR body. The live runner has no `gh`, and adding it to `bootstrap.sh` would only reach the host at the next re-provision.
3. **Duplicated helper code:** the two report steps are now one step, so `api()` and `find_issue()` are defined once. I checked it with shellcheck and `bash -n`, and the YAML parses.
4. **A down runner silences the probe:** DEPLOYMENT.md now says a `prod-probe` run queued for more than an hour should be treated as an alert. A probe that fails to start on hosted runners still fails, and `report` then files the tracking issue.
5. **Duplicate "pass again" comment on retry:** the issue is now closed before the comment is posted.
6. **Spelling:** `labelled` → `labeled`.
7. **Forks without the runner hang:** the "Fall back to hosted" row in DEPLOYMENT.md now says such a fork must set `CI_RUNS_ON`.

I also updated the CI-runner intro, the *Trust note* exposure list and rotation advice, and added a **Runner** paragraph under § Production objectives probe. The PR title and body now describe the new runner split.

**Follow-up:** `ci-wait-merge.sh` can't read PR status here (my notes say this host's token lacks permission to read check status), so future gauntlet CI watches on this host will hang the same way.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr182-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 4 tokens (160411 cached reads)
- Output: 1288 tokens
- Cost: $1.1508104000000003
- Wall-clock: 87s

<!-- garden-usage-end -->
