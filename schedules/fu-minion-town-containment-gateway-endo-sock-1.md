cadence: daily
last_dispatched: 2026-10-03T02:20:06Z
job_basename_prefix: fu-minion-town-containment-gateway-endo-sock-1
preflight: containment-gateway-record-check.sh
---
---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Containment drift check for kriscendobot/minion.town gateway records — FINDINGS ONLY

This tick exists only because the deterministic preflight
`scripts/jobs/containment-gateway-record-check.sh` did NOT come back clean. Its
report is prepended above this body. Routine no-change checks never dispatch
(the preflight exits 2 and the scheduler just advances the clock).

The preflight already did the recursive scan of
`/var/lib/endo-gateway/store/vhosts/` on `i-0380cd68b90020fad` (SSM, us-west-1),
whitespace-tolerant matching of the three de-registered records (`f1d754fc…`,
`fe0a8e60…`, `09201a316203…`), the dckc-owned baseline comparison, and — for a
de-registered record found active under its own filename — the remediation
(move back to `store/vhosts-revoked-20260812/`) plus a proving rescan. Do NOT
redo that scan by hand; rerun the script instead:
`scripts/jobs/containment-gateway-record-check.sh --no-remediate --verbose`
(exit 2 = clean now).

## What to do

1. Relay the prepended report to the maintainer inbox
   (`scripts/jobs/message-user.sh`): any reappearance/remediation, any
   unexpected active dckc-owned record, any content reference, or any scan
   failure. An inability to scan is itself a finding, never a quiet pass.
2. For a SCAN FAILURE, diagnose briefly (AWS creds, SSM agent, instance state)
   and rerun the script once; report both results.
3. For a failed remediation move, or a finding the script does not auto-fix,
   report it and leave the fix to the maintainer's direction.
4. If the maintainer accepts a new dckc-owned record, add its id to
   `DCKC_BASELINE` in the script (main2) rather than re-reporting it daily.

## What NOT to verify

Do NOT assert or re-arm the systemd containment drop-in. The weblet powers plane
is deliberately OPEN under `kriscendobot/minion.town` issue #58; that is the
authorized state, not drift.
