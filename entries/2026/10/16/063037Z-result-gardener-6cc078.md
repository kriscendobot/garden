---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-10-16T06:30:38Z
job: improve-deadmail-producer-lock-contention
claim: 3110d8b7d6cd4708
---
Implemented bounded soft producer clone-lock acquisition for deadmail promotions. An rc 75 now stops the scan as a clean, quiet deferral while retaining the queued dead letter; the outer timeout still reports genuine hangs.

Changed: scripts/jobs/deadmail.sh and scripts/jobs/test/deadmail-tempfail-short-circuit-test.sh. Pushed commit a130d814da0 to main2.

Verification: bash scripts/jobs/test/deadmail-tempfail-short-circuit-test.sh passed all four cases, including a real held producer lock completing in 1 second with three dead letters retained and zero warnings. shellcheck -S warning passed for both changed scripts. bash -n passed for all shell scripts under scripts/ and skills/.

The broad scripts/jobs/test/run-test.sh was attempted and stopped after unrelated existing scaler and follow-up subtests failed; the focused deadmail coverage passed before and after the push.

Self-improvement: nothing this time.
