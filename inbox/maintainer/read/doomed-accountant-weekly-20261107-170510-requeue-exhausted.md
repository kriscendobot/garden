from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-11-07T17:43:32Z
doom_base: accountant-weekly-20261107-170510
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-11-07T17:43:32Z
last_seen: 2026-11-07T17:43:32Z
---
SPLIT-ELIGIBLE job PARKED in jobs/plan/ (held, gate=go-ahead) after its sole backed-off retry also exited non-productively on endolin-garden-ece02cb4.
The reaper stopped retrying it; split it into claim-sized stages or surface it as indivisible.
The work is preserved at jobs/plan/accountant-weekly-20261107-170510; it stays HELD until a human promotes it
(promote-plan.sh accountant-weekly-20261107-170510) or removes it, so nothing is lost.
Original job base: accountant-weekly-20261107-170510

--- original job body ---
---
handler-timeout: 14000
---

---
role: accountant
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Weekly arc apportionment

Run the accountant's weekly engagement (roles/accountant/AGENT.md;
context/operations/accountant.md):
1. `scripts/jobs/set-apportionment.sh --carry-forward`.
2. Build the statement from `scripts/jobs/accountant-statement.sh`.
3. Propose next week's slate, and send statement + proposal with
   `scripts/jobs/message-user.sh <your-base>`.
4. Apply an unambiguous reply with `set-apportionment.sh --authorized-by
   <login> --message-id <id>`, confirm the resulting table, and complete. With
   no reply, complete with the carried-forward slate in force.

Standing maintainer direction (kriskowal, 2026-10-02): "keep distributing tokens to this ranking as capacity becomes available each reset, not just as a one-time apportionment." The ranking is the slate approved 2026-10-02 (`projects/garden/budget-slate-20261001.md`), with separate arcs for the three minion.town slices. Apply the 90% ceiling, and account for reset credits (`projects/garden/reset-credits.md`). If `set-apportionment.sh` is missing on your host (deploy pending), do not hand-write config. Report the gap and park a successor.
