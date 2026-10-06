---
child-release-standing-token-backoff-ramp-reap-count: 0
child-build-standing-token-backoff-ramp-host: endolin-garden2-5bcdff64
child-build-standing-token-backoff-ramp-reap-count: 0
child-kriscendobot-garden-pr116-conduct-host: endolin-garden2-5bcdff64
child-kriscendobot-garden-pr116-conduct-reap-count: 0
order: serial
children: kriscendobot-garden-pr116-conduct build-standing-token-backoff-ramp release-standing-token-backoff-ramp
on-child-failure: halt
state: running
created_by: gardener
created_at: 2026-10-06T19:04:24Z
---

# Deliver the accepted standing token-backoff ramp

Serially conduct kriscendobot/garden PR 116, build the accepted design, and deploy the implementation. This orchestration carries every remaining action in kriskowal's approved review directive https://github.com/kriscendobot/garden/pull/116#pullrequestreview-5432482973.
