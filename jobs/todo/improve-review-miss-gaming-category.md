---
role: builder
---
# Add an evaluator-gaming category to the review-retrospective loop

The garden already runs a continuous evaluator-failure recorder: the
review-retrospective double loop (`skills/review-retrospective/SKILL.md`,
`scripts/jobs/review-miss-record.sh`, role `prosecutor`). As of 2026-07-28 it holds
24 misses in 13 clusters under `journal/review-misses/`, with categories including
`process`, `test-gap`, and `correctness-bug`.

What it records is **evaluator misses** — things the panel let through that a human
later caught. What it does *not* distinguish is **evaluator gaming** — work shaped
to satisfy the reviewer rather than the goal. These are different failures with
different fixes: a miss says the rubric was too narrow; gaming says the rubric was
satisfiable without doing the work.

The existing corpus already contains at least two clusters that are arguably the
gaming shape but are filed as something else:

- `garden-design-pr-gauntlet-bypass` (count 2, PRs 7 and 809) — a design PR
  reaching maintainer review *without* the required design-panel gauntlet. That is
  evaluator **avoidance**.
- `feature-shipped-without-tests` (count 1, PR 151) — tests deferred behind an
  unlanded dependency where a pure-function extraction would have made the logic
  testable immediately. Satisfying the seat's letter, not its purpose.

## What to build

1. Add an `evaluator-gaming` category to the review-miss taxonomy
   (`skills/review-retrospective/SKILL.md` and whatever validates `category:` in
   `scripts/jobs/review-miss-record.sh`).
2. Extend the prosecutor's discriminator brief (`roles/prosecutor/AGENT.md`) with
   the distinguishing question, stated so it is answerable from a diff and a review
   thread rather than from intent-reading: *did this change alter what the
   evaluator measures rather than what the evaluator is for?* Give it the two
   concrete shapes above plus the avoidance shape (route around the gauntlet) as
   worked examples.
3. **Do not** re-categorize the existing corpus automatically. Propose the
   re-categorization of those two clusters in the tada for maintainer review, with
   the reasoning; a category change is a judgment, not a migration.

## Constraints

- Additive to the existing store's lifecycle (cluster mint / join / K-floor /
  recurrence-reopen). Do not change the K floor or the dispatch gate.
- The category must not become a score. It is a label on a durable record for
  later reading, not an input to routing, reputation, or the auction.

## Verification

- Extend `scripts/jobs/test/review-miss-record-test.sh` to cover the new category
  through mint / join / recurrence, and report counts in the tada.

## Why now

Posted from issue #62 follow-up (`issue-garden-62-jcorbin-cross-analysis`).
@jcorbin's devoker cross-analysis observed that the garden legislated *against*
evaluator-coupling prospectively without ever looking for it retrospectively.
Recording it continuously as it is noticed is cheaper and more durable than an
archaeological audit, and the garden already has the loop to hang it on.

<!-- garden-reaped: 2 -->
