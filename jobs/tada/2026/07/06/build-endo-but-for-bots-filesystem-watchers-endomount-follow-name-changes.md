I have everything I need to conclude. This is a clear duplicate: the M3 feature is already implemented and merged.

## Findings

I did **not** open a PR. Opening a fresh draft PR would have created a pure duplicate of already-landed work, which the builder pre-flight ("verify no open PR already implements the issue; skip and surface the existing PR") exists to prevent.

**The M3 `filesystem-watchers` design is already implemented and merged into `llm`.**

- **PR [#277](https://github.com/endojs/endo-but-for-bots/pull/277)** — *"feat(daemon): EndoMount.followNameChanges live entry-name stream"* — **MERGED to `llm` on 2026-07-01** (merge commit `562c87b`). It delivers exactly what this job asks:
  - `followNameChanges(...pathSegments)` on `EndoMount` (`packages/daemon/src/mount.js:774`), a snapshot-then-diff stream yielding `{ add, type }` / `{ remove }`, structure lifted from `pet-store.js`, with confinement filtering matching `list()` and a `try/finally` releasing the watcher on iterator drop.
  - `MountInterface.followNameChanges` guard (`interfaces.js:589`, `M.call().rest(PathSegmentsShape).returns(M.remotable())`).
  - New `watchDirectory` primitive on `FilePowers` (`daemon-node-powers.js:476`, `types.d.ts:2008`) wiring `node:fs.watch` with a 50 ms coalescing window; XS powers expose a graceful-degradation stub (`bus-daemon-rust-xs-powers.js:442`).
  - Changeset, help text, and tests (`watch-directory` contract tests plus `endo.test.js` / `mount.test.js` public-API coverage).
- **PR [#592](https://github.com/endojs/endo-but-for-bots/pull/592)** — *"feat(platform,daemon): factor watchDirectory into @endo/platform"* — **OPEN draft**, a kriskowal-requested follow-up moving the `watchDirectory` primitive from `@endo/daemon` into `@endo/platform`. This confirms the surface is live and actively being refined.

The package `packages/daemon/src/mount.js` exists only on `llm` (absent on `master`), so `llm` is the correct and only possible base — consistent with the job directive; a `master`-base mirror is not possible.

**One design item is intentionally not implemented:** the `fs.watchFile` polling fallback the job clause mentions. The design itself defers it ("Use as a per-entry fallback... *if needed*"; the returned interface is "shaped to allow a polling implementation without changing the `EndoMount` body"). PR #277 instead ships graceful degradation to an immediately-closing stream with a `console.error` diagnostic when `fs.watch` is unavailable, which was accepted in review. Adding the polling fallback now would collide head-on with the in-flight #592 (which relocates the whole primitive), so it belongs as a post-#592 follow-up in `@endo/platform`, not a fresh duplicate PR here.

## Root cause of the duplicate job / follow-up

`designs/filesystem-watchers.md` still carries `Status | Not Started` in its frontmatter (line 7) even though #277 implemented and merged it on 2026-07-01. A producer reading the roadmap re-posted it as unbuilt M3 work. **Recommended follow-up:** a small docs update on `llm` flipping that design's status to reflect #277 (and cross-linking #592), so the roadmap stops re-emitting this build job. I did not open that PR since the job scope was "build," not "update design status," and I did not want to originate an unrequested docs PR — flagging it for the liaison instead.

No code changed; no commits or pushes made; the project worktree is left for the scratch janitor to reclaim.

Self-improvement: nothing new to encode — the builder's "verify no open PR already implements the issue" pre-flight caught this correctly; the real fix is the stale design-status frontmatter, surfaced above as a follow-up for the liaison rather than a role/skill change.
