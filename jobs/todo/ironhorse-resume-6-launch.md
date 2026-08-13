<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-08-13T22:51:05Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
repo: the garden itself (journal board operation)

# Launch the Ironhorse test262 campaign resume-6 (17 children, js-12..js-28)

Maintainer decision (kriskowal, 2026-08-13): fix the campaign meter, then relaunch.
Resume-5 died after ONE child with `orchestration-status: budget-meter-incomplete` —
not out of budget, but because `campaign-spend.sh` fatals on an unmetered (cleric /
`provider: openai`) usage row. Child `ironhorse-js-11-strings` **succeeded**
(`built-ins/String` 334 → 516 covered, 0 failures, head `4821c236` on PR #970), so
resume-6 picks up at child **12**.

## PRECONDITION — verify before launching (this job is parked for exactly this reason)

The meter fix (`garden-campaign-spend-unmetered-rows`) must be **DEPLOYED**, not
merely landed on `main2`. A fix sitting undeployed relaunches straight back into the
same fatal on the next cleric child.

Confirm the **deployed** root file `/home/kris/garden2/scripts/jobs/campaign-spend.sh`
no longer fatals on unmetered rows — the string

    is an unmetered or invalid campaign row

must be **absent** from the deployed script, and the deployed script must still
reject malformed rows. Run the campaign-spend tests against the deployed tree if
they are present.

If the fix has not deployed, **do not launch**. Report the gap and let the liaison's
deploy-on-upgrade Monitor drive the deploy (or the maintainer authorize a sysop
deploy op); launching first keeps the fleet busy and blocks the deploy. Do **not**
self-authorize a deploy.

Also confirm all 17 children below are still parked in `jobs/plan/` with
`gate: orchestrated`.

## LAUNCH (once the precondition holds), from a synced journal

    scripts/jobs/post-orchestration.sh --serial --on-child-failure continue \
      --budget-tokens 10000000 \
      ironhorse-test262-implementation-completion-resume-6 \
      ironhorse-js-12-regexp ironhorse-js-13-numeric-date-json \
      ironhorse-js-14-binary-data-atomics ironhorse-js-15-collections \
      ironhorse-js-16-modules ironhorse-js-17-resource-management \
      ironhorse-js-18-realms-eval-annexb ironhorse-js-19-intl-core \
      ironhorse-js-20-intl-formatters ironhorse-js-21-intl-datetime-segmenter \
      ironhorse-js-22-temporal-core ironhorse-js-23-temporal-plain \
      ironhorse-js-24-temporal-zoned ironhorse-js-25-temporal-integration \
      ironhorse-js-26-residual-gap-closure ironhorse-js-27-full-suite-report-refresh \
      ironhorse-js-28-issue-summary

## Carried forward, and why

- **`--on-child-failure continue`.** Each child's complete-coverage gate is
  structurally unsatisfiable — a slice's residual is another slice's work — so under
  `halt` the campaign stops at its first child every time (that is what ended
  resume-3 at 0/21). Children 07–11 all completed with `orchestration-failed: true`
  while delivering real, verified, regression-free increments.
- **Budget 10,000,000**, the figure the maintainer chose today, unchanged for 17
  children (~9.1M at the observed ~534k enforced tokens/child).
- Two caveats the maintainer set this budget with in view: the enforced figure
  **undercounts** (it sums only `usage/<child>.jsonl`, not the gauntlet panel/fix/clean
  sub-ledgers, roughly 60% of real spend — true quota impact is likely nearer 24M),
  and **any cap overshoots by about one child**, since enforcement is checked between
  children and cannot stop mid-child.
- **Children 27 and 28 are load-bearing.** Under `continue` they are the only honest
  measurement of what the campaign achieved. If either is skipped, fails, or is cut
  off by the budget, the run has no end-state report and its result is *unknown*
  rather than good. If the budget looks like it will not reach them, say so.

## Context

- Shared PR: https://github.com/endojs/endo-but-for-bots/pull/970 (open, draft, do not merge)
- Branch `feat/ironhorse-262-language-completion`; pins test262 `be13516fb6…`, XS oracle `23b4d6b0a6…`
- Issue spine: https://github.com/kriscendobot/garden/issues/51
- Prior orchestration reports: `jobs/tada/ironhorse-test262-implementation-completion-resume-{4,5}.md`
