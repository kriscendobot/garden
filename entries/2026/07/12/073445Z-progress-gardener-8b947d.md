---
kind: progress
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-12T07:34:47Z
---
# SturdyRef press tick (2026-07-12T06:50 dispatch, job endo-sturdyref-press-20260712-065004)

**Headline: #704 (bridge cut 6, the tail of bar 1) is GREEN — 22/22 checks pass
at head `36949cad0`.** Evidence: `gh pr checks 704` → 22× pass; CI run
29183444593 `completed/success` (verified 07:33Z this tick). The bar-1 bridge
stack #521→#541→#698→#700→#701→#702→#703→#704 is now test-green end to end,
all DRAFT as charged.

**What this tick did (observer-then-unstick posture, no source pushed):**
1. Found the previous tick's fix `0dd7f34ad` had failed CI on **lint only**
   (run 29182201810; all four `test (…)` matrix legs PASSED there — the
   facet-boundary shape-agnostic probe fix worked). The lint red was a
   duplicate `shutdown` key in `packages/daemon/src/ocapn.js` left by the
   cut-5 rebase.
2. A peer instance (kriscendobot) pushed the correct fix `36949cad0` at
   06:57:34Z (removes the duplicate key, keeps the better docstring) — I
   verified the diff and did NOT touch the branch (peer-collision discipline).
3. Its CI run 29183444593 came back red on **one leg**: `cover (22.x,
   ubuntu-latest)` — an AVA timeout with 4 tests pending in
   `test/component/inline-eval.test.js` (652 passed; a familiar-UI component
   suite, no sturdyref code in the path; same leg passed on `0dd7f34ad`'s
   near-identical tree). Called it a coverage-instrumentation flake and
   re-ran the failed leg (`gh run rerun 29183444593 --failed`, 07:24Z) →
   **success** at ~07:31Z. 22/22 checks now pass.

**Confinement statement:** no behavior landed this tick. The green run
re-executed the load-bearing no-identification test ("the ocapn capability and
netlayer handles never cross a facet boundary" — a confined guest cannot
recover the ocapn identity through its host-view) in all four test matrix
legs; no location or correlation surface was added anywhere in the tick.

**Board hygiene:** the POISONED `endojs-endo-but-for-bots-pr704-shepherd`
parked in `jobs/plan/` is now MOOT (#704 green) — liaison notified to drop it
rather than promote (inbox-send this tick).

**Maintainer gates:** #695 go/no-go (agent-surface design; builder cuts A–F =
bar 2) still UNREAD (`inbox/maintainer/unread/20260711T211001Z-4a530e.md`,
sent 2026-07-11T21:10Z). Per prior tick's norm: nudge after 2026-07-12T21:00Z
if still unanswered. Bar 2 is the only remaining unbuilt finish-line bar and
it is maintainer-gated; bar 1 rests green.

**Next-tick guidance:** (1) nothing to press on the bridge stack — it is green
and DRAFT; do not merge out of order; the stack rests pending the #695 gate.
(2) If the maintainer answers #695 go: post the builder cuts A–F per the
design (A daemon token core, B daemon provide+mail stacked after #541; then
C agent-tools escrow, D lal, E fae, F genie). (3) Nudge #695 after 21:00Z.
(4) The `cover (22.x)` inline-eval AVA-timeout flake has now been seen once —
if it recurs, consider a small job to bump that suite's timeout or isolate it
rather than re-running by hand. (5) The CI-vs-local environment-sensitivity of
the guest `@host` facet shape (prior tick's observation) remains a non-urgent
designer probe candidate.
