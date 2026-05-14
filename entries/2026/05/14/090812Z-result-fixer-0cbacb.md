---
ts: 2026-05-14T09:08:12Z
kind: result
role: fixer
worktree: dispatches/fixer--pr-135-panel-fix--20260514-084845--f3e898/project
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
---

# Fixer: PR #135 panel-fix round

Addressed the 2026-05-07 bot-self panel verdict on PR #135 (`feat/mount-core`). Five fixup commits, all must-fix items addressed plus four should-fix items.

## Must-fix items addressed

- **Realpath check in `Mount.subDir`** (reviewers 12, 13). Commit 7b9de4eca. `assertConfinedOrAncestor` already does realpath checking against the parent root, but the new sub-mount's `currentDir` / `confinementRoot` were set to the symlink path itself; now resolved to realpath up front so every later assertion inside the sub-mount sees the on-disk truth.
- **Realpath check in `EndoHost.provideSubMount`** (reviewers 12, 13). Commit 862c920b3. Threaded `filePowers` into `makeHostMaker` so `provideSubMount` can call `filePowers.realPath(parentPath)` and `filePowers.realPath(fullPath)` and refuse when the child's realpath is not under the parent's realpath. Without this, a symlink inside the parent could redirect the child's confinementRoot outside.
- **Bound recursion depth in `capability-vfs.readdir({ recursive: true })`** (reviewer 13). Commit bcb25f7d2. New `MAX_READDIR_DEPTH = 64` cap matching the daemon-side `MAX_CHECKIN_DEPTH`. Generator throws on cap rather than silently truncating.
- **Direct test for `host.provideSubMount(...)`** (reviewer 2). Commit 612dc601f, `'host provideSubMount stores a usable mount formula'`.
- **End-to-end `MountFile.streamBase64()` test** (reviewer 2). Commit 612dc601f, `'mount file streamBase64 yields base64-encoded chunks'`. Decodes each base64 chunk via `@endo/base64.decodeBase64` and concatenates the resulting bytes; exercises the recent makeReaderRef fix end-to-end.
- **`.` rejection test for `subDir`** (reviewer 2). Commit 612dc601f, `'mount subDir rejects "." segment'`. Also added the parallel `'host provideSubMount rejects "." segment'`.
- **Symlink-escape regression test for `subDir` and `provideSubMount`** (reviewer 13). Commit 612dc601f, `'mount subDir rejects symlink escape'` and `'host provideSubMount rejects symlink escape'`.

## Should-fix items addressed

- **Standardised "invalid segment" error message** between `mount.js` and `host.js` (reviewer 6). Both now emit `Invalid subDir segment: "<seg>"` with `q()` quoting. Picked up across commits 7b9de4eca and 862c920b3.
- **Replaced em-dash in `mount.js` comment** (reviewer 8). Commit 7b9de4eca; the rewritten comment uses a sentence break. Also caught and fixed the same em-dash in `capability-vfs.js` module docstring (commit bcb25f7d2).
- **`subDir(...).snapshot()` test** (reviewer 1). Commit 612dc601f, `'mount subDir result supports snapshot()'`. Backs against a scratch-mount so `snapshotFn` is wired, then asserts the sub-mount's snapshot is a usable ReadableTree.
- **`selfRef` capture comment** (reviewer 1 note). Commit 7b9de4eca. Added a docstring explaining why `selfRef` is hoisted and assigned after `makeExo` returns, so a future refactor splitting `makeMountExo` does not regress.

## Out-of-scope items surfaced (panel's own "follow-up" section)

These are explicitly listed by the panel as out-of-scope for this PR; recording them here so the orchestrator can decide whether to open follow-up PRs/issues:

- Expose `getScratchMountPath(formulaNumber)` from daemon and call it from `provideSubMount` instead of reconstructing `${statePath}/mounts/${formulaNumber}` twice (reviewer 1).
- Tighten `EndoHost.provideSubMount`'s return type once `Mount` has a stable type (reviewer 3).
- Add `path: string` to `ScratchMountFormula` so both branches in `provideSubMount` can share one property access (reviewer 3).
- TOCTOU between `has` and `list`/`readText` in `capability-vfs.stat` — a single Mount-side `{ exists, type }` method would resolve it atomically (reviewer 13).
- `help.md` updates for `Mount.snapshot`, `Mount.subDir`, `EndoHost.provideSubMount` (reviewer 11).

Also surfacing one observation for the orchestrator: the project's own `packages/daemon/CLAUDE.md` § "Exo and Interface Authoring" claims `.rest(M.string())` is correct and `.rest(M.arrayOf(M.string()))` is wrong, but the recent fix in this PR (commit 750048f28, "correct Mount has/list interface guard") moved the guard to `.rest(M.arrayOf(M.string()))` to match `ReadableTreeInterface` and made Phase 8 pass. The panel's reviewer 4 ratified this as a bug fix. There is a real contradiction between the CLAUDE.md text and the current `ReadableTreeInterface` guard. Not in scope for this fixer round, but the daemon-CLAUDE.md is now misleading; a future builder or gardener should reconcile.

## Commits pushed (in order)

```
7b9de4eca fix(daemon): subDir realpath-confines new mount root
862c920b3 fix(daemon): provideSubMount realpath-confines child under parent
bcb25f7d2 fix(daemon): bound readdir recursion depth in capability-vfs
39be08c44 style(daemon): prettier-format host.js sub-mount realpath check
612dc601f test(daemon): cover subDir/provideSubMount and streamBase64
```

Branch head: `612dc601f`. Pushed to `endojs/endo-but-for-bots` `feat/mount-core`.

## CI status

CI is mid-run on the new head as of this entry. The previous head (`5b4e2275f`) had one red check, `lint`, which I cannot independently reproduce on this dispatch's worktree: `npx corepack yarn lint` exits 0 across the whole repo, and the only TypeScript error is the pre-existing `@libp2p/utils` resolution error the PR body and panel both acknowledge. Worth verifying after CI lands; if it returns red on `lint`, the steward should dispatch a shepherd to inspect.

## Files changed

Five files:

- `packages/daemon/src/mount.js`: realpath confinement, em-dash, error quoting, selfRef comment.
- `packages/daemon/src/host.js`: realpath check in provideSubMount, threaded `filePowers`, standardised error message.
- `packages/daemon/src/daemon.js`: one line, threads `filePowers` into `makeHostMaker`.
- `packages/daemon/src/capability-vfs.js`: depth-bounded readdir, em-dash.
- `packages/daemon/test/endo.test.js`: seven new tests.

Within the 5-file hard-escalation budget (capability-vfs.test.js was not touched; the streamBase64 end-to-end coverage lands in endo.test.js where the host harness gives the test access to a real Mount).

## Local-test caveat

The dispatch-root path is long enough that the daemon's UNIX-socket path overruns the 108-char limit, so `npx corepack yarn test` on the daemon's endo.test.js fails locally on every test before any assertion runs (ENOENT on `endo.sock`). The non-daemon-launching tests (capability-vfs.test.js, pet-name.test.js, formula-identifier.test.js) all pass, and `yarn lint` is exit-0. CI will be the real signal for the new endo.test.js tests.

Self-improvement: a one-shot fixer running in a deep `dispatches/<role>--<purpose>--<ts>--<id>/project/` worktree cannot run the daemon's full test suite locally because UNIX-socket paths overflow 108 chars; the dispatch-root chooser should consider a shorter scheme (`dispatches/<short-id>/project/`) or the dispatch-prepare script should pre-create a `/tmp/endo-<short-id>` symlink the daemon tests can target. Surfaced this to the orchestrator via a journal `message` entry so the gardener can pick it up.
