---
kind: progress
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-26T23:42:36Z
---
# SturdyRef press tick (endo-sturdyref-press-20260726-233502) — WHOLE STACK CI-GREEN; gauntlet unstuck-armed, go-ahead requested

State verified this tick (`gh pr view … statusCheckRollup`, all OPEN drafts):
endojs/endo-but-for-bots#698 24/24 GREEN (head `c19fdd96c`), endojs/endo-but-for-bots#700 24/24 GREEN (`e0122dfd7`),
endojs/endo-but-for-bots#541 21/21 GREEN (`fd60a74b0`), endojs/endo-but-for-bots#702 21/21 GREEN (`137673219`),
endojs/endo-but-for-bots#703 22/22 GREEN (`bb3906aad` — the 17:28 tick's macOS `test (22.x, macos-15)`
token-autocomplete failure cleared on rerun: runner flake, confirmed), endojs/endo-but-for-bots#704 22/22 GREEN
(`e32b01f2a`). **Bar 1 (OCapN sturdyref support, bridge cuts 1–6) is CI-complete end to end.**

Bar 2: the posted build completed — endojs/endo-but-for-bots#871 (agent provide/accept surface, design
endojs/endo-but-for-bots#695 phases 2–3) is OPEN draft, **21/21 GREEN at `c3fa894c9`**, zero reviews. Its
auto-gauntlet job `endo-sturdyref-agent-surface-build-gauntlet` was POISONED (deadline-overrun, rc=124 at
2400s) and parked in jobs/plan/ gate=go-ahead at 23:03Z. Diagnosis: the overrun was benign — the first
cycle finished the CLEAN stage (pushed `076318a0b` + `c3fa894c9`, now the green head) and died before the
panel started.

Press actions this tick:
1. AMENDED the parked gauntlet job (via land-journal-edit.sh, CAS-landed on origin/journal2): added
   `handler-timeout: 14000` (~3.9h, within the 14339s claim-budget max) so a retry cannot deterministically
   re-overrun, plus a resume note (clean done, CI green, spend budget on the panel).
2. MESSAGED the maintainer (inbox 20260726T234209Z-5dd69f) recommending "go ahead on
   endo-sturdyref-agent-surface-build-gauntlet". Did NOT self-promote — go-ahead-gated jobs are
   maintainer-only per promote-plan.sh.

No project code pushed this tick, so confinement invariants stand as last exercised on the green heads:
no-location (passStyleOf-opaque sturdyref, mediated enliven via closely-held network cap),
no-identification (unlinkable mints), opaque-and-unforgeable; endojs/endo-but-for-bots#871 carries the
agent-surface guard/escrow regression tests.

Next tick: (1) if the gauntlet was promoted, do NOT collide — watch it (jobs/doin/, PR reviews on
endojs/endo-but-for-bots#871); (2) if still parked and no maintainer reply, the effort is blocked on the
go-ahead — do not re-message every hour, the notice + message stand; (3) after the panel terminates
cleanly and the PR un-drafts, the remaining finish-line question is whether design
endojs/endo-but-for-bots#695 phase 4 (cross-turn retention/revocation) is required for the "throughout"
bar or stays out of scope per its HARD GATE.
