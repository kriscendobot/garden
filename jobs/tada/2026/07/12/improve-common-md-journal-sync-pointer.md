Done. Report follows.

## Completion report

**Job:** `improve-common-md-journal-sync-pointer` — repoint the three dead references to the phantom `garden/skills/journal-sync/SKILL.md` in `roles/COMMON.md`.

**What I did:** Edited the three references (former lines 26, 192, 237) in `roles/COMMON.md`, then committed and pushed to `main2` (rebase CAS loop, pushed clean on first try).

**What changed:**
- **§ dispatch-root detail (line 26):** replaced the skill link with an instruction to post journal appends via `scripts/jobs/journal-entry.sh` (add-only fetch/rebase/push-retry against `journal2`), keeping the `WORKTREES.md` lifecycle pointer.
- **§ Writing an entry (line 192):** replaced "Follow journal-sync/SKILL.md" with the concrete `scripts/jobs/journal-entry.sh <kind> [body-file]` invocation and its CAS semantics; added the split the job asked for — `skills/journalism/SKILL.md` for *reading* the journal, `skills/message-bus/SKILL.md` for directed messages.
- **§ heartbeat note (line 237):** repointed the worktree-status commit/push at `scripts/jobs/journal-worktree-keeper.sh` (the script that actually owns that commit) instead of the phantom skill.

**Verification:** Confirmed all four referenced targets exist on disk (`scripts/jobs/journal-entry.sh`, `scripts/jobs/journal-worktree-keeper.sh`, `skills/journalism/SKILL.md`, `skills/message-bus/SKILL.md`) and confirmed by `journal-entry.sh`'s own header comment that it implements the add-only, resync-and-retry CAS append. Post-edit `grep -rn journal-sync roles/COMMON.md` returns no matches (exit 1). Pushed to `origin/main2`.

**Follow-ups:** None required for this file. Note: `journal-sync` may still be referenced by other files elsewhere in the library (this job scoped only `roles/COMMON.md`, the sole implicated non-script file); a broader sweep could confirm no other phantom pointers remain, but that's outside this job's stated scope.

Self-improvement: nothing this time — the fix was exactly the deterministic repoint the job specified.
