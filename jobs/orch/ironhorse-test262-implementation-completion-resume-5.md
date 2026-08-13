---
order: serial
children: ironhorse-js-11-strings ironhorse-js-12-regexp ironhorse-js-13-numeric-date-json ironhorse-js-14-binary-data-atomics ironhorse-js-15-collections ironhorse-js-16-modules ironhorse-js-17-resource-management ironhorse-js-18-realms-eval-annexb ironhorse-js-19-intl-core ironhorse-js-20-intl-formatters ironhorse-js-21-intl-datetime-segmenter ironhorse-js-22-temporal-core ironhorse-js-23-temporal-plain ironhorse-js-24-temporal-zoned ironhorse-js-25-temporal-integration ironhorse-js-26-residual-gap-closure ironhorse-js-27-full-suite-report-refresh ironhorse-js-28-issue-summary
on-child-failure: continue
state: running
budget_tokens: 10000000
created_by: producer
created_at: 2026-08-13T22:07:24Z
---

# ironhorse test262 completion — resume-5

Relaunch of `ironhorse-test262-implementation-completion-resume-4`, which
exhausted its 750,518-token budget after 1,067,391 recorded tokens (316,873
overshoot) with children 09 (`proxy-mop`) and 10 (`arrays-species`) complete.
Eighteen children remain, `11-strings` through `28-issue-summary`.

Maintainer decision (kriskowal, 2026-08-13): **relaunch sized to finish**, budget
10,000,000, `--on-child-failure continue` carried forward from resume-4.

## Why this budget

Observed rate is ~534,000 enforced tokens per child (1,067,391 over two). Eighteen
children is therefore ~9.6M enforced, so 10M is sized to carry the campaign to
completion rather than to force another checkpoint. It is still a real ceiling: a
runaway child stops the campaign instead of running unbounded.

Two things the maintainer decided with in view:

- **The enforced figure undercounts.** `campaign-spend.sh` sums only
  `usage/<child>.jsonl`, not the gauntlet sub-job ledgers (panel/fix/clean), which
  are roughly 60% of real spend. True quota impact for this run is likely nearer
  24M than 10M.
- **Any cap overshoots by about one child.** Enforcement is checked between
  children, so a budget cannot stop mid-child. Resume-4 overshot by 42%. Do not
  treat 10M as a hard wall.

## Carried forward from resume-4

`--on-child-failure continue`, because each child's complete-coverage gate is
structurally unsatisfiable: a slice's residual is some other slice's work. Under
`halt` the campaign stops at its first child every time (that is what ended
resume-3 at 0/21). Residuals are swept by `26-residual-gap-closure`, and
`27-full-suite-report-refresh` measures the true end state.

**Children 27 and 28 are load-bearing.** With `continue`, they are the only honest
measurement of what the campaign actually achieved. If either is skipped, fails,
or is cut off by the budget, the run has no end-state report and its result is
unknown rather than good. If the budget looks like it will not reach them, say so
rather than letting them fall off the end.
