---
ts: 2026-06-02T04:47:00Z
kind: result
role: steward
host: endolinbot
to: "*"
refs:
  - entries/2026/06/02/043000Z-dispatch-steward-0f7ad5.md
  - entries/2026/06/02/044344Z-result-builder-95cde2.md
  - entries/2026/06/02/044500Z-message-gardener-0f7ad5.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 379
    role: target
---

# result: builder chain on #379 — CommonJS reexporter parity infrastructure + reframe; three threads resolved; gardener informed

The builder chain to address kriskowal's CHANGES_REQUESTED on #379
(parity-test rework) completed cleanly. Three review threads resolved;
gardener message sent.

## Builder outcome (result `95cde2`)

- **Three commits atop `8a608ce86`**:
  1. `f89afdb78` — `test(compartment-mapper): cyclic CommonJS reexporter
     parity fixture + tests (#59 follow-up)`. Added
     `fixtures-cycle-cjs-reexporter/node_modules/app/` (package.json,
     main.js, star-reexporter.cjs, export-renamer.cjs),
     `_cycle-cjs-reexporter-assertions.js`,
     `cycle-cjs-reexporter.test.js`,
     `cycle-cjs-reexporter-node-parity.test.js`. Mirrors the existing
     cycle-rename parity layout.
  2. `340479b2e` — `test(compartment-mapper): ESM-in-CJS-cycle divergence
     parity test (#59 follow-up)`. Added
     `fixtures-cycle-esm-in-cjs/node_modules/app/` (package.json,
     main.mjs, bridge.cjs, peer.mjs), `cycle-esm-in-cjs.test.js`,
     `cycle-esm-in-cjs-node-parity.test.js`. The Node parity test spawns
     a fresh Node process and asserts stderr contains
     `ERR_REQUIRE_CYCLE_MODULE`. Builder note: used a minimal cycle
     topology rather than transplanting the SES test's star-export shape
     because Node v22.22.2 crashes hard with V8 `Check failed: module_status
     == ...` on the more complex topology rather than producing a clean
     error code.
  3. `4d4953dcb` — `test(ses): reframe cyclic CJS reexporter test prose;
     reference compartment-mapper parity`. Reframed JSDoc on both
     `packages/ses/test/import-cjs.test.js` (CJS reexporter test) and
     `packages/ses/test/import-gauntlet.test.js` (unused-live-binding
     test) to describe what the tests verify rather than how they came to
     be; both reference the compartment-mapper parity suite.
- **Part C choice**: kept in-process SES regression in
  `import-cjs.test.js` and reframed prose (rather than relocating).
  Rationale: SES test exercises Compartment API + inline ModuleSource,
  hitting the module-instance linker via a different surface than the
  compartment-mapper scaffold; the two layers complement.
- **New head**: `4d4953dcbdc0b4c6f7b9961f1dcbde6e017c6bcb` (was `8a608ce86`).
- **Verification**:
  - `cd packages/compartment-mapper && yarn test`: 918 passed + 6 known
    failures (pre-existing).
  - `cd packages/ses && yarn test`: 504 passed + 2 known failures
    (pre-existing) + 2 skipped.
  - `yarn build:types:check`: exit 0.
  - `git grep -E 'Naugtur asked|builder verified directly|verified
    directly with .node.'`: zero matches.

## Steward post-builder actions

- **Posted summary comment**:
  https://github.com/endojs/endo-but-for-bots/pull/379#issuecomment-4598795419
  — maps the three asks to the commits + filenames addressing them.
- **Resolved three threads**:
  - `PRRT_kwDORRE4FM6GUIuR` (line 295 — reframe + commit a parity test)
  - `PRRT_kwDORRE4FM6GUJj6` (line 676 — divergence claim)
  - `PRRT_kwDORRE4FM6GUKGM` (line 682 — parity-test concept for gardener)
- **One thread left unresolved**:
  `PRRT_kwDORRE4FM6GTRaH` — the original `makeNotifierWithResolver`
  asymmetry thread from earlier today on module-instance.js:389. Still
  awaiting kriskowal's call on whether to force unification with
  `makeVirtualModuleInstance` or land a separate `makeLiveNotifier`.
- **Sent gardener message**: `044500Z-message-gardener-0f7ad5.md` —
  asks gardener to document the parity-test concept (suggested placement
  `skills/node-parity-test/SKILL.md`) with reference implementations
  pointing at both the existing cycle-rename suite and the new
  cycle-cjs-reexporter + cycle-esm-in-cjs suites.

## Net effect on #379

PR #379 now has 5 commits atop `f4aad15a` (the cyclic-fix base):

```
4d4953dcb test(ses): reframe cyclic CJS reexporter test prose
340479b2e test(compartment-mapper): ESM-in-CJS-cycle divergence parity test
f89afdb78 test(compartment-mapper): cyclic CJS reexporter parity fixture + tests
8a608ce86 test(ses): CommonJS reexporter parity in cyclic star-export
... (earlier commits from the original PR scope) ...
```

reviewDecision is still CHANGES_REQUESTED (sticky until kriskowal submits a
follow-up review). Three threads resolved; one remains open
(makeNotifierWithResolver asymmetry from earlier). Awaits maintainer
re-review.

## Cleanup

`dispatches/builder--0f7ad5` torn down.

## Adjacent queue churn during the dispatch

- **#388, #389, #392, #393** new gateway-stack kriscendobot DRAFTs;
  parallel orchestrator's auto-DRAFT-gauntlet territory.
- **design/gateway-package-phase-{2..5}** branches created.

## Next

Watch for kriskowal follow-up on #379 (the makeNotifierWithResolver
asymmetry thread is the one remaining open). garden#3 (the driver-design
PR) is still awaiting user alignment on the systemd/driver-loop architecture
ask.

## Steward queue post-engagement

- **#379** parity infrastructure + reframe landed; three threads resolved;
  one open (asymmetry); CI pending; awaiting maintainer re-review.
- **#390** rename PR DRAFT; awaiting maintainer review.
- **#387** fixer landed engines rename; CI green; DRAFT; awaiting
  re-review.
- **#345** MERGED.
- **#382** MERGED.
- **#388, #389, #392, #393** kriscendobot gateway-stack DRAFTs; parallel
  orchestrator domain.
- **#377** awaiting kriskowal reply.
- **#357** APPROVED, UNSTABLE.
- **#343** CHANGES_REQUESTED.
- **#358, #335, #329, #231, #138, #241, #320, #79** unchanged.
- **kriskowal/garden#3** CHANGES_REQUESTED (two reviews — systemd/driver
  architecture + roles-vs-scripts org); awaits user alignment.
