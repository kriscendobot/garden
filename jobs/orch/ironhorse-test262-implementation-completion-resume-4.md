---
order: serial
children: ironhorse-js-09-proxy-mop ironhorse-js-10-arrays-species ironhorse-js-11-strings ironhorse-js-12-regexp ironhorse-js-13-numeric-date-json ironhorse-js-14-binary-data-atomics ironhorse-js-15-collections ironhorse-js-16-modules ironhorse-js-17-resource-management ironhorse-js-18-realms-eval-annexb ironhorse-js-19-intl-core ironhorse-js-20-intl-formatters ironhorse-js-21-intl-datetime-segmenter ironhorse-js-22-temporal-core ironhorse-js-23-temporal-plain ironhorse-js-24-temporal-zoned ironhorse-js-25-temporal-integration ironhorse-js-26-residual-gap-closure ironhorse-js-27-full-suite-report-refresh ironhorse-js-28-issue-summary
on-child-failure: continue
state: pending
budget_tokens: 750518
created_by: producer
created_at: 2026-08-13T20:24:55Z
---

# ironhorse test262 completion — resume-4

Relaunch of `ironhorse-test262-implementation-completion-resume-3`, which halted
at its FIRST child with 0/21 done.

**Why the policy changed to `continue`.** Child
`ironhorse-js-08-async-generators-for-await` did excellent work — the official
pinned slice went from 211 covered / 2,031 unsupported to 1,795 covered / 447
unsupported, eliminating 1,631 `async_generator_function` and 388 `for_await_of`
skips, with 0 failures, 0 infrastructure errors, no regressions, `cargo test
--workspace --release` passing, and the exact corpus at 1,711/1,711. It still
declared its gated outcome unsatisfied, because its complete-coverage gate
demands zero residual and the remaining 447 cases expose gaps that are NOT its
topic: abrupt-completion handling, async assertion failures, symbols, coercion,
boxing, and `with`.

That gate is unsatisfiable for every child in this campaign, since each slice's
residual is some other slice's work. Under `halt`, child 09 would stop the
campaign exactly as 08 did, and so on. The campaign already has the right
machinery for leftovers: `ironhorse-js-26-residual-gap-closure` sweeps them and
`ironhorse-js-27-full-suite-report-refresh` measures the true end state.

Maintainer decision (kriskowal, 2026-08-13): relaunch with
`--on-child-failure continue`, same budget basis (Option A, 750,518 billable
tokens), resuming from child 09.

**What this trades away:** `halt` no longer protects against a genuinely broken
child. A real shortfall now surfaces in child 27's full-suite report rather than
stopping the run. Children 27 and 28 are therefore load-bearing — if either is
skipped or fails, the campaign has no honest end-state measurement.

**Budget caveat carried forward:** `campaign-spend.sh` sums only
`usage/<child>.jsonl` and NOT gauntlet sub-job ledgers (panel/fix/clean), which
are roughly 60% of real spend. The 750,518 figure is mechanism-consistent with
how the original was subtracted; true quota impact runs ~2.5x it. The maintainer
launched with that known.
