---
gate: orchestrated
orchestrated_by: ironhorse-test262-implementation-completion
priority: high
roadmap: ironhorse-test262-completion
role: builder
posted_by: mentor
posted_at: 2026-08-08T04:54:34Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
handler-timeout: 7200
# Complete Promises, jobs, and async functions

Repository: `endojs/endo-but-for-bots`.

Work in the single shared Ironhorse completion branch/PR established by the first child. Read every earlier child report, fetch the remote branch, and preserve its commits. The measured starting point is the public full-suite report at https://kriscendobot.github.io/garden/reports/ironhorse-test262/20260808-14f26d0a6/report.html with machine data at https://kriscendobot.github.io/garden/reports/ironhorse-test262/20260808-14f26d0a6/report.json. Its exact pins are engine/report source `14f26d0a6989f5bb93cd1c1ca731dc7e1bc383d6`, `tc39/test262@be13516fb6441b950ba8a3df97eb34062c186972`, and Moddable XS oracle `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`. Rebase only as needed and record any changed pins.

Official test262 acceptance slice:
`test/built-ins/Promise/**` excluding async-generator-only cases, `test/language/expressions/async-function/**`, `test/language/statements/async-function/**`, and `$DONE`/promise jobs used by those slices.

Implementation scope:
Implement thenable assimilation, reaction jobs, species, finally, all/race/allSettled/any and keyed combinators over general iterables, async-function await/resume and rejection propagation. Make the harness drain jobs deterministically and preserve meter determinism.

Acceptance requires real execution with the official XS differential oracle, converting this slice from unsupported/failure to covered except for a specifically justified host-only or proposal exclusion. Add focused Rust unit/regression tests for the causal feature. Do not merely relabel, suppress, or add expectations for failures.

Regression invariant: no case that is covered in the starting report or by any earlier child may regress, no new `ironhorse-failure` or `infrastructure` result may appear, and every previously passing proprietary exact-metering/byte-identity case under `rust/engine/ironhorse-262/cases/**` must remain passing with its exact computron expectation unchanged. Run the affected official slice, the complete Ironhorse Rust workspace gates, and the exact metering corpus before push. Report commands, totals before/after, changed skip reasons, head SHA, and PR URL. Keep the PR open; do not merge it.

issue_spine: issue-kriscendobot-garden-51
issue_url: https://github.com/kriscendobot/garden/issues/51#issuecomment-5224315524
submitter: kriscendobot
