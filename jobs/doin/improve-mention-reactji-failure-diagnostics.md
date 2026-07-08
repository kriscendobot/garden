scripts/jobs/handlers/mention-reactji-gh.sh
The reactji POST at line 44 is invoked as `gh_api_retry ... >/dev/null 2>&1`, which swallows `gh_api_retry`'s diagnostic WARN (rc + gh's stderr, and its definitive-vs-transient classification). The only surviving trace is the terse info-level `reactji POST failed on $path`, which is below WARN so it's filtered out of the mentor's `journalctl -p warning` tail. Result: a reactji failure (observed once this tick: `WARN: reactji failed on issue-comment/4833847468`) reaches the mentor with no cause, making recurring-vs-benign undiagnosable. Change: keep `>/dev/null` (discard the success payload) but drop the `2>&1` so `gh_api_retry`'s stderr diagnostic reaches the journal; capture gh's stderr and upgrade the handler's own failure line to a `WARN:` that includes the reason (rc/response). Additionally, classify a definitive 404 (deleted/absent comment or issue — a benign ack race) as a silent skip (`exit 0`, info log) rather than an error, so a deleted-comment race stops masquerading as a failure worth a WARN, and a real 403/permission failure stands out. Do not change the watcher's continue-on-failure behavior — the ack must remain non-fatal to job posting.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 18
  claimed_at: 2026-07-08T02:52:13Z
