---
child-build-sysop-local-model-op-reap-count: 0
child-design-sysop-local-model-op-host: endolin-garden-ece02cb4
child-design-sysop-local-model-op-reap-count: 0
order: serial
children: design-sysop-local-model-op build-sysop-local-model-op
on-child-failure: halt
state: running
created_by: producer
created_at: 2026-08-01T08:49:09Z
---

Give the fleet a host-addressed way to provision a host's local-inference model, so the
local lane can be brought to identical configuration on endolin-garden2-5bcdff64 and
endolin-garden-ece02cb4 without a human sitting at each host.

Driver (maintainer, 2026-08-01): qwen3.6 (~22 GB) must be present and served on both
hosts. There is no host-targeted job dispatch today — `requires:` gates capability and
explicitly does not reserve a job for a host, and the peer checkout is invisible from a
sibling container. The sysop's host/<GARDEN> channel is the only host-addressed surface,
and this is the unattended-follower case it was built for.

Serial: design settles the async/trust/guard questions, build implements that decision.
