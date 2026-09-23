Fix pushed to main2.

## Completion report

**What I did:** Fixed the unguarded post-success cursor advance in `scripts/jobs/triager.sh`. The `printf ... | cursor-set.sh "$CURSOR_KEY"` call (lines 537-538) was a bare piped command under `set -euo pipefail` with no rc guard — the sole cursor-set.sh call site missing one. When cursor-set.sh returned nonzero (journal push contention or the `exit 75` outage rc), `set -e` killed the whole tick silently after triage had already succeeded and posted its job, marking the unit Failed with no follow-up log line (the observed `garden-triager@kriscendobot-minion.town` symptom).

**What changed:** Wrapped the pipe in `if ... then rc=0; else rc=$?; fi` and, on nonzero rc, log a `WARN: cursor advance failed ... will re-advance next tick` and `exit 0` — staying quiet on the shared `GARDEN_OFFLINE_RC` (75) so a single journal outage doesn't warn per repo. This mirrors the existing cursor-**read** guard directly above it (lines 481-484) and `comment-watcher.sh` (~2185), so the write side now matches the read side's idiom exactly. A stalled cursor is safe: the next tick re-triages the same old→new range and `post-job.sh`'s deterministic basename makes the re-post idempotent.

**Verification:** `bash -n` passes. Committed with explicit pathspec and pushed to `main2` (`913e1d0d1d..3dc215a57d`).

**Follow-ups:** None. This was the last unguarded cursor-set.sh call site per the job's audit.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-triager-cursor-set-unguarded-pipefail.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (313796 cached reads)
- Output: 3004 tokens
- Cost: $0.919997
- Wall-clock: 54s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
