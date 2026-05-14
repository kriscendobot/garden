---
ts: 2026-05-14T05:43:53Z
kind: result
role: fixer
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 109
    role: source
refs:
  - entries/2026/05/14/054100Z-dispatch-steward-3edfcc.md
---

# Result: fixer redrafted PR #109 title + body per pr-formation

Third instance of the kriskowal "title + description need an update" pattern after #128 (cycle 9) and #129 (earlier today). Same shape as the precedents: redraft per the upstream PR template, no checklists, no file callouts, behavior over diff.

## What changed

**Title** was `feat(syrups): add @endo/syrups package (comma-less netstring variant)`. The package was renamed to `@endo/syrup-frame` after the original title was set (commit `e7f141a4e`), and the scope grew to include an opt-in `framing: 'syrups'` option on the OCapN TCP-for-testing netlayer (`packages/ocapn/src/netlayers/tcp-test-only.js`, +netlayer test). The title now reads:

> `feat(syrup-frame): syrup-frame package and opt-in syrups framing for OCapN TCP-for-testing`

**Body** was a per-file walkthrough of the old `packages/syrups/` tree. Rewritten to the upstream template sections (Description, Security / Scaling / Documentation / Testing / Compatibility / Upgrade Considerations), framed as behavior and intent: what the new package does, what changed in the netlayer, where the design rationale lives (sibling PR #108). No checklists. No "I changed file X" prose.

**Comment**: posted a brief neutral summary at endojs/endo-but-for-bots#109 (issuecomment-4447977549) noting the rename and the framing addition as the two reasons the old body no longer fit.

## Out of scope per dispatch

- Re-request review: not in the directive.
- Address inline review items: none surfaced in the dispatch.
- Code changes: none.

## Pattern observation

The first three instances of this redraft pattern (#128, #129, #109) all share the same trigger shape: a kriskowal one-line directive on an open PR, no specific code asks, the PR body either is stale to current scope or carries pre-rewrite shape. The fixer's lane for this kind of dispatch is bounded: read the current scope from git, write the new prose, edit + comment, done. The `pr-formation` skill (created from the #128 cycle) is doing its job.

Self-improvement: the pr-formation skill's four-part body order (What / Why / Attend to / Out of scope) maps cleanly onto the upstream endo-but-for-bots template (Description + the five Considerations subsections), but the skill's example body shows only the four-part order without the template subsections. A skill reader looking at the example in isolation might write a body with the four headings rather than the template's headings. Worth a note in the skill that on endojs-family projects the template's subsections are the canonical shape and the four-part discipline gets folded into the Description and the relevant Consideration sections. Threshold-borderline observation; routing as a `message` to the gardener if a fourth instance of this pattern produces the same friction, otherwise letting it ride.
