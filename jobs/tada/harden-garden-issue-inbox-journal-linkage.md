Done. Pushed to `main2` as `081f32296`.

## Completion report

**Job:** Make `garden-issue-inbox` resilient to a severed journal linkage (kriskowal/garden #24).

**Root cause confirmed:** A garden-root relocation severs the shared `$GARDEN_ROOT/journal` worktree's gitdir (`fatal: not a git repository: …/garden2/.git/worktrees/journal`). Because every read/dispatch the issue-inbox watcher does resolves the journal remote *through* that worktree, `journal_remote` reached its `die` path and the whole tick aborted in `ensure_clone` **before** the reactji/dispatch step — silently dropping the maintainer's issue. I reproduced this end-to-end with the real watcher (exit 1, no reactji, no post, exact #24 FATAL).

**What changed** (commit `081f32296`, direct to `main2`, no PR):

1. **`common.sh` — new shared `repair_journal_worktree_gitdir` helper.** Factored the keeper's hardened prune-BEFORE-repair (unconditional `worktree prune` → `worktree repair`, gated on both gitdir *and* origin resolving). Non-destructive, so a caller with no backup/active-writer machinery can use it.
2. **`journal-worktree-keeper.sh`** — `jw_repair_gitdir` now delegates to the shared helper and layers its lossless rebuild on a non-zero return. Behavior-preserving (keeper suite 87/0); the keeper stays the only caller that rm-rf-rebuilds.
3. **`issue-inbox-watcher.sh`** — calls the shared repair at **tick start, before any journal read**, and heals its own verify clone (drops a corrupt one; re-adds a missing origin). An unrepairable-in-place linkage is **surfaced** (WARN + throttled maintainer signal via `alert_maintainer`), never a silent abort; dispatch then continues.
4. **`common.sh` — broadened `_journal_remote_from_state_clones`** to also scan `$GARDEN_STATE/<svc>/verify` clones (not only `*/journal`). A severed worktree now resolves the remote from the watcher's **own** verify clone instead of dying.

**Sibling watchers:** comment-watcher and mention-watcher share the identical verify-clone read path; they inherit the early-abort protection automatically via the broadened `common.sh` fallback. The proactive tick-start repair is scoped to issue-inbox (the confirmed drop) to keep blast radius tight — noted in the commit.

**Regression test** (`scripts/jobs/test/issue-inbox-journal-linkage-test.sh`, new): severs the worktree to a nonexistent garden2-style path with only a prior verify clone as remote source; asserts one tick self-heals and still reactji+dispatches, plus the repairable and surfacing paths. **Fails before** the change (verified by stashing the edits: 7 failures, the exact #24 FATAL) and **passes after**.

**Test results:** new 17/0 · issue-inbox 25/0 · keeper 87/0 · relink 25/0 · comment-watcher 207/0 · mention-watcher 19/0 · core run-test exit 0.

**Note:** The durable root-cause fix is host-side (the `garden2` bind-mount that makes git canonicalize the worktree link path); this change stops the silent drop.

**Follow-up (optional):** consider adding the same proactive tick-start repair to comment/mention watchers for full parity, and consider making the `_journal_remote_from_state_clones` scan generic across any clone dir under `$GARDEN_STATE` rather than the two known suffixes.
