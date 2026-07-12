---
kind: progress
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-12T08:07:52Z
---
# SturdyRef press tick (2026-07-12T08:05 dispatch, job endo-sturdyref-press-20260712-080502)

**Headline: REST TICK — no movement needed. Bar 1 (the bridge stack) rests
green and DRAFT; bar 2 (agent provide/accept, design #695) remains
maintainer-gated; nothing pressable before the 21:00Z nudge window.**

**Verified this tick (real execution, 08:05–08:12Z):**
- `gh pr checks 704` → **22/22 pass** (all statuses `pass`; e.g. run
  29183444593 legs green). Head unchanged at `36949cad0` (same as the 07:34Z
  tick's green head — no push since).
- The bar-1 stack #521→#541→#698→#700→#701→#702→#703→#704 is all OPEN + DRAFT
  (verified via `gh pr list --search sturdyref`); bases unchanged, no
  out-of-order merge.
- `inbox/maintainer/unread/20260711T211001Z-4a530e.md` (the #695 go/no-go)
  is **still unread**; #695 has no PR comments. Gate unanswered.
- No sturdyref job in `jobs/todo/` or `jobs/doin/`; no live sturdyref peer on
  `inbox-list` (only git-capability + xs2rust builders, self-heals, liaison).
- The moot `endojs-endo-but-for-bots-pr704-shepherd.md` is still parked in
  `jobs/plan/` — liaison was notified at the 07:34Z tick (do not double-act);
  its poison record sits in the maintainer inbox.
- The `cover (22.x)` inline-eval AVA-timeout flake did NOT recur (the rerun'd
  leg stayed green; still seen exactly once).

**Confinement statement:** no behavior landed this tick (observe-only). The
resting green run last re-executed the load-bearing no-identification test
("the ocapn capability and netlayer handles never cross a facet boundary")
across all four matrix legs; no location or correlation surface changed
anywhere since.

**Next-tick guidance (carried forward, unchanged):**
1. Bar 1 rests — do not merge the stack out of order; keep DRAFT.
2. On a #695 "go": post builder cuts A–F per the design (A daemon token core,
   B daemon provide+mail stacked after #541; then C agent-tools escrow,
   D lal, E fae, F genie).
3. If the gate is still unread after **2026-07-12T21:00Z**, nudge via
   `message-user.sh` (one nudge, not per-tick).
4. Flake watch: if `cover (22.x)` inline-eval times out again, post a small
   job to bump/isolate that suite instead of hand-rerunning.
5. Non-urgent designer-probe candidate remains: CI-vs-local environment
   sensitivity of the guest `@host` facet shape.
