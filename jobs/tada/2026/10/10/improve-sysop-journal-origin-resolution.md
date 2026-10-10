I've fixed the spurious "journal worktree yielded no origin; using cached journal remote" warning, and the fix is pushed to `main2` as `de3e1c46ce2`.

**What changed**
- The sysop and the gardener-scaler already look up the journal origin through the same function, `journal_remote` in `scripts/jobs/common.sh`. The scaler gets there through `ensure_clone`, so the scaler needed no change of its own.
- I added a new helper there, `_read_journal_worktree_origin`. It reads the journal worktree's `remote.origin.url` up to 3 times, 0.5s apart, before giving up. Two settings control it: `GARDEN_JOURNAL_ORIGIN_READ_ATTEMPTS` (default 3) and `GARDEN_JOURNAL_ORIGIN_READ_SLEEP` (default 0.5).
- `journal_remote` now uses that helper. It only falls back to the cache and logs the warning when every attempt reads empty. The existing check that refuses a fork URL still applies to the retried value.
- New cases in `scripts/jobs/test/fallback-warn-dedup-test.sh`:
  - if the first read is empty and the second works, there is no fallback and no warning;
  - if every read is empty, it tries exactly 3 times, falls back to the cache and logs one warning;
  - the attempt count can be changed.

**Tests:** all of these pass:
- `fallback-warn-dedup` (22)
- `journal-worktree-relink` (25)
- `journal-worktree-keeper` (117)
- `journal-remote-origin-rewrite-guard` (27)
- `journal-clone-seed-from-root` (15)
- `sysop` (59)
- `scaler-desired-count` (15)

**Follow-ups:** none. The change takes effect on each host at its next deploy. A real outage now makes each lookup up to about 1s slower before it falls back.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-sysop-journal-origin-resolution.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (806643 cached reads)
- Output: 6391 tokens
- Cost: $0.7466446000000002
- Wall-clock: 179s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
