---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: builder

Repo: endojs/endo-but-for-bots, based on `master`. Continues the Bun probe: draft PR https://github.com/endojs/endo-but-for-bots/pull/1516 (head 2b7550456e). Build on that branch (or a master-based successor); keep it a DRAFT unless the work stands on its own.

Maintainer decisions: Bun matters in its own right (users have asked for it), not only as a Safari proxy. Safari has NO `URLSearchParams.prototype.length` (maintainer checked: `undefined`), so it is a Bun-only quirk.

Task:
1. Identify the SECOND property in the probe's reverted two-property SES permit. Check each property against Safari/JSC where possible and say whether it is Bun-only or an engine difference.
2. Audit Bun's other SES intrinsics gaps (lockdown failures, not just those two).
3. SES permit policy (maintainer): permitting `URLSearchParams.prototype.length` is acceptable IF its value is innocuous and cannot be abused to share state or communicate between compartments. Verify that explicitly: what is the property (data vs accessor, writable, value type, what it reads)? Is it a primitive/frozen after lockdown? Could it carry mutable state or a communication channel across compartments? Write the analysis in the PR with a clear verdict. Only permit if it passes; apply the same test to the second property. If a property fails the test, leave it unpermitted and report. Prefer a narrowly scoped permit in the SES permits table, with a comment/doc noting it is Bun-only.
4. Re-run `test:bun` with the permits and report the new pass counts (configs and packages). Triage remaining failures into Bun-quirk vs real bug vs AVA-incompat, briefly.
5. Decide whether the execution-only Bun CI job should stay required, advisory (non-blocking), or be gated to the green packages. Recommend with evidence.

Time-boxed; the deliverable is evidence and a recommendation.
