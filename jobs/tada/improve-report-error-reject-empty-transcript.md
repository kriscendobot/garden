Landed on `origin/main2` as `58283556a`. Worktree cleaned up.

---

**Completion report: improve-report-error-reject-empty-transcript**

**What I did**
- Centralized the empty-blob defense in `skills/gardener-inbox-error-reporting/report-error.sh`, the single script every gardener-inbox escalation passes through.

**What changed**
- Added a guard immediately before `TRANSCRIPT_SHA=$(... hash-object ...)` (the file-exists check already lived there at lines 49–53). When `[ ! -s "$TRANSCRIPT" ]`, the helper now writes a synthetic, self-describing line — `report-error: handler produced no captured output (empty transcript); rc/state=$STATE, context=$CONTEXT` — into a `mktemp` copy and hashes that, leaving the caller's file untouched. The non-empty branch hashes the transcript as before.
- Net effect: a zero-byte transcript can no longer escalate to the dreaded zero-byte git blob `e69de29b…`. Verified: an empty transcript now hashes to a distinct, non-empty, content-addressed blob (`7ce62c35…` in test), and the blob body is self-describing/fetchable.
- The fix moves responsibility off each caller. The two callers that never pre-filled — `scripts/driver/driver.sh` and `scripts/jobs/common.sh` — now get the protection for free; the gardener path is no longer the only one covered.

**Decisions**
- Left the per-caller synthesize guard in `gardener.sh:136-139` in place as defense-in-depth (the job explicitly permits this, and its existing comment already frames it that way). No equivalent assertion was removed, so nothing was weakened.
- Followed the garden-infra-jobs convention: built on an isolated worktree off `origin/main2`, committed an explicit pathspec, pushed `HEAD:main2`, and removed the worktree. Inbox was empty at the checkpoint.

**Follow-ups**
- None required. Optionally, the docstring/SKILL.md for this skill could note the centralized empty-transcript guarantee so future callers know they need not pre-fill, but the behavior is self-documenting in the script comment.
