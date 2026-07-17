---
kind: progress
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-17T05:10:56Z
---
SturdyRef press tick (05:05 dispatch, endo-sturdyref-press-20260717-050512) — the lane is UNBLOCKED and in live hands; this tick's contribution is a convergence pointer that prevents a duplicate-shim fork.

State verified this tick (gh pr view, 05:07-05:09Z):
- endojs/endo-but-for-bots#774 (shim, `build/sturdyref-shim-first-wins` @ 9eb314ea98): OPEN, DRAFT — the first-wins `@endo/sturdyref` shim with four confinement tests, landed 04:34Z.
- endojs/endo-but-for-bots#737: OPEN, DRAFT, head still ce7341b47d (unchanged since kriskowal's CHANGES_REQUESTED review 00:42Z). The review-response job `endojs-endo-but-for-bots-pr737-review-3363fee9` completed at ~05:0xZ as a ROUTER: it posted builder job `endojs-endo-but-for-bots-pr737-sturdyref-global-shim`, claimed 04:56:35Z by endolin-garden-ece02cb4/gardener-19, confirmed actively working via journalctl (`working` 04:56:58Z). That builder owns #737's branch; NO project pushes from this tick (anti-collision).
- Bridge cuts unchanged since 07-11: endojs/endo-but-for-bots#698 @ 4e21536286, #700 @ 951cde7f13, #541 @ fab626e84a; designs #511 @ 182d0449eb, #539 @ 22923949b2.

Duplicate-shim risk found and mitigated: the router's preflight said "no peer resolution existed", and the builder job body never mentions endojs/endo-but-for-bots#774 — yet it asks for the same first-wins shim semantics on #737's branch. Two independently-minted shims would defeat the first-wins convergence the maintainer asked for. Sent inbox message 20260717T051012Z-a9825e to the live builder pointing at #774's branch/head/semantics and the four confinement tests as the bar, asking it to converge with or explicitly supersede that shape. Builder had not yet pushed when the message landed (head still ce7341b47d), so it arrives in time.

Maintainer gates still open (consolidated nudge 20260716T200737Z-72c74a remains UNREAD in inbox/maintainer/unread/): (2) marshal rank-prefix pick A/q vs B/t vs C/w; stack-collapse vs restack of #541 + bridge cuts; (3) re-reviews of designs endojs/endo-but-for-bots#695 and #697. Not re-nudged this tick — the nudge is already queued and the #737 lane is moving.

Confinement statement: no sturdyref behavior changed this tick (observation + one bus message only), so no confinement surface moved. Standing invariants ride #774's four named tests (no-location, no-identification/unlinkability, opaque/withheld, first-wins convergence) per its tada report — not re-executed here. The convergence message explicitly carries the confinement test bar forward to the #737 response builder.

Next tick: (1) check whether gardener-19's builder pushed to #737 (`build/sturdyref-pass-style-ocapn-single`) and whether it acknowledged/acted on the #774 convergence pointer — if it minted a second divergent shim, reconcile (that is the offered follow-up). (2) If #737's response lands and re-requests review, the stack order remains #774 shim -> #737 pass-style -> bridge cuts (#698/#700) -> #541 daemon threading -> agent provide/accept surface. (3) Maintainer gates: watch for the unread nudge being read; do not re-send unless another ~24h passes with no movement.
