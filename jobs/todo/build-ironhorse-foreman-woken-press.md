---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: builder
handler-timeout: 14339

# Build: foreman-woken, budgeted press for the Ironhorse test262 arc

Repo: garden (main2). Tracker: https://github.com/kriscendobot/garden/issues/51
Maintainer directive (kriskowal, issue comment id 5884119530, 2026-09-29T05:15Z; cited as plain text, not a URL, so no directive identity derives): resume the arc, "but within a budget and a press interval scheduler that only the foreman can wake. That is, each engagement should be followed by a plan to continue the arc, which the foreman will pick up only if budget permits."

ISSUE NOTE (copy verbatim into every follow-on job):
issue_spine: issue-kriscendobot-garden-51
issue_url: https://github.com/kriscendobot/garden/issues/51#issuecomment-5884119530
submitter: kriscendobot

State handed to you:
- The scheduler-driven `ironhorse-ratchet` schedule (2h, mentat watcher, dispatch: ratchet-delegated) was SNOOZED to 2027-01-01T00:00Z by deadmail-issue-comment-5884119530 so no scheduler tick wakes the arc. Retire/delete it once the foreman-woken path replaces it; never un-snooze it back to a scheduler cadence.
- The ratchet merge delegation (journal2 entries/2026/09/28/201230Z-message-gardener-aa49da.md; config/delegations/ironhorse-test262-ratchet) is unchanged and still active. Do not widen it. Today the schedule is the ONLY automatic mentat producer and claim/handlers require the scheduler-canonical watcher task + date/time basename (context/operations/ironhorse-ratchet.md). Moving admission to the foreman must preserve every one of those gates (active record, exact canonical task, arc marker, no fallback tier, no provider pin) — only the waker changes.
- Parked plan activate-ironhorse-ratchet-autopilot-20260929-r4 (timer-released ~11:30Z) was written to admit a scheduler tick; it has been annotated with this directive. Coordinate with it (inbox-list.sh / inbox-send.sh) — its deploy-verification work stays useful; its "snooze to near-future to admit the first tick" step is superseded.
- Parked ironhorse-test262-ratchet-round3-floor-resolution-20260928 (awaiting-maintainer: reconcile the historical floor vs restore all 901 paths) is still unanswered; the comment above does not answer it. Do not decide it.

Build (deterministic, no LLM in the gate path; tests under scripts/jobs/test/):
1. Press interval: a deferred plan may carry `not_before: <ISO-UTC>`; plan_deferred_ranked (hence the foreman's promotion) skips it until that instant. post-plan.sh gets `--not-before`; annotate-plan.sh can adjust it. Fail closed on an unparseable value (never promote early). Nothing but the foreman promotes these.
2. Budget: the foreman already refuses promotion at fleet/host budget high water. Add a per-arc budget: journal config (e.g. config/arc-budgets/ironhorse-test262-ratchet) naming a token cap per rolling window, with spend derived from the usage ledger for jobs carrying the arc marker (reuse campaign-spend.sh's derivation style; no mutable counter). The foreman skips an over-budget arc's plans and records why (decision log). The maintainer has not named the number — ask on the issue via message-user.sh; until answered, park the first engagement rather than guessing, OR use a conservative default only if the maintainer approves it.
3. Self-continuation: every arc engagement (the mentat ratchet-watcher step, and any crank builder it dispatches) ends by parking exactly one deferred successor `ironhorse-test262-press-<UTC stamp>` with `not_before = now + press interval` (propose 6h; make it config) carrying the arc marker, idempotent against a live successor. A halted/paused/revoked arc parks none. Make the foreman-promoted successor satisfy the watcher's claim/handler gates in place of the scheduler-canonical basename.
4. Update context/operations/ironhorse-ratchet.md (and skills/job-board / schedule docs where they describe press cadence), land on main2, verify on the deployed leader before seeding the first successor plan.
5. Reply on https://github.com/kriscendobot/garden/issues/51 with what landed and how to set the budget/interval; refresh the issue title/body if state changed. Never close the issue.
