---
kind: progress
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-12T12:37:43Z
---
# SturdyRef press tick (2026-07-12T12:35 dispatch, job endo-sturdyref-press-20260712-123502)

**Headline: REST TICK — no drift since the 11:20Z tick. Bar 1 (the bridge
stack) rests green and DRAFT; bar 2 (agent provide/accept, design #695)
remains maintainer-gated; nudge window opens 21:00Z tonight (not yet open).**

**Verified this tick (real execution, 12:35–12:45Z):**
- `gh pr view 704 --json headRefOid,statusCheckRollup` → head still
  `36949cad0` (no push since the 07:34Z green tick); **all 22 checks
  SUCCESS**, zero non-pass.
- Bar-1 stack re-verified via `gh pr list --search "sturdyref in:title"`:
  #521 (base `llm-27f53e6`) → #541 → #698 → #700 → #701 → #702 → #703 → #704,
  all OPEN + DRAFT, bases in exact stacked order. Designs #511/#539 open
  drafts (updatedAt 2026-06-26 / 2026-07-11). No out-of-order merge risk.
- `gh pr view 695 --json comments,reviews` → **zero comments, zero
  reviews**; `inbox/maintainer/unread/20260711T211001Z-4a530e.md` (the #695
  go/no-go) is **still unread**. Gate unanswered on both surfaces; now
  ~12:40Z, the 21:00Z one-nudge window is not open — did not nudge.
- Peer check: `jobs/doin/` holds only the PR #706 git-capability gauntlet
  (unrelated to sturdyref); `jobs/todo/` empty; no sturdyref peer on
  `inbox-list`; my inbox drained empty.
- Stale-poison note: `poison-endojs-endo-but-for-bots-pr704-shepherd-
  requeue-exhausted` (reaper, 04:53Z) parks a shepherd for a #704 red that
  **self-healed** by the 07:34Z green tick — the parked job at
  `jobs/plan/endojs-endo-but-for-bots-pr704-shepherd` is moot while #704 is
  22/22 green. It is held for a human; maintainer may remove it. No action
  taken (agents do not promote/remove held poison jobs).
- Flake watch: no new CI run since the resting green one, so the
  `cover (22.x)` inline-eval flake had no chance to recur (still seen once).

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
   `message-user.sh` (ONE nudge total — the 20:50Z or 21:50Z driver that
   first sees the open window sends it and records it here).
4. Flake watch: if `cover (22.x)` inline-eval times out again, post a small
   job to bump/isolate that suite instead of hand-rerunning.
5. Non-urgent designer-probe candidate remains: CI-vs-local environment
   sensitivity of the guest `@host` facet shape.
