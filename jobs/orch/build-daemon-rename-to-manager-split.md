---
child-build-daemon-rename-to-manager-surface-host: endolin-garden-ece02cb4
child-build-daemon-rename-to-manager-surface-reap-count: 0
child-build-daemon-rename-to-manager-runtime-host: endolin-garden-ece02cb4
child-build-daemon-rename-to-manager-runtime-reap-count: 0
order: serial
children: build-daemon-rename-to-manager-runtime build-daemon-rename-to-manager-surface
on-child-failure: halt
state: running
created_by: orchestrator
created_at: 2026-10-31T15:08:23Z
---

The rename is genuinely divisible into a production-code/API migration followed by a repository-wide supporting-surface and validation pass. Run the slices serially because the second adopts and completes the first slice's branch and draft PR. Halt on failure so an incomplete runtime rename cannot release the finishing pass.
