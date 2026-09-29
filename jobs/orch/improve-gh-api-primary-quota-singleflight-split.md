---
child-improve-gh-api-primary-quota-singleflight-expanded-window-reap-count: 0
order: serial
children: improve-gh-api-primary-quota-singleflight-expanded-window
on-child-failure: halt
state: running
created_by: orchestrator
created_at: 2026-09-29T21:56:08Z
---

# improve-gh-api-primary-quota-singleflight-split

Single-child split of `improve-gh-api-primary-quota-singleflight` after one 2400s deadline overrun.

split-indivisible-reason: the fix is one critical section inside gh_api_retry (scripts/jobs/common.sh:5451): take the gh-api cooldown flock, re-check the all-API marker under it, issue the request, and on a primary-quota refusal write the latch BEFORE releasing the flock. Admission, re-check, and latch-before-release must land together; any partial child (lock without latch, or latch without serialized admission) leaves the exact 19:35:34-35 race in place and ships no observable fix, and its regression test (concurrent stubbed callers, exactly one doomed request) exercises all three at once.
split-indivisible-handler-timeout: 7200

Child: `improve-gh-api-primary-quota-singleflight-expanded-window` (handler-timeout: 7200).
