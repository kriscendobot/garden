---
kind: progress
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-11T23:12:35Z
---
# SturdyRef press tick (2026-07-11T23:05 dispatch, job endo-sturdyref-press-20260711-230511)

**Branch HEADs (verified via `gh api .../commits/<branch>`):**
`build/sturdyrefs-pass-style-ocapn` @ `d3c68897b9de` (#521, DRAFT),
`build/sturdyrefs-endor-syscall-retention` @ `fab626e84aae` (#541, DRAFT, CI
green — 22/22 check-runs `success` verified this tick),
`design/sturdy-refs-cross-peer-bridge` @ `5aee6e0b4e2c` (**#697, NEW this hour**
— the wire-bridge design posted at 22:10 was claimed, built, and opened as a
DRAFT 496-line design by `endolin-garden2-5bcdff64/gardener-13`; report in
`jobs/tada/ebfb-design-sturdyref-wire-bridge.md`),
`design/sturdy-refs-endor-syscall-followup` (#539, DRAFT),
`design/sturdy-refs-agent-surface` (#695, DRAFT). #510 MERGED.

**Maintainer gate status:** the 21:10 #695 go/no-go question
(`inbox/maintainer/unread/20260711T211001Z-4a530e.md`) is still UNREAD — bar 2
(agents provide/accept throughout) stays gated. Not re-pinged.

**Pressed this tick:** sequenced #697's six-cut builder table (the design
explicitly left sequencing to the press-driver) per the standing multi-part
decomposition: six children parked `--orchestrated` under one **serial,
halt-on-failure orchestration `ebfb-orch-sturdyref-bridge-cuts`** (origin
commit `4d84fa4676`). Stack: cut 1 roots on
`build/sturdyrefs-endor-syscall-retention`; each later cut bases on its
predecessor's branch; every child body carries the design's verbatim change +
test plan + load-bearing confinement test, and KEEP-DRAFT. Cut 4's body handles
the design's two open maintainer questions (identity reuse, netlayer arming):
check for an answer first; if silent, conservative provisional defaults
(distinct-by-default identity, no production netlayer armed) stated in the PR
and messaged to the maintainer. Duplicate-checked before posting: no
bridge-cut job existed anywhere in plan/todo/doin/tada. The orchestrate
watcher is leader-only; leader is `endolin-garden2-5bcdff64` and
`garden-orchestrate.{service,timer}` exist in `scripts/systemd/` — this is the
board's first `jobs/orch/` record, so NEXT TICK VERIFY the watcher actually
promoted cut 1 into todo/ (if `jobs/orch/` sits inert with cut 1 still in
plan/, the timer may not be armed on the leader — surface that to the
maintainer/liaison rather than hand-promoting).

**Confinement statement:** nothing landed this tick widens any invariant
(assessment + seven journal records). Each posted cut binds its confinement
test as done-criteria: cut 1 opaque-and-unforgeable (no secret bytes reachable
on the materialized ref), cut 2 no-location (URI emission closely held, no
`toString` leak), cut 3 opaque-and-unforgeable + guest-unreachable store, cut 4
no-location (`ocapn` capability endowment-sweep), cut 5 no-location +
no-identification (token reveals no locator, unlinkable grants, mediator-only
dialing), cut 6 all three end-to-end.

**Next tick guidance:** (1) verify orchestrate promoted
`ebfb-sturdyref-bridge-cut1-bytes-wire-read` to todo/ or that a builder claimed
it — first-use of the orch substrate, watch for inertness; (2) check the
maintainer's #695 reply — on GO, post cuts A–F as a second serial
orchestration (do NOT fold them into the bridge orchestration; different
design, different gate); (3) #697's two open questions may get answered on the
PR — relay any answer into cut 4's context if cut 4 hasn't run; (4) stack
hygiene (#521→#541 weave onto live `llm`, #539/#511/#697 base refresh) stays
deferred to landing time.
