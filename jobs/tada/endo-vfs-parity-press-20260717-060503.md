VFS-parity press dispatch 2026-07-17: re-wove #656 across two `llm` advances; the rest of the open set is review-blocked only.

**What I did**

- **#656 (provideSubMount)** had gone CONFLICTING against `llm` after the daemon→manager file renames (#598) and the 2026-07-17 upstream merge (#773) landed. I rebased its 5 commits onto `c4eb8449af`, and when `llm` advanced again mid-dispatch (#749 content-locator, #754 ReadableBlob), rebased once more onto `41cb5806ac`. Both rebases applied conflict-free; the diff now correctly targets `packages/daemon/src/manager.js`. Pushed as `76e6800ee5` (force-with-lease against the prior head) and posted evidence on the PR (comment 5002114458).
- **Execution evidence:** all 5 `provideSubMount` tests pass locally at the new tip; the full `-m '*mount*'` slice is green for every mount/sub-mount test. Getting there required a short-path secondary worktree — the job worktree's 144-char path exceeds the ~104-char Unix-socket limit, so daemon spawns fail with `endo.sock` ENOENT (see follow-ups).
- **CI at close:** 20/24 checks pass, 4 pending, **zero failures**; PR is MERGEABLE/UNSTABLE (pending only).
- **#713 (glorp), #655 (mount grep), #657 (mount JSON):** verified CLEAN/MERGEABLE with all checks passing; their stacked bases didn't move, so no re-weave — blocked on maintainer review only.
- No new surface opened (correctly deferred while #656's weave/CI was in flight). Scratch worktree, shims, and tmp dirs cleaned up.

**Follow-ups for the next dispatch**

1. Confirm #656's 4 remaining CI checks (slow suites: macOS/xs/hermes/cover) landed green.
2. Next parity gap once the set is review-blocked only: edit-with-hashline per `endopi-edit-tool.md` and glob+grep beyond the mount — confirmed genie exposes only a `glob` filter on `listDirectory` (no standalone glob/grep, no hashline edit) in genie/lal/fae.
3. Two non-attributable test issues worth small upstream fixes: `git › Git.status reports merge conflicts…` fails on any host with `rerere.enabled=true` (asserts on `/CONFLICT/` stderr that rerere replaces with "Recorded preimage"); `mount followNameChanges filters confinement-escaping symlinks` flakes under full-suite load but passes in isolation.
4. Press-runner note: daemon tests can't run in the long job-worktree path (socket-path limit) — future dispatches should reuse the short-worktree trick.
