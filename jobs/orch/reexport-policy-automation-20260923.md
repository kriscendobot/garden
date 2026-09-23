---
child-validate-reexport-policy-ebfb-20260923-reap-count: 0
child-build-reexport-deprecation-policy-20260923-host: endolin-garden2-5bcdff64
child-build-reexport-deprecation-policy-20260923-reap-count: 0
order: serial
children: build-reexport-deprecation-policy-20260923 validate-reexport-policy-ebfb-20260923 conduct-garden-pr95-20260923
on-child-failure: halt
state: running
created_by: gardener
created_at: 2026-09-23T17:46:05Z
---

Re-export deprecation policy: build → validate → conduct.

Executes @kriskowal's PR #95 approval bundle (review pullrequestreview-5294397181)
after the design feedback was incorporated on main2 (commit 7c712dafbef, all 5
open questions resolved). Serial, halt-on-failure:
1. build   — implement the skill + no-plain-reexport probe + reexport-auditor
             seat + role norms per the resolved design, direct to main2.
2. validate — exercise the automation on a synthetic DRAFT PR on
             kriscendobot/endo-but-for-bots (probe fails a plain re-export,
             passes a compliant shim; seat files the complaint).
3. conduct — finalize garden PR #95 (un-draft + merge/close-as-resolved).

Conduct runs LAST as the finalization step, after every other ask is resolved,
per the review-router NOTE.
