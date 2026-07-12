---
kind: progress
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-12T00:23:11Z
---
# SturdyRef press tick (2026-07-12T00:20 dispatch, job endo-sturdyref-press-20260712-002002)

**Branch HEADs (verified via `gh api repos/endojs/endo-but-for-bots/commits/<branch>` this tick):**
`build/sturdyrefs-pass-style-ocapn` @ `d3c68897b9de` (#521, DRAFT),
`build/sturdyrefs-endor-syscall-retention` @ `fab626e84aae` (#541, DRAFT),
`build/sturdyref-bridge-1-bytes-wire-read` @ `4e21536286eb` (**#698, bridge cut
1, DRAFT — CI GREEN: `gh pr checks 698` → 24/24 pass, verified this tick**),
`build/sturdyref-bridge-2-ocapn-promotions` @ `951cde7f13de` (**#700, bridge
cut 2, DRAFT — CI GREEN: `gh pr checks 700` → 24/24 pass, verified this
tick**), `design/sturdy-refs-cross-peer-bridge` @ `5aee6e0b4e2c` (#697, DRAFT),
`design/sturdy-refs-agent-surface` @ `619493db4dc5` (#695, DRAFT). #510 MERGED.

**Orchestration substrate first-use VERIFIED (last tick's watch item):**
`jobs/orch/ebfb-orch-sturdyref-bridge-cuts.md` is `state: running`; cuts 1 and
2 completed to `jobs/tada/` and produced stacked DRAFT PRs #698 and #700; the
watcher serially promoted **cut 3 (daemon mint/export, sturdyref-store +
host-facet grants)**, now LIVE in `jobs/doin/` under builder
`ebfb-sturdyref-bridge-cut3-daemon-mint-export` (endolin-garden-ece02cb4
gardener 11, claimed 23:46Z, alive on the bus per inbox-list). Cuts 4–6 remain
parked `--orchestrated` in `jobs/plan/`. The auto-dispatched shepherds on
#698/#700 red CI are still in `doin/` but both PRs now read 24/24 green —
transient reds resolved; shepherds should observe green and close.

**Maintainer gates (both still silent, not re-pinged):** (1) the 21:10Z #695
go/no-go on agent-surface cuts A–F
(`inbox/maintainer/unread/20260711T211001Z-4a530e.md`) is still UNREAD — bar 2
(agents provide/accept throughout) stays gated on it; (2) #697's two open
questions (identity reuse, netlayer arming) have **zero PR comments** (`gh pr
view 697 --json comments` → empty) — cut 4's job body already carries the
conservative-provisional-defaults fallback, so no relay needed.

**Pressed this tick:** nothing pushed — correct per the collision rule: every
unblocked artifact is actively owned (cut 3 live builder; cuts 4–6
orchestrated serial behind it; shepherds hold #698/#700), and the only idle
line (agent-surface A–F) is maintainer-gated. Observation-only tick.

**Confinement statement:** nothing landed this tick, so no invariant widened.
Standing bind unchanged: each orchestrated cut carries its load-bearing
Distributed Confinement test (cut 3 in flight binds opaque-and-unforgeable +
guest-unreachable store; cut 5 no-location + no-identification; cut 6 all
three end-to-end).

**Next tick guidance:** (1) check cut 3's outcome — on tada, confirm the
watcher promotes cut 4 and that cut 4's PR states the provisional defaults and
messages the maintainer; on failure, the halt policy should surface it — make
sure it did; (2) check the maintainer's #695 reply — on GO, post agent-surface
cuts A–F as a SECOND serial orchestration (separate from the bridge one);
(3) confirm the #698/#700 shepherd jobs closed out after observing green;
(4) stack hygiene (#521→#541 weave onto live `llm`, #539/#511/#697 base
refresh) stays deferred to landing time.
