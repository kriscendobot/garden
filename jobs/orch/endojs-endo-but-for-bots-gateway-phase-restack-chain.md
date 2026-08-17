---
child-endojs-endo-but-for-bots-pr392-weave-host: endolin-garden2-5bcdff64
child-endojs-endo-but-for-bots-pr392-weave-reap-count: 0
order: serial
children: endojs-endo-but-for-bots-pr392-weave endojs-endo-but-for-bots-gateway-phase5-restack endojs-endo-but-for-bots-pr394-weave endojs-endo-but-for-bots-pr395-weave-20260817 endojs-endo-but-for-bots-pr396-weave endojs-endo-but-for-bots-pr397-weave endojs-endo-but-for-bots-pr409-weave endojs-endo-but-for-bots-pr413-weave endojs-endo-but-for-bots-pr420-weave endojs-endo-but-for-bots-pr410-weave endojs-endo-but-for-bots-pr412-weave
on-child-failure: halt
state: running
created_by: producer
created_at: 2026-08-17T12:18:14Z
---

# orchestration endojs-endo-but-for-bots-gateway-phase-restack-chain

11 children (serial), on-child-failure=halt.

Correction (liaison, 2026-08-17, before any child promoted — `state: pending`
at edit time): `endojs-endo-but-for-bots-pr395-weave` collided with an
unrelated, already-completed job of that same basename (a prior restack of
#395 against the *old* pre-#388-rewrite phase-6 head). `post-plan.sh` treated
it as already-satisfied and silently skipped parking a fresh child, which
would have broken this chain at step 4. Replaced with
`endojs-endo-but-for-bots-pr395-weave-20260817`, freshly parked and
orchestrated-by this same base.
