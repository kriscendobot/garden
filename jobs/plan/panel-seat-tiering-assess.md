---
gate: orchestrated
orchestrated_by: panel-seat-tiering
priority: normal
role: assayer
posted_by: producer
posted_at: 2026-08-01T08:48:48Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
handler-timeout: 7200

# Panel seat tiering — 2/3: ASSESS and propose

Second of three children of orchestration `panel-seat-tiering`. Runs **after**
child `panel-seat-tiering-gather`. **Read `journal/reports/panel-seat-tiering/evidence.md`
first** — that file is your input. If it does not exist or is a thin summary
rather than real per-seat data, say so in your `tada/` report and stop; do not
reconstruct the evidence yourself and do not proceed on assertion.

Land your output at `journal/reports/panel-seat-tiering/proposal.md`.

Do **NOT** run git in `$GARDEN_ROOT`; use your per-job worktree.

## What to produce

A **proposal**, not an implementation — child 3 lands the changes.

1. **Per-seat disposition**, each one of: `deterministic-gate` (write a
   `seat-gate-<seat>.sh` pre-pass), `lower-tier` (bind to a cheaper model),
   `retain`, or `insufficient-evidence`. Every disposition cites the specific
   evidence supporting it. Default to `insufficient-evidence` where the data is
   thin — a wrong demotion on a review seat costs more than it saves, because a
   missed defect reaches the maintainer.
2. **Prefer a gate to a cheaper model** wherever a deterministic rule exists. A
   gate costs ~0 and cannot hallucinate; `seat-gate-coverage-auditor.sh` is the
   working precedent and `panel.sh`'s `seat_review` already dispatches to
   `seat-gate-<seat>.sh` when present and executable.
3. **The tier-binding question.** Panel seats currently get NO `--model`. Decide
   whether seats should be bound at all, and if so how the binding should reach
   `panel.sh` — it must stay consistent with the closed inventory
   (`scripts/jobs/model-tier-inventory.tsv`) and with the rule that **no
   automatic path may emit mentat/Fable**. Note that `automatic_route_body`
   governs job bodies, not `claude -p` flags inside a supervised script, so this
   is a genuinely new surface; design it, do not assume an existing lever fits.
4. **Sequencing and blast radius.** Order the changes so the cheapest, most
   reversible land first. Name what would have to be true to roll each one back.
5. **A measurement plan.** State how the next weekly
   `model-tier-effectiveness-review` will tell whether each change helped, and
   what regression would signal it hurt. A change with no way to detect harm
   should not be proposed.

## Scope boundary

The 57%-error panel disposition rate is IN SCOPE to quantify and to sequence
against, but fixing it is **not** this orchestration's deliverable. If the
evidence shows the error rate dominates the cost question, say so plainly and
recommend a separate job rather than widening this one.

## Definition of done

`journal/reports/panel-seat-tiering/proposal.md` landed on `journal2`, with a
per-seat disposition table, the tier-binding design, a landing order, and the
measurement plan. Implement nothing.
