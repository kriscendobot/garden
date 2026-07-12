---
kind: progress
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-12T03:38:20Z
---
# SturdyRef press tick (2026-07-12T03:35 dispatch, job endo-sturdyref-press-20260712-033502)

**Branch HEADs (verified via `gh pr view`/check-runs API this tick):**
`build/sturdyrefs-pass-style-ocapn` (#521, DRAFT),
`build/sturdyrefs-endor-syscall-retention` (#541, DRAFT),
bridge cuts 1–3 (#698/#700/#701, DRAFT, green per prior ticks),
`build/sturdyref-bridge-4-ocapn-singleton` @ `cb2b599d0ad1` (#702, cut 4, DRAFT —
**CI GREEN: 22/22 check-runs success, verified this tick**; shepherd
`endojs-endo-but-for-bots-pr702-shepherd` completed to `jobs/tada/`),
`build/sturdyref-bridge-5-foreign-internalization` @ `3cd5aca1d00f` (**#703, cut 5,
DRAFT, NEW since the 02:35Z tick** — CI 17 success / 5 failure; auto-dispatched
shepherd `endojs-endo-but-for-bots-pr703-shepherd` is live on it per
`inbox-list.sh` + `jobs/doin/` this tick),
`design/sturdy-refs-cross-peer-bridge` @ `5aee6e0b4e2c` (#697, DRAFT). #510 MERGED.
Stack order verified intact: #521 → #541 → #698 → #700 → #701 → #702 → #703 → cut 6.

**Movement since the 02:35Z tick — the serial orchestration advanced two steps:**
(1) **Cut 5 COMPLETED** to `jobs/tada/` and delivered stacked DRAFT PR **#703**
(foreign-SturdyRef internalization: `ocapn-peer`/`ocapn-sturdyref` formula types,
`known-sturdyrefs-store` dedup keyed on `locationId + sha256(swissNum)`, facet-seam
fallback `resolveSturdyRefToIdWith`, host-only `acceptSturdyRefUri`, the armed
dial+serve OCapN client with a real `tcp-test-only` netlayer test — 10/10 local
`ocapn.test.js` per its report). Its stated follow-up: no production netlayer is
armed by default (maintainer's open question); cut 6 will need daemon-side arming.
(2) **#702 (cut 4) went CI-GREEN** — its shepherd drove the four red test-matrix
legs green and completed. (3) The orchestrate watcher **promoted cut 6
(three-party round-trip)** at 03:07:11Z; builder
`ebfb-sturdyref-bridge-cut6-three-party-roundtrip` claimed 03:07:16Z
(endolin-garden-ece02cb4 gardener 4), alive on the bus this tick; branch
`build/sturdyref-bridge-6-three-party-roundtrip` not yet pushed (404 — in-progress
local work, ~40 min into the claim). Orchestration
`jobs/orch/ebfb-orch-sturdyref-bridge-cuts.md` still `state: running`,
halt-on-failure, no child failures. Cut 6 is the LAST child — when it reaches
`tada/`, the bridge orchestration (finish-line bar 1's closer) completes.

**Maintainer gates (both still silent, verified this tick):** the 2026-07-11
21:10Z #695 go/no-go on agent-surface cuts A–F
(`inbox/maintainer/unread/20260711T211001Z-4a530e.md`) remains UNREAD (~6.6h —
below the ~24h escalation bar; escalate with a fresh nudge if still unread past
~2026-07-12T21:00Z); #695 and #697 both still have zero PR comments
(`gh pr view … --json comments` → 0). Bar 2 (agents provide/accept throughout)
stays gated on the #695 decision.

**Pressed this tick:** nothing pushed — correct per the collision rule. Every
unblocked lane is owned by a live agent: cut 6 by its builder, #703's red CI by
its shepherd, and the only idle lane (bar 2, agent surface) is maintainer-gated.

**Confinement statement (nothing landed by this tick, so no surface widened):**
standing binds unchanged. Cut 5 (#703) binds **no-location** (OCapN
capability/client/netlayer are a daemon-core singleton never vended through a
facet; `acceptSturdyRefUri` is host-only; `locate` returns only the
`endo://…?type=ocapn-sturdyref` locator, never the foreign peer locator or the
swiss-num) and **no-identification** (random location-free local formula ids;
daemon-private dedup index; secret-free rejections), per its completion report
and tests. Cut 6 in flight is chartered to exercise all three properties
end-to-end (confined guest at B cannot recover C's locator or the swiss-num).

**Next-tick guidance:** watch cut 6 (claimed 03:07:16Z — if its claim exceeds the
~2400s deadline it requeues; take the wheel only if it vanishes without requeue)
and #703's shepherd. When cut 6 reaches `tada/`, verify the orchestration record
flips to complete, then bar 1 needs an end-to-end assessment tick. On a #695 GO,
post the agent-surface cuts A–F as a second serial orchestration (bar 2).
