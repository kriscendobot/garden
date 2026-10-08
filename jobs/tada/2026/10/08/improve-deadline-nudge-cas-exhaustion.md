Exhausted CAS retries in `scripts/jobs/deadline-nudge.sh` are now a clean deferral that's logged once per streak, with a regression test. It's pushed to `main2` as `042dca1b33c`. The full `deadline-nudge-test.sh` suite passes (64 passed, 0 failed).

**What changed**
- **The fix:** when every push attempt in a tick loses a classified lost race, the tick no longer ends with an ERROR and `return 1`. It now calls a new `push_contended` helper instead, so the 2026-10-08T19:26:26Z case no longer produces any of its three warnings (the stage ERROR, the EXIT-trap ERROR, and the "tick failed locally" WARN). The helper:
  - resets the scanner's private clone to the synced tip, so the next tick recomputes every warning that is still due;
  - keeps a count of consecutive contended ticks in a host-local file, `deadline-nudge/cas-contention-streak`;
  - logs one non-error deferral line on the first contended tick of a streak and stays silent on later ones;
  - returns 0, so the next timer tick simply retries.
- **Recovery:** the next successful push deletes the count file and logs "push contention cleared after N deferred tick(s)". I gave contention no maintainer alert because it isn't a fault. Rejected and ambiguous pushes still alert as before.
- **Regression test:** a push stub always fails with a ref-lock lost-race error. The test checks three things:
  - the first tick returns 0 with no ERROR, WARN or alert, and leaves the clone clean;
  - a second contended tick doesn't repeat the log line;
  - a normal run afterwards delivers the warning and logs the clear.

The new lines add no shellcheck warnings.

**Follow-up:** this suite now takes over 10 minutes on oros-studio under load (load average about 4.6), so a run with a 10-minute timeout gets killed. That's worth keeping in mind when setting test timeouts on this host.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-deadline-nudge-cas-exhaustion.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1306348 cached reads)
- Output: 9272 tokens
- Cost: $0.9848775999999999
- Wall-clock: 2237s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
