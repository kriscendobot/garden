---
ts: 2026-05-29T05:38:31Z
kind: result
role: gardener
host: endolinbot
project: endo-but-for-bots
to: liaison
short_id: d94d11
refs:
  - entries/2026/05/29/053130Z-dispatch-steward-f9a0b1.md
  - entries/2026/05/29/051600Z-result-steward-c6d7e8.md
  - https://github.com/endojs/endo-but-for-bots/pull/376
prs:
  - repo: endojs/endo-but-for-bots
    pr: 376
    role: precipitating
---

# Result: steward maintainer-feedback ownership + design-vs-source dispatch

## Maintainer directive

Investigate the missed kriskowal COMMENTED review on contractor-opened
design-only PR #376 (6 inline comments at 2026-05-29T05:01:20Z; steward
deferred 28 minutes until the maintainer flagged it at 05:29Z) and land
the structural fix.

## Investigation findings

Three gaps in the current state of `roles/steward/AGENT.md` and
`skills/monitor-endo-but-for-bots/SKILL.md`:

1. **Ownership ambiguity.** Nothing in the steward role file or any
   skill said "defer to contractor on PRs the contractor opened." The
   steward's deferral was its own invention. The contractor's slot
   machinery owns initial-PR-drafting and slot-level gamut advancement;
   it does not naturally absorb mid-stream maintainer-feedback events
   and its per-cycle cadence (5 to 30 minutes) is too slow for the
   maintainer's same-cycle expectation on an active review.

2. **Role-by-PR-shape gap.** The monitor skill's PullRequestReviewEvent
   row (as edited earlier today) dispatched fixer universally on
   COMMENTED. PR #376 is a design-only PR (every changed path under
   `designs/`); for design-only PRs the right response role is
   designer with a feedback brief, not fixer (whose surgical-fix scope
   is code, not design).

3. **Timing (event vs cycle).** The PR-creation-flow scan handles
   *panel-state* transitions per cycle, but *maintainer-state*
   transitions on draft PRs are inter-cycle Monitor-surfaced events.
   Neither file explicitly named the Monitor-event → dispatch path,
   so the steward had no documented obligation to act in the same
   tick the Monitor fired.

## Files edited and commit

Commit `ccb4599b` on `origin/main`:

- `roles/steward/AGENT.md` — new **Maintainer-feedback response**
  section (placed immediately before *PR-creation-flow scan*) with
  four subsections:
  - *Ownership: steward, not contractor.* States the rule and the two
    reasons (cadence, identical authority bounds). Names the
    composition pattern when both orchestrators are alive on the same
    host: steward acts on the Monitor event; contractor's next scan
    re-dispatches the next-stage-owed role on the resulting push.
  - *Dispatch decision by PR shape.* Routes design-only PRs to
    designer-with-feedback and source-touching PRs to fixer. Defers
    to `roles/judge/AGENT.md` § Panel-kind discrimination for the
    shape predicate rather than re-implementing it.
  - *Trigger surfaces.* Enumerates the three Monitor surfaces that
    can carry maintainer-feedback (daemon-log tail, @-mention
    surveillance, per-cycle survey safety net).
  - *Composition with the PR-creation-flow scan.* Names the
    orthogonality: panel-state vs maintainer-state transitions are
    independent and each owed its own next-stage role.
  - *Notes from the field* — 2026-05-29 row citing this dispatch and
    the 28-minute gap on PR #376.

- `skills/monitor-endo-but-for-bots/SKILL.md` — `PullRequestReviewEvent`
  row split by PR shape:
  - `CHANGES_REQUESTED` on source-touching → fixer
  - `CHANGES_REQUESTED` on design-only → designer with feedback brief
  - `COMMENTED` with non-trivial body on source-touching → fixer
  - `COMMENTED` with non-trivial body on design-only → designer with
    feedback brief
  - `APPROVED` → clear bulletin row (unchanged)

  Cross-links `roles/steward/AGENT.md` § Maintainer-feedback response
  for the ownership rule and `roles/judge/AGENT.md` § Panel-kind
  discrimination for the shape predicate. Adds a 2026-05-29
  Notes-from-the-field row.

- Frontmatter `updated:` bumped to 2026-05-29 on both files.

## Consequence for PR #376

The gardener does not act on #376 directly; that is the parallel
designer dispatch's job (the dispatch mentions one was opened in
parallel to this one). The structural fix this dispatch lands ensures
the next analogous case lands a same-cycle dispatch from the steward
rather than recreating the 28-minute gap.

## Out-of-scope (not edited)

- `roles/general-contractor/AGENT.md` — no change needed. The
  contractor's slot machinery already targets initial-PR-drafting and
  gamut advancement; nothing in it claimed maintainer-feedback
  ownership, so no positive deletion is owed. If the contractor's
  per-cycle survey starts dispatching response-to-feedback in the
  future and races with the steward, a re-clarification lands then.
- `skills/at-mention-surveillance/SKILL.md` — already correct after
  this morning's per-repo override edit; the @-mention surveillance
  matrix dispatches per its own table, and the new steward section
  cross-links it without changing its body.

## Self-improvement

Two observations from this engagement worth surfacing:

1. **Same-day double edit on monitor-endo-but-for-bots.** The skill's
   `updated:` date is 2026-05-29 from this morning's edit (commenter
   parity); this afternoon's edit (PR-shape split) is the second on
   the same date. The frontmatter discipline in `roles/COMMON.md`
   does not prescribe how to disambiguate; the gardener kept a single
   `updated:` value with two Notes-from-the-field rows distinguishing
   the two edits, which seems clean enough not to warrant a frontmatter
   amendment.

2. **The PR-shape discrimination is referenced from three places**
   (judge, monitor skill, steward role). Each defers to the judge's
   canonical wording rather than copying it. This is the right shape
   under the don't-duplicate-rules discipline, but the dependency edge
   means a future judge-side change to the predicate (e.g., the
   panel-kind heuristic evolving to recognize "primarily-design"
   mixed PRs) needs an audit of the citing sites. No action this
   engagement; flagging for the next gardener pass.

Self-improvement: `roles/steward/AGENT.md` and `skills/monitor-endo-but-for-bots/SKILL.md`; new steward section establishes Monitor-surfaced maintainer-feedback as the steward's same-tick obligation, and split the monitor skill's PullRequestReviewEvent row so design-only PRs route to designer rather than fixer.
