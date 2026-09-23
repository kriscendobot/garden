Pushed cleanly. Work is complete.

## Completion report

**Job:** Add an `evaluator-gaming` category to the review-retrospective loop.

**What I did:**

1. **Taxonomy (`skills/review-retrospective/SKILL.md`).** Added an `evaluator-gaming` row to the failure-category table (maps to "not a seat: the work altered what the review *measures* rather than what it is *for*"). Added a discriminator paragraph in § 1 stating the distinguishing question — *did this change alter what the evaluator measures rather than what the evaluator is for?* — framed to be answerable from the diff and review thread rather than intent, with the three worked shapes: **avoidance** (route around the gauntlet), **letter-not-purpose** (tests deferred behind an unlanded dep where a pure-function extraction was available), and **move-the-measurement** (assertions restating the implementation / rename dodging a lint gate).

2. **Prosecutor brief (`roles/prosecutor/AGENT.md`).** Added a "Name gaming as gaming" operating norm carrying the same distinguishing question and three shapes, instructing the prosecutor to name the gamed seat/gate in `missed_by`.

3. **Test (`scripts/jobs/test/review-miss-record-test.sh`).** Added subtest 9 exercising `evaluator-gaming` through mint (count 1) → join on a distinct PR (count 2) → dispatch/close → recurrence-reopen, asserting the category is preserved across the full lifecycle. **All 37 subtests pass.**

**What did *not* change (by design):** The writer `review-miss-record.sh` validates `category:` only as non-empty — the taxonomy is explicitly *open* ("mint a category by adding a row"), so no allowlist was added; that would contradict the mint-a-category convention and reject legitimate future categories. The category remains a free-form durable label: no K-floor change, no dispatch-gate change, not an input to routing/reputation/auction.

**For maintainer review — proposed re-categorization of two existing clusters (NOT applied; a category change is a judgment, not a migration):**

- `garden-design-pr-gauntlet-bypass` (count 2; PRs 7, 809), currently `process` → **`evaluator-gaming`**. A design PR reaching maintainer review *without* the required design-panel gauntlet is the **avoidance** shape: the evaluator was skipped, not satisfied. `process` reads as "the chain failed to run"; `evaluator-gaming` captures that the review surface was reached while routing around the gate that governs it. Answerable from the record: the PR exists as a review surface, yet no gauntlet/panel job ran for it.
- `feature-shipped-without-tests` (count 1; PR 151), currently `test-gap` → **`evaluator-gaming`**. This is the **letter-not-purpose** shape: tests deferred behind an unlanded dependency when a pure-function extraction would have made the new logic unit-testable immediately. The coverage seat saw no untested *new runtime path* and passed while the logic went unexercised — the seat's letter met, its purpose unmet. `test-gap` says "the rubric was too narrow"; `evaluator-gaming` says "the rubric was satisfiable without doing the work," which is the more precise diagnosis and points at a different fix (require the testable extraction, not just more coverage).

Note: `feature-shipped-without-tests` is at count 1 / 1 PR, below the K≥3/≥2-PR floor either way, so a re-label does not itself trip dispatch.

**Follow-ups:** none required. If the maintainer accepts either re-categorization, it's a one-field edit to the cluster file's `category:` (the store writer preserves the category across joins/status changes, so it will persist), best done as a small deliberate edit rather than an automated pass.

**Commit:** `3a3d8a4627` pushed to `main2`. Activates on the fleet after the next deploy.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-review-miss-gaming-category.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 32 tokens (1012867 cached reads)
- Output: 12525 tokens
- Cost: $1.4294685000000003
- Wall-clock: 188s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
