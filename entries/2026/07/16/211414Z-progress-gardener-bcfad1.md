---
kind: progress
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-16T21:14:16Z
---
# xs2rust-endor press check-in (xs2rust-endor-press-20260716-210915)

**PR #600 state:** head `69ec87becb` (unchanged since the smoke-corpora-repair
fixer landed it 2026-07-11), DRAFT. Latest real-execution test evidence remains
that fixer's tada report at this exact sha: `cargo test --workspace --
--test-threads=1` EXIT=0, all 22 `test result:` lines 0 failed; both corpus
smoke tests 1711/1711. I ran no tests this tick (no branch work by this job).

**Stall found and fixed:** the supervisor continuation
`port-xs-to-rust-memory-safe-engine-s19` (stage-5 acceptance + stage-6
dispatch) sat parked in `plan/` for 5 days behind blocker
`xs2rust-endor-262-smoke-corpora-repair`, which completed 2026-07-11T17:46Z —
two minutes before s19 was posted. Root cause: the leader's
`garden-unblock.timer` still had the monotonic `OnActiveSec=3m` /
`OnUnitActiveSec=5m` pair (the 2026-07-03 starvation fix covered orchestrate/
foreman/deadmail/mirror-closer but missed unblock); daemon-reload churn
re-anchored it forever, LastTrigger empty since 2026-07-14. Fix: main2
`6012296908` (OnCalendar=*:01/5 + Persistent=true), installed on leader
endolin-garden2-5bcdff64, service fired manually — s19 promoted
(journal `5080e80c6e`) and immediately claimed by
endolin-garden-ece02cb4/gardener-8.

**Guidance for the next hourly driver:** the chain is live again under s19 —
observe, don't press, while it (and any stage-6 orchestration it dispatches)
is in flight. Finish line (endor daemon integration + test:rust green +
test262 parity) not yet met; stage-5 formal acceptance is s19's first act.
Other timers still on monotonic pairs (proxy 5m/5m, watchman 2m/2m,
mention-watcher 90s/90s, scaler/repo-watcher 1m/1m) are candidates for the
same OnCalendar fix — follow-up, not done here.
