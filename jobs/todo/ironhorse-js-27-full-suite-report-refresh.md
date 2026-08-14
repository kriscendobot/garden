---
tier: mentor
handler-timeout: 10800
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-14T22:22:09Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
handler-timeout: 10800
# Run the final authoritative full suite and publish the refreshed report

Repository: `endojs/endo-but-for-bots`.

Work in the single shared Ironhorse completion branch/PR established by the first child. Read every earlier child report, fetch the remote branch, and preserve its commits. The measured starting point is the public full-suite report at https://kriscendobot.github.io/garden/reports/ironhorse-test262/20260808-14f26d0a6/report.html with machine data at https://kriscendobot.github.io/garden/reports/ironhorse-test262/20260808-14f26d0a6/report.json. Its exact pins are engine/report source `14f26d0a6989f5bb93cd1c1ca731dc7e1bc383d6`, `tc39/test262@be13516fb6441b950ba8a3df97eb34062c186972`, and Moddable XS oracle `23b4d6b0a65f35209d9118c4c13c6c9b3e68784d`. Rebase only as needed and record any changed pins.

Official test262 acceptance slice:
First the pinned 52,092-case corpus for an exact before/after comparison, then the complete current authoritative `tc39/test262` `test/**` tree at a newly recorded revision.

Implementation scope:
Run the bounded/resumable oracle-backed automation end to end. Require zero Ironhorse failures, zero unsupported outcomes, zero infrastructure outcomes, and only enumerated standards-grounded host/proposal skips. Publish self-contained HTML, JSON and provenance under `kriscendobot/garden` GitHub Pages without disturbing existing Pages content; update the stable report index; verify each public URL by HTTP 200 and parse the public JSON. Include before/after totals, exact engine/test262/oracle revisions, runtime, batch completeness, and any unavoidable exclusions.

Acceptance requires real execution with the official XS differential oracle, converting this slice from unsupported/failure to covered except for a specifically justified host-only or proposal exclusion. Add focused Rust unit/regression tests for the causal feature. Do not merely relabel, suppress, or add expectations for failures.

Regression invariant: no case that is covered in the starting report or by any earlier child may regress, no new `ironhorse-failure` or `infrastructure` result may appear, and every previously passing proprietary exact-metering/byte-identity case under `rust/engine/ironhorse-262/cases/**` must remain passing with its exact computron expectation unchanged. Run the affected official slice, the complete Ironhorse Rust workspace gates, and the exact metering corpus before push. Report commands, totals before/after, changed skip reasons, head SHA, and PR URL. Keep the PR open; do not merge it.

issue_spine: issue-kriscendobot-garden-51
issue_url: https://github.com/kriscendobot/garden/issues/51#issuecomment-5224315524
submitter: kriscendobot
