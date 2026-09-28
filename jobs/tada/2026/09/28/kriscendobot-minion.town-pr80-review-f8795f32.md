I handled kriskowal's approving review on kriscendobot/minion.town#80 ("Please conduct and ship this") and all three of its inline comments. The PR is not merged yet: I posted a conductor job to un-draft and merge it, and that job hasn't run.

The recheck preflight (`pr-feedback-preflight.sh`) exited 0, so no peer had already done this work.

**Design doc updates**, pushed to the PR head `design/siwe-invitation-pivot`:
- **`473dabb`:** `designs/siwe-invitation-pivot.md` now has status **accepted — ADAPT now**. The old "Open questions" section is replaced by "§ 8. Decisions", which quotes each of kriskowal's answers:
  1. Adapt, now. The deployed `siwe-idp.minion.town` issuer stays.
  2. Drop on-chain holdings (Tier 2) and the on-chain registry (Tier 3) for now. They are not parked for later.
  3. Do the implementation now, because the account and recovery layer it builds on is already on `main` (`src/auth/accounts.ts` and the guest recovery routes).
- **`09d37f0`:** the banner in `designs/siwe-onchain-authz.md` now says the on-chain tier model is superseded and will not ship.

**Inline comments:** I replied to each of the three (replies 4127200152, 4127200368, 4127200561), citing the commit that addresses it.

**CI:** the new head `09d37f0` passed all checks (test and Claude harness on amd64 and arm64). GitHub reports the PR as mergeable and CLEAN.

**Jobs posted**, both confirmed in `jobs/todo/` on `origin/journal2`:
- **`build-siwe-recovery-bond-provider-minion-town`:** adds the SIWE issuer as another optional way to recover a guest account. It grants no access or scopes, adds no allowlist or `config/policy.json` entries, and does no on-chain reads. It stops at a draft PR.
- **`kriscendobot-minion.town-pr80-conduct-20260928`:** the conductor, to un-draft and merge #80.

The earlier SIWE tier jobs (`apply-siwe-onchain-authz-maintainer-decisions`, `deploy-siwe-thunk-minion-town`) were already withdrawn on 2026-09-16, so nothing needed cancelling.

**Follow-up:** the build job's PR will stay a draft, so it needs a maintainer "run the gauntlet" to go to review.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr80-review-f8795f32.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1091325 cached reads)
- Output: 8062 tokens
- Cost: $0.8565769999999998
- Wall-clock: 362s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
