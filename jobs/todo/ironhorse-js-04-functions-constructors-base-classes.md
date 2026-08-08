---
role: builder
handler-timeout: 7200
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=high at=2026-08-08T08:49:03Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
handler-timeout: 7200
# Complete functions, construction, new.target, and base classes

Repository: `endojs/endo-but-for-bots`.

Work in the single shared Ironhorse completion branch/PR established by the first child. Read every earlier child report, fetch the remote branch, and preserve its commits. The measured starting point is the public full-suite report at https://kriscendobot.github.io/garden/reports/ironhorse-test262/20260808-14f26d0a6/report.html with machine data at https://kriscendobot.github.io/garden/reports/ironhorse-test262/20260808-14f26d0a6/report.json. Its exact pins are engine/report source `14f26d0a6989f5bb93cd1c1ca731dc7e1bc383d6`, `tc39/test262@be13516fb6441b950ba8a3df97eb34062c186972`, and Moddable XS oracle `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`. Rebase only as needed and record any changed pins.

Official test262 acceptance slice:
`test/built-ins/Function/**`, `test/language/expressions/{function,arrow-function,call,new,new-target}/**`, `test/language/statements/function/**`, and non-derived cases in `test/language/{expressions,statements}/class/**`.

Implementation scope:
Close `to_instance`, `native-call:Function`, call/apply/bind, arguments objects, callable/constructable discrimination, prototype selection, new.target, and base-class constructor/method/field/static initialization. Preserve re-entrant call/construct behavior and typed constructor errors.

Acceptance requires real execution with the official XS differential oracle, converting this slice from unsupported/failure to covered except for a specifically justified host-only or proposal exclusion. Add focused Rust unit/regression tests for the causal feature. Do not merely relabel, suppress, or add expectations for failures.

Regression invariant: no case that is covered in the starting report or by any earlier child may regress, no new `ironhorse-failure` or `infrastructure` result may appear, and every previously passing proprietary exact-metering/byte-identity case under `rust/engine/ironhorse-262/cases/**` must remain passing with its exact computron expectation unchanged. Run the affected official slice, the complete Ironhorse Rust workspace gates, and the exact metering corpus before push. Report commands, totals before/after, changed skip reasons, head SHA, and PR URL. Keep the PR open; do not merge it.

issue_spine: issue-kriscendobot-garden-51
issue_url: https://github.com/kriscendobot/garden/issues/51#issuecomment-5224315524
submitter: kriscendobot
