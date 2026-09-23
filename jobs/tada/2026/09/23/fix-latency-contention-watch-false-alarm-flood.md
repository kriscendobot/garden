The job is already complete. A prior attempt of this same job committed and pushed the full fix as `987bb13b9b` ("fix(watches): stop the latency/contention false-alarm flood"), which is now HEAD and identical to `origin/main2`. I re-derived the state, verified the fix addresses every defect in the spec, and confirmed all test suites pass.

## Completion report

**Status:** Already committed and pushed to `main2` (987bb13b9b); working tree clean; local HEAD == origin/main2. No new work needed beyond verification.

**What the landed fix does, mapped to the 5 spec defects:**

1. **comment-latency-watch dead-classification** — Heartbeat/outcome ages are clamped at 0 and the clock is re-read for the heartbeat pass (the `age=-13s` came from a heartbeat written after `now` was sampled). `outcome=cooldown`/offline-journal is now **muted** within the stuck bound (design §2/§4); beyond it it's a distinct `comment-watcher-stuck-cooldown-host` class alerted **once at host level**, never as 16 per-repo "dead" notices. Only a genuinely stale heartbeat (>3×cadence) classifies as dead.

2. **journal-clone-oversized recalibration** — Rethresholded from the live distribution (healthy: 0–128 packs, ≤335 MB; pathological: 1,391–40,806 packs, 4.2–90 GB). Guard now keys on **size (4 GiB)** and **gc.log presence**, with a **1000-pack backstop** (order of magnitude above the healthy population). Healthy 55 MB / 57-pack clones are no longer flagged or churn-rebuilt.

3. **journal-fetch-drift below floor** — Drift is now gated by the 10s floor on **both** the ratio and projection paths, and requires **≥12 samples over ≥1h**, so short-lived per-job inbox clones never qualify. Samples older than 6h age out.

4. **test-fixture path leaking into live stats** — `fetch-timeout-test` was writing its fixture clones into the live rings (`journal-lock-contention-_home_kris__garden_fetch_test_clone`); it now uses an isolated temp root + ring dir, and a `GARDEN_TEST=1` context with no explicit `GARDEN_CONTENTION_DIR` records nothing.

5. **Self-closing + storm guard** — Notices whose key is no longer evaluated close via `--recovered`, retiring the old flood. Both watches gained a fleet-wide storm guard: >5 distinct keys of one class in a tick collapse into a single `comment-latency-storm-<class>` / `journal-contention-storm-<class>` summary.

**Verification I ran:** `comment-latency-watch-test` PASS; `journal-contention-watch-test` PASS; `fetch-timeout-test` 18/18 PASS.

**Follow-ups:** none. Rollout proceeds through the normal rolling deploy; the `--recovered` logic will retire the ~70 outstanding false notices as the new rules take effect on each host.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-latency-contention-watch-false-alarm-flood.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 96 tokens (5231583 cached reads)
- Output: 50696 tokens
- Cost: $3.8841044999999994
- Wall-clock: 730s
- Model(s): claude-opus-5-5 ×1, claude-opus-4-8 ×1

<!-- garden-usage-end -->
