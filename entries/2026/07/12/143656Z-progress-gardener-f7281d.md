---
kind: progress
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-12T14:36:59Z
---
# SturdyRef press tick (2026-07-12T14:35 dispatch, job endo-sturdyref-press-20260712-143505)

**Headline: REST TICK — no drift since the 13:38Z tick. Bar 1 (the bridge
stack) rests green and DRAFT; bar 2 (agent provide/accept, design #695)
remains maintainer-gated; the 21:00Z one-nudge window is still ~6h away.**

**Verified this tick (real execution, 14:35–14:45Z):**
- `gh pr view 704 --json headRefOid` → head still `36949cad0` (no push
  since the 07:34Z green tick). `gh pr checks 704 --json name,state` →
  **22/22 SUCCESS, zero non-pass** (grouped count: `[{"count":22,
  "state":"SUCCESS"}]`).
- Bar-1 stack re-verified via `gh pr list --search sturdy`: #521 (base
  `llm-27f53e6`) → #541 → #698 → #700 → #701 → #702 → #703 → #704, all
  OPEN + DRAFT, bases in exact stacked order; designs #511/#539/#695/#697
  all open drafts. No out-of-order merge risk.
- `gh pr view 695 --json comments,reviews` → **zero comments, zero
  reviews**; `inbox/maintainer/unread/20260711T211001Z-4a530e.md` (the
  #695 go/no-go) is **still unread**. Now ~14:45Z — the 21:00Z nudge
  window is not open; did not nudge.
- Peer check: `jobs/doin/` holds only the PR #678 review-retro job
  (unrelated); no sturdyref peer on `inbox-list.sh`; my inbox drained
  empty.
- Stale-poison note (unchanged): `jobs/plan/endojs-endo-but-for-bots-
  pr704-shepherd` (reaper-poisoned 04:53Z) remains moot while #704 is
  fully green; held for a human, not touched.
- Flake watch: no new CI run since the resting green one, so the
  `cover (22.x)` inline-eval flake had no chance to recur (still seen
  exactly once).

**Confinement statement:** observe-only tick — no behavior landed, so no
location or correlation surface changed. The resting green run last
re-executed the load-bearing no-identification test ("the ocapn capability
and netlayer handles never cross a facet boundary") across all matrix legs.

**Next-tick guidance (carried forward, unchanged):**
1. Bar 1 rests — do not merge the stack out of order; keep DRAFT.
2. On a #695 "go": post builder cuts A–F per the design (A daemon token
   core, B daemon provide+mail stacked after #541; then C agent-tools
   escrow, D lal, E fae, F genie).
3. If the gate is still unread after **2026-07-12T21:00Z**, nudge via
   `message-user.sh` (ONE nudge total — the first driver that sees the
   open window sends it and records it here).
4. Flake watch: if `cover (22.x)` inline-eval times out again, post a
   small job to bump/isolate that suite instead of hand-rerunning.
5. Non-urgent designer-probe candidate remains: CI-vs-local environment
   sensitivity of the guest `@host` facet shape.
