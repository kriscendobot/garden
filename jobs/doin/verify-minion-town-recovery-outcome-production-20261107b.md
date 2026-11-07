---
posted_at: 2026-11-07T16:15:21Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Finish the production acceptance gate for the failed guest-recovery outcome work in kriscendobot/minion.town.

The implementation is on head branch `fix/recovery-outcome-screen`, opened by job `build-minion-town-recovery-outcome-screen-20261105`. Find its PR by the durable garden marker. The PR is intentionally an orchestrated slice until its normal gauntlet, merge, continuous deployment, and production observations finish.

Own every remaining step:

1. If the PR is still in its gauntlet or awaiting merge, monitor it in the foreground for the bounded handler window. Do not bypass review or merge policy. If it cannot reach production in this claim, durably re-arm this same one-time successor before completing or leave the job unfinished for requeue.
2. After merge, wait for `deploy (continuous deployment)` and its triggered production probe to finish successfully. Diagnose or post a concrete fix job for any failure; do not call a skipped or failed deploy accepted.
3. Verify https://minion.town/ with Playwright. Exercise the dedicated failed-recovery screen through request interception or a dedicated throwaway test principal only; never mutate a maintainer's account or guest. Confirm exact GitHub wording, cleared address bar, heading focus and live-region semantics, one-reload persistence followed by consumption, and the actions to choose another provider and open the wait-list form.
4. Verify the production wait-list action end to end with the dedicated fixed address `prod-probe@minion.town`, accepting only HTTP 202 and the privacy-preserving success response. Repeated use must remain the single idempotent probe row. Confirm the new `wait-list-store-accepts-signup` production objective passes.
5. Save production screenshots as durable evidence. Update the PR description's phase/evidence ledger from `orchestrated-slice` to `deliverable` with production run links and observations, and post one concise top-level completion comment with the evidence. This job explicitly authorizes those PR edits/comments.

Report the PR, merge/deploy/probe run URLs, Playwright observations, screenshots, and any follow-up.

(Re-armed 2026-11-07 by build-minion-town-recovery-outcome-screen-20261105: the original `verify-minion-town-recovery-outcome-production-20261107` was reaper-doomed only because every worker on endolin-garden-ece02cb4 had a dead Bash tool (EROFS tmpexec); it never did work.)

<!-- garden-transient-elapsed: kind=exit0 through=0 values=2368 -->
<!-- garden-reap-now -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-11-07T16:15:35Z
