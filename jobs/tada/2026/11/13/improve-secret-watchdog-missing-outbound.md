**Completion report: improve-secret-watchdog-missing-outbound**

I fixed the secret watchdog crash and added a regression test for it. The fix is pushed to `main2` as `db769963d06`. The new test fails on the old script and passes with the fix.

**Cause:** in `scripts/secrets/watchdog.sh:40`, `find "$ledger/outbound/$kind"` exits nonzero when that directory doesn't exist. Because the script runs under `set -euo pipefail`, that one failure stopped the whole sweep. On 2026-11-13 this happened because `typesafe.key` was installed but there was no `outbound/typesafe` directory.

**What changed:**
- **Missing directory:** the script now checks for the directory before calling `find`. If it is missing, the key counts as having zero accepted uses, so idle time is measured from when the key was placed and the idle alert is still sent.
- **Repeat runs:** I fixed a second crash of the same kind. `alert_maintainer_edge` returns 1 when an alert's fingerprint hasn't changed, and the three places that call it (the unconsumed, age and idle alerts) would also have stopped a repeat sweep. Each call now ends in `|| true`.
- **Small cleanup:** `${newest:-placed}` is now `${newest:-$placed}`. It worked before, but only because bash read the bare word as a variable name.

**Test:** the new `scripts/jobs/test/secret-watchdog-test.sh` runs offline against a local journal repo. It installs a `typesafe.key` placed 40 days ago, with no `outbound/typesafe` in the ledger. It checks that:
1. the sweep exits 0;
2. the idle alert is raised with fingerprint `none:40:direct`;
3. a second sweep with the same fingerprint also exits 0.

**Follow-ups:** none needed. The deployed hosts will pick up the fix through the normal rolling deploy.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-secret-watchdog-missing-outbound.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (792140 cached reads)
- Output: 6416 tokens
- Cost: $0.7983
- Wall-clock: 112s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
