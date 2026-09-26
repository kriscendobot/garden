The requested work is already fully implemented in `origin/main2` (my HEAD), and more comprehensively than the job spec's minimum. No code changes are needed.

## Completion report

**Finding: already fixed — no changes required.**

The job asked me to harden `journal_remote()` in `scripts/jobs/common.sh` so a stale/relocated journal worktree self-heals instead of wedging every producer. The current implementation (lines 682–730) already does exactly this — and exceeds the spec — landed by a prior series of commits now in `origin/main2` (which my worktree is checked out from):

- `ef323fc4a` / `a0ddbce44` — self-heal a dangling journal-worktree gitdir instead of a false 'no origin' crash-loop
- `cdd341056` — fall back to root origin when the journal worktree is unrepairable
- `556103da2` — cache the journal remote and self-heal a transient empty read

The job's stated "currently" one-liner (`... || die "no JOURNAL_REMOTE set ..."`) no longer matches the file. The present `journal_remote()` implements all three requested steps and then some:

1. **worktree repair + retry** — `ensure_journal_worktree_linked()` (lines 652–665) runs `git worktree repair` + `worktree prune` to re-link a dangling gitdir before the origin read, then the config read is retried (line 698). This is the requested step (1).
2. **root-origin fallback** — line 716 falls back to `git -C "$GARDEN_ROOT" config --get remote.origin.url`, with the same shared-origin rationale the job gives (journal2 and main2 live in one repo). This is the requested step (2). A per-host cache fallback (lines 712–715) is added ahead of it to also absorb transient empty reads (config lock / deploy window).
3. **die only if all fail** — the `die` is reached only after repair, cache, and root-origin all fail (lines 724–729), and it now distinguishes a broken worktree from a genuinely missing origin, naming the dangling gitdir target so the operator fix is obvious.

**Verification:** `bash -n scripts/jobs/common.sh` passes; the fix commits are confirmed ancestors of HEAD (`git merge-base --is-ancestor 556103da2 HEAD` → true).

**Changes:** none. Nothing committed or pushed — the tree is already correct.

**Follow-ups:** none. This self-heal request converged before this job was claimed; it can be closed as already-resolved.
