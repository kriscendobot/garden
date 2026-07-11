---
kind: progress
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-11T21:10:48Z
---
# endo-sturdyref-press tick (2026-07-11T21:05 dispatch) — substrate green; surfaced the cuts A–F go/no-go to the maintainer; filed #696

Standing hourly SturdyRef press-driver, `endojs/endo-but-for-bots` (base `llm`).

## Assessment (state as found, re-verified against live PRs)

- **#521** (pass-style, cuts 1–2): DRAFT, MERGEABLE, base `llm-27f53e6` — done, stable.
- **#541** (daemon facet-boundary threading, cuts 3–4): **CI fully green** —
  `gh pr checks 541` observed 21/21 pass this tick, including
  `test (22.x, macos-15)` (19m13s) which was red last tick; the pr541 shepherd
  has left the bus (its work is done). Base `build/sturdyrefs-pass-style-ocapn`.
- **#539** (enlivenment design): updated `22923949b2` — the designer marked the
  token-representation open question **Resolved** with a pointer to #695.
  Design #539's cut table has exactly 4 cuts; **all four are landed** (1–2 in
  #521, 3–4 in #541). The daemon substrate for the effort is complete pending
  stack landing.
- **#695** (`design(sturdy-refs): agent provide/accept surface and the guest
  token`): NEW this tick — the `ebfb-design-sturdyref-agent-surface` sub-job
  completed. DRAFT off `llm`, branch `design/sturdy-refs-agent-surface` @
  `619493db4d`, CI green (all observed checks pass). Settles the guest token as
  a daemon-minted method-less remotable, fresh per grant, WeakMap-bound, with a
  method mask excluding `identify`/`locate`; ends in six builder cuts
  (A daemon token core, B daemon provide+mail, C agent-tools escrow, D lal,
  E fae, F genie). The designer gated posting cuts A–F on maintainer acceptance
  and surfaced one open question (formula-backed tokens? design recommends no).
- No other sturdyref worker live (`inbox-list.sh`: only unrelated peers);
  `jobs/todo`+`jobs/plan` hold no pending sturdyref jobs.

## Pressed this tick

1. **Filed tracking issue endojs/endo-but-for-bots#696** for the deferred
   `M.sturdyRef()` patterns matcher (blocked on the `@endo/marshal` rank-order
   entry for `'sturdyref'`; `M.kind('sturdyref')` is the interim recogniser per
   #541's `interfaces.js` and #695 § Deferred follow-ups). Named twice in prior
   reports as "to be filed"; verified no duplicate existed first.
2. **Surfaced the maintainer decision** (charter step 5 — the next bar is gated
   on a human call, not on labor): maintainer message
   `20260711T211001Z-4a530e`, asking (a) accept #695 → go on posting builder
   cuts A–F (A–B stacked after #541), (b) answer the formula-backed-token
   question, noting (c) #696 and the remaining bar-1 wire-codec debt.

## Confinement statement

Nothing landed this tick widens any invariant (issue + message + assessment
only). The pending cuts bind no-location, no-identification, and
opaque-and-unforgeable via #695's per-artifact invariant table and its
agent-surface confinement test plan (two grants of one object uncorrelatable;
nothing reachable from a token reads a locator).

## Verification status

No code landed this tick → no suite run here (not verified ≠ regression).
Observed evidence: `gh pr checks 541` (21/21 pass, run 29166110266),
`gh pr checks 695` (all observed checks pass), `gh pr view` on
#521/#539/#541/#695 (states/bases/HEADs above), `gh issue list` (no #696
duplicate), `inbox-list.sh` (no sturdyref peer).

## Next unblocked artifacts (for the next tick)

1. **Check my inbox lineage + maintainer inbox for the #695 go/no-go.** On GO:
   post builder cuts A–F per #695's cut table — prefer parked children plus one
   orchestration job (serial; cuts A–B stacked on
   `build/sturdyrefs-endor-syscall-retention`), per the standing decomposition.
2. If no answer yet: do not re-ask every tick — re-surface only after ~a day of
   silence; meanwhile the wire-codec / `internalizeLocator` bridge (bar-1
   three-party-handoff debt) is the remaining non-gated design gap; a designer
   sub-job for it is a legitimate press if the maintainer stays silent and the
   board stays idle.
3. Stack hygiene at landing time: #521 → #541 weave onto live `llm`;
   #539/#511 base refresh (`llm-65b0abe`).
4. Deferred: #696 (`M.sturdyRef()`, blocked on marshal rank-order).
