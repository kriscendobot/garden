---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-09-01T15:54:57Z
---
Assessed all standing Ironhorse fronts; no new dispatch or repository change was warranted.

- Fixture parity remains complete. `jobs/orch/` has no active orchestration, and endojs/endo-but-for-bots#282 is merged at `cd6e55513c`; its head has 27/27 successful checks. The latest terminal fixture campaign halted on `endor-walker-host-hooks`, not a third `endor-walker-exports-resolution` stall.
- `gh api repos/endojs/endo-but-for-bots/commits/b067f228696c2bd16ddc7d52f86f4e01ce322768/check-runs` reported 27/27 successful checks with no failures or pending jobs, including `test-ironhorse` and `test-ironhorse-oracle`.
- Relevant open Ironhorse lines are green: endojs/endo-but-for-bots#1103 is 27/27, #1075 and #1039 are 24/24, #1018/#1016/#945 are 5/5, and #877 is 28/28. GraphQL found no unresolved threads on #1103, #1075, #1039, #1018, or #1016. #877's lone open thread is outdated/addressed.
- endojs/endo-but-for-bots#1018 remains nominally CHANGES_REQUESTED, but head `7b9e4e1ad8e7` and its 2026-09-01T14:42:11Z completion summary directly address the layering review; no duplicate fixer was posted. #945's completed refresh mapped all six asks to head `455a32e6443d` and re-requested maintainer review.
- Endor Git probes endojs/endo-but-for-bots#1081 and #1082 remain 24/24 successful. Bindings PR kriscendobot/endo-but-for-bots#4 remains 35 successes with only the documented `windows-gnu-zig-probe` failure.
- No files, branches, pull requests, or jobs changed.
- Self-improvement: nothing this time.
