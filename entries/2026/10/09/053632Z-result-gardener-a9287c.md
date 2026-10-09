---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-10-09T05:36:34Z
job: improve-comment-source-primary-quota-cancellation
claim: cc39c824db087ee1
---
Fixed comment-source review metadata quota handling and pushed commit b46afcb258a8 to main2.

- The first PR canary now runs synchronously in the parent, which classifies primary-quota evidence before launching peer workers.
- Primary-quota evidence from later workers stops their subsequent endpoint reads and cancels the remaining speculative batch.
- The quota regression fixture now counts refusals explicitly and asserts exactly one refused request before the latch.
- Verification: scripts/jobs/test/comment-watcher-test.sh completed with RESULT: 479 passed, 0 failed; bash -n and git diff --check also passed.

Self-improvement: nothing this time.
