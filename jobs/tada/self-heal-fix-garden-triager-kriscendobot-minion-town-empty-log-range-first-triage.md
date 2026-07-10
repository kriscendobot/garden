Verified: the cold-start (empty-`old`) path now produces a real change summary and exits 0, exactly as required. No further work needed.

## Completion report

**Finding: the job was already resolved before I claimed it.** The fix landed as commit `d486643cf` ("triager-claude: never pass an empty revision to git log on cold start") on `origin/main2` ~29 minutes before this claim — this worktree was checked out off `main2` and already contains it.

The described bug (`"${old:+$old..$new}"` collapsing to an empty string on cold start → `git log --stat ""` → exit 128 → pipefail/`set -e` aborts before any `[triage-claude]` line) is fixed in `scripts/jobs/handlers/triager-claude.sh`, in a more robust way than the job's minimal suggestion:
- Line 26 computes `range="${old:+$old..}$new"` for the human-readable prompt string (the corrected form the job asked for).
- Lines 42–46 select the git-log range with an explicit `if [ -n "$old" ]` branch: `$old..$new` when a cursor exists, else `-1 "$new"` to describe just the new tip — so `git log` is *never* handed an empty revision, and the cold start yields a real change summary rather than an empty one.

**Verification:** built a throwaway bare repo with a single commit and ran the exact lines 42–46 with `old=""`. Result: exit 0 with a genuine one-commit `--stat` summary (the previously-failing signature is gone). Also grepped `scripts/` — no remaining `"${old:+$old..$new}"` occurrences.

**Changes:** none — no edits, commits, or pushes were needed; the tree already matched the desired end state.

**Follow-ups:** none. This was a benign race — the self-healing job was posted before (or concurrently with) the fix landing. No action required.
