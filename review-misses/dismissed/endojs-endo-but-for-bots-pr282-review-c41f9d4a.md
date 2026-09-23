---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr282-review-c41f9d4a
verdict: not-a-miss
category: new-direction
review_at: 2026-08-16T06:28:34Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/282#pullrequestreview-4945588548
identity: endojs/endo-but-for-bots#282:review:4945588548
---

Whole-review CHANGES_REQUESTED on PR #282 (endor-run compartment-mapper
reimplementation) carrying three asks, no inline defects. Ask 1: pin the merge
base to an `llm-<sha>` branch and rebase, resolving conflicts (an operational
pipeline directive — the maintainer here coins the "pin the merge base" verb).
Ask 2: since this is another implementation of compartment-mapper, establish
parity by exercising every applicable compartment-mapper test fixture with a
drift safeguard so an unaccounted fixture fails the suite, keeping fixtures under
`packages/compartment-mapper/test` for now (a possible future top-level
`test/fixtures` tree noted). Ask 3: post a follow-up job to reconcile the
node_modules resolution against the endor registry cache — making registry-cache
resolution the default and gating legacy node_modules behavior behind a flag —
and take it to design or build.

Grounds: all three asks are forward-directed direction, not a defect the review
should have anticipated. The full 16-seat code panel demonstrably ran on this PR
(review 4307471252, 2026-05-18, all seats reporting), so there is no
skipped-evaluator avoidance shape. Ask 1 is a pipeline op (consistent with the
prior pr282 dismissals 148f5c93 "rebase, resolve, shepherd, conduct" and
336f6623). Ask 2 is a maintainer parity-strategy steer resting on codebase-specific
intent — no seat carries a standing convention that a compartment-mapper
reimplementation must adopt the whole upstream fixture corpus with a drift gate;
that requirement is first stated in this review (and elaborated across the adjacent
08-17/08-19 reviews, an evolving design conversation). Ask 3 is explicitly new work
("post a follow-up job to explore that option") — a default-flip and legacy-flag
architecture the maintainer is choosing, which no gate or seat owns. This is the
earliest of the three #282 reviews and matches the new-direction pattern of all
three prior dismissals.

Deliverable verification (primary closed as an honest handoff to orchestration
`pr282-flag-gated-reconciliation`, deliverable-complete: false): asks 2 and 3 were
genuinely executed — `endojs-endo-but-for-bots-pr282-fixture-parity` (tada
2026-08-17T02:06:50Z, a 40-entry parity manifest + drift safeguard) and
`endojs-endo-but-for-bots-pr282-registry-default-followup` (tada
2026-08-17T01:52:56Z, design-record correction 86745db2b0) both reached tada, so
those directives are real, not a false no-op. Discrepancy noted for the owner (not
a review-miss): ask 1's child `pr282-pin-rebase-reconcile` stalled after requeues
and never completed (the orchestration halted at child 1/3); PR #282 remains
based on `llm`, not a pinned `llm-<sha>`, though the head continued to evolve
(currently 4ef606ec, 08-21) via later work — the pin-the-merge-base directive is
the one ask whose deliverable is not fully realized, an execution stall for the
pipeline owner rather than a defect the panel could have caught.
