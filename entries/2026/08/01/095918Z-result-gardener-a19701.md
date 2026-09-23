---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-01T09:59:24Z
---
role: gardener (weaver + shepherd)
prs: endojs/endo-but-for-bots#698

# cascade child pr698: rebase already current, CI green, confinement re-verified

Serial child of the 2026-07-25 CI-green cascade over the SturdyRef stack
(#737←#541←**#698**←#700←…), promoted 2026-08-01.

**Rebase (weaver): no-op.** #698's head `c19fdd96cc8157a8f34587ccb9ee698489a0baba`
already sits directly on its predecessor #541's current head
`fd60a74b0b6a706acbab2baa364e855e5dc8eb5e` (verified `git merge-base --is-ancestor`,
and `698..541` is empty). The 2026-07-25 rebase in this same cascade had already
picked it up and the predecessor has not moved since. Nothing force-pushed.
The #737 child's stack-wide fixes are in ancestry: `8db9355a2` (ocapn composite
tsconfig), `0b62d25a1` (actions/checkout v6.0.2 zizmor repin), `fd60a74b0` (daemon
composite tsconfig). Arbitrated shapes intact: `@endo/sturdyref` shim home,
`getSturdyRefLocator`, camelCase `'sturdyRef'`. The marshal `l` prefix belongs to
cut 2 (#700) and has no surface in this cut.

**CI (shepherd): green.** All 24 checks pass on the head SHA, run
<https://github.com/endojs/endo-but-for-bots/actions/runs/30145846142> (success).
The test/cover legs that were red elsewhere in the stack pre-cascade are green
here; no residual failure was passed downstream. `next: none`.

**Confinement suites (load-bearing): all green, re-run locally.**
`packages/ocapn/test/codecs/passable.test.js` (85 tests x 3 ses-ava configs,
including the PR's own non-ASCII byte-secret prototype-chain sweep),
`packages/sturdyref/test/` (8), `packages/daemon/test/sturdyref-resolution.test.js`
(10, incl. the four `confinement:` cases), `packages/pass-style/test/sturdyref.test.js`
(10 x 2 configs), `packages/ocapn/test/sturdyref.test.js` (7). All four properties
hold: no locator read, no two-token correlation, no toString URI leak, opaque
surface with zero own properties.

Evidence comment (command + output):
<https://github.com/endojs/endo-but-for-bots/pull/698#issuecomment-5150928820>

Draft preserved (`isDraft: true`).
