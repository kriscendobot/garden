Drift check complete. No inbox messages. This was a read-only production-containment check via SSM — no garden-repo changes, nothing to commit.

# Completion Report — `fu-minion-town-containment-gateway-endo-sock-1-20260827-030507`

**Outcome: no change. Containment holds; nothing to re-do.** Read-only drift check against the deployed minion.town host (`i-0380cd68b90020fad`, us-west-1) via SSM Run Command `1af25ee6-4219-423c-918c-f6070e6b9eac` (Status: Success). Per the job's instruction, reporting quietly — no maintainer inbox message sent.

## What I verified

1. **Systemd drop-in disarming the powers plane — PRESENT and effective.** `/etc/systemd/system/endo-gateway.service.d/zz-containment-20260812.conf` present with SHA-256 `a00e791997e05c7e8a4e074047d1fdbdbb07bf4cce184625c4a47ce3f2a01fc5` (matches the recorded value). `endo-gateway.service` `active` (MainPID 1574803, unchanged since the 08-24 check — no restart/redeploy in between); `GATEWAY_ENDO_SOCK` absent from the live process environ (count = 0); latest boot log reads `powers plane : disabled (GATEWAY_ENDO_SOCK unset — /.well-known fails closed)`.

2. **The two de-registered `@agent` gateway records — still ABSENT from the active store.** Both `f1d754fc…c56cdd3.json` and `fe0a8e60…cb1748a0.json` are `active=0 revoked=1` — present only under `/var/lib/endo-gateway/store/vhosts-revoked-20260812/`. No CD-redeploy recurrence of either.

3. **Whitespace-immune active-store `@agent` scan → NONE_ACTIVE.** Used a `json.load` + `.strip()` scan (per the 08-25 whitespace-sensitivity pitfall), so pretty-printed records cannot be missed. No active record carries powers `@agent`.

## Notable observation (no action required)
- The third dckc-owned `@agent` record that reappeared during the Aug 23 restart and was reported to the maintainer inbox on 2026-08-25 is **no longer active** — the scan returns zero `@agent` records. Its disappearance is a positive change, not a reappearance of a contained record, and the maintainer was already notified of it; no remediation or new notification is warranted.

## Remediation
- None. Neither contained record reappeared, so the recorded de-registration did not need to be re-run. The permanent fix (`minion-town-weblet-powers-host-escape-fix`) remains the standing out-of-scope follow-up.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-minion-town-containment-gateway-endo-sock-1-20260827-030507.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 27 tokens (711359 cached reads)
- Output: 12005 tokens
- Cost: $1.1263205000000003
- Wall-clock: 183s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
