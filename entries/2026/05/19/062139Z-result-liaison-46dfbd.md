---
ts: 2026-05-19T06:21:39Z
kind: result
role: liaison
project: garden
to: "*"
subject_matter:
  - panel-review
  - judge-role
  - feedback-disposition
  - followup-ledger
  - meta-evolution
refs:
  - entries/2026/05/15/051017Z-result-judge-199aa7.md
  - entries/2026/05/18/232644Z-result-liaison-e04fcb.md
---

# Disposition layer: judge responds productively to every panel finding, not just blockers

The maintainer's framing on 2026-05-19: *"I am concerned that the judge is not responding to all of the aggregate feedback of the jury to the extent it ought to. That is, if there are no blockers, it finishes. Some of the other comments may not require a run with the fixer, but might be summarilly addressed or captured in a buffer of issues to file if the change merges without addressing them. Let's consider a workflow that would enable us to respond productively to all feedback."*

This entry records the meta-evolution that addresses the framing.

## Diagnosis

Pre-change, the panel-review aggregation grouped findings into three buckets: **must-fix**, **should-fix**, **out-of-scope**. The judge's loop-termination rule (`roles/judge/AGENT.md`) keyed only on must-fix being empty. When the panel returned clean on must-fix but non-empty on should-fix or out-of-scope, the judge un-drafted; the should-fix and out-of-scope items landed in the public review body and, in practice, were ignored.

The 2026-05-15 PR #75 panel run (`entries/2026/05/15/051017Z-result-judge-199aa7.md`, "Gamut complete: 0 must-fix items, all 12 seats comment-only") is the worked example of feedback going nowhere: twelve seats produced comment-only blocks, the PR un-drafted, the comment content sat in the review body unanswered.

## What landed

A **disposition layer** on top of the existing aggregation. Each finding ends with one of five explicit dispositions the judge applies at aggregation time per a rubric in `skills/panel-review/SKILL.md` § Disposition rubric:

| Disposition       | What it means                                                                                            | Where the work lives                                              |
| ----------------- | -------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------- |
| **must-fix-loop** | Blocks un-draft. Standard jury-fixer loop iterates until empty.                                          | The existing fixer-loop machinery.                                |
| **summary-fix**   | Addressable without a panel re-run. Judge posts one bundled job to the board; un-draft is not blocked.   | A `summary-fix` job in `journal/jobs/open/`.                      |
| **follow-up**     | Useful but out of scope for this PR. Judge appends to per-PR ledger with `status: parked`.               | `journal/projects/<slug>/followups/<repo>--<N>.md`.               |
| **acknowledge**   | Real observation, no work warranted. Aggregated body records the reasoning.                              | The aggregated review body only.                                  |
| **drop**          | Deliberate no-op (e.g., panel hallucination, panel disagreement resolved against the change).            | One-line rationale per drop in the judge's `result` entry.        |

The three pre-existing buckets remain (they are what jurors return); the dispositions are the judge's per-finding output. The rubric is conservative: bucket-default is the starting point; only demotion to `acknowledge` or `drop` (where the rubric clearly warrants) overrides it.

The judge runs three post-loop actions before `gh pr ready <N>`:
1. Submit the disposition-tagged review.
2. Post a `summary-fix` job to the board if any summary-fix dispositions are present. **Non-blocking** — the judge does not wait for the job to be claimed.
3. Append the followup ledger if any follow-up dispositions are present.

## Followup ledger and merge-trigger

Follow-up findings land in `journal/projects/<slug>/followups/<repo-with-dash>--<N>.md` with `status: parked`. The steward's per-cycle survey gains a *Revisit parked followups* sub-step that polls each parked entry's PR (and, when set, its upstream mirror via the boatman's recorded number) for merge state. On merge:

- Post an `action-followups` job to the board with the ledger items inlined.
- Update the ledger to `status: actioned` with `merge_event:` and `actioned_via:` populated.

A PR that closes without merging transitions the ledger to `status: dropped`. A PR stale for >30 days routes via `message: steward → liaison` so the liaison can decide.

The maintainer's framing: *"Use the journal, but arrange for the follow-up to be revisited automatically by the steward when the PR is merged or its mirror is merged upstream."*

## Settled decisions

Three from the 2026-05-19 conversation:

1. **Judge classifies at aggregation** — the rubric lives on `skills/panel-review/SKILL.md`. Jurors do not propose dispositions; the judge owns the layer.
2. **Summary-fix does not block un-draft** — un-draft happens on must-fix-loop empty, regardless of whether the summary-fix job has been claimed.
3. **Follow-ups live in the journal, revisited at merge** — bot-side merge or upstream-mirror merge, whichever happens first.

## Files changed (garden commit 3d5ddd6, this journal commit)

### Garden `main` (commit 3d5ddd6)

- `skills/panel-review/SKILL.md`: aggregation section gains the disposition layer; *Dispositions*, *Disposition rubric*, and *Follow-up ledger* are new top-level sections. Posting-the-review section keyed off dispositions instead of buckets.
- `skills/pr-creation-flow/SKILL.md`: jury-fixer loop section rewritten in terms of `must-fix-loop` dispositions; loop-exit discipline keyed off dispositions.
- `roles/judge/AGENT.md`: operating norms gain *Assign a disposition to every finding* and *Post-loop actions* steps; Definition of done split into non-terminating and terminating round shapes.
- `roles/fixer/AGENT.md`: when-to-enter-this-role grows two entries (claim a `summary-fix` job, claim an `action-followups` job); operating norms distinguish multi-round must-fix-loop from one-shot summary-fix / action-followups dispatches.
- `roles/steward/AGENT.md`: new top-level section *Parked followup revisit*; per-cycle Survey grows a *Revisit parked followups* sub-step.

### Journal (this commit)

- `journal/projects/followups.md`: cross-project followup discipline doc.
- This `result` entry.

## What the next judge dispatch will do differently

When the orchestrator next dispatches a judge against a draft PR and the panel returns:

- **With must-fix-loop items**: fixer-loop as before. Same shape; just terminology aligned.
- **With only non-must-fix-loop items**: the judge classifies each into summary-fix / follow-up / acknowledge / drop, posts the summary-fix job (if any), appends the followup ledger (if any), and then un-drafts. The maintainer reviewing the un-drafted PR sees disposition tags on each finding and knows which are deferred and how.

The 2026-05-15 PR #75 worked-example would, under the new shape, have produced a followup ledger file at `journal/projects/endo-but-for-bots/followups/endo-but-for-bots--75.md` parking the comment-only items, with the boatman-ferried upstream merge to `endojs/endo#3232` triggering an `action-followups` job naming them. Nothing dropped silently.

## Self-improvement

One structural lesson: the silent feedback loss was load-bearing for a multi-month stretch and the chain produced clean-looking gamuts that consumed panel work without actioning it. The fix is structurally small (a disposition layer on top of existing aggregation) but the prior shape would have been hard to spot from a single panel's output. The aggregate signal — 12 seats producing comment-only blocks that lead to clean un-drafts repeatedly — is what made the loss visible. A merged-PR-feedback-watch pattern keyed on "panel produced comment-only blocks, maintainer raised the same concern post-merge" would have caught this earlier.

Operational lesson: a concurrent journal-sync from another long-running session (the contractor's parent-context monitor wrap-loop) wiped the first attempt at this commit's untracked files. The journal-sync skill's *Notes from the field* already documents the hazard; the operational defense is to stage-and-commit in a single tool call rather than leaving files untracked across a sequence of operations. Surface this is a re-confirmation of the skill's rule, not a new finding.

Self-improvement: the maintainer noticing structural loss in a system that "looks clean" is the high-value form of feedback the garden's chain produces; the corresponding rule on the gardener is to listen specifically for "the system is doing X but ought to be doing Y" framings as the load-bearing meta-evolution signal, distinct from per-PR correctness feedback.
