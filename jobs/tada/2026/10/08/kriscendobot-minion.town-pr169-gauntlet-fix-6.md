I fixed round 6's one must-fix on kriscendobot/minion.town#169 and pushed `d3f982c`. CI is green: 3 of 3 checks passed.

**Must-fix (from the integrator, round 6):** the PR description still described code that no longer exists at the head: `guest_recovery_key_preflight`, `lib/guest-recovery-helpers.sh` and `$GUEST_RECOVERY_HELPERS`. I rewrote it to match the code:
- The preflight is one inline step (4.0) in the `deploy-app.sh` remote heredoc.
- `DEPLOYMENT.md` now documents the `account.env` requirement and a rollout-ordering note: hosts provisioned before the key existed need the provisioning script run once before their next deploy.
- The `<!-- garden-job: … -->` marker is kept.

**Should-fix items I also applied, all in commit `d3f982c`:**
- **Writer check:** `deploy-account-endpoint-secret.sh` now checks the key against the same rule as the preflight (`^[A-Za-z0-9_+/=-]{32,}$`), not only its length. A key with a space or quote is now refused when it is written, instead of being written and then failing every later deploy. This also makes the description's "same rule" claim true.
- **Docs:** the `account.env` requirements in `DEPLOYMENT.md` (around line 330) now name `GUEST_RECOVERY_KEY` alongside `ACCOUNT_GATE_SHARED_SECRET`.
- **Tests:** `test/deploy-secret-preflight.test.ts` has a new block that runs the writer's check. It confirms short, space-bearing and quote-bearing keys are refused, and that a key the writer accepts also passes the `deploy-app.sh` preflight. All 15 tests in the file pass locally. The run was slow because the host load was about 28, and the first attempt timed out while starting up before any test ran.

**Not done:**
- I did not regroup the six back-and-forth commits, which the integrator and packager suggested (non-blocking). It needs a history rewrite and force-push of the PR head; the next panel or the merge step can decide on it.
- `DEPLOYMENT.md` already failed Prettier's format check before this PR, so I didn't reformat it.

I did not re-run the panel; panel-7 is the driver's job.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr169-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (810642 cached reads)
- Output: 6949 tokens
- Cost: $0.7793724000000002
- Wall-clock: 911s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
