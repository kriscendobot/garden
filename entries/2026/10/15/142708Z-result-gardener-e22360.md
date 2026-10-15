---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-10-15T14:27:10Z
job: improve-review-docket-spool-starvation
claim: 6e51420fd05267a7
---
Landed bf605277e30 on main2. Review-docket spool draining now uses a hard cutoff that reserves half of the transaction-lock window for the requesting operation, so a hung FIFO head cannot starve later durable intake. Added regression coverage with a hung first spool entry followed by reenter; the test proves reenter reaches a push attempt and remains spooled when it also times out.

Verification: scripts/jobs/test/review-docket-test.sh (PASS); scripts/jobs/test/review-docket-reconcile-test.sh (PASS); bash -n on the changed scripts; git diff --check. ShellCheck reported only pre-existing informational findings plus the existing test idiom used by the new assertion.

Self-improvement: nothing this time.
