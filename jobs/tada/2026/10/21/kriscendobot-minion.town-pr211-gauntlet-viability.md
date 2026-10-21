Deciding question: Is `main` still at the failed-deploy merge f6fe2b522 (#200), with nothing newer that fixes the deploy or re-lands the change, so production and `main` still disagree?

Evidence:
- **PR state:** #211 is OPEN, draft and unmerged. Head `heal/revert-pr200-f6fe2b5` (87cebeb) is a revert of #200. Its base is the frozen `main-f6fe2b5` (f6fe2b522). It has no reviews or comments yet.
- **Base history:** `main`'s tip is still f6fe2b522, the #200 merge from 2026-10-21T14:33Z. Nothing has landed after it, so no forward-fix, re-land or other heal has superseded this revert.
- **Deploy status:** The deploy run for f6fe2b522 (39617782849) concluded `failure`, and the prod probe after it was `skipped`. The last successful deploy and probes were on 7d4c23a45. That matches the PR's premise: the deploy smoke rolled the app back to the previous artifact and skipped the later deploy steps, so production does not match `main`.
- **Related PRs:** A search turned up no PR fixing or reverting the same thing. #200 is the merged source, and no other open PR covers it.
- **Motivation:** It still holds. #200's startup check requires the `guest-formula-fingerprint` index and deliberately refuses to start without it. I found no sign that anyone has run the fleet-admin migration (`deploy-accounts-store.sh`) since, and there is no green deploy after the merge. Reverting is still the reviewed way to restore consistency, and re-landing the change (run the migration, then revert this revert) stays possible.

Answer: yes. The PR has not been superseded and its premise holds, so the gauntlet can start.

Follow-up for the maintainer: the long-term fix is still for the fleet admin to run `deploy/aws/scripts/deploy-accounts-store.sh` and then re-land #200 by reverting this revert. If someone runs the migration and redeploys f6fe2b522 successfully before this PR merges, this revert is no longer needed.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr211-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (121413 cached reads)
- Output: 1413 tokens
- Cost: $0.4202226
- Wall-clock: 21s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
