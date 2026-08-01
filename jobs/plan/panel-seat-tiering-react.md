---
gate: orchestrated
orchestrated_by: panel-seat-tiering
priority: normal
role: builder
posted_by: producer
posted_at: 2026-08-01T08:48:53Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
handler-timeout: 10800

# Panel seat tiering — 3/3: REACT — land the evidence-backed improvements

Third of three children of orchestration `panel-seat-tiering`. Runs **after**
child `panel-seat-tiering-assess`. **Read `journal/reports/panel-seat-tiering/proposal.md`
first** — it is your work order. If it is missing, or proposes nothing that its
own evidence supports, report that and stop rather than inventing changes.

Repository: https://github.com/kriscendobot/garden. Land directly on `main2`, no
PR (garden convention — no PR workflows for the garden's own repo). Do **NOT**
run git in `$GARDEN_ROOT`; use your per-job worktree.

## What to do

Implement **only** the dispositions the proposal marks as evidence-supported.
Leave every `insufficient-evidence` seat exactly as it is — an unmeasured seat
stays where it is, and that is a correct outcome, not an incomplete one.

Likely shapes, per the proposal:

1. **Deterministic seat gates.** New `scripts/jobs/gardening/seat-gate-<seat>.sh`,
   modelled on the existing `seat-gate-coverage-auditor.sh`. Each MUST own the
   seat's block on stdout in **every** branch (pass, fail, and nothing-to-judge)
   — `panel.sh`'s `seat_review` returns the gate's output directly, so a gate
   that prints nothing reproduces the 0-byte-seat-block failure that has jammed
   the panel gate before.
2. **Tier bindings for seats**, if the proposal designs one. Respect the closed
   inventory and the invariant that no automatic path emits mentat/Fable.
3. **Regression coverage.** Anything that changes panel dispatch needs a test
   under `scripts/jobs/test/`. `GARDEN_PANEL_SEAT` / `GARDEN_PANEL_DECIDE` /
   `GARDEN_PANEL_APPELLATE` exist precisely so a panel can be driven
   non-interactively — use them; do not add a test that spends `claude -p`.
4. **Documentation.** Update `skills/panel/SKILL.md` and
   `skills/model-selection/SKILL.md` where behaviour changed. If seats gain a
   tier, `skills/model-selection/SKILL.md` must say so — it currently documents
   the job-body choke point only.

## Gates before you push

Run the repository's own checks (`scripts/jobs/test/`) and the pre-push gates.
A lint or test failure is a defect in our automation, not an acceptable warning —
close it locally rather than pushing red.

## Definition of done

Changes landed on `main2`; every landed change traceable to a specific claim in
`proposal.md`; tests green; skills updated; and a `tada/` report that states
plainly which proposed dispositions you implemented, which you skipped, and why.
If you skipped something the proposal recommended, that is a legitimate outcome —
report it, do not silently drop it.
