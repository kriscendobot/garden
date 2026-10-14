---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-10-14T16:59:29Z
job: improve-namespace-clone-lock-noise
claim: ef80573b2ae36ba4
---
Implemented and pushed 0396add351f1 to main2.
Changed namespace-clone-maintenance to match soft-lock warnings directly in the capture file, avoiding pipefail/SIGPIPE misclassification, and made definite-failure classification pipe-safe. Expanded the regression to model non-TTY <4> journald prefixes and a capture larger than a pipe buffer; it requires exactly one <6> coalesced contention summary.
Checks: scripts/jobs/test/namespace-clone-maintenance-test.sh passed; scripts/jobs/test/namespace-clone-orphan-sweep-test.sh passed; bash -n and git diff --check passed; shellcheck reported only the pre-existing SC1091 and SC2016 informational findings.
Follow-ups: none.
Self-improvement: nothing this time.
