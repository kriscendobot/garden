---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# fix kriscendobot/minion.town#218: move the unused deletion facet to #220, then resume the gauntlet

Repo: kriscendobot/minion.town, PR https://github.com/kriscendobot/minion.town/pull/218 (head branch as on the PR, base `main-68c3960`).
The gauntlet `kriscendobot-minion.town-pr218-gauntlet` stopped a third time at review-budget-reached (13/13, head `4a2bef5`, CI green 4/4, about $23 spent).
Each round fixed real defects, but the panel keeps forcing the decomplector's repeated-mechanism question
(latest review on `4a2bef5`, finding "a deletion mechanism ships with no consumer"): `http.ts` discards `guestBondAdmin`, and
`GuestBondAdmin.closeGuestBonds`/`unbondGuest`, `GuestBondsClosedError` and the closed-guest flag have no caller until #220.

Supervisor decision (arc supervisor, under the inverted-review standing order, journal `entries/2026/10/07/203746Z-message-gardener-a253b1.md`).
This takes the decomplector's own option "split out the deletion path":

1. **Move the deletion-only surface out of #218 and into #220**, which consumes it. That covers `closeGuestBonds`, the admin `unbondGuest` (if only deletion uses it),
   `GuestBondsClosedError`, the closed-guest flag and its IAM attribute grant, and their tests and doc text. Revert `makeDynamoAccountStore`'s
   `{ accountStore, guestBondAdmin }` return shape if nothing in #218 needs it.
2. **Keep in #218** the per-bond ledger rows written in the bond/rebind/unbond transaction, `row_kind`, recovery-key versioning,
   the backfill and its checker, and the IAM grants those need. These were decided 2026-10-23 and 2026-10-24; do not reopen them.
3. Carry the moved code onto #220's branch (`split/pr216-account-deletion`, stacked on #218 and #219) so nothing is lost:
   a follow-up commit there, with safe-push-pr-head.sh. #220 stays draft and unscheduled for a gauntlet; it is restacked after #218 merges.
4. Update #218's PR body ("What", "Decision", "Out of scope") and the design text to match. Answer the decomplector thread once, briefly.
5. Apply any other real defect (wrong behavior, data loss, authority error, failing test) still open on the latest panel review; leave should-fix items.

Keep CI green on #218 and leave it draft. When done, resume its gauntlet for two rounds:
`scripts/jobs/gauntlet.sh --resume-from-stage kriscendobot-minion.town-pr218-gauntlet panel --add-rounds 2`. If that fails, report why.
