---
role: fixer
priority: high
posted_by: liaison
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Fix: claim-admission records a decision commit on every declined claim (journal churn, ~2,200/day)

Repo: the garden itself (`kriscendobot/garden`, `main2`, push direct, no PR).

## Observed
Of 6,252 `journal2` commits in the 24h to 2026-09-28 05:00Z, **2,701 were `decision(...)`**, and **2,232 of those
were `claim-admission:decline-claim`**. Every refused claim (most likely clerics during `codex-endolin` backoff, retrying
each tick, and possibly monks under the budget gate) writes a journal commit. This is the same shape as the
triager-pacing churn fixed in 74461976fd / 3c696ea6c8: it regrows the journal (back to ~322 MiB / 29k commits five
days after the 09-23 truncation), which slows every fetch and made fresh clones exceed the 45s cap (see
`fix-journal-cold-clone-bootstrap`).

## Ask
1. Apply record-on-change to claim-admission declines: record a decision only when the (worker kind, decision, reason)
   state changes for that worker/host, plus the existing heartbeat cadence (e.g. 6h), not on every tick. Reuse the
   shared decision-ledger churn guard if one exists, rather than a new mechanism.
2. Audit the other high-volume emitters in the same window (`plan-queue:promote-plan` 222/day,
   `reaper:schedule-plain-retry` 106/day, `watchdog-notice` 334/day, `bulletin:` 220/day, `budget-live` 463/day,
   `error:` 124/day, `terminal-failure:` 112/day). Fix any that write on every tick without a state change, and report
   the rest with a one-line justification each.
3. Tests: N consecutive identical declines give one record, and a changed reason gives a second. Run the claim-job and
   decision-ledger suites and push. Report the estimated commits/day before and after. Complete via the normal
   completion path.
