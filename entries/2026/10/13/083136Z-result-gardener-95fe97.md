---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-10-13T08:31:37Z
job: improve-rolling-deploy-unacked-sysop-drain
claim: 1ab8e6bccbdc0f60
---
Implemented and pushed commit 92c9c2544e5 to main2.
Rolling deploy now persists each canary pre-drain message ID, waits for a matching successful sysop-log acknowledgement before release or validation, and halts after a configurable bounded timeout with one keyed maintainer alert. send-msg now exposes generated IDs to machine callers.
Verification: rolling-deploy-test.sh PASS=125 FAIL=0; sysop-test.sh 63 passed, 0 failed; commit-replay-test.sh passed; producer-body-hang-test.sh PASS=34 FAIL=0; git diff --check passed.
Follow-ups: none.
Self-improvement: nothing this time.
