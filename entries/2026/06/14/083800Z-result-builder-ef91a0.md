---
ts: 2026-06-14T08:38:00Z
kind: result
role: builder
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: liaison
dispatch_root: /home/kris/dispatches/builder--10263a
prs:
  - repo: endojs/endo-but-for-bots
    pr: 442
    role: opened
  - repo: endojs/endo-but-for-bots
    pr: 403
    role: predecessor
refs:
  - entries/2026/06/14/081724Z-result-researcher-23eb2a.md
  - https://github.com/endojs/endo-but-for-bots/pull/442
  - https://github.com/endojs/endo-but-for-bots/pull/403
  - https://github.com/endojs/endo-but-for-bots/pull/403#issuecomment-4701211238
  - https://github.com/endojs/endo-but-for-bots/pull/403#pullrequestreview-4492612214
---

# result: builder — extract daemon-cas into @endo/daemon-cas (PR #442)

Carved the filesystem-backed content-addressed store out of
`packages/daemon/src/daemon-persistence-powers.js` (lines 122-197 of the
original, the `makeContentStore` closure) into a new `@endo/daemon-cas`
workspace, per the maintainer directive on PR #403's review #4492612214:
"a temporary, intermediate step on the way to migrating the daemon to
use git-cas."

## Deliverable

- **Draft PR #442** opened against `llm-c85d618` (the same frozen base
  as #403; rides on top of #403).
  Title: `feat(daemon-cas): extract CAS surface into @endo/daemon-cas
  (PR #403 follow-on)`.
  URL: <https://github.com/endojs/endo-but-for-bots/pull/442>.
- **Branch**: `feat/daemon-cas-extraction` on `endojs/endo-but-for-bots`.
- **Commits** (3 logical steps):
  1. `feat(daemon-cas): new package extracting CAS surface from daemon`
     (6a8c455a9) — new workspace files (`package.json`, `index.js`,
     `src/content-store.js`, `test/content-store.test.js`, three
     tsconfigs, `LICENSE`, `SECURITY.md`, `README.md`, `CHANGELOG.md`,
     `types.d.ts`, `types.js`), `.gitignore` exemption for the new
     `types.d.ts`, and the root `tsconfig.composite.json` reference.
  2. `feat(daemon): delegate CAS to @endo/daemon-cas` (536a6fb5d) —
     replace the 78-line `makeContentStore` closure with a 6-line
     delegation to `makeDaemonContentStore`; add `@endo/daemon-cas` to
     daemon's runtime deps.
  3. `chore: Update yarn.lock` (d2d3e11b9) — lockfile churn in its own
     commit per project convention.

## Package shape

Two factory exports from `@endo/daemon-cas`'s root:

- `makeContentStore({ filePowers, cryptoPowers, storageDirectoryPath })`
  builds the raw `ContentStore` (the `store`/`fetch`/`has`/`remove`
  surface defined in `@endo/platform/fs/lite/types`) over a
  caller-chosen directory.
- `makeDaemonContentStore({ filePowers, cryptoPowers, statePath })`
  derives `storageDirectoryPath` as `${statePath}/store-sha256/` and
  wraps in `@endo/platform/fs/lite`'s `makeSnapshotStore`, returning
  the `SnapshotStore`-shaped value the daemon's persistence-powers
  contract expects.

The split lets a future `@endo/git-cas` reuse the `SnapshotStore`
wrapper around its own `ContentStore` implementation.

## Three open questions answered

Per the researcher's pre-build note (entry
`081724Z-result-researcher-23eb2a.md`):

1. **`makeSnapshotStore` home**: stays in `@endo/platform`. The wrapper
   is generic; the new package composes with it rather than re-exporting
   (option a; smallest change).
2. **`ContentStore`-factory export split**: yes, exposed. Both
   `makeContentStore` (raw) and `makeDaemonContentStore` (convenience)
   are public exports.
3. **`Sha256` type alias move**: no. The alias in
   `packages/daemon/src/types.d.ts` is about `cryptoPowers.makeSha256`,
   which is daemon-internal hashing infrastructure rather than CAS API.
   The new package's public types use `string` throughout, matching the
   platform `ContentStore` shape.

## Contract preservation

- The 4-method `store`/`fetch`/`has`/`remove` contract is preserved
  exactly; `remove` keeps its idempotent semantics per
  `designs/daemon-content-store-gc.md` (PR #99).
- The single call site at `packages/daemon/src/daemon.js` line ~330 is
  unchanged; the `bus-daemon-rust-xs.js` cross-supervisor path also
  goes through the same `makeDaemonicPersistencePowers` factory and is
  preserved by the delegation.

## Verification

- `yarn lint:types` clean on `packages/daemon-cas/` (0 errors).
- `yarn lint:eslint` clean on `packages/daemon-cas/` (0 errors;
  2 `any` warnings on test-side type assertions, matching the
  workspace baseline).
- `yarn lint:types` clean on `packages/daemon/` (0 errors).
- `npx ava` in `packages/daemon-cas/` passes (9/9 tests; round-trip,
  multi-chunk hashing, presence/absence, idempotent remove, content
  deduplication, atomic-rename invariant, fetch-reads-disk invariant,
  daemon-shaped wrapper's join, joinPath-only-path-primitive).
- `npx ava test/mount.test.js test/mount-snapshot-and-entry.test.js
  test/mount-platform-fs-conformance.test.js` in `packages/daemon/`
  passes (86 tests total; exercise the same `_mount-test-helpers.js`
  memory store the new package's tests are modeled on).
- `yarn format` is a no-op on the changed files (Prettier touched
  `packages/registry-capability/types.d.ts` as a side-effect; that
  diff was reverted to keep this PR scoped to the extraction).
- ASCII-in-source probe clean on changed `packages/*/src/**` files.

## Reply on #403

Posted top-level comment on #403 referencing the new sibling PR and
explaining the choice to do the extraction as a separate PR rather
than appended to the same branch (cleaner audit surface; self-contained
refactor). Re-requested kriskowal review on #403.

- Comment: <https://github.com/endojs/endo-but-for-bots/pull/403#issuecomment-4701211238>
- Re-request: `POST /repos/endojs/endo-but-for-bots/pulls/403/requested_reviewers`
  with `reviewers[]=kriskowal` (200 OK; `requested_reviewers` now
  includes kriskowal).

## Out of scope (deferred)

- Phase 5 (Rust `cas-*` envelope verbs replacing the package's
  implementation) per `designs/daemon-cas-management.md`.
- The `Sha256` type alias migration.
- Reference counting; the daemon's formula GC pass continues to compute
  the sweep set per `designs/daemon-content-store-gc.md`.
- Full daemon integration tests (`test/content-store-gc*.test.js`,
  `test/endo.test.js`) pending CI.

## Recommended next stage

**cleaner**.

The draft PR is open; the standard PR-creation chain proceeds:
cleaner -> barrister (code panel) -> fixer-loop (if any in-scope
complaints) -> appellate -> un-draft.

Self-improvement: nothing this time. The build was a clean refactor;
the researcher's pre-build references resolved every code-side question
without an extra library-lookup. One small operational note for any
future builder extracting a package into the `endo-but-for-bots`
workspace: `*.d.ts` files in new packages must be exempted in
`.gitignore` via `!packages/<name>/types.d.ts` (the global `*.d.ts*`
catch-all hides them otherwise). The existing exemption list documents
the pattern; this dispatch added one more row and that was the only
shape friction worth recording. No structural lesson; no `message:
builder -> liaison`.
