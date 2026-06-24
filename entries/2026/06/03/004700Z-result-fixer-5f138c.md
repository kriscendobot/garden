---
ts: 2026-06-03T00:47:00Z
kind: result
role: fixer
project: endo
repo: endojs/endo-but-for-bots
---

UDS→sock rename on #388 plus stack-wide rebase #389..#397.

## Part A: #388 addressing commit

- SHA `741890f1d` (force-pushed onto design/gateway-package-phase-2).
- Title: `refactor(gateway): rename UDS to sock terminology; drop Windows named-pipe scope (#388)`.
- Renames the file `src/uds-paths.js` → `src/sock-paths.js` (and its test), the toggle `udsBootstrap` → `sockBootstrap`, every UDS prose / comment reference to "sock", and drops the entire Windows named-pipe code path (per kriskowal's Linux/Mac scope directive on #389).
- Dropped exports: `BOOTSTRAP_PIPE_WINDOWS` constant.
- Dropped `BootstrapPathResolution.kind` value `'windows-named-pipe'` (now always `'unix-socket'`).
- Dropped `BootstrapPathResolution.source` value `'windows'`.
- Dropped the `if (platform === 'win32')` branch from `resolveBootstrapSocketPath`.
- Removed two Windows-only tests from `sock-paths.test.js` (named-pipe resolution + Windows-override kind); gateway test count went from 127 → 125. All 125 remaining tests pass; `yarn lint:types` clean.
- Top-level summary comment on PR #388: https://github.com/endojs/endo-but-for-bots/pull/388#issuecomment-4608052027.

## Part B: stack rebases (lower-first, force-pushed with --force-with-lease)

| PR  | branch                              | old head      | new head      | notes |
| --- | ----------------------------------- | ------------- | ------------- | ----- |
| #388 | design/gateway-package-phase-2     | f3de0d0fa     | 741890f1d     | rename commit |
| #389 | design/gateway-package-phase-3     | 4190e0195     | cdaf627568    | conflicts in `README.md`, `index.js`, `bootstrap.js`. Propagated `listRegistrations` → `listRegisteredPeers` through admin backplane wiring (phase 2's sibling fixer renamed it; phase 3 was written against the pre-rename name). Admin's CapTP-facing `GatewayAdmin.listRegistrations()` method kept (phase-3-added public API). |
| #392 | design/gateway-package-phase-4     | 1293362b3     | d2a276a464    | conflicts in `README.md`, `index.js`. Two-commit branch (feature + yarn.lock). `@endo/stream` added as gateway dependency; required `yarn install` re-run. |
| #393 | design/gateway-package-phase-5     | 51bbd5a3b     | b988a2650e    | conflicts in `README.md`, `bootstrap.js`. Propagated `listRegistrations` → `listRegisteredPeers` in phase-5's new tests. |
| #394 | design/gateway-package-phase-6     | c29678f5f     | 72d425f710    | conflicts in `index.js`. Four-commit branch (feature + yarn.lock + cleanup + review carry). |
| #395 | design/gateway-package-phase-7     | cf750f5ac     | 96708da1ba    | conflicts in `README.md` (two sections). |
| #396 | design/gateway-package-phase-8     | 20d34d55e     | ac68f08116    | conflicts in `index.js` (the new ledger-construction block). |
| #397 | design/gateway-package-phase-9     | ccaceaaa9     | 3cc7e50511    | conflicts in `src/config.js`, `test/ocapn-ws.test.js`, `test/git-http.test.js`. Used `sed` to mass-rename remaining `udsBootstrap: <bool>` in `gateway.test.js`. |

Each layer's tests + typecheck were green before push: 125, 151, 169, 235, 273, 315, 357, 391 tests passed respectively (cumulative; each phase adds its tests).

## CI status

CI is running on all 8 PRs. The pre-existing failures (`test/netlayer-tcp-syrup.test.js` exit-code-1 on every test job, and a `makeClient not found` lint error in `packages/<other>`) are unrelated to the rename and were present on the branches before this dispatch. No new failures introduced by the rename.

## Items NOT addressed (per dispatch scope)

- #389 separate-admin-socket feedback — next layer's fixer.
- #393 Uint8Array / `types.d.ts` sweep — next layer's fixer + cross-PR sweep.
- #392 hack acknowledgment — may need designer.
- #394 per-comment items — next layer's fixer.
- #343 CLI / systemd follow-up — separate substantial PR.

## Cross-cutting observation

Several PRs above #388 (specifically #392 with `@endo/stream` and #394 with `@endo/base64`, and #393 with `@endo/marshal` indirectly) add new workspace dependencies. The rebase needs a `yarn install` per phase after the new `package.json` lands so the tests under `packages/gateway/` resolve correctly. The fixer's `yarn install` between phases is mechanical and not worth a skill of its own.

Self-improvement: a "stack-wide rename" rebase has a predictable cross-PR shape (the rename in the base PR creates conflicts in every successor; resolution is mostly "keep the rename's wording while preserving the successor's new content"). The `git rerere` mechanism kicked in helpfully (each successive rebase auto-resolved file pairs the earlier rebase already touched). A future stack-rebase dispatch should be told to `git config rerere.enabled true` at the start of its work to make this an explicit, rather than implicit, optimization. Routed as a `message` to liaison rather than a skill change because the configuration is one git command and does not warrant a `SKILL.md`.
