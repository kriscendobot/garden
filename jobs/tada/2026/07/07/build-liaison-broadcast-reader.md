Done. Both changes landed on `main2` (commit `8e97b86c7`).

## Completion report

**Job:** `build-liaison-broadcast-reader` — the serial follow-up to `build-transcript-capture`, closing out Decisions 5 & 6 of `designs/transcript-journal-capture.md`. Two garden-library files changed, landed directly on `main2` (no PR), no remote armed.

**1. Liaison broadcast-reader (`roles/liaison/AGENT.md`).** Added a standing Operating-norm bullet: the liaison drains its own bus addresses with `scripts/jobs/read-msgs.sh "liaison-$GARDEN" role/liaison broadcast` on bring-up (session preflight / starting stage) and at natural checkpoints thereafter. The per-host seen-key `liaison-$GARDEN` keeps each host its own read cursor (outside the journal, surviving `git reset --hard`), so a fleet-wide broadcast reaches every liaison — leader and follower — exactly once per host. Folded into an existing standing Monitor (maintainer-inbox on the leader, leader-marker watch on a follower), no new daemon. This closes the standing gap where nothing the fleet broadcasts could reach a liaison — the channel the already-queued `cleanupPeriodDays` notice on `role/liaison` was waiting for.

**2. Bring-up surfacing (`context/operations/starting.md`).**
- Wired the same broadcast drain into the bring-up procedure (a note after the three-Monitor list, applicable to every host), pointing back to the liaison role brief.
- Added an optional **transcript-durability arming** step alongside the issue-inbox/bulletin armings: surfaces that capture is inert until a remote is pointed at (deletion is disabled with no arming; transcripts spool locally meanwhile, nothing lost), and offers the arming act — maintainer creates a private repo, grants the bot push, then `set-transcripts-remote.sh <url>` + a journal `message` entry. Explicitly *offer only, do not arm*, and notes the local `~/.claude` disk-posture change. Links `context/operations/transcripts.md` for detail.

**Verification.** All new relative links resolve to committed files (`../../context/operations/transcripts.md`, `../../roles/liaison/AGENT.md`, `transcripts.md`) and both referenced scripts (`read-msgs.sh`, `set-transcripts-remote.sh`) exist. The `library-link-check.sh` script is scoped to `journal/library/`, not these main2 docs, so links were verified directly. Kept the diff to the two files; no index/link housekeeping was required. Inbox drained clean.

**Did not do (correctly):** did not arm any transcripts remote — the liaison only offers it.

**Follow-ups:** none.
