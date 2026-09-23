Everything is done and verified. Writing the completion report.

Transcript-journal capture is implemented, landed on main2, and verified — built by two Opus builders under a serial orchestration I supervised; nothing is armed (inert by design until the maintainer acts).

**What I did (supervisor, per skills/orchestration):**
- Read the landed design `designs/transcript-journal-capture.md` (d9c7ad6c7) and decomposed its § Builder spec into two serial Opus builder children parked with gate `orchestrated` under my base, then recorded the orchestration (`--serial --on-child-failure halt`). The leader's deterministic `garden-orchestrate` watcher promoted, watched, and completed them; its outcome summary reads "All children succeeded."
- Surfaced the arming steps and the design's open questions to the maintainer inbox at 23:40Z, and a "landed and verified, ready to arm" follow-up at 00:05Z.

**What landed (by the builders):**
- `a71081d81` — child 1 `build-transcript-capture`, the full § Builder spec items 1–8: `common.sh` knobs + `transcript_spool`; the spool hook in `gardener-claude.sh` immediately before the existing `rm -f` (rm and rationale untouched); `transcript-capture.sh` (cleanupPeriodDays=36500 jq reconcile first, inert-exit when `config/transcripts-remote` is absent, blobless+sparse `transcripts2` clone, redact+`gzip -n` sweep with idle gating, verified CAS push, spool/ledger cleared only after verification); `set-transcripts-remote.sh`; every-host `garden-transcript-capture` timer at :20 (no leader gate); launcher seed; 20-assertion test; `context/operations/transcripts.md`.
- `8e97b86c7` — child 2 `build-liaison-broadcast-reader`: liaisons now drain `role/liaison` + `broadcast` via `read-msgs.sh "liaison-$GARDEN" …` (per-host seen-key) on bring-up and at checkpoints — making the already-queued `cleanupPeriodDays` notice deliverable — plus the bring-up transcript-arming offer in `starting.md` (offer-only, never self-armed).

**My verification (not just the builders' word):** re-ran `scripts/jobs/test/transcript-capture-test.sh` from the landed tree myself — 20/20 PASS; confirmed the spool-hook placement and the intact false-resume `rm`; reviewed child 2's full diff (2 files, +51, links and script references sound).

**Follow-ups:**
- **Maintainer (permissioned, surfaced to inbox):** arm the archive — create a **private** repo (recommended `kriskowal/garden-transcripts`), grant the bot push, run `scripts/jobs/set-transcripts-remote.sh <url>`, record a journal `message` entry. Open questions awaiting your call: private repo as plan of record; liaison sessions in scope (default yes); idle threshold (`GARDEN_TRANSCRIPT_IDLE_SECS`, default 21600).
- The new timer/units activate on each host at its next deliberate deploy of main2; the settings reconcile then converges every host (including this one) within the hour.
- Deferred by design, to file when wanted: local janitor for pushed originals, `find-transcript.sh`, branch rotation.
- Fleet observation worth keeping: a pure-supervision job idling between events gets non-productive-requeued (~10 min cadence); riding the sanctioned treadmill (per-cycle worktree commit + foreground polls) is the working pattern for long supervisors.
