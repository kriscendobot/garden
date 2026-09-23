---
kind: progress
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-22T13:59:46Z
---
# SturdyRef press — 13:53 dispatch tick: ARBITRATION LANDED; restack orchestration posted

**The hold is over.** Maintainer arbitration arrived 2026-07-22T06:27:18Z as a
kriskowal comment on endojs/endo-but-for-bots#737:
- **Shim placement:** standalone `@endo/sturdyref` package (#774's home) wins.
- **Marshal rank prefix:** `l` (locator/link), between number (`f`) and remotable (`r`).
- **Stack shape (implicit):** he directed "rebase this and change the github pr
  base" — RESTACK, not fold; #737 keeps its PR identity atop #774.

Convergence already landed before this tick: job
`endojs-endo-but-for-bots-pr737-c18afe76` (result entry 063746Z-result-gardener-0bc04c)
rebased #737 onto `build/sturdyref-shim-first-wins`, changed its GitHub base,
moved the first-wins consumer to `@endo/sturdyref`, assigned prefix `l` —
head `09130626`, targeted tests + typechecks reported green in its PR comment.

**Verified live this tick (`gh pr view --json state,isDraft,updatedAt,headRefOid,reviewDecision`):**
- #737 OPEN draft head `09130626` base `build/sturdyref-shim-first-wins` (moved 06:37Z);
  #774 `59bd235e` (llm ← build/sturdyref-shim-first-wins) unmoved; #698 `4e215362` /
  #700 `951cde7f` / #541 `fab626e8` unmoved since 07-11; #695 `f5df0a4c` / #697
  `e4a0a614` / #539 `22923949` still CHANGES_REQUESTED awaiting maintainer re-review;
  #511 `182d0449` (06-26).
- Omnibus `20260721T171232Z-297e3f` is in `inbox/maintainer/read/` — the 4th-nudge
  trigger (~17:12Z) is CANCELLED for the sturdyref lane; the arbitration answered it.
- No live sturdyref peer (`inbox-list.sh`), no restack job on the board before this
  tick; my inbox empty. Note: the 09:51Z handler of this same job base died rc=1
  (error entry 095130Z-error-gardener-88f090) before acting; this run replaces it.

**Action this tick:** posted the restack decomposition per the standing
orchestration pattern — orchestration
`endo-sturdyref-restack-541-698-700-pr737-line` (serial, halt-on-failure) over
parked weaver children:
1. `endojs-endo-but-for-bots-pr541-restack-pr737-line` — rebase --onto
   `build/sturdyref-pass-style-ocapn-single`, dropping the stale closed-#521
   foundation `build/sturdyrefs-pass-style-ocapn`; change #541's GitHub base.
2. `endojs-endo-but-for-bots-pr698-restack-pr737-line` — rebase bridge cut 1 onto
   the moved #541 head (no GitHub base change).
3. `endojs-endo-but-for-bots-pr700-restack-pr737-line` — rebase bridge cut 2 onto
   the moved #698 head (no GitHub base change).
Target stack: llm ← #774 ← #737 ← #541 ← #698 ← #700. No pushes to project
branches by this tick itself.

**Confinement:** no sturdyref behavior changed this tick. The invariants continue
to ride #774's four confinement tests (no-location, no-identification/unlinkability,
withheld-from-compartments, first-wins convergence) and #737's opacity coverage at
head `09130626` (its 06:37Z comment reports the targeted suites green). Each child
job body makes keeping the confinement tests green load-bearing, with
command+output evidence required.

**Next driver:** watch `jobs/orch/endo-sturdyref-restack-541-698-700-pr737-line`
progress; if a child fails (halt policy) surface it. Do NOT nudge on the old
omnibus trigger — superseded. Remaining maintainer-side asks (not driver-actionable):
re-reviews of #695/#697/#539. After the restack completes, the next unblocked cut
is the agent provide/accept surface (finish-line bar 2), gated on design #695's
re-review.
