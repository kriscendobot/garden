<!-- garden-promoted-from-plan: gate=deferred priority=normal at=2026-07-01T23:58:09Z -->

# Factor `watchDirectory` out of the daemon into `@endo/platform`

Follow-up requested by **kriskowal** on the merged PR #277:
https://github.com/endojs/endo-but-for-bots/pull/277#issuecomment-4858295070
> Please post a follow-up job to factor watchDirectory out to `@endo/platform`.

Repo: **endojs/endo-but-for-bots**, base branch **`llm`**, **bot identity**
(kriscendobot / bot fork — this is bot-repo work, no upstream endojs/endo touch).
Wear **designer** (a short extraction design / delta) then **builder** on the
resulting design; the standard researcher-precedes-designer/builder chain and the
gardening state machine apply.

## What to move

PR #277 landed `watchDirectory` as a self-contained primitive inside
`makeFilePowers` in `packages/daemon/src/daemon-node-powers.js` (currently
~lines 473–671). It wraps `node:fs.watch({ persistent: false })` with:

- an in-memory buffered event queue + waiter list (push/pull async-iterable),
- a 50 ms per-filename debounce/coalescing window (`Map<name, timer>`),
- best-effort `{ kind: 'add' | 'remove' | 'replace', name }` events where `kind`
  is a hint the consumer reconciles against its own snapshot set,
- an idempotent `cancel()` / `close()` lifecycle, and
- a failure path that surfaces `fs.watch` unavailability as an
  immediately-terminated stream.

Its only ambient dependency is node `fs`. Consumers: `EndoMount.followNameChanges`
(`packages/daemon/src/mount.js`) via the `FilePowers.watchDirectory` entry; the
type lives in `packages/daemon/src/types.d.ts`; there is a stub/branch in
`packages/daemon/src/bus-daemon-rust-xs-powers.js`.

## Target

`@endo/platform` (`packages/platform/`) — "Platform filesystem types and adapters
for Endo". It already carries node-fs adapters under `src/fs-node/` and a
`src/fs/extended/shared/watcher-exo.js` plus `test/watch.test.js`, so a
directory-watching primitive belongs here rather than in the daemon.

## Scope / decisions for the designer

- **API shape & home**: where in `@endo/platform` `watchDirectory` lands and what
  it exports (e.g. a `makeWatchDirectory(fs)`/node-fs adapter vs. an exo), and how
  `makeFilePowers` in the daemon then consumes it (import + delegate, keeping the
  `FilePowers.watchDirectory` surface identical so `mount.js` is unchanged).
- **Move the coverage too**: `packages/daemon/test/watch-directory.test.js` (and
  the relevant slices of `mount.test.js`) — decide what becomes an
  `@endo/platform` unit test vs. what stays as daemon integration coverage.
- Keep behavior **byte-for-byte equivalent** (50 ms debounce, `kind` hint
  semantics, idempotent cancel, fs.watch-unavailable → terminated stream). This is
  an extraction/refactor, not a behavior change; the net observable behavior on
  `EndoMount.followNameChanges` must be invariant.
- Update `packages/daemon/package.json` to depend on `@endo/platform` if it does
  not already, and add the workspace wiring.

## Out of scope

- The **multiplexing** follow-up (per-path `pubsub` topic fanout to share one
  watcher across subscribers) called out in PR #277's Scaling section — separate.
- The `NameHubInterface` cross-interface unification — separate sibling design.

## Reference

- Design: `designs/filesystem-watchers.md` (canonical).
- The merged implementation is the source of truth for behavior parity.
