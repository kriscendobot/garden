---
gate: deferred
priority: low
posted_by: producer
posted_at: 2026-07-02T17:33:31Z
---

# shepherd on endojs/endo-but-for-bots PR #588 (PARKED from doin — churn/near-poison)

Repo: endojs/endo-but-for-bots (bot-pushable; bot-repo only). Standing comment auth.

Moved from jobs/doin to a blocked plan by the liaison on 2026-07-02: this shepherd was reaped repeatedly (PR #588 was at 3/5 requeue cycles) during the host-identity instability (the endolinbot2 env-drift kept knocking the leader/reaper offline, orphaning claims). Parking it here rescues it from poisoning on the reaper's next requeue.

RESUME once the host identity is durably stable (leader running as the intended identity). Task: rebase PR #588 onto current origin/llm (which carries the bucketed scripts/eslint-repo.sh lint fix, #597) and drive CI green; escalate to a fixer only for a genuinely different failure.
