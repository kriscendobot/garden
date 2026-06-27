Worktree removed. Work complete.

---

## Completion report: `reaper-continue`

**Ask:** the reaper recovers stalled/aborted gardener jobs, but Claude may remember those sessions — arrange to use `--continue`/`--resume` so an interrupted session is carried forward to completion instead of restarting from scratch.

**Root cause found:** the reaper (`scripts/jobs/reaper.sh`) only requeues the *job* (`doin/<base>` → `todo/<base>`). The actual `claude` invocation lives in the job handler (`scripts/jobs/handlers/gardener-claude.sh`), which ran `claude -p` with **no session id** — so a fresh gardener re-claiming a requeued job started from a blank slate, discarding the dead session's entire transcript and any uncommitted edits.

**What I did** (two commits on `origin/main2`):

1. **`gardener-claude.sh` — deterministic session resume.** The handler now derives a stable session id from the job base (`uuid5("garden-job:<base>")`). A fresh claim starts the session under `--session-id <sid>`; a requeue whose transcript still exists on this host resumes it with `--resume <sid>` plus a continuation nudge prompt ("you were interrupted, continue from where you left off, including uncommitted work in your worktree"). Because the reaper requeues the *same base*, the id reproduces deterministically — so **nothing has to be plumbed through the board or the reaper**. Resume is best-effort/same-host (transcripts live under `~/.claude/projects/<encoded-cwd>/`); absent transcript falls back to a fresh session pinned to the same id, so the *next* death stays resumable.
2. **`reaper.sh` — cross-reference comment** so the recovery story is discoverable from where the maintainer expects it (the reaper), while the reaper itself stays a dumb requeue with no session knowledge.

**Verification:** `bash -n` clean on both files; shellcheck clean (only the pre-existing SC1091 source-follow info). Tested the branch selection (`--session-id` when no transcript, `--resume` when present) and confirmed the empty-array expansion is safe under `set -u` (the no-session-id fallback path). Built/pushed from an isolated worktree off `origin/main2` per garden-infra discipline; worktree torn down.

**Notes / possible follow-ups (not done — would benefit from maintainer review):**
- **Cross-host resume is inherently impossible** — transcripts are local to the host that wrote them. A requeue claimed on a different host degrades to a fresh (deterministic-id) session. This is the best achievable and degrades safely.
- **Worktree preservation:** the reaper still force-removes the orphaned worktree on requeue, so a resumed session recovers its *reasoning* (transcript) but not the literal uncommitted *files* — Claude re-derives edits from the transcript. Preserving the worktree for true file-level continuity is a separate GC-semantics decision (orphan/disk tradeoff) I deliberately left out of this surgical change.
- Inbox was empty throughout; no maintainer/peer messages arrived.
