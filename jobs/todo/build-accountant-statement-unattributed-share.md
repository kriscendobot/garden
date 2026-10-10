---
role: builder
arc: garden-upkeep
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# accountant-statement.sh: estimate unattributed spend per pool

Garden repo (main2). `scripts/jobs/accountant-statement.sh` shows arc spend and pool used % separately. On 2026-10-10, claude-endolin1 was at 27% (about 73M) while only about 5M was charged to any arc. Non-foreman work (auto-staged gauntlets, watchers, liaison) never passes through the slate, so the statement hides how much spend that is.

Add a line or column per pool to the Pools section that estimates the **unattributed share**: pool tokens spent this window minus arc-charged spend on that pool. Use the existing meters/ledger, and state the method in one line. If arc spend can't be split per pool, show a fleet-wide total plus each pool's used-tokens instead. Keep it read-only and deterministic, and update context/operations/accountant.md if the output shape changes.

Requested by the maintainer proxy (reply 20261010T163557Z-98b626 to accountant-weekly-20261010-160507) for next week's statement.
