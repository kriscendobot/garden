Implemented and pushed journal contention monitoring to `main2`.

Commits:
- `0ee659b7da` — host-local lock, fetch, push-retry, and outage-latch instrumentation.
- `5fd533bcc1` — anomaly checker, read-only probe, automatic clone remedy, systemd timer/service, bulletin summary, tests, and operations docs.

Built thresholds:
- 256-sample analysis window; 512-line rings; 5-minute cadence.
- Hard guards: fetch ≥31.5s, any lock give-up, >3 steals, 50 push attempts or definite failure, latch >600s, clone ≥2 GiB/≥50 packs/`gc.log`.
- Baselines: median + 3×MAD with floors of fetch 15s, lock 60s, push 5 attempts.
- Drift: newest-third median ≥1.5× oldest-third, floors fetch 10s/lock 20s/push 3, plus fetch projection to the guard within 24h.
- Baseline/drift requires two ticks; hard guards alert immediately.
- Automatic clone rebuild backoff: 6 hours.

Verification:
- New contention scenarios: PASS.
- Job-system suite: 386 passed, 0 failed.
- Fetch/common suite: 18 passed, 0 failed.
- Cursor suites: 59 passed and 8 passed, 0 failed.
- Clone keeper: 47 passed, 0 failed.
- Unit enablement: 40 passed, 0 failed.
- Root-repo guard: 76 passed, 0 failed.
- Comment-latency scenarios: PASS.
- Shell syntax, focused shellcheck, and diff checks passed.
- The broader `tests/checks/run.sh` still reports four unrelated suites failing: container-hardening shellcheck, two gauntlet suites, and maintainer-inbox information hiding.

Read-only host probe completed successfully with 111 output lines. Current notable per-clone results:
- `deadmail/verify`: 7,894,839,296 bytes, 38 packs, fetch p95 2.158s.
- `ci-watcher/verify`: 6,151,414,784 bytes, 40,806 packs.
- `maintainer-approval/verify`: 3,088,752,640 bytes, 25,267 packs.
- `comment-watcher/verify`: 2,726,339,584 bytes, 18,595 packs.
- `pages-watcher/verify`: 2,522,218,496 bytes, 13,039 packs, fetch p95 4.136s.
- `approval-reconciler/verify`: 2,433,368,064 bytes, 10,943 packs.
- Worst fetch p95: `foreman/journal` at 10.085s of the 45s cap.
- Totals: 6 clones over 2 GiB; 13 at the pack guard; 0 outage skips; latch off.
- Checker heartbeat is expectedly absent until the normal rolling deploy installs and starts the new timer. No manual deployment was run.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-journal-contention-watch.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 5 on 2 host(s) (1 unmetered)
- Input: 306 tokens (26248050 cached reads)
- Output: 168481 tokens
- Cost: $35.2041585 (1 engagement(s) unpriced)
- Wall-clock: 4828s
- Model(s): claude-opus-4-8 ×4

<!-- garden-usage-end -->
