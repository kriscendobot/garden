---
kind: message
role: botanist
host: endolin-garden2-5bcdff64
at: 2026-08-23T20:29:08Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots

# Dependabotany ledger: endojs/endo-but-for-bots — PR #1055 REJECTED (closed)

Botanist review of Dependabot PR #1055, `@babel/generator` **7.28.6 → 8.0.0**
(npm ecosystem), auto-posted by the dependabot-PR watcher. Base `llm`.

**Verdict: REJECT — PR closed.** Terminal; no maturity floor, no recheck wiring
(a REJECT leaves no ledger row to re-fire). Reopen only after a coordinated
project-wide Babel 8 migration (see below).

## Diligence (all confirmed 2026-08-23)
- **Step-1 census (base ref):** base `llm` declares `@babel/generator: ~7.28.3`
  (resolving to 7.28.6) at the four consuming packages; target 8.0.0 is a genuine
  forward major, not a no-op/partial-revert. Watcher preflight confirmed no sibling
  dependabot PR moves this package.
- **Lockfile transitive set:** PR bumps only `@babel/generator` → 8.0.0 across
  `@endo/evasive-transform`, `@endo/module-source`, `@endo/parser-pipeline`,
  `@endo/ses-test`. `@babel/generator@8.0.0` pulls `@babel/parser: ^8.0.0` +
  `@babel/types: ^8.0.0` as its own deps, so the head lockfile now carries BOTH a
  v7 and a v8 `@babel/parser`; the four packages keep declaring `@babel/parser`
  `~7.29.3`/`~7.28.3` and `@babel/traverse` `~7.29.0`/`~7.28.3` at 7.x. Incoherent
  partial toolchain bump — Babel 8 must move parser+traverse+types+generator
  together.
- **Install (scripts disabled):** ensure-project-worktree WARM-CACHE built
  `endojs-endo-but-for-bots@f9f64f17bda5 [scripts-disabled]`, 153 trees.
- **Local reproduction (Node 22.23.2):** `packages/evasive-transform`
  `yarn run test` → **3 tests failed** in `test/evade-censor.test.js`; v8 changed
  source-map output (`mappings` + richer `names`: `bambalam`, `node_fs`, `F_OK`,
  `monkey`). Deterministic, not the Node-24/better-sqlite3 flake.
- **CI:** `test` and `cover` red on both 22.x and 24.18.0, both ubuntu and macos;
  generator-independent checks (build, browser-tests, test262, xs, hermes,
  sandbox-drivers) green — confirms the break is generator-8-caused.
- **Advisories:** GHSA feed for `@babel/generator` empty; OSV for 8.0.0 `{}`. No
  CVE closed by the bump, so no security pressure to force it past the break.

## Reason (two independent grounds)
1. Incoherent isolated major bump (v8 generator against v7 parser/traverse ASTs).
2. Observable regression: v8 changed evasive-transform's source-map contract; its
   snapshot tests fail. Blessing the new output + selecting Babel-8 versions for
   the untouched parser/traverse/types packages are maintainer design decisions,
   not mechanical dependabot consequences (botanist step-6 edges b + c).

Closed with a reopen-inviting verdict comment on the PR.
