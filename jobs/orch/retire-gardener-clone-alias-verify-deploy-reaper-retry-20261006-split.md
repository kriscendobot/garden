---
order: serial
children: retire-gardener-clone-alias-verify-deploy-reaper-retry-20261006-expanded-window
on-child-failure: halt
state: running
created_by: producer
created_at: 2026-10-06T19:44:22Z
---

Single-child split of retire-gardener-clone-alias-verify-deploy-reaper-retry-20261006 after a deadline overrun.
split-indivisible-reason: remaining work is one serial fetch-timeout-test.sh verdict (15-50 min per run under host load, must also run against the 70b6d1e3d42^ extract); one suite run cannot be partitioned
split-indivisible-handler-timeout: 10800
