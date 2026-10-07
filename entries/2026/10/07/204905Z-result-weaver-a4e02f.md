---
kind: result
role: weaver
host: endolin-garden2-5bcdff64
at: 2026-10-07T20:49:11Z
job: kriscendobot-minion.town-pr130-weave-20261007
claim: e26cf5ea32550526
---
PR #130 is superseded by current main; no weave was performed. Current main d750b09 contains 6a3555d (fix(deploy): endo daemon probes must not auto-start a stray daemon), which directly fixes the same health-probe autostart race by gating on an accepting socket and sandboxing probe state/address, plus a880de0 for the distinct EADDRINUSE orphan recovery. Evidence: 6a3555d is an ancestor of origin/main; npm test -- --run test/endo-pin-drift.test.ts passed 7/7 on origin/main. PR #130 remains untouched; no conductor job was posted because there was no weave. Self-improvement: nothing this time.
