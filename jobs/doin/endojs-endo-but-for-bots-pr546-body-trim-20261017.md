---
role: gardener
requires: host=endolin-garden-ece02cb4
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Update the PR body of endojs/endo-but-for-bots#546

The fix-2 stage of gauntlet endojs-endo-but-for-bots-pr546-gauntlet-20261007 trimmed the PR body per the pruner seat, but the oros-studio bot PAT gets 403 on updatePullRequest for endojs. On this host, replace the body of https://github.com/endojs/endo-but-for-bots/pull/546 with the text between the markers below, verbatim (`gh pr edit 546 -R endojs/endo-but-for-bots --body-file <file>`). Change nothing else.

----- BODY -----
> **Mirror of upstream [endojs/endo#3137](https://github.com/endojs/endo/pull/3137)** (`feat: support .ts runtime modules via erasable type syntax`).
> This is a garden mirror onto the bot fork (`endojs/endo-but-for-bots`) for autonomous work. Base `master-5be15cb` is a frozen snapshot of upstream's PR base (`endojs/endo@5be15cbd`). The head carries #3137's commits through `2f2c0a3b`, followed by review follow-up commits.

Refs: #2864

## Description

Lets Endo packages author source in TypeScript using [erasable type syntax](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-5-8.html#the---erasablesyntaxonly-option) only (no `enum`, `namespace`, `const enum`, or parameter properties). Published packages still ship `.js`.

Types are stripped differently in each context:

- **Dev and test:** Node.js built-in type stripping, on by default from Node.js 22.18 and 23.6. CI runs 22.x and 24.x.
- **Bundling:** `@endo/bundle-source` strips workspace `.ts`, and the `@endo/benchmark` rollup config uses `amaro` `transformSync` in strip-only mode.
- **Packing:** [`ts-node-pack`](https://github.com/turadg/ts-node-pack) (`yarn pack:all`) erases `.ts` to `.js` and rewrites relative `.ts` specifiers.
- **`@endo/cli` and `@endo/daemon`:** the `amaro/strip` hook. `endo.cjs` imports it, and the daemon adds it to the processes it forks.

The PR migrates two modules as proof of the approach. `@endo/eventual-send` moves `E.js` to `E.ts`. `@endo/patterns` moves `patternMatchers.js` to `patternMatchers.ts` and folds the helper types from the removed `src/patterns/types.ts` into it.

It also adds the `@endo/no-nonrelative-ts-import` lint rule to the `internal` config. Package entrypoints stay `.js`, because Node.js will not strip types under `node_modules`, and runtime `.ts` imports must be relative.

### Security Considerations

No new authorities or trust boundaries. Type erasure is a load-time or pack-time transformation that leaves runtime semantics unchanged. `amaro` (a Node.js project package) becomes a runtime dependency of `@endo/cli` and `@endo/daemon`, and its hook runs in every process those packages fork.

### Scaling Considerations

The `amaro` hook adds a small startup cost to the CLI, daemon, and worker processes; published packages are unaffected.

### Documentation Considerations

See [`docs/typescript.md`](docs/typescript.md).

### Testing Considerations

The existing suites run against the migrated `.ts` sources through Node.js type stripping. New tests cover the `@endo/no-nonrelative-ts-import` rule, `makeAmaroExecArgv`, `E(any)` typing, and bundling a module that reaches the workspace `.ts` sources. Running `ts-node-pack` on `@endo/eventual-send` and `@endo/patterns` produced tarballs with `src/E.js` and `src/patterns/patternMatchers.js`, no `.ts` sources, and no `.ts` import specifiers. Still missing: a bundle-and-run test on XS, and a CI step that runs tests against the packed output.

### Compatibility Considerations

Published `@endo/eventual-send` and `@endo/patterns` keep the same `.js` entrypoints and exports. Installing them from a git checkout or a workspace link puts `.ts` under `node_modules`, which Node.js refuses to strip, so that kind of install is not supported. `@endo/cli` and `@endo/daemon` (both private) now declare `engines.node >=22`, a breaking change recorded as `major`. The guile-interop CI job moves from Node.js 20 to 22.

### Upgrade Considerations

Publishing `.ts` source and `.d.ts.map` files so that "Go to definition" lands on `.ts` is deferred until `ts-node-pack` can emit them.

----- END BODY -----

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-18T00:57:54Z
