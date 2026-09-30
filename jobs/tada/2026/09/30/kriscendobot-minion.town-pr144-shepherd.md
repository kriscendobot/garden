**Shepherd report: https://github.com/kriscendobot/minion.town/pull/144**

CI is still red. Nothing in the PR can fix it: GitHub Actions is blocked by billing on the kriscendobot account.

**Diagnosis**
- **The PR:** head `6970365b`, a draft that is mergeable. It changes only two design docs (`designs/guest-coupons.md`, `designs/invitation-only-guest-onboarding.md`).
- **The failure:** all three checks (`test`, `Claude harness (amd64)`, `Claude harness (arm64)`) in run 36691445004 failed within about 3 seconds. They had no runner, no steps, and no log.
- **The cause:** the check-run annotation says *"The job was not started because recent account payments have failed or your spending limit needs to be increased."* This affects the whole account, not just this PR. The previous runs on this branch (08:19Z, 07:44Z) and on other branches (08:23Z) passed.

**What I did**
1. Reran the failed jobs once (`gh run rerun 36691445004 --failed`). The same billing block came back (new job 109810739230).
2. Told the maintainer via `message-user.sh` (msg-kriscendobot-minion.town-pr144-shepherd-0aa8c93a132c). Billing & plans on the kriscendobot account needs a payment or spending-limit fix. Until then, CI on every kriscendobot repo will stay red and the CI watcher may keep posting shepherd jobs no shepherd can fix. I included the rerun command to use after the fix.
3. Added a field note to `roles/shepherd/AGENT.md` on how to recognize a billing-blocked run: no steps, "log not found", and the reason is in the annotations. Pushed to main2 as `f3413cdb70a`.

I made no commits to the PR, since nothing is wrong in its diff.

**Classification: `next: liaison`.** A human has to fix the kriscendobot account's Actions billing, then rerun: `gh run rerun 36691445004 -R kriscendobot/minion.town --failed`.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `8de865b3c550986fa9c4baf601da3d0b49896ed4`; this job presented `6970365bcbf8e3dc326ad495a3ebbce9db5d28ff`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer received a deduplicated stale-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr144-shepherd.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (537892 cached reads)
- Output: 4203 tokens
- Cost: $0.5985744000000001
- Wall-clock: 99s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
