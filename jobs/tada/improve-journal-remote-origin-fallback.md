Pushed cleanly on the first attempt. Job complete.

---

**Completion report**

**Job:** Harden the journal-remote resolution against the fleet-wide FATAL cascade caused by a transient loss of `remote.origin.url` on `$GARDEN_ROOT/journal`.

**What I found:** The primary ask — the `journal_remote()` fallback in `common.sh` (try `$JOURNAL_REMOTE` → journal-worktree origin → cache → `$GARDEN_ROOT` origin → only then `die`) — **already landed in a prior commit** (`common.sh:716`, plus a per-host cache fallback that predates the `$GARDEN_ROOT` step). The function had evolved well past the lines 490–494 the job referenced. No change was needed there.

**What I changed:** The remaining half — the worktree-keeper self-heal. Previously `keep_journal_worktree()` merely *skipped* the tick with a WARN when `$JW` had a resolvable gitdir but a missing `remote.origin.url`, leaving the config gap open. I added:
- `jw_ensure_origin()` in `scripts/jobs/journal-worktree-keeper.sh`: when the worktree repo opens fine (gitdir resolves — a pure config gap, distinct from `jw_repair_gitdir`'s dangling-gitdir case) but origin is absent, it re-adds origin from `$GARDEN_ROOT`'s origin URL (the same repo/remote). Idempotent, best-effort, handles both the wholly-absent remote (`remote add`) and origin-section-without-url (`config remote.origin.url`) cases.
- Wired it into `keep_journal_worktree()` right after `jw_repair_gitdir`, before the skip gate — so the worktree now self-heals its *remote* the same way it already self-heals its *branch*.

**Verification:** `bash -n` on both scripts; a 4-case isolated-repo behavioral test (missing origin re-added; idempotent when present; origin-section-without-url fallback; non-repo no-op) — all pass.

**Pushed:** commit `d2e178122` to `main2` (clean, first attempt).

**Follow-ups:** None. The journal_remote fallback and the keeper self-heal now both close the transient one-worktree config-gap window.
