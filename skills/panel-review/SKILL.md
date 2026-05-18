---
created: 2026-05-13
updated: 2026-05-14
author: gardener
---

# Skill: panel-review

Adopted from `references/endo-but-for-bots/skills/panel-review-12-perspectives.md` and shaped for this garden's two-panel jury (seventeen-seat code panel for source-touching PRs, seven-seat design panel for design-only PRs).

The aggregation discipline and submission contract for jury reviews. The defaults in `skills/pr-creation-flow/SKILL.md` § Jury composition are the **code panel** (seventeen seats: assessor, typist, stylist, packager, archivist, prover, curator, migrator, locksmith, warden, saboteur, breaker, purist, spec-keeper, wire-watcher, engine-realist, integrator) for source-touching PRs and the **design panel** (seven seats: critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice) for design-only PRs; both are dispatched by the [judge](../../roles/judge/AGENT.md), which picks the panel kind per `roles/judge/AGENT.md` § Panel-kind discrimination. This skill describes how each panel's findings combine into one verdict and how the judge submits that verdict.

## When to use

- Every PR-creation-flow jury round, on either panel kind. The judge is the panel's foreperson (aggregates the per-juror blocks into one body and submits the formal review).
- A maintainer-requested standalone review of a stale PR. Same procedure; the orchestrator names the panel composition in the dispatch brief and the judge dispatches that composition.

## Panel composition

- **Default for source-touching PRs (code panel): seventeen seats** (assessor, typist, stylist, packager, archivist, prover, curator, migrator, locksmith, warden, saboteur, breaker, purist, spec-keeper, wire-watcher, engine-realist, integrator), dispatched concurrently as a single panel round by the judge. See `skills/pr-creation-flow/SKILL.md` § Jury composition for the seat list, the halved-responsibilities rationale, the four 2026-05-15 maintainer-modeled additions, the 2026-05-18 addition of the `integrator` seat, and the concurrent-dispatch default.
- **Default for design-only PRs (design panel): seven seats** (critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice), dispatched concurrently as a single panel round by the judge. See `skills/pr-creation-flow/SKILL.md` § Jury composition for the seat list and the design-panel rationale. The judge discriminates between panels by the PR's file list per `roles/judge/AGENT.md` § Panel-kind discrimination.
- **Smaller panels** (3 to 6 seats from either default) are valid when the orchestrator names a reduced composition in the dispatch brief for a tiny PR. The aggregation discipline below applies unchanged.
- **Custom compositions** are valid when a maintainer's directive names them. The judge dispatches each named seat and aggregates them all. Cross-panel compositions are permitted (e.g., add the novice to a code-panel round when the PR's JSDoc revision warrants a new-reader's eye).

## Per-juror block shape

Each panel member returns:

```
### <perspective name>

**Verdict:** approve / request-changes / comment-only

**Findings:**
- (concrete actionable, file:line where applicable)

**Notes (out of scope but worth flagging):**
- ...
```

Each block under ~400 words. "Comment-only" is for taste; anything that warrants a code change is "request-changes".

## Aggregation

The judge groups findings into:

- **Must fix before merge** (any "request-changes" with concrete code / test / doc impact). Drives the jury-fixer loop per `skills/pr-creation-flow/SKILL.md`.
- **Should fix in this PR** (taste or clarity items raised independently by at least two seats; on the seventeen-seat code panel the deliberate inquiry-area overlap means routine duplicate flagging is expected and is the signal "promote to should-fix").
- **Out of scope / follow-up** (useful but not blocking this PR's loop).

Dedupe overlapping findings. Where panel members disagree, present both views and pick the side most consistent with the project's `CLAUDE.md` (or `AGENTS.md`); make the disagreement explicit so the orchestrator can act.

## In-scope vs out-of-scope

The jury-fixer loop iterates only on **must-fix and should-fix items in scope for the PR's change**. Out-of-scope complaints (adjacent refactors, package-wide hygiene, follow-up issues) live in the "Out of scope / follow-up" section and do not block the loop. The orchestrator surfaces them as separate issues or follow-up PRs after the jury declares the loop done.

See `skills/pr-creation-flow/SKILL.md` § Jury-fixer loop for the loop's exit condition.

## Posting the review

**Submit as a formal review, not a plain comment.** A plain `gh pr comment` does not flip `reviewDecision`, so the orchestrator's dispatch matrix never sees the verdict and the jury-fixer loop never advances.

```sh
gh pr review <N> -R <repo> --request-changes --body-file /tmp/panel.md
# OR if must-fix is empty but should-fix has items:
gh pr review <N> -R <repo> --comment --body-file /tmp/panel.md
# OR if the panel net-approves with no findings (rare for a fresh PR):
gh pr review <N> -R <repo> --approve --body-file /tmp/panel.md
```

The judge submits the formal review. The body is the same aggregated report (typically 1700 to 2750 words for the seventeen-seat code-panel default, 900 to 1400 words for the seven-seat design-panel default; smaller panels run shorter still). Cite findings by perspective grouped where members agreed; do not list individual agent names.

## Pitfalls

- **Panel-report prose is not exempt from the project style rules.** The aggregated body ships in a public PR review. The same prose rules apply (no em-dashes per `skills/em-dash-style/SKILL.md`, no methodology leaks per `skills/pre-pr-checklist/SKILL.md`). Sweep the body before submitting.
- **A "shadow" finding may be a panel hallucination.** Variable-shadowing claims need a 30-second sanity check before promoting to a should-fix item. Re-read the offending lines and confirm they are in the same lexical scope. A panel run that reads the diff once can mis-name a parameter as shadowing an outer const that lives in a different function.
- **Sibling-package forks miss recent peer fixes.** When a PR introduces a package by forking an existing peer, the correctness perspective should diff the new sibling against the peer's recent commits for fixes that landed between the fork point and the PR's submission. A one-line check that pays for itself on every sibling-fork PR.
- **GitHub blocks `--request-changes` on a self-authored PR.** When the authenticated identity is also the PR's author, the submission returns a GraphQL error. Fall back to `--comment` with the full body; the verdict is preserved in the body, but `reviewDecision` does not flip. The orchestrator's dispatch matrix that keys on `reviewDecision` also keys on the "Must-fix before merge" heading in the body for bot-authored PRs.
- **Design-plus-implementation in one PR needs a design-assessment posture.** When a PR implements all phases of a design as a single deliverable explicitly to assess the design's completeness, the panel's job grows beyond "is this code correct" to include "did the design specify enough to implement, and where did the builder fill in gaps?". The aggregate body carries an "Out of scope but worth flagging (design feedback)" section listing the panel's answers, intended as input back to the design PR rather than as fixer-brief items.

## Notes from the field

- _2026-05-13_: adopted from the reference and reshaped for the 2-member default panel (juror plus saboteur). The reference's 12-perspective form was preserved as a larger-panel option.
- _2026-05-14_: redesign. The default panel grew from 2 seats to 6 named seats (assessor, stylist, archivist, curator, locksmith, saboteur), the judge role was introduced as the panel's foreperson (it aggregates and submits, but is not itself a reviewer), and per-juror block submission migrated from "the juror is the panel-side editor" to "each seat returns a block, the judge aggregates". The orchestrator names a different composition in the dispatch brief when the default does not fit.
- _2026-05-14_ (same day, later): twelve-seat default. The maintainer's directive was to halve each seat's responsibilities so the panel could be deeper in each inquiry area. Each of the six prior seats split into two successor seats; concurrent dispatch became the explicit default at twelve. The aggregation discipline (must-fix / should-fix / out-of-scope grouping, dedupe of overlapping findings) is unchanged.
- _2026-05-14_ (later same day): design panel landed in parallel to the code panel. The five-seat design panel (critic, skeptic, copyeditor, pedant, novice) reviews design-only PRs (file additions only under `<project>/designs/`); the existing twelve-seat code panel reviews source-touching PRs. The judge picks the panel per `roles/judge/AGENT.md` § Panel-kind discrimination. The aggregation discipline is unchanged; only the seat list and the typical aggregated-body word range differ.
- _2026-05-15_: design panel grew from five seats to seven. Two new seats joined: the `decomplector` (Rich-Hickey-lens reader on complexity / state / identity / value modeling) and the `ergonomist` (interface-ergonomics reader on the proposed API or UI surface). The aggregated-body word range for the design panel was widened to roughly 900 to 1400 words to absorb the two additional seats' blocks. The aggregation discipline is unchanged.
