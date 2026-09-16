---
order: serial
children: ironhorse-computron-benchmark-baseline-design ironhorse-computron-benchmark-baseline-build
on-child-failure: halt
state: pending
created_by: producer
created_at: 2026-09-16T05:10:55Z
---

Campaign: honor the maintainer's PR #1282 course-correction — instead of
eliminating the tests that constrain the range of valid Ironhorse computron
values, establish benchmark-based baselines for particular loads (modelling
polynomial-in-input-size built-in costs). "Make a plan and execute that plan."

Serial, halt-on-failure:
  1. ironhorse-computron-benchmark-baseline-design  — make the plan (designer)
  2. ironhorse-computron-benchmark-baseline-build    — execute the plan (builder)

Source: https://github.com/endojs/endo-but-for-bots/pull/1282#issuecomment-5692322970
