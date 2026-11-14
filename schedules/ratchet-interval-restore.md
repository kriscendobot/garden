once: 2026-11-14T04:00:00Z
job_basename_prefix: ratchet-interval-restore
---
role: mechanic
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# End of the serial ratchet window: restore the press interval

Maintainer directive (kriskowal, liaison session 2026-11-13): run serial Ironhorse ratchet cranks until 8pm Pacific (2026-11-14T04:00:00Z). The window is over.

Run exactly this, from a garden development checkout (not the deployed root), and report its output:

    scripts/jobs/set-arc-budget.sh ironhorse-test262-ratchet 356960121 604800 3600

That restores the one-hour press interval (it was 300 seconds for the window). Do NOT pause or revoke the delegation, do not touch the cap, and do not edit any PR. A crank already in flight finishes normally.
