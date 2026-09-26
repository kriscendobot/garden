Weave complete. Report follows.

---

## Weave report — endojs/endo-but-for-bots PR #656

**Task:** Rebase `feat/mount-provide-submount` (the `provideSubMount` sub-mount primitive, daemon-mount Phase 4) onto current `llm` to clear a DIRTY/CONFLICTING merge state, preserving net diff.

**Starting state:** PR head `c8922cc928` on merge-base `7870da1d91`; `origin/llm` had advanced 30 commits (`f7932ed5a9`). `mergeable: CONFLICTING`, `mergeStateStatus: DIRTY`.

**What I did:**
- Rebased the 4 PR commits onto `origin/llm` in an isolated project worktree. Commit 1 conflicted in three files; commits 2–4 replayed cleanly.
- Resolved every conflict by reading both sides (no `--ours`/`--theirs`). All three were the base having independently evolved the same mount code the PR touched:
  - **`mount.js`** — base made `resolveSegments` private + added a `deniedSegments` param; PR needed it exported. Kept **both**: `export const resolveSegments(..., deniedSegments = undefined)`.
  - **`types.d.ts`** — `MountFormula` gained base's `deniedSegments?` and PR's `parent?`; kept both. In `EndoHost`, kept base's evolved `provideScratchMount`/`provideGit` signatures (opts, `allowHistoryRewrite`) **and** the PR's new `provideSubMount` method.
  - **`daemon.js`** — base renamed the mount factory to `makeRevocableMount` and added `deniedSegments`; PR added the `parent` dependency edge (`thisDiesIfThatDies`). Merged the `mount` maker to destructure `{ path, readOnly, deniedSegments, parent }` over base's revocable-mount body, and dropped the now-unused `makeMount` import (base's body uses `makeRevocableMount`; the PR's own `formulateSubMount` only needs `resolveSegments`).

**Verification:**
- No conflict markers remain (the one match in `git.test.js` is a legitimate test-string assertion).
- `git range-diff` old-PR vs rebased-PR: commits 2/3/4 are byte-identical (`=`); only commit 1 changed, and solely by the mechanical base adaptations above — net diff preserved. Monotonic read-only clamp (`effectiveReadOnly`) and symlink-escape guard from later commits intact.
- `node --check` passes on all five changed files.
- Full `yarn` verify was not run locally (fresh worktree, no `node_modules`; install is heavy) — deferred to CI.

**Pushed:** `--force-with-lease` to `feat/mount-provide-submount` → new head `95fabf49c0`. PR now reports `mergeable: MERGEABLE`; `mergeStateStatus: UNSTABLE` reflects CI re-running against the rebased head, not a conflict.

**Follow-ups:** Watch CI on the rebased head to green (a shepherd if it goes red). The Phase 4 primitive is now mergeable.
