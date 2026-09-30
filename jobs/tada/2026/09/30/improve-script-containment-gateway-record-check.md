I've written `scripts/jobs/containment-gateway-record-check.sh` and set the daily containment schedule to run it directly as its preflight. A clean day no longer uses an agent claim. A live read-only run against the gateway host took about 4 seconds, scanned 57 records and came back clean.

The schedule only starts working this way once the script reaches this host: it is on `main2` but not yet in the deployed checkout. If the next tick (around 2026-10-01T01:50Z) runs before that, the scheduler will send one "missing preflight / deploy-lag" note to the maintainer inbox and dispatch the agent tick as it does today.

**What the script does:**
- **One bounded scan.** It sends a single SSM command to `i-0380cd68b90020fad` that walks `/var/lib/endo-gateway/store/vhosts/` recursively and reads every record. A 90-second overall deadline keeps it inside the scheduler's 120-second limit, and the scan on the host also has its own timeout.
- **What counts as a finding:**
  - any of the three de-registered records (`f1d754fc…`, `fe0a8e60…`, `09201a31…`) matching by filename or by content with whitespace ignored;
  - any dckc-owned record outside the 20 accepted today;
  - any record that can't be read or parsed.
- **Fixing a reappearance.** A de-registered record found active under its own filename is moved back to `vhosts-revoked-20260812/`, the same step as the original de-registration. An existing copy there is not overwritten; the new one gets a `.reappeared-<ts>` suffix. The store is then rescanned in the same run to prove it is clean. Anything else is reported, never moved. `--no-remediate` makes a run read-only.
- **Exit codes.** A clean pass exits 2 and prints nothing, so the scheduler just advances the clock. A finding or a scan failure exits 0 and writes a report to stdout and to the scheduler's context file. Any failure (AWS or SSM error, deadline passed, no completion marker from the scan) counts as a finding, never a quiet pass.
- **No drop-in check.** It still does not check the systemd containment drop-in, because the open powers plane is authorized under issue #58.

**Other changes:**
- **Test:** `scripts/jobs/test/containment-gateway-record-check-test.sh` runs the scan against local fixture directories, with no AWS. All 17 checks pass. It covers a clean store, a reappeared record in a subdirectory being moved and rescanned, not overwriting an existing revoked copy, read-only mode, a content reference split by whitespace, an unexpected dckc record, an unparseable record, and a missing store.
- **Commit:** `2a5c1991779`, pushed to `main2`.
- **Schedule:** on `journal2`, `schedules/fu-minion-town-containment-gateway-endo-sock-1.md` now carries `preflight: containment-gateway-record-check.sh`. Its body is rewritten for findings-only ticks: pass the report to the maintainer inbox, re-run the script once on a scan failure, and add maintainer-accepted dckc records to `DCKC_BASELINE`.

**Things to know:**
- **Leader-host dependency.** The scheduler runs only on the leader, which is currently this host and has working AWS credentials. If the leader moves to a host without them, every tick becomes a scan-failure report rather than silence.
- **Hard-coded dckc baseline.** The 20 accepted dckc records are in the script and match exactly the IDs the 09-28 and 09-29 reports listed. A new accepted record needs an edit to `main2`.
- **Today's timed-out job.** The job still sitting in `doin` (`fu-…-20260930-015006`, the one that hit its 2400-second limit) was left alone.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-script-containment-gateway-record-check.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 62 tokens (2260911 cached reads)
- Output: 21297 tokens
- Cost: $1.5876422
- Wall-clock: 235s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
