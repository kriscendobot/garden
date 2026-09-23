Landed on `main2` (`4f280ec1e1`), all gates green. Job complete.

---

**Completion report**

Implemented recommendation 8 of `designs/cybernetics-audit.md` § 7 — scheduled dispatch now goes through the fleet's one admission gate. Landed bare on `main2` (`4f280ec1e1`) per CLAUDE.md § Conventions.

**What changed**

1. **Budget-hold routing (`scripts/jobs/scheduler.sh`, `usage-meter.sh`, `post-job.sh`).** When `budget_fleet_status` is `backoff` (every bounded pool at high water), a due dispatch is now parked in `plan/` under the budget-hold envelope instead of written straight to `todo/` — the identical routing `post-job.sh` applies. Extracted the envelope into a shared `budget_hold_wrap` helper (in `usage-meter.sh`) that `post-job.sh` now also uses, so the two admission producers can't drift. `unknown`/`off` budget state routes to `todo/` (fail-open), matching `post-job.sh`.

   **Atomicity preserved deliberately:** the routing is done *inline*, in the same CAS commit as the `last_dispatched` stamp — not by shelling out to `post-job.sh`. Shelling out would split stamp-and-post into two commits against two clones, breaking the exactly-once-per-cadence guarantee and the carry-forward drain's same-commit `git rm`. The identity index (`post-job.sh`'s other feature) is a genuine no-op for scheduled jobs — one producer, no external directive — so it's intentionally not replicated; the occupancy gate is the scheduler's own dedup. A test asserts a second tick in the same period posts nothing more.

2. **Occupancy dedup.** New optional `occupancy:` schedule field (`skip` | `carry-forward`), opting a recurring schedule into the board check the `once:` path already performs, keyed on the timestamped family in `plan/todo/doin` (never `tada`). `skip` advances the clock and posts nothing while a prior instance is live; `carry-forward` stays due. Fixes the per-period accumulation that ran four `endo-*-press-*` generations concurrently on 2026-09-01. Wired through `set-schedule.sh` (`GARDEN_SCHEDULE_OCCUPANCY`, validated) and preserved across re-stamps via `write_schedule`.

3. **Drain posture — decided explicitly.** Under a fleet drain the scheduler now dispatches nothing and advances no clock. Rationale: a scheduled dispatch is *new work* and a drain is the operator's moratorium on new work, so the tick is a whole no-op; because no clock advances, each due schedule fires *exactly once* for the then-current period when the drain lifts — no `todo/` backlog flood, no permanently-broken cadence (only intra-drain periods coalesce, which is what a moratorium should do). This removes the anomaly the audit named (§ 1.3: one of only two producers ignoring drain). Orthogonal to budget-hold (park vs skip).

   I judged this a defensible decision rather than a genuine open maintainer question, so I did **not** use the design-with-open-questions PR carve-out. **Flagging it for review anyway:** if you'd prefer schedules to keep posting under drain (parking to `plan/` rather than skipping), it's a one-line flip of the drain gate.

**Verification.** New `scripts/jobs/test/scheduler-admission-test.sh` (19 hermetic cases: budget-hold routing + fail-open + exactly-once, occupancy skip/carry-forward/none, drain suspend + clean resume). All existing scheduler/budget tests pass (anchored-cadence, handler-timeout, preflight-deploy-lag, preflight-typo, carry-forward, live-budget-admission, post-job-template-role, promote-plan-shepherd-budget, job-frontmatter-validation). CI gates green: `shellcheck -S warning` on all edited entrypoints, `bash -n` across `scripts/`+`skills/`, `tests/checks/run.sh`. Documented all three in `skills/schedule/SKILL.md`.

**Follow-ups (out of scope, noted in the audit).** `gauntlet.sh`/`auction.sh` stage posts share the same bypass class (`designs/live-budget-admission.md:174`) — a separate job.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/cybernetics-rec8-scheduler-admission.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 132 tokens (9120009 cached reads)
- Output: 71991 tokens
- Cost: $7.505058250000002
- Wall-clock: 1041s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
