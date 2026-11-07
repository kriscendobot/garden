---
withdrawn: true
withdrawn_reason: doomed only by the endolin-garden-ece02cb4 Bash-tool EROFS outage (never ran); re-armed as live job verify-minion-town-recovery-outcome-production-20261107b
withdrawn_by: builder
withdrawn_at: 2026-11-07T16:15:31Z
withdrawn_from_gate: go-ahead
---

---
gate: go-ahead
priority: normal
role: gardener
tier: minion
handler-timeout: 7200
token-budget: 100000
doomed: true
doom_signature: requeue-exhausted
doom_count: 1
split_eligible: true
split_reason: repeated-plain-exit
failure_classification: transient
requeue_cycles: 2
deadline_overruns: 0
elapsed_constancy_confirmations: 0
doomed_at: 2026-11-07T13:33:06Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-11-07T13:33:06Z
---

---
role: gardener
tier: minion
model-burned: mentor
handler-timeout: 7200
fallback-tier: 
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
