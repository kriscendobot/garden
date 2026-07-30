cadence: weekly-at-Mon-09:00-UTC
last_dispatched: 2026-07-27T09:00:00Z
job_basename_prefix: model-tier-effectiveness-review
---
---
role: assayer
tier: minion
model: gpt-5.6-terra
---
# Weekly model-tier effectiveness review

Assess every model currently known to the garden and determine whether its tier remains the fastest and cheapest tier at which it is still effective for the size and risk of work dispatched to it.

Use the executable tier inventory and the journal evidence since the prior review. Evaluate at minimum: job-size and risk class; elapsed and active execution time; estimated or measured cost; completion versus timeout, requeue, poison, or maintainer intervention; verification and panel outcomes; defect or fix-loop rate; and downstream PR review outcomes, especially approval and merge. Separate provider outages and quota failures from model-quality failures. Control for selection bias, role mix, tiny samples, and jobs whose acceptance outcome is not yet observable.

Apply tier expectations:
- myrmidon and minion: small or mechanical jobs, low cost, short latency, reliable completion.
- mentor and mentat: large, ambiguous, or high-risk jobs, strong verification, high acceptance and PR-approval rates.
- mentat remains manual-only; automatic routing targets minion; Kimi is disabled while Moonshot credits are exhausted.
- Carry forward `reports/kimi-k3-credit-exhaustion-20260730.md`: Kimi's complete
  activation-to-exhaustion invoice is $64.00 across 28 token-bearing engagements;
  analyze 4 token-bearing failures separately from 14 zero-token quota/outage
  attempts, and do not treat the completion-censored sample as PR acceptance.

For each model, report the current tier, evidence window, sample sizes, work mix, performance and acceptance measures, confidence, and one disposition: retain, promote deeper, demote shallower, or insufficient evidence. Prefer movement toward the fastest and cheapest shallower tier that still meets effectiveness and acceptance parameters for its assigned work. Recommend deeper movement when failures, review rejection, or fix-loop burden show the current tier is not effective. Do not mistake speed alone for success.

Compare against the prior review through schedule carry-forward when available. Produce a complete proposed tier table and a concise list of changes with evidence. Do not silently alter routing on weak evidence. If a retier is well-supported, post a bounded garden follow-up job to update the executable mapping, documentation, and regression tests; otherwise surface the recommendation to the maintainer. Never widen automatic access to mentat.
