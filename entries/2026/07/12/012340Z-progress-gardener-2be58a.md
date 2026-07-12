---
kind: progress
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-12T01:23:40Z
---
# SturdyRef press tick (2026-07-12T01:20 dispatch, job endo-sturdyref-press-20260712-012012)

**Branch HEADs (verified via `gh api repos/endojs/endo-but-for-bots/commits/<branch>` this tick):**
`build/sturdyrefs-pass-style-ocapn` @ `d3c68897b9de` (#521, DRAFT),
`build/sturdyrefs-endor-syscall-retention` @ `fab626e84aae` (#541, DRAFT),
`build/sturdyref-bridge-1-bytes-wire-read` @ `4e21536286eb` (#698, cut 1,
DRAFT — CI GREEN: `gh pr checks 698` → 24/24 pass, verified this tick),
`build/sturdyref-bridge-2-ocapn-promotions` @ `951cde7f13de` (#700, cut 2,
DRAFT — CI GREEN: `gh pr checks 700` → 24/24 pass, verified this tick),
`build/sturdyref-bridge-3-daemon-mint-export` @ `15c7e51668d6` (**#701, cut
3, DRAFT, NEW since last tick — created ~01:12Z; CI IN FLIGHT: `gh pr checks
701` → 18 pass / 4 pending, ZERO fails, verified this tick**),
`design/sturdy-refs-cross-peer-bridge` @ `5aee6e0b4e2c` (#697, DRAFT). #510 MERGED.

**Movement since the 00:23Z tick — the serial orchestration is advancing on
schedule:** cut 3 (daemon mint/export) completed to `jobs/tada/` and produced
stacked DRAFT PR **#701** (base `build/sturdyref-bridge-2-ocapn-promotions`,
correct stack order). The orchestrate watcher promoted **cut 4 (the
closely-held `ocapn` singleton formula)**, now LIVE in `jobs/doin/` under
builder `ebfb-sturdyref-bridge-cut4-ocapn-singleton` (endolin-garden-ece02cb4
gardener 18, claimed 00:49Z, alive on the bus per `inbox-list.sh` this tick).
Cuts 5–6 remain parked `--orchestrated` in `jobs/plan/`. A shepherd
(`endojs-endo-but-for-bots-pr701-shepherd`) is live in `doin/` driving #701's
CI; with 18/22 pass and 4 pending it should observe green and close.
Orchestration `jobs/orch/ebfb-orch-sturdyref-bridge-cuts.md` still
`state: running`, halt-on-failure, no child failures.

**Maintainer gates (both still silent, not re-pinged this tick):** (1) the
21:10Z #695 go/no-go on agent-surface cuts A–F
(`inbox/maintainer/unread/20260711T211001Z-4a530e.md`) remains UNREAD — bar 2
(agents provide/accept throughout) stays gated on it; (2) #697's two open
questions (identity reuse, netlayer arming) still have zero PR comments (`gh
pr view 697 --json comments` → 0) — cut 4's job body carries the
conservative-provisional-defaults fallback (distinct-by-default identity, no
production netlayer armed), so the live builder is not blocked.

**Pressed this tick:** nothing pushed — correct per the collision rule: cut 4
is actively owned by a live builder, cuts 5–6 are orchestrated serial behind
it, the shepherd holds #701, and the only idle line (agent surface, bar 2) is
maintainer-gated.

**Confinement statement:** nothing landed this tick, so no Distributed
Confinement surface widened. Standing bind unchanged: cut 4 in flight binds
no-location (the `ocapn` capability that reveals location is closely held,
endowment-sweep test required); cut 5 binds no-location + no-identification on
foreign-locator internalization; cut 6 binds all three end-to-end.

**Next-tick guidance:** (1) confirm cut 4 completed or is still moving —
watch for `build/sturdyref-bridge-4-ocapn-singleton` and its stacked PR; on a
halt (child failure) surface to the maintainer; (2) check whether the #701
shepherd observed green and closed; (3) on a #695 GO, post the agent-surface
cuts A–F as a second serial orchestration (that is the bar-2 line); (4) if the
maintainer answers #697's open questions after cut 4 lands, a follow-up fixer
on the singleton's identity/netlayer defaults may be needed while still DRAFT.
