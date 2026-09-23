All 25 tests pass. The requested hardening is already fully present on `main2` — no code changes needed.

## Completion report

**Finding: the requested work was already landed on `main2` (superseded).** The job asked to harden `journal_remote()` so a broken/missing journal worktree falls back to the garden repo's own origin instead of `die`ing and crash-looping the fleet. That exact fix already exists in `scripts/jobs/common.sh` (`journal_remote()`, lines 682–730), landed by prior commits ahead of this job's claim:

- `cdd341056` — *fall back to root origin when the journal worktree is unrepairable* (the core fix this job specifies).
- `556103da2` — *cache the journal remote and self-heal a transient empty read* (an extra per-host cache tier ordered ahead of the root fallback).
- `a0ddbce44` / `ef323fc4a` — *self-heal a dangling journal-worktree gitdir* via `git worktree repair` + `prune` preflight.

The shipped implementation is a strict superset of the spec's minimal patch:
1. `$JOURNAL_REMOTE` override short-circuit (unchanged).
2. Preflight `ensure_journal_worktree_linked` — repairs a dangling gitdir when the admin dir survives.
3. Read the worktree's `remote.origin.url` (caches it on success).
4. Fall back to the per-host cache (`$JOURNAL_REMOTE_CACHE`).
5. **Fall back to `git -C "$GARDEN_ROOT" config --get remote.origin.url`** — exactly the requested behavior, with a single WARN, not a `die`.
6. Only then `die`, with a diagnosis that distinguishes a broken worktree (names the dangling gitdir + suggests `worktree repair`) from a genuinely missing origin.

**Test already covers the requested case.** `scripts/jobs/test/journal-worktree-relink-test.sh` includes the precise scenario the job asked to add — *"unrepairable gitdir but ROOT has origin: root fallback, no die"* — plus cache-wins, no-origin-die, and named-gitdir-die cases. I ran it: **25 passed, 0 failed.**

**Changes:** none. Nothing to commit or push; `main2` already carries the fix and its regression test.

**Follow-up (out of scope, as the spec notes):** the dangling `/home/kris/journal` worktree (backing repo `/home/kris/garden2` deleted) is environmental. Repairing/re-adding it, or teaching `journal-worktree-keeper` to re-create a worktree whose backing gitdir is dead instead of logging `WARN … skipping`, remains a worthwhile separate task — but the fleet no longer crash-loops on it regardless, which is what this job protected against.
