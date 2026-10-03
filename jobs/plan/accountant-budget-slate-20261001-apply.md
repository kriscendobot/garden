---
gate: orchestrated
orchestrated_by: accountant-budget-conversation-20260930-resume-split
priority: normal
role: accountant
posted_by: orchestrator
posted_at: 2026-10-03T03:28:17Z
---

---
role: accountant
tier: mentor
fallback-tier: minion
dispatch: automatic
---
**Role: accountant.** Apply and record the budget slate the maintainer APPROVED. This is a child of the split orchestration `accountant-budget-conversation-20260930-resume-split`, which comes from `accountant-budget-conversation-20260930-resume`.

**Inputs (already durable in the journal, so do not wait for a reply):**
- The revised slate and mandate text the maintainer approved: `journal/inbox/maintainer/read/msg-accountant-budget-conversation-20260930-resume-636d6d525ffa.md`. It has 7 arcs: MT over MCP+OCapN 30%, MT capability git remote 20% (incl. kriscendobot/minion.town#86), MT UI 15%, background Endo/OCapN 20%, moonshots 8%, garden upkeep 5%, Endo backlog sliver 2% (staged gauntlets only, and the 2026-08 weaves stay parked). The message also carries the adjusted 6-item mandate text.
- The maintainer's reply, in `journal/inbox/accountant-budget-conversation-20260930-resume/unread/20261002T043717Z-c66a59.md`, sent 2026-10-02T04:37Z: "approve — separate arcs for the three minion.town slices (not one combined arc). Apply the slate as proposed, authorized_by: kriskowal. Going forward, keep distributing tokens to this ranking as capacity becomes available each reset, not just as a one-time apportionment."

**Do:**
1. `build-accountant-arc-apportionment` is done, so `scripts/jobs/set-apportionment.sh` now exists on main2. Read its `--help` and apply the slate exactly as approved, in one commit: three separate minion.town arcs, the adjusted mandate text, `authorized_by: kriskowal`, and `--carry-forward` (or the equivalent) so the ranking re-applies at each quota reset, per the maintainer's "going forward" directive. If the deployed root lacks the script, run it from your per-job worktree. Do not hand-edit `config/*`.
2. Record the outcome at `journal2:projects/garden/budget-slate-20261001.md` via `land-journal-edit.sh`. Include the slate, the reasons (the maintainer's ranking, and spend running near the inverse of it), the mandate change, the separate-arcs decision, the standing per-reset directive, and the policies (spend to 90% and never 100%; use reset credits mid-week before they expire; hold the endolin2 credit that expires 10-22 for mid-week).
3. Send the maintainer a one-paragraph confirmation of what was applied with `message-user.sh <your-base>`, without waiting for a reply.
4. If set-apportionment.sh cannot express "carry forward each reset", say so in the record and in your report, and post a named follow-up job for it. Do not fake it.
