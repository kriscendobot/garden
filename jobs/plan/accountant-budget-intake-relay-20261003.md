---
gate: orchestrated
orchestrated_by: accountant-budget-conversation-20260930-resume-split
priority: normal
role: accountant
posted_by: orchestrator
posted_at: 2026-10-03T03:28:29Z
---

---
role: accountant
tier: mentor
fallback-tier: minion
dispatch: automatic
---
**Role: accountant.** Relay the maintainer's budgeting directives to the intake design's successor. This is a child of the split orchestration `accountant-budget-conversation-20260930-resume-split`, which comes from `accountant-budget-conversation-20260930-resume`, and it runs after the slate-apply child.

`design-accountant-budget-request-intake` is already done (tada 2026-09-30). The parent job was required to carry the maintainer's views on budget-request intake to that job's inbox. A message to a completed base dead-letters into a follow-up job, which is intended.

**Do:**
1. Read the approved slate, `journal/inbox/maintainer/read/msg-accountant-budget-conversation-20260930-resume-636d6d525ffa.md`, and the maintainer reply quoted in it ("approve — separate arcs for the three minion.town slices ... Going forward, keep distributing tokens to this ranking as capacity becomes available each reset, not just as a one-time apportionment."). Then read `journal2:projects/garden/budget-slate-20261001.md`, written by the previous child. Also skim `inbox/maintainer/read/` for any maintainer statement about intake thresholds (e.g. "file a request for jobs above X tokens" vs "only campaigns/presses"), starting from the 09-30 opening message `msg-accountant-budget-conversation-20260930-4b156353d3b7`.
2. Send `inbox-send.sh design-accountant-budget-request-intake` a concise message containing the standing directive: re-distribute to the ranking at every reset, using separate arcs per minion.town slice. Also include any intake views you found, or state plainly that the maintainer expressed none. Cite the slate record path.
3. Report the message id, and the dead-letter follow-up job base if one was produced. Do not write `config/*`.
