---
order: serial
children: endojs-endo-but-for-bots-pr714-shepherd-4995011322 endojs-endo-but-for-bots-pr714-conduct-4995011322
on-child-failure: halt
state: running
created_by: producer
created_at: 2026-07-16T18:00:06Z
---

# orchestrate: shepherd → conduct endojs/endo-but-for-bots PR #714

Serial two-step routed from kriskowal's "shepherd and conduct" attention directive
on PR #714 (cid 4995011322). Drive CI to green, then merge.

1. endojs-endo-but-for-bots-pr714-shepherd-4995011322  (role: shepherd)
2. endojs-endo-but-for-bots-pr714-conduct-4995011322    (role: conductor)

Serial, halt on child failure: if the shepherd cannot drive CI green, do NOT
proceed to merge — surface instead.

Directive: https://github.com/endojs/endo-but-for-bots/pull/714#issuecomment-4995011322
