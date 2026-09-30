---
role: gardener
tier: mentor
handler-timeout: 3600
split-indivisible-reason: 'single atomic scan-remediate-rescan of one live SSM-reached store (/var/lib/endo-gateway/store/vhosts); remediation must be proven by a rescan in the same run, so no part stands alone; the overrun came from hand-scanning, now scripted by scripts/jobs/containment-gateway-record-check.sh (main2 2a5c1991779)'
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-30T04:34:04Z cleared=none -->

---
role: gardener
tier: mentor
fallback-tier: minion
handler-timeout: 3600
split-indivisible-reason: single atomic scan-remediate-rescan of one live SSM-reached store (/var/lib/endo-gateway/store/vhosts); remediation must be proven by a rescan in the same run, so no part stands alone; the overrun came from hand-scanning, now scripted by scripts/jobs/containment-gateway-record-check.sh (main2 2a5c1991779)
dispatch: automatic
---
# Containment drift check for kriscendobot/minion.town gateway records (expanded window)

Resumes `fu-minion-town-containment-gateway-endo-sock-1-20260930-015006`, which overran its 2400s wall scanning by hand.

Run the deterministic check instead of scanning by hand:

    scripts/jobs/containment-gateway-record-check.sh --verbose

(from the deployed garden scripts; if the deployed root lags main2 2a5c1991779,
run it from a per-job worktree of main2). It recursively scans
/var/lib/endo-gateway/store/vhosts/ over SSM, asserts the three de-registered
records (f1d754fc…, fe0a8e60…, 09201a316203e9d99e3c906b12c9466d8f0ae8dc8baf8db484c918d6698f657f)
are absent (filename + whitespace-tolerant content match) and that no unexpected
dckc-owned active record exists, moves a reappeared record back to the revoked
store, and rescans.

- Exit 2 (clean): report no-change QUIETLY.
- Exit 0 (finding or scan failure): relay the report to the maintainer inbox via
  message-user.sh — an inability to scan is a finding, not a quiet pass.

Do NOT check or re-arm the systemd containment drop-in: the powers plane is
authorized OPEN under kriscendobot/minion.town issue #58.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-30T04:44:34Z
