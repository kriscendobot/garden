---
child-ironhorse-js-07-promises-async-functions-reap-count: 0
order: serial
children: ironhorse-js-07-promises-async-functions ironhorse-js-08-async-generators-for-await ironhorse-js-09-proxy-mop ironhorse-js-10-arrays-species ironhorse-js-11-strings ironhorse-js-12-regexp ironhorse-js-13-numeric-date-json ironhorse-js-14-binary-data-atomics ironhorse-js-15-collections ironhorse-js-16-modules ironhorse-js-17-resource-management ironhorse-js-18-realms-eval-annexb ironhorse-js-19-intl-core ironhorse-js-20-intl-formatters ironhorse-js-21-intl-datetime-segmenter ironhorse-js-22-temporal-core ironhorse-js-23-temporal-plain ironhorse-js-24-temporal-zoned ironhorse-js-25-temporal-integration ironhorse-js-26-residual-gap-closure ironhorse-js-27-full-suite-report-refresh ironhorse-js-28-issue-summary
on-child-failure: halt
state: running
budget_tokens: 2080000
created_by: producer
created_at: 2026-08-12T17:17:54Z
---

# Ironhorse test262 implementation completion — resume 2 (restored campaign)

Serial, halt-on-failure resume of the Ironhorse test262 completion campaign after
its not-yet-run remainder was swept off the board TWICE by the `orchestrate.sh`
requeue-count stall false-positive (2026-08-08 at child 6/29, 2026-08-12 at child
7/29). Both stall fixes are now live in the deployed root (`9a16e2a6ef`,
`ede7f1f467`), verified before this relaunch.

Stages `js-00`..`js-06` are already DONE (in `jobs/tada/`) and are NOT re-posted.
This campaign carries the 22 downstream children `js-07`..`js-28`, in run order,
recovered byte-identically (modulo the producer's plan frontmatter) from the
parent of the second sweep commit `c95607119cb1b8a9a48f732820ba51f96a53b1a7`
(`journal2`, 2026-08-12T03:34:03Z).

Each child completes its official test262 acceptance slice against the XS
differential oracle in the single shared Ironhorse completion branch/PR, preserving
the regression and exact-metering invariants each body names. Halt-on-failure: a
child that fails to achieve its gated outcome halts the serial run for maintainer
attention rather than sweeping the remainder.

Budget: 2,080,000 billable tokens (~$68.06 notional / ~$20.73 real-dollar-equivalent
at the current 3.28x index) — this week's calibrated combined figure across the
fleet's two Claude accounts, per follower-liaison message
`role/liaison/20260812T164547Z-ef36a7` and the calibration record
`jobs/tada/budgeted-campaign-dispatch-design.md`.
