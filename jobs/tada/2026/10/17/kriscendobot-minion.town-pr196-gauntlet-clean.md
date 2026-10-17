Clean stage for kriscendobot/minion.town PR #196 finished with nothing to change: coverage was already in place and CI is green at the current head (`82eb5885`). I pushed nothing and used no project checkout.

- **Idempotence check:** the PR is open and still a draft. All three checks passed: `test`, `Claude harness (amd64)` and `Claude harness (arm64)`.
- **Coverage:** I read the diff rather than running the tests myself. The PR touches `deploy/probe/prod-objectives.mjs`, its test file, `prod-probe.yml` and `DEPLOYMENT.md`. The tests cover:
  - the new `guestStateViolations` evaluator: pass, bearer echoed, bearer elsewhere in the body, wrong types, a non-object answer, a non-JSON answer, and that no failure message contains the bearer;
  - the `guest-state-omits-bearer` check against a mocked fetch: pass, fail without leaking the bearer, and a bearer that isn't plain visible ASCII refused;
  - the skip when no credential is set, and the updated list of check names.

  The only untested branch is the one-line refusal when `GET /api/guest` answers something other than 200. It's small enough that I didn't add a commit for it.
- **Dead code:** none. The change only adds code and orphans nothing.
- **CI:** `ci-wait-merge.sh kriscendobot/minion.town 196 --no-merge` returned rc 0 (CI GREEN, 3 checks, 0 failed).

Follow-ups: none for this stage. The gauntlet goes on to the panel stage.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr196-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (236890 cached reads)
- Output: 1313 tokens
- Cost: $0.465222
- Wall-clock: 25s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
