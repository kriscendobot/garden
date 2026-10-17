I added a production check that `GET /api/guest` no longer returns the guest's bearer, ran it by hand against production, and it passes. The check is in draft PR kriscendobot/minion.town#196, and all its CI checks pass (test and both Claude harness legs).

**1. The check.** The new check is `guest-state-omits-bearer` in `deploy/probe/prod-objectives.mjs`. It passes only if `GET /api/guest` answers 200 with `contacts` and `messages` as arrays, has no `formulaIdentifier` field, and the bearer appears nowhere in the body. The public summary reports only the status code and the field names.
- **No growing guest set:** the probe never creates a guest. I created one long-lived probe guest in production once (`POST /api/guest` → 201). Its bearer is in AWS Secrets Manager as `minion/prod-probe-guest` (the copy you can read back), and in the `prod-probe` environment secret `MINION_PROBE_GUEST_BEARER` (Actions secrets can't be read back).
- **Without the secret:** the check reports `skipped` / `no-credential`, never `pass`. I set the secret before opening the PR because the scheduled probe runs in strict mode, where a skip turns the run red.
- **Tests:** unit tests sit beside the existing ones and cover passing, the bearer being echoed, a bearer with a trailing newline, the skip, and a failure reason never containing the bearer. All 18 tests and the typecheck pass locally.
- **Other edits:** `prod-probe.yml` now passes the new secret, and `DEPLOYMENT.md` has a table row, the local-run recipe and a note on replacing the probe guest.
- Since minion.town's main has no frozen base branch, I pushed a snapshot, `main-3d161b9`, for #196 to target.

**2. Hand run on production** (2026-10-17T03:56Z): all 8 checks passed. The new check got 200 with fields `["contacts","messages"]`, and the bearer is not in the summary. I posted this result, with no token in it, on #195: https://github.com/kriscendobot/minion.town/pull/195#issuecomment-6229344423

**3. Garden doc.** In `context/operations/minion-town-mcp.md` I replaced the "`GET /api/guest` echoes it … redact before logging" bullet with "Only creation discloses it" (fix deployed and checked in production 2026-10-17). That bullet also covers the `invitations/accept` answer: I only tested `GET` live, but #195 makes both answers from the same code. The doc notes that the #196 check runs on every probe only once it merges. Pushed to main2 as 340293dc21c and 776cdbeefc2.

**Follow-ups:**
- #196 needs its gauntlet run (it was opened directly as a draft) and then a merge.
- The probe guest stays in the daemon permanently, because there is no delete route. Replacing it later leaves the old guest behind; `DEPLOYMENT.md` says so.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-pr195-prod-validation.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 66 tokens (2635483 cached reads)
- Output: 16456 tokens
- Cost: $1.5489686000000005
- Wall-clock: 2353s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
