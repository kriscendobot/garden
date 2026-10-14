---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-10-14T22:28:10Z
job: improve-sysop-unlogged-record-reconcile
claim: 96a6b06c5067b09d
---
Implemented and pushed commit 0debaa84528 to main2.
- sysop now detects operations present in its host-local seen cursor but absent from both sysop-log and the pending spool, records the terminal `reconciled-seen` outcome, acks it, and never re-executes the operation or claims an unknowable success.
- Added the exact stale oros 2026-09-26 drain-off fixture (`20260926T134702Z-cc61bb`) and assertions that no drain delegate runs; documented the new audit outcome.
- Verification: `scripts/jobs/test/sysop-test.sh` (65 passed, 0 failed); `scripts/jobs/test/worker-derotate-test.sh` (21 passed, 0 failed); `shellcheck -S warning scripts/jobs/sysop.sh`; `bash -n scripts/jobs/sysop.sh scripts/jobs/test/sysop-test.sh`; `git diff --check HEAD^ HEAD`; remote `main2` equals HEAD.
Follow-ups: deploy main2 to affected hosts so their next sysop tick reconciles legacy gaps and worker-derotate can restore healthy capacity.
Self-improvement: nothing this time.
