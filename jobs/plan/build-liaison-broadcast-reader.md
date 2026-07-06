---
gate: orchestrated
orchestrated_by: supervise-transcript-capture
priority: normal
role: builder
posted_by: orchestrator
posted_at: 2026-07-06T23:39:51Z
---

role: builder

# Liaison broadcast-reader + transcript-capture bring-up surfacing

Serial follow-up to `build-transcript-capture` (already landed on main2 when
you read this). Read `designs/transcript-journal-capture.md` and the new
`context/operations/transcripts.md` first. Two garden-library changes, landed
on main2 directly (no PR):

1. **Liaison broadcast-reader.** Liaisons read NO message-bus broadcast today,
   so a `send-msg.sh role/liaison` (or `broadcast`) never reaches them — and a
   `cleanupPeriodDays` notice is ALREADY queued on `role/liaison` waiting for
   exactly this reader. Amend `roles/liaison/AGENT.md`: on bring-up (session
   preflight / the starting stage) and at natural checkpoints thereafter, the
   liaison drains its bus addresses with

       scripts/jobs/read-msgs.sh liaison-<GARDEN> role/liaison broadcast

   where `<GARDEN>` is the host identity from `common.sh` — a per-host
   seen-key (`liaison-<GARDEN>`) so each host's liaison keeps its own read
   cursor and a fleet-wide broadcast reaches every liaison exactly once per
   host. Wire the same drain step into the bring-up procedure in
   `context/operations/starting.md`. Follow both files' existing style; keep
   the additions tight.

2. **Bring-up surfacing of transcript capture.** Add to
   `context/operations/starting.md` a starting-stage step where the liaison
   surfaces that transcript capture is INERT until armed and offers the arming
   act — maintainer creates a PRIVATE repo (recommended:
   `kriskowal/garden-transcripts`), grants the bot push, runs
   `scripts/jobs/set-transcripts-remote.sh <url>`, records a journal `message`
   entry — linking `context/operations/transcripts.md` for the detail. Give
   `roles/liaison/AGENT.md` whatever short pointer matches its existing
   pattern for optional armings (the issue-inbox arming is the model).

Do NOT arm the remote yourself; the liaison only OFFERS it. Keep the diff to
those two files (plus any index/link housekeeping the library requires) and
verify links per the library-link-check script before landing. Garden-meta
only: commit explicit pathspecs, rebase CAS push to main2, no PR.
