---
kind: progress
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-17T09:39:51Z
---
SturdyRef press tick (09:35 dispatch, endo-sturdyref-press-20260717-093501) — lane assessed, one CI-clearing action taken, no project pushes. Note: the 07:20 tick (endo-sturdyref-press-20260717-072004) FAILED at claim (rc=1 at 07:20:42Z, error entry 072040Z-error-gardener-49319b) and its claim is a dead entry in doin/ awaiting the reaper — the last real tick was 05:05.

State verified this tick (gh pr view / gh pr checks, 09:36-09:42Z):
- endojs/endo-but-for-bots#737 (`build/sturdyref-pass-style-ocapn-single` @ b56b346534): OPEN, DRAFT. The review-response builder job (endojs-endo-but-for-bots-pr737-sturdyref-global-shim) COMPLETED: full response to kriskowal review 4718500574 pushed, dead-SHA references corrected, summary posted 05:15:59Z, review RE-REQUESTED from kriskowal. CI 24/25 pass; the lone red `test (22.x, macos-15)` is the known runner flake (log-verified this tick: `Failed: @endo/chat#test` — untouched by the PR — plus the node24 cleanup infra error). I re-ran the failed job (`gh run rerun 29557070434 --failed`) so the board is clean for the re-review.
- endojs/endo-but-for-bots#774 (`build/sturdyref-shim-first-wins` @ 59bd235e2b): OPEN, DRAFT. Head advanced by a fixup! (test tightening + pony tweak); CI fully green at this head (25/25 pass, checks verified 09:40Z).
- Bridge cuts unchanged: #698 @ 4e21536286, #700 @ 951cde7f13, #541 @ fab626e84a. Designs: #511 @ 182d0449eb; #539 @ 22923949b2 (kriskowal CHANGES_REQUESTED 06-26, addressed at aa104684c, awaiting re-review); #695 @ f5df0a4c83 (CHANGES_REQUESTED 07-15, addressed same hour, awaiting re-review).

Every next artifact now gates on the maintainer:
1. #737 re-review (requested 05:15Z today) + the shim-placement arbitration posed in its summary: shim embedded in @endo/pass-style (#737) vs standalone @endo/sturdyref (#774).
2. Marshal rank-prefix pick (A/q vs B/t vs C/w) + stack-collapse-vs-restack for #541 + bridge cuts.
3. Design re-reviews #539, #695 (and #697) — #695's acceptance gates posting builder jobs for agent-surface cuts A-F (the provide/accept "throughout" bar).
The consolidated maintainer nudge 20260716T200737Z-72c74a remains UNREAD (verified inbox/maintainer/unread/ this tick); per the 05:10 tick's norm, not re-nudged — the ~24h re-send window opens ~20:07Z today. The GitHub-side re-review request (05:15Z) is itself a fresh signal.

Confinement statement: no sturdyref behavior changed this tick (observation + one CI re-run only), so no confinement surface moved. Standing invariants ride #774's four named confinement tests (no-location, no-identification/unlinkability, withheld-from-compartments, first-wins convergence) — CI green at 59bd235e2b is real-execution evidence they pass at the current head — and #737's pass-style opacity coverage (16/16 pass-style, 125/125 ocapn per its builder's local run; its CI green at b56b346534 modulo the flake being re-run).

Next tick: (1) check the re-run of run 29557070434 went green and whether kriskowal re-reviewed #737 or arbitrated the shim placement; (2) if the placement lands, the follow-on is converging #774/#737 on the chosen home, then the bridge-cut restack; (3) if the maintainer nudge is still unread past ~20:07Z with no GitHub movement, re-send the consolidated nudge per the standing norm.
