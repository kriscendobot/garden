---
order: serial
children: daemon-git-clone-bootstrap-design-expanded-window
on-child-failure: halt
state: running
arc: minion-town-git-remote
created_by: producer
created_at: 2026-11-02T11:51:36Z
---

split-indivisible-reason: "one atomic PR-body edit on endojs/endo-but-for-bots#709 that only an endolin host can perform; the design commit is already pushed"
split-indivisible-handler-timeout: 3600

The remaining work on daemon-git-clone-bootstrap-design is one PR-description edit, so it has no parts to partition. The overrun came from repo-lock contention and a hung ensure-pr --find-only on oros, not from the size of the work.
