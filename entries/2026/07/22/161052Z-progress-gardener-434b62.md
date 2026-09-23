---
kind: progress
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-22T16:10:53Z
---
# SturdyRef press — 16:05 dispatch tick: #541/#698/#700 restack COMPLETE; cuts 3–6 cascade posted

**The 13:53 tick's restack orchestration finished.** All three children of
`endo-sturdyref-restack-541-698-700-pr737-line` completed (serial, all succeeded;
orch tada `orchestration-status: complete`):
- #541 → head `379cc837`, base changed to `build/sturdyref-pass-style-ocapn-single`,
  reconciled to the shared opaque `@endo/sturdyref` minting; focused shim/pass-style/
  marshal/OCapN/daemon-confinement suites green (daemon retention integration blocked:
  better-sqlite3 native binding absent in that env).
- #698 → head `6a03f5a3`; one-symbol reconcile (`getSturdyRefDetails`→`getSturdyRefLocator`);
  passable.test.js 85 passed incl. the confinement sweep; sturdyref/descriptors/
  components/subtypes/operations/fuzz all green (weaver-reported, command+output in tada).
- #700 → head `0a2d9899`; cut-2 re-expressed on the `@endo/sturdyref` shim
  (`fromLocation`/`toLocation`, per-tracker `ownRefs` WeakSet, `reveal` →
  `SturdyRefLocator|undefined`); 17 sturdyref/uri tests incl. closely-held-reveal
  confinement surface, full @endo/ocapn 546 passed, goblin-chat 4 passed.

**Verified live this tick** (`gh pr view/list`, `gh api compare`): stack is now
llm ← #774 `59bd235e` ← #737 `09130626` ← #541 ← #698 ← #700 as arbitrated. But
bridge cuts 3–6 (#701 `15c7e516`, #702 `cb2b599d`, #703 `a67769b0`, #704 `36949cad`)
were NOT in that orchestration and are stale: compare shows bridge-3 vs restacked
bridge-2 `diverged, behind_by 426`; the old 701→704 internal links remain intact
(`ahead` only). No live sturdyref peer (`inbox-list.sh`), no competing board job,
my inbox empty. #737's CHANGES_REQUESTED is stale (inline comments addressed 07-17
`b56b3465`; 07-22 arbitration executed 06:37Z) — awaits maintainer re-review, as do
#695/#697/#539.

**Action this tick:** posted the cascade — orchestration
`endo-sturdyref-restack-701-704-pr737-line` (serial, halt-on-failure) over four
parked weaver children `endojs-endo-but-for-bots-pr70{1,2,3,4}-restack-pr737-line`,
each rebasing onto its moved predecessor with reconciliation toward the arbitrated
shapes (`@endo/sturdyref` shim home, `getSturdyRefLocator`, camelCase `sturdyRef`,
prefix `l`) and the confinement suites load-bearing. Target stack: … ← #700 ← #701
← #702 ← #703 ← #704. No pushes to project branches by this tick itself.

**Confinement:** no sturdyref behavior changed this tick (board/orchestration work
only). The invariants ride #774's four confinement tests, #737's opacity coverage,
and the restacked #698/#700 heads whose weavers re-ran the confinement suites green
(no-location: locator only via closely-held mapping; no toString URI leak;
unlinkability; opaque SturdyRef surface). Each new child job body makes keeping
those suites green load-bearing with command+output evidence required.

**Next driver:** watch `jobs/orch/endo-sturdyref-restack-701-704-pr737-line`; on a
child failure (halt policy) surface it. After cuts 3–6 land, the next unblocked
artifact is the agent provide/accept surface (finish-line bar 2) — its design #695
still awaits maintainer re-review (as do #697/#539, and #737 re-review). Those
re-reviews are maintainer-side; do not re-nudge (the 07-21 omnibus already asked).
