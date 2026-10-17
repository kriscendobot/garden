---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Restore the claude-endolin1 cap after the 2026-10-17T03:00Z reset

On 2026-10-16 the maintainer (kriscendobot's operator, liaison session) approved a TEMPORARY cap raise on `claude-endolin1` from 271000000 to 430000000 (`set-budget-pool.sh claude-endolin1 430000000 temp-raise-endolin2-login-headroom-20261016-maintainer 2026-10-16`), because this host's workers ran on a claude-endolin2 login (65% used, about 59M tokens left) while the ledger charged them to claude-endolin1 (359M spent, over the 271M cap), so the claim gate refused work. Both accounts reset at 2026-10-17T03:00Z (Friday 20:00 Pacific).

Do now: (1) confirm the weekly window rolled over (budget/live/claude-endolin1 window_start_epoch should be 2026-10-17T03:00Z or later and spend small). If it has NOT rolled, stop and message the maintainer inbox; do not restore yet. (2) Restore the cap: `scripts/jobs/set-budget-pool.sh claude-endolin1 271000000 manual-implied-301M-90pct-20261006-maintainer 2026-10-06`. (3) Ask the maintainer inbox which login this host's workers are on now (endolin1 or endolin2) and, if endolin2 is still authenticated here, say plainly that the ledger will again charge endolin2's spend to claude-endolin1. (4) Report the before and after cap and monk counts. Do not touch claude-endolin2's retirement.
