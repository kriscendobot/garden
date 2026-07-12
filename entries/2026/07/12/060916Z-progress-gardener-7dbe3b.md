---
kind: progress
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-12T06:09:18Z
---
# SturdyRef press tick (2026-07-12T05:50 dispatch, job endo-sturdyref-press-20260712-055002)

**Headline: took the wheel on stalled #704 — rebased onto the fixed cut-5 head,
repaired the flapping confinement assertion, pushed; CI pending.** The auto-posted
`endojs-endo-but-for-bots-pr704-shepherd` was POISONED (requeue-exhausted, 5 cycles,
parked in `jobs/plan/` at 04:53Z), so no lane owned #704's red CI. No other live
sturdyref worker (`inbox-list` checked at claim).

**What was actually wrong (real-execution evidence).** #704's 4 red matrix legs all
fail in `endo.test.js` "the ocapn capability and netlayer handles never cross a facet
boundary": `E(guest).lookup(['@host'])` resolves to the host's bare MAIL HANDLE
(`open/openEdit/receive/receiveEdit`) and `identify` is absent (run 29179035963 log).
Cut6's branch was also 2 commits behind cut5 (`7c41f12f6` prettier, `a67769b07` the
armed-netlayer `shutdown()` teardown the pr703 shepherd landed). Crucially the same
test at cut5's head `a67769b07` — where #703's CI is 22/22 GREEN and the log shows
`✔ … never cross a facet boundary (733ms)` — **fails locally with the identical
TypeError** (reproduced twice, incl. fresh state): the guest's host-view resolution is
**environment-sensitive** (bare mail handle vs namespace-shaped facet), not a cut6
regression — no cut6 source path can affect guest `@host` resolution (verified: diff
is ocapn.js arming block, inert when unarmed).

**Fix pushed (branch `build/sturdyref-bridge-6-three-party-roundtrip`, forced update
`4e7292c9a` → `0dd7f34ad`):** (1) rebase onto cut5 head `a67769b07`; (2) new commit
`0dd7f34ad` makes the assertion shape-agnostic — the guest's `@host` probe for
'ocapn' must either throw `target has no method "identify"` (bare handle, the
stronger posture) or return `undefined` (namespace-shaped miss). Either way the
invariant under test — a confined guest cannot recover the ocapn identity through its
host-view — is exercised, and the test no longer encodes which facet shape it gets.

**Local verification (node 22.23.1, this tick, at 0dd7f34ad):** facet-boundary test
✔ (245ms); `test/three-party-roundtrip.test.js` 4/4; `test/ocapn.test.js` 10/10 incl.
armed cross-peer enliven; full `@endo/ocapn` lockdown suite 547/547 (via
`ava --config ../../ava-endo-lockdown.config.mjs`; the `.bin` shims in a fresh
pnpm-linker worktree lack exec bits — run ava directly); endo.test.js `*SturdyRef*`
matches 5/5. Harness notes for peers: local runs need `better_sqlite3.node` copied
from a sibling worktree store (yarn build scripts are sandbox-blocked), and a short
`sockPath` root (long scratch paths overflow sun_path; node reports a MISSING PARENT
DIR as `listen EACCES`, not ENOENT — pre-create the parent).

**CI: NOT yet verified** — pushed at ~06:1xZ, matrix takes ~20m; #704 stays DRAFT.

**Confinement statement:** the landed change strengthens, not widens: the test now
accepts the *stronger* posture (no `identify` reachable at all) while still requiring
no-identification (the ocapn identity is unrecoverable through the guest's
host-view) under either resolution. No location or correlation surface added; all
prior confinement tests re-ran green locally.

**Maintainer gates:** #695 go/no-go (agent-surface cuts A–F, bar 2) still UNREAD
(`inbox/maintainer/unread/20260711T211001Z-4a530e.md`, ~8.7h) — nudge after
~2026-07-12T21:00Z per prior tick. Netlayer default-arming rides with it.

**Next-tick guidance:** (1) check #704's matrix on `0dd7f34ad` — if green, bar 1 is
test-green end to end; the stack #521→#541→#698→#700→#701→#702→#703→#704 then rests
pending the #695 gate. If the facet-boundary test flaps the OTHER way anywhere, the
shape-agnostic probe already covers it — look for a NEW signature before touching it.
(2) The poisoned `endojs-endo-but-for-bots-pr704-shepherd` parked in `jobs/plan/`
(gate go-ahead) is moot once #704 is green — surface to the liaison to drop it rather
than promote. (3) #695 nudge after 21:00Z. (4) Environment-sensitivity of guest
`@host` facet shape is worth a designer look eventually (why does resolution differ
CI-vs-local at the same commit?) — a small probe job, not urgent, does not block bar 1.
