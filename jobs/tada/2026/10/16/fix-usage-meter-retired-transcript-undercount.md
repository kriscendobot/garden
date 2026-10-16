## Completion report: `fix-usage-meter-retired-transcript-undercount`

The usage meter now counts finished monk jobs' transcripts instead of losing them. The fix is commit `9fc0f74036c`, pushed to main2.

**What was wrong:** when a monk job finished, `monk-claude.sh` deleted its top-level session transcript so the session could never be resumed. The meter only reads transcripts still under `~/.claude/projects`, so each finished job's top-level tokens dropped out of the host's `budget/live` spend. That is why spend stayed flat and went non-monotone on oros.

**What changed:**
- **`scripts/jobs/usage-meter.sh`**
  - New `GARDEN_RETIRED_TRANSCRIPTS` directory (default `$GARDEN_STATE/retired-transcripts`) and `GARDEN_RETIRED_TRANSCRIPT_MAX_AGE` (default 8 days).
  - New `meter_retire_transcript <path> <base>`: moves the transcript out of the projects tree to `<base>-<sid>.jsonl`, keeping its mtime, then prunes retired files past the max age. If the copy fails it still deletes the original, so resume safety comes before metering.
  - `_meter_session_total` and `_meter_entitlement_cutoff` now scan the retired directory alongside the logdir. Overlap between the two is covered by the existing message-id dedupe. A retired file also counts as proof the sensor works, so a host with only retired history reports a genuine idle 0 rather than "unknown".
- **`scripts/jobs/handlers/monk-claude.sh`:** on genuine completion it calls `meter_retire_transcript` for both project-dir encodings. The old `rm -f` stays as a fallback. Resume safety is unchanged because `<sid>.jsonl` no longer exists in the projects tree.
- **New test `scripts/jobs/test/meter-retired-transcript-test.sh` (10/10 pass).** It checks that a retired transcript:
  - leaves the projects tree, with its mtime kept
  - is still counted by `_meter_session_total` and `meter_window_total` inside the window
  - is excluded before the cutoff and pruned past 8 days
  - is not double-counted when a copy also sits in the logdir

  It also checks the idle-0 case and that a host with no session files anywhere still reports "unknown".

The commit message says that host spend figures will rise toward the truth after deploy. That shifts the inputs to `fit-quota-calibration.sh`, the accountant arc, `triager-pace.sh`, and the spend/cap status fallback. The claim gate reads utilization and is not affected.

**Other tests:** `transcript-capture`, `meter-journal-cutoff`, `quota-panel` and `augment-usage-session-delta` pass. `budget-live-percent-label-test.sh` fails ("weekly-tokens commit message changed"), but it fails the same way on an untouched main2 checkout, so this change didn't cause it.

**Follow-ups:**
- Someone should look at that failing `budget-live-percent-label` test separately.
- The per-job engagement ledger (`meter_job_session_usage`) was left alone on purpose: it already takes its after-snapshot before the transcript is removed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-usage-meter-retired-transcript-undercount.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (749414 cached reads)
- Output: 10129 tokens
- Cost: $0.8323027999999999
- Wall-clock: 130s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
