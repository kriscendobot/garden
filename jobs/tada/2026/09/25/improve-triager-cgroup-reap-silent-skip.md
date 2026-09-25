The triager's cgroup straggler sweep now logs a WARN whenever it skips, instead of returning with no log. The change is pushed to `main2` as `6fc21936148`, and `scripts/jobs/test/triager-test.sh` passes 162/162.

**What changed** (`scripts/jobs/triager.sh`, `triager_reap_cgroup_stragglers`): each of the three early returns now writes one line before returning 0:
- **No cgroup-v2 line:** `WARN: cgroup reap skipped — no cgroup-v2 '0::' line in /proc/self/cgroup`
- **Wrong cgroup:** `WARN: cgroup reap skipped — leaf '<leaf>' is not a garden-triager@*.service cgroup (<cgpath>)`
- **Unreadable process list:** `WARN: cgroup reap skipped — <procs> unreadable`

A skipped sweep can now be told apart in the journal from a normal pass that found no stragglers.

**Test:** I added a case (P3) to `scripts/jobs/test/triager-test.sh`. It runs a tick outside any `garden-triager@*.service` cgroup without the test-only cgroup fixture, and checks that the tick exits 0 and logs `WARN: cgroup reap skipped`. It passes on this host by hitting the wrong-cgroup case. The other two cases have no test.

**Follow-ups:**
- Any triager run outside its systemd service, such as a manual run, now logs the wrong-cgroup WARN once per run. That is intended, since it is diagnostic only.
- The next time systemd reports "Found left-over process" for a triager unit, look for these WARNs in the same window. If they are absent, the sweep ran and missed the processes instead of skipping, and that would need its own investigation.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-triager-cgroup-reap-silent-skip.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (355763 cached reads)
- Output: 3721 tokens
- Cost: $0.4787646
- Wall-clock: 61s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
