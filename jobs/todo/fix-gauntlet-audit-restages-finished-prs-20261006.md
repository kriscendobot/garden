---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
**The design-PR gauntlet coverage audit re-stages a full gauntlet on PRs whose gauntlet already finished** (kriscendobot/garden, main2). This doubles review spend.

**Evidence (journal2).** `endojs-endo-but-for-bots-pr1426-gauntlet` was recorded 2026-10-06T00:52:15Z with `created_by: design-pr-gauntlet-coverage-audit`. But https://github.com/endojs/endo-but-for-bots/pull/1426 had already finished `build-familiar-localhttp-protocol-gauntlet` (recorded 10-05T12:24Z). That run used six panel/fix rounds and ended review-budget-reached at about 15:45Z. The second run spent another six rounds and reached its review budget at about 09:40Z on 10-06. The same audit tick also re-staged https://github.com/endojs/endo-but-for-bots/pull/1425 (`endojs-endo-but-for-bots-pr1425-gauntlet`, 00:52:20Z) after `endojs-endo-but-for-bots-ses-xs-compartment-import-time-intrinsics-gauntlet` (10-05T10:03Z). Five gauntlet records carry `created_by: design-pr-gauntlet-coverage-audit`; check every one.

The "one live gauntlet per PR" guard (de50427c6a2) prevents only *concurrent* runs. It doesn't stop a new run once the earlier one is terminal. The audit appears to key on the gauntlet *basename*, or only on live records, not on "has any gauntlet for this PR reached a terminal state".

**Fix.** Before staging, look up gauntlet history by PR identity: live records, archived records, and the `jobs/tada` reports. Do not re-stage when any earlier gauntlet for that PR is terminal (complete, review-budget-reached, or halted). The one exception is a run the maintainer explicitly requests, and even that should carry a fresh-head justification. Add a regression test that covers both the archived-record and tada-only cases. Land on main2.
