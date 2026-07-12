---
kind: progress
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-12T04:47:56Z
---
# SturdyRef press tick (2026-07-12T04:35 dispatch, job endo-sturdyref-press-20260712-043505)

**Headline: the bridge orchestration COMPLETED — bar 1 is artifact-complete.** All six
children of `ebfb-orch-sturdyref-bridge-cuts` reached `tada/` (record now reads
`orchestration-status: complete`, "All children succeeded"). Cut 6 delivered stacked
DRAFT PR **endojs/endo-but-for-bots#704** (`build/sturdyref-bridge-6-three-party-roundtrip`
@ `4e7292c9a9`, base cut 5): three-party round-trip over real `tcp-test-only` netlayers with
the daemon rotating through A/B/C, daemon-side netlayer arming with dialable self peer-locator,
`shutdown()`, plus the live-handoff contrast test. Stack verified this tick:
endojs/endo-but-for-bots#521 → #541 → #698 → #700 → #701 → #702 → #703 → #704, all OPEN+DRAFT.

**Independent bar-1 verification (real execution, this tick, node 22.23.1 linux, #704 head):**
`packages/daemon: yarn test test/three-party-roundtrip.test.js` → **4/4 pass** (daemon as
A/B/C each with "no A-C traffic, a fresh B-C session", plus dedup/re-dial);
`yarn ava test/ocapn.test.js` → **10/10 pass** (mint, formatUri/materializeFromUri
`ocapn://` round-trips, persistent identity, unarmed-cannot-dial, armed cross-peer enliven);
`packages/ocapn: yarn test test/handoff-sturdyref-contrast.test.js` → **1/1 pass**
(handoff → sturdy-ref upgrade, never the reverse). Harness note: ocapn tests MUST run via
`yarn test` (ses-ava lockdown config); plain `yarn ava` false-fails with
`assert is not defined`.

**CI: 4 test-matrix legs red on both #703 and #704 — DIAGNOSED this tick, deterministic
test bug, not infra.** `endo.test.js` "the ocapn capability and netlayer handles never
cross a facet boundary" (cut 5's confinement test) fails at line 3026:
`E(guest).lookup(['@host'])` resolves to the host's MAIL HANDLE
(`open/openEdit/receive/receiveEdit`, `src/mail.js`), which has no `identify` — the test
assumed a namespace-shaped facet. Confinement itself holds MORE strongly than asserted
(the guest's host-view cannot even ask `identify`); the assertion, not the seam, is wrong.
Reproduced locally after sidestepping a sockaddr path-length artifact (long scratch
worktree paths overflow the ~104/108-char unix-socket limit → `ENOENT endo.sock`; point
`makeConfig` sockPath at a short dir to reach the real failure). **Diagnosis + suggested
one-line fix delivered to both live lane owners**
(`endojs-endo-but-for-bots-pr703-shepherd`, `…-pr704-shepherd`,
msgs 20260712T044700Z-b4fb14 / 20260712T044705Z-007144); the re-run they triggered at
~03:59Z will red again without it. Nothing pushed to project branches by this job
(collision rule: both lanes shepherd-owned; my worktree tweak was reverted uncommitted).

**Maintainer gates (verified this tick):** the endojs/endo-but-for-bots#695 go/no-go on
agent-surface cuts A–F (`inbox/maintainer/unread/20260711T211001Z-4a530e.md`) still
UNREAD (~7.6h; escalate past ~2026-07-12T21:00Z). #695/#697 PR comments still 0. Bar 2
(agents provide/accept throughout) remains gated. Netlayer default-arming remains the
tracked open question (cut 6 deliberately did not prejudge it).

**Confinement statement:** nothing landed this tick, so no surface widened. Independently
re-executed the standing binds: no-location (grant listing carries no
location/designator/transport/secret — cut 6 report; my runs confirm the `ocapn://` URI
codec round-trips without exposing foreign locators to guests) and no-identification
(dedup converges daemon-side; guest-side presence carries no correlatable identity —
three-party tests 4/4). The one red test is an over-strong-shape assertion, not a
confinement leak.

**Next-tick guidance:** (1) check whether the shepherds landed the endo.test.js:3026 fix
and the matrix went green on endojs/endo-but-for-bots#703/#704 — bar 1 can then be
declared test-green end to end (all PRs stay DRAFT per charter); (2) #695 gate — nudge
after ~2026-07-12T21:00Z if still unread; on GO, post the agent-surface cuts A–F as a
second serial orchestration (bar 2, the "throughout" surface: Lal/Fae/Genie +
@endo/agent-tools provide/accept); (3) netlayer default-arming question rides with the
#695 decision.
