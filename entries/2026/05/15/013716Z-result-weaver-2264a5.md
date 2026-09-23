---
ts: 2026-05-15T01:37:16Z
kind: result
role: weaver
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/05/15/005225Z-dispatch-liaison-2264a5.md
---

# Merge endo-upstream/master into llm (dispatch 2264a5)

Status: **conflict resolutions complete and validated locally; not pushed (dispatch root was torn down before the merge commit and push step).**

## What happened

The merge was performed in `/home/kris/dispatches/weaver--2264a5/project`. The branch was 920 ahead, 32 behind. `git merge --no-ff endo-upstream/master` produced 27 unmerged paths. All were resolved per the `conflict-resolution` skill (read both sides; never `--ours`/`--theirs`); `yarn.lock` was the sole regenerate-from-scratch case.

After local validation (yarn install, yarn build, yarn lint all green: 0 errors, 1760 pre-existing warnings), the dispatch worktree was removed before the agent could `git commit && git push`. The work is irretrievable from disk; this entry preserves the resolutions list so a follow-up weaver can re-merge mechanically.

## Conflict resolution highlights (for the next weaver to replay)

CI workflow files (`.github/workflows/{browser-test,ci,release,typedoc-gh-pages,update-action-pins,update-action-pins-major}.yml`): keep HEAD's newer action SHAs, layer in upstream's `persist-credentials: false` hardening and zizmor comments. For `release.yml`, keep HEAD's `changesets/action@6a0a831f` (1.7.0 newer than upstream's 1.6.0).

`packages/bytes/{README,CHANGELOG}.md` and `.changeset/quiet-bytes-arrive.md`: take upstream's expanded API list (adds `bytesToImmutable`, `bytesFromImmutable`, `concatImmutables`); keep HEAD's `designs/endo-bytes.md` reference (the design file is llm-only and real).

`packages/bundle-source/package.json`: take upstream's `amaro` (replaces HEAD's `ts-blank-space`); the on-disk `src/endo.js` already uses amaro on llm, so this aligns the manifest with reality.

`packages/cli/package.json`: keep HEAD's `@endo/compartment-mapper` (used directly by `src/commands/{run,archive,make}.js` on llm); drop upstream's `@endo/bundle-source` (no consumer on llm after the cli refactor).

`packages/ocapn/src/{cryptography,netlayers/websocket}.js` and the `codecs/descriptors.js` `serializeHandoff{Give,Receive}`: HEAD's `makeCryptography(codec)` injection design supersedes upstream's standalone `signHandoffGive`/`makeOcapnPublicKey`/etc. exports. All callers on llm flow through `makeCryptography`.

`packages/ocapn/test/codecs/{descriptors,passable}.test.js` and `_codecs_util.js`: keep HEAD's `SyrupCodec.makeReader` abstraction (the upstream-side `import { makeSyrupReader } from '../../src/syrup/decode.js'` and `encodeSwissnum` imports were left orphaned after HEAD's refactor and are dropped).

`packages/daemon/src/connection.js`: keep HEAD's `renderRejection`, `ERROR_SENTINEL`, `registerCapTpConnection`, and the `messageToBytes` Error-encoding branch (real diagnostic fix on llm); drop upstream's `// console.log('->', text);` comment.

`packages/eslint-plugin/lib/configs/imports.js` + `packages/eslint-plugin/package.json` + root `package.json` + `.yarnrc.yml`: **partial revert of upstream's import-x migration.** The migration (`.changeset/migrate-eslint-plugin-import-x.md`) breaks ESLint on three llm-only packages (`chat`, `hex-test`) and on `playwright.config.ts` because import-x's bundled `unrs-resolver` does not honour the per-package `import/resolver: { exports: { conditions: [...] } }` config and rejects type-only re-exports from `@playwright/test`. Resolution: keep `eslint-plugin-import` at `^2.31.0` (no alias), restore `eslint-import-resolver-exports`, keep HEAD's inline `settings.import/resolver` block in `lib/configs/imports.js`, and delete `.changeset/migrate-eslint-plugin-import-x.md`. The migration is a separate concern the project can pursue later once the per-package conditions story is reconciled with import-x.

`packages/ocapn/test/codecs/operations.test.js`: auto-merge produced a duplicate `hexToImmutableBuffer` declaration. Removed the second copy.

`yarn.lock`: regenerated via `corepack yarn install`. The 8 `YN0060` peer-dependency warnings about `eslint-plugin-import` and airbnb-base are stale (would have applied only with the import-x alias) and disappeared once the import-x migration was reverted.

## Local validation

`corepack yarn install` clean. `corepack yarn build` clean. `corepack yarn lint` clean (0 errors). Prettier reformatted `packages/daemon/src/connection.js` (the conflict resolution had wider line wraps than Prettier's 80-col default); ran `yarn format` and re-staged.

## Next step

Re-dispatch weaver with the same task. The fresh worktree will hit identical conflicts (no upstream commits since this run); replaying the resolutions above mechanically is the fastest path. Allow ~20 minutes for the lint OOM-retry cycle (the first `yarn lint:eslint` invocation fatal-errors at `--max-old-space-size=4096`; `NODE_OPTIONS=--max-old-space-size=12288` clears it).

Self-improvement: when a long-running weaver dispatch approaches the orchestrator's teardown horizon, commit and push the merge **before** running the full `yarn build` + `yarn lint` validation pass. The validation can run on a re-cloned worktree if the push is in place; the merge bytes are the irreplaceable part. I should have committed after `yarn.lock` regenerated and pushed, then validated, then amended/follow-up only if validation surfaced something. Filed as a lesson against `roles/weaver/AGENT.md` § Procedure (insert a "commit + push before validation" step between current steps 6 and 7).
