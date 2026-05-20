---
ts: 2026-05-20T23:10:05Z
kind: result
role: builder
project: endo-but-for-bots
refs:
  - entries/2026/05/20/225513Z-dispatch-liaison-96fa5a.md
---

# Result: builder 96fa5a — partial mirror of endojs/endo#3036 onto endo-but-for-bots@llm

PR: <https://github.com/endojs/endo-but-for-bots/pull/330> (DRAFT)
Branch: `mirror/3036-exo-stream`, head SHA: `68f4918ad`.

## 1. llm-side baseline

`@endo/exo-stream` **already exists on llm**, landed via the `kriskowal-exo-stream` branch (commit `3e240f9ff feat(exo-stream): Add @endo/exo-stream package`) plus follow-up cleanups (numeric-separators autofix, prettier reformat, type-fix patches). `@endo/daemon`'s `package.json` already lists `@endo/exo-stream` as a workspace dep.

The llm package differs from PR #3036's snapshot only by module / export renaming: `streamIterator` -> `readerFromIterator`, `iterateStream` -> `iterateReader`, `streamBytesIterator` -> `bytesReaderFromIterator`, `iterateBytesStream` -> `iterateBytesReader`. Protocol semantics unchanged. `yarn test` on `@endo/exo-stream` passes (121 tests).

The remaining un-mirrored part is the **daemon / CLI wire-in** (PR #3036's first commit `b66f8149e refactor(daemon,cli): Use new exo-stream package`). The daemon's `reader-ref.js` and `ref-reader.js` modules and their consumers are still on the legacy protocol.

## 2. Conflict count / triage

`git apply --3way` would have produced heavy conflicts (4 missing files outright: `cli/demo/cat.js`, `cli/src/commands/bundle.js`, `cli/src/commands/install.js`, plus 30+ hunks rejected in daemon source and package.json). The bigger structural problem is wire-protocol-coupling: the legacy `makeReaderRef` / `makeIteratorRef` API is not wire-compatible with the new `bytesReaderFromIterator` / `readerFromIterator` API, so any migration must move paired producer / consumer endpoints atomically. llm has accreted significant call sites since PR #3036 opened nine months ago:

- llm-only legacy-API producers / consumers not in PR #3036's diff: `daemon/src/mount.js`, `daemon/src/channel.js`, `daemon/src/worker.js`, `daemon/src/daemon-persistence-powers.js`, two extra sites in `daemon/src/daemon.js` (gateway retention sync; `makeBytesBlob`).
- 41 legacy-API call sites in `daemon/test/` (4 test files).
- Cross-package legacy consumers in `@endo/chat`, `@endo/chat-network-view`, `@endo/fae`, `@endo/genie`, `@endo/jaine`, `@endo/lal`, `@endo/platform`.

Triage outcome: **mostly-already-done plus partial-mirror with surfaced gaps**. The exo-stream package itself is fully subsumed; the wire-in migration is significantly larger than PR #3036's original scope and is left as documented future work in the PR body.

## 3. Branch + head SHA

Branch `mirror/3036-exo-stream`, HEAD `68f4918ad` (single commit, author Kris Kowal <kriskowal@kriskowal.com>, committer endolinbot).

## 4. PR URL

<https://github.com/endojs/endo-but-for-bots/pull/330> (DRAFT). PR-create succeeded on the first attempt.

## 5. yarn lint / yarn test

- `@endo/exo-stream`: `yarn lint:eslint` (0 errors, 4 pre-existing warnings). `yarn test`: 121 tests pass.
- `@endo/daemon`: `yarn lint:eslint` (0 errors, 314 pre-existing warnings). Full `yarn test` not run (long-running, requires a running daemon; the index.js change is a re-export only and `yarn lint:types` failure is the pre-existing `@libp2p/utils` TS resolution issue, verified by checking lint:types on HEAD without any changes).

The ship is a single 25-line additive diff to `packages/daemon/index.js` and `packages/daemon/types.d.ts` that re-exports the four new exo-stream APIs alongside the legacy exports, with a comment naming the wire pairing and the migration constraint. No wire is changed; no test is broken.

## 6. Self-improvement

Self-improvement: when a brief invites partial-mirror with surfaced gaps, surface the architectural reason for partiality (here: wire-protocol-coupling across many call sites) in the PR body's gap analysis section, not just the count of conflicting hunks. The PR body is the right place because future migrators read it before tackling the rebase; a journal entry is for the dispatcher.
