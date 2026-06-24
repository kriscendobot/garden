---
ts: 2026-05-21T05:48:02Z
kind: result
role: weaver
project: endo-but-for-bots
worktree: dispatches/weaver--333228/project
repo: endojs/endo-but-for-bots
---

# Result: weaver 7d7d5e — merge actual/master into llm

Per kriskowal's 2026-05-21T05:23:13Z request on closed PR #109 (upstream endojs/endo#3256 syrup-frame+OCapN MERGED): merged `endo-upstream/master` into `origin/llm` on `endojs/endo-but-for-bots`. The new master tip carries #3256 plus other upstream advances since the last sync (Node 18/20 CI drop, module-source AST diagnostics fix, compartment-mapper no-name diagnostic, marshal rank-cover-ops refactor, composite tsconfig generation).

## Heads

- Pre-merge `origin/llm`: `01f982e49` (feat(turbo): test depends on transitive ^build, #240)
- Pre-merge `endo-upstream/master`: `bf951df34` (feat(syrup-frame): add @endo/syrup-frame package and opt-in syrup framing for OCapN TCP-for-testing, #3256)
- Merge commit: `b381e6ada` ("merge: actual/master into llm")
- Push: `01f982e49..b381e6ada  HEAD -> llm` (origin)

Divergence at start: llm 1029 ahead of master; master 61 ahead of llm.

## Conflict resolutions (by file)

Sixteen files entered conflict; nineteen others had their conflicts auto-resolved from rerere (recorded by the 2026-05-15 prior weaver merge to `merge/actual-master-into-llm-20260515`).

- **.github/workflows/ci.yml**: kept llm's pinned action SHAs and Node-version matrices ([20.x, 22.x, 24.x] for the test job, [20.x, 24.x] for cover/test262/viable-release; restored `${{ matrix.node-version }}` plumbing in the cover and viable-release jobs that the rerere auto-merge had silently dropped); adopted master's `persist-credentials: false` on every actions/checkout step; kept both new lint steps (Check SECURITY.md uniformity from llm, Check composite tsconfig files are up to date from master); kept llm's dorny/paths-filter v3 SHA; took master's newer actions/cache v5.0.5 over llm's v5.0.3 for the XS binary cache. Dropped the redundant async-hooks `# '20.6'` comment that llm added (duplicated a comment already two lines below).
- **.github/workflows/{browser-test,depcheck,release,typedoc-gh-pages,update-action-pins,update-action-pins-major}.yml**: same pattern. `persist-credentials: false` and zizmor-ignore comment from master; pinned SHAs and node-version preferences from llm; kept llm's actions/configure-pages v6 for typedoc-gh-pages (newer than master's v4); kept llm's changesets/action SHA for release.yml.
- **CONTRIBUTING.md**: kept both new sections (llm's "Mermaid Diagrams" and master's "TypeScript declarations").
- **package.json**: kept llm's curated `eslint-config-prettier: ^10.1.8`, `eslint-plugin-import: ^2.31.0`, `eslint-plugin-jsdoc: ^62.5.5`, and added `eslint-import-resolver-exports`; kept llm's `build:wasm` script and added master's five new `build:types*` scripts. Did **not** adopt master's `eslint-plugin-import: catalog:dev` (which would route through llm's `eslint-plugin-import-x` soft-fork alias and is a deliberate llm divergence with its own security-pinning rationale in `.yarnrc.yml`).
- **packages/bytes/SECURITY.md**: trivial "Github" → "GitHub" capitalization (took master).
- **packages/marshal/test/rankOrder.test.js**: master's API refactor (#3265) reorders `unionRankCovers` / `intersectRankCovers` / `getIndexCover` to (covers/sorted, compare?) with compare defaulting to `compareRankRemotablesTied`. Master's signature-checking tests match the current source; llm's six tests were written against the older (compare, covers) signature and would no longer compile against the merged source. Dropped llm's six redundant tests, kept master's signature tests, preserved llm's two `coveredEntries` iterator tests (separate function, stable signature). Imports: union of both sides plus `compareRankRemotablesTied`.
- **packages/module-source/tsconfig.json**: adopted master's narrowed-include pattern (`src/*.js` not `src`, per upstream #3271 "remove too-broad includes from default tsconfig"), keeping llm's `*.ts` extension and adding `src/*.ts`.
- **packages/ocapn/package.json**: added master's new `@endo/syrup-frame: workspace:^` dependency.
- **packages/ocapn/src/netlayers/tcp-test-only.js**: combined master's syrup-framing deframer branch with llm's `@types/node` v25 `Buffer` cast on the socket data handler; imports include both `Logger` (from master) and `SelfIdentity` (from llm).
- **packages/ocapn/test/python-test-suite/index.js**: master added a separate `makeTcpNetLayer` registration with `framing: 'none'` but referenced an undefined `client` variable (a stale rename from master's `makeOcapn` → `makeClient` refactor that did not land here). Moved the `framing: 'none'` option onto the already-active netlayer in `makeOcapn`'s `network` factory, which is the actually-used netlayer in this Python interop harness.
- **packages/ocapn/test/codecs/operations.test.js**: dropped a duplicate `const hexToImmutableBuffer` declaration that git's textual merge accepted from both sides because both adjacent definitions were identical (silent merge bug; would have crashed the test at load time with `SyntaxError: Identifier 'hexToImmutableBuffer' has already been declared`).
- **yarn.lock**: regenerated via `yarn install` against the merged package.json files (75 conflict markers cleared). Pre-existing peer-dep warning about `eslint-plugin-import` vs `eslint-config-airbnb-base` carries over unchanged.

## Validation

- All staged files: syntax-checked (`node --check` for JS, `python3 yaml.safe_load` for YAML, `json.load` for JSON). All pass.
- `yarn workspace @endo/marshal run test`: 82 passed, 1 skipped, 0 failed. All seven new `rankOrder` signature tests pass on the merged source.
- `yarn workspace @endo/ocapn run test`: 531 passed, 1 uncaught exception (the new `netlayer-tcp-syrup.test.js`, see below).

## Known regression surfaced for the dispatcher (out of weaver scope)

`packages/ocapn/test/netlayer-tcp-syrup.test.js` is a new test file from master that imports `makeClient` from `../src/client/index.js` and calls `client.registerNetlayer(...)`. llm's `client/index.js` still exports the older `makeOcapn` API and has no `registerNetlayer` surface (the rename and reshape happened on master in a commit that did not land in llm). The test file is preserved verbatim from master so the upstream contribution is not silently dropped, but it will fail at module load until a builder/fixer ports master's `makeClient` / `registerNetlayer` rewrite into the bot estate. This is the same gap that surfaced in `python-test-suite/index.js` (handled inline above by moving the `framing: 'none'` to the active netlayer).

Recommended follow-up: dispatch a builder against `endojs/endo-but-for-bots@llm` to port the master `makeClient` API (including `registerNetlayer`), then re-run `yarn workspace @endo/ocapn run test` to confirm the syrup-framing test passes end-to-end.

Self-improvement: nothing this time. The prior weaver's merge of 2026-05-15 left useful rerere preimages that pre-resolved nineteen of this merge's textual conflicts; the only structural ones requiring fresh judgment were the master API/test divergence (which is properly out of weaver scope, surfaced for the dispatcher) and the rerere's silent over-application on the cover/viable-release jobs (which the weaver's "trust no conflict that looks trivial" norm caught on inspection).
