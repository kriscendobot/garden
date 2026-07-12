---
kind: progress
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-12T02:38:16Z
---
# SturdyRef press tick (2026-07-12T02:35 dispatch, job endo-sturdyref-press-20260712-023501)

**Branch HEADs (verified via `gh pr view`/check-runs API this tick):**
`build/sturdyrefs-pass-style-ocapn` @ `d3c68897b9de` (#521, DRAFT),
`build/sturdyrefs-endor-syscall-retention` @ `fab626e84aae` (#541, DRAFT),
`build/sturdyref-bridge-1-bytes-wire-read` @ `4e21536286eb` (#698, cut 1, DRAFT),
`build/sturdyref-bridge-2-ocapn-promotions` @ `951cde7f13de` (#700, cut 2, DRAFT),
`build/sturdyref-bridge-3-daemon-mint-export` @ `15c7e51668d6` (#701, cut 3,
DRAFT — CI GREEN: check-runs API → 22/22 success, verified this tick),
`build/sturdyref-bridge-4-ocapn-singleton` @ `cec382fa212b` (**#702, cut 4,
DRAFT, NEW since the 01:20Z tick — CI 18 success / 4 failure**: the four
`test (22.x|24.x, ubuntu|macos)` matrix legs are red; the auto-dispatched
shepherd `endojs-endo-but-for-bots-pr702-shepherd` claimed it 02:05:46Z and is
live driving it green),
`design/sturdy-refs-cross-peer-bridge` @ `5aee6e0b4e2c` (#697, DRAFT). #510 MERGED.
Stack order verified intact: #521 → #541 → #698 → #700 → #701 → #702 → cut 5.

**Movement since the 01:20Z tick — the serial orchestration advanced two
steps:** (1) cut 4 (the closely-held `ocapn` identity singleton) COMPLETED to
`jobs/tada/` and delivered stacked DRAFT PR **#702** — it recovered from the
01:29Z deterministic deadline overrun (rc=124 @ 2400s) via requeue and
finished. Its report states the no-location bind: the `ocapn` formula is a
daemon-core singleton with no pet name and no host/guest facet accessor;
conservative provisional defaults adopted (distinct-by-default identity, no
production netlayer armed) and stated in the PR body. (2) The orchestrate
watcher promoted **cut 5 (foreign internalization, `acceptSturdyRefUri`,
facet-seam fallback)** at 02:01:08Z; builder
`ebfb-sturdyref-bridge-cut5-foreign-internalization` claimed 02:01:11Z
(endolin-garden2-5bcdff64 gardener 12), alive on the bus per `inbox-list.sh`
this tick. Cut 6 (three-party round-trip) remains parked `--orchestrated` in
`jobs/plan/`. Orchestration `jobs/orch/ebfb-orch-sturdyref-bridge-cuts.md`
still `state: running`, halt-on-failure, no child failures.

**Maintainer gates (both still silent, verified this tick):** (1) the 21:10Z
#695 go/no-go on agent-surface cuts A–F
(`inbox/maintainer/unread/20260711T211001Z-4a530e.md`) remains UNREAD — bar 2
(agents provide/accept throughout) stays gated on it; (2) #697's open
questions still have zero PR comments (`gh pr view 697 --json comments` → 0)
and #695 likewise 0 — cut 4 shipped with the conservative-provisional-defaults
fallback, reversible while draft.

**Pressed this tick:** nothing pushed — correct per the collision rule: cut 5
is actively owned by a live builder (34 min into its claim), #702's red CI is
actively owned by a live shepherd (claimed 02:05:46Z), cut 6 is orchestrated
serial behind cut 5, and the only idle line (agent surface, bar 2) is
maintainer-gated.

**Confinement statement:** nothing landed this tick, so no Distributed
Confinement surface widened. Standing bind unchanged: cut 4 (now in #702)
binds no-location (the location-revealing `ocapn` capability is closely held,
unreachable from workers/guests, per its tada report and unit tests); cut 5 in
flight binds no-location + no-identification on foreign-locator
internalization (its job body requires the confined-guest-cannot-read-a-locator
and unlinkable-token tests); cut 6 binds all three end-to-end.

**Next-tick guidance:** (1) check whether the #702 shepherd drove the four
test-matrix legs green (a cut-4 test red may need a fixer; watch for a
shepherd→fixer escalation) and whether cut 5 completed or is still moving —
watch for `build/sturdyref-bridge-5-foreign-internalization` and its stacked
PR; on an orchestration halt (child failure) surface to the maintainer;
(2) on a #695 GO, post the agent-surface cuts A–F as a second serial
orchestration (the bar-2 line); (3) if the maintainer answers #697's open
questions, a follow-up fixer on #702's identity/netlayer defaults may be
needed while still DRAFT; (4) the #695 gate has been silent ~5.5h — if it
passes ~24h unread, escalate with a fresh `message-user` nudge rather than
letting bar 2 sit indefinitely.
