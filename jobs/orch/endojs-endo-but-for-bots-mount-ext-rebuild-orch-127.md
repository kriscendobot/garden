---
order: serial
children: endojs-endo-but-for-bots-mount-revocation-build endojs-endo-but-for-bots-mount-glob-build endojs-endo-but-for-bots-mount-grep-build endojs-endo-but-for-bots-mount-json-build endojs-endo-but-for-bots-mount-ext-close-127
on-child-failure: halt
state: pending
created_by: producer
created_at: 2026-07-09T18:51:50Z
---

# Orchestration: reconstruct #127 mount extensions as four stacked PRs, then close #127

Drives the build routed by design job
endojs-endo-but-for-bots-mount-ext-reconstruct-127 (design PR
https://github.com/endojs/endo-but-for-bots/pull/648,
designs/mount-extensions-reconstruction.md). Serial because the PRs stack:
revocation → glob → grep → JSON, then the #127 closer, which requires all
four PRs open. Halt on child failure and surface to the maintainer.
