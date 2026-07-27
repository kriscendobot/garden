# Press report — npm-via-CAS registry proxy (tick 2026-07-27, 11:35Z)

## Assessment

All five design phases remain merged at `llm` HEAD `7f8c08d74f` (last tick landed #862 on kriskowal's approval). No new maintainer reviews or approvals arrived on the four held gap drafts (#857 peer/optional deps, #859 process shim, #860 npmrc auth, #873 workspace protocol) — all still green, MERGEABLE, draft, awaiting promotion. The bundler-generators reproducibility gap still rides PR #600 (xs2rust arc, active yesterday); not duplicated here. No live peer held any shared branch; inbox empty at both checkpoints.

## What I did — probed for the next gap class and closed one: PR #875

Re-established the finish line at HEAD first (built `endor` from `7f8c08d74f`; cold isolated state under `/tmp`): `endor run entry.js` with `semver: ^7.5.4` fetched `semver@7.8.5` from registry.npmjs.org into the CAS (`28e493d4b3…`), executed in XS with correct output, and replayed green under `--offline`.

Then ran three fresh real-package probes, which surfaced three distinct failure classes:

1. **chalk@5.6.2** — failed at link time: the archive runtime had **no package `imports` field (`#`-specifier) support** at all. Squarely npm-proxy domain, uncovered by any draft → **fixed this tick**.
2. **nanoid@5** — `import webcrypto not found`: its node build imports `node:crypto` (core builtins unavailable by design; a browser-condition/webcrypto policy question, recorded, not pressed).
3. **@sindresorhus/is** — `get Intl: undefined variable`: `Intl` missing from the XS compartment globals (engine surface, belongs to the xs2rust arc).

**The fix (draft PR https://github.com/endojs/endo-but-for-bots/pull/875, branch `feat/endor-npm-imports-field`, commit `909de10137`):** Node-semantics subpath-imports resolution in the archive runtime — `__resolveImports` sharing the exports matching core (factored out as `__matchSubpathMap`), wired into both ESM load hooks (import-conditions-first; in-package targets load under their canonical key so their own relative imports resolve correctly; bare targets route through the link map) and CJS `require` (require-conditions-first). Unlisted/blocked specifiers fail cleanly, never falling back to files. Six new tests; **`cargo test -p endo` 179/179 green** (single-threaded; the one parallel flake is the pre-existing global quiesce flag that draft #864 fixes). **Real-execution evidence:** the chalk probe now prints `chalk says green-text` online and `--offline` — and chalk's conditional `#supports-color` proves the condition ordering for real (its `node` build touches unavailable builtins; resolution lands on the `default` browser build). Design doc's Known gaps list updated in the same commit. Kept draft per the arc's discipline.

## Follow-ups for the next tick

- Five gap drafts now held for maintainer promotion: #857, #859, #860, #873, and new **#875** — watch for approvals and land on the #862 pattern (verify on the exact merged tree, merge, provenance comment).
- Recorded probe findings not pressed: nanoid's `node:crypto`/webcrypto (builtin-shim or browser-condition policy — worth a design note before code) and missing `Intl` in XS compartments (engine arc's surface).
- Build-from-fresh-checkout still needs the #600 generators (this tick reused the 05:35Z worktree's generated `ses_boot.js`/`worker_bootstrap.js`/`daemon_bootstrap.js`).
