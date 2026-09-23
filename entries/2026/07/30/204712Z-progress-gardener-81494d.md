---
kind: progress
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-30T20:47:14Z
---
SturdyRef press tick endo-sturdyref-press-20260730-082002 — observe-and-verify; no code pushed. The effort's single blocker is unmoved, so I spent this tick gathering real-execution confinement evidence rather than re-escalating (two unanswered escalations already sit in the maintainer's unread inbox from today at 04:30Z and 07:21Z).

State re-verified live via gh pr view --json at ~20:43Z (2026-07-30):
- Bar-2 canonical PR endojs/endo-but-for-bots#871 (agent provide/accept surface): OPEN draft, MERGEABLE, 21/21 statusCheckRollup SUCCESS, zero reviews, zero comments, head c3fa894c9 unchanged since 07-26 (kriscendobot fork; the endojs-side cf9c795a orphan is distinct and quiet).
- Full stack unmoved since 07-25/26: #774 59bd235e2 / #737 49ed6026a / #541 fd60a74b0 / #698 c19fdd96c / #700 e0122dfd7 / #701 a99012a62 / #702 137673219 / #703 bb3906aad / #704 e32b01f2a; designs #511/#539 open drafts. All CI rollups SUCCESS.
- jobs/plan/endo-sturdyref-agent-surface-build-gauntlet still parked behind gate: go-ahead, poisoned: true (deadline-overrun). No maintainer word on the bus or GitHub.

Local real-execution verification (isolated project worktree at the #871 kriscendobot-fork head c3fa894c9, warm-cache deps, node ava CLI):
- packages/agent-tools/test/sturdyref-escrow.test.js: 3 tests passed. Confirms the escrow renders a fresh opaque handle per grant, two grants are unlinkable (t.not(first.ref, second.ref)), a forged handle is rejected before a tool receives it, and plain text is untouched.
- packages/daemon/test/agent-sturdyref-surface.test.js: 3 tests passed. Confirms confinement: only lookup/maybeLookup/list admit a sturdyref; a sturdyref cannot request identify/locate/listIdentifiers/listLocators; evaluation endowment slots admit a sturdyref but the worker naming slot and result-name slot do not.
- packages/daemon/test/*sturdyref*.test.js + foreign-sturdyref + known-sturdyrefs-store + sturdyref-resolution + sturdyref-store: 32 tests passed. Includes the no-secret / opaque-and-unforgeable / no-locator / unlinkable-grant confinement tests across the daemon read-side and store.
- packages/ocapn/test/sturdyref*.test.js and handoff-sturdyref-contrast.test.js: NOT verified locally. They fail to load in this warm-cache tree with ReferenceError: assert is not defined (a transitive @endo/eventual-send import resolves before the SES assert global installs); CI is 21/21 green on these, so this is a local runner/module-load ordering gap, not a regression. No code was changed.

Confinement property preserved this tick: no behavior changed. The no-location (enlivenment mediated by the closely-held OCapN network capability per design #539), no-identification (unlinkable per-grant mints, verified: two renders of one sturdyref produce distinct handles), and opaque-and-unforgeable (forged handles rejected; secrets not reachable on grant handles) properties are now re-verified by real-execution of the agent-tools and daemon sturdyref test suites at the #871 head, not just by CI inspection.

Follow-ups for the next driver:
- The maintainer has two unread escalation messages from today (04:30Z, 07:21Z) asking to reset/promote the gauntlet or name a different next cut. Do not send a third; wait for a reply. If still no reply by ~2026-08-01T07:21Z (72h past the latest escalation), re-escalate then.
- If the gauntlet promotes out of plan/, the claiming gardener runs the panel; observe without colliding.
- The ocapn-package sturdyref tests' local-load failure (assert global ordering) is an environment gap worth a local-verify note, not a code fix on this branch.
