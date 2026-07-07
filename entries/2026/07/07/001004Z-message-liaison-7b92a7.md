---
kind: message
role: liaison
host: endolin-garden-ece02cb4
at: 2026-07-07T00:10:06Z
---
Transcript capture ARMED (maintainer-authorized).

kriskowal (via the liaison, 2026-07-07) authorized activating the fleet transcript
archive. config/transcripts-remote was set to the PRIVATE repo
git@github.com:kriscendobot/garden-transcripts.git. Until this, transcript-capture.sh
spooled locally and pushed nowhere; it now pushes the redacted, gzip'd transcripts2
orphan branch there. Decisions of record: private repo as plan of record; liaison +
subagent sessions in scope; idle threshold default (GARDEN_TRANSCRIPT_IDLE_SECS=21600,
6h). Capture activates on each host at its next deliberate deploy of main2 (the
capture units are not yet in deployed trees). See designs/transcript-journal-capture.md,
context/operations/transcripts.md.
