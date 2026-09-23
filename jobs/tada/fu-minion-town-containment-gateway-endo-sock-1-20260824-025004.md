Drift check complete — containment fully intact, no change since the original job.

# Completion Report — `fu-minion-town-containment-gateway-endo-sock-1-20260824-025004`

**Outcome: no change. Containment holds; nothing to re-do.** Read-only drift check against the deployed minion.town host (`i-0380cd68b90020fad`, us-west-1) via SSM Run Command `e22b7474-db60-4c50-98cc-675bc6c09c2c` (Status: Success). No garden-repo changes; nothing committed. Per the job's instruction, reporting the no-change result quietly — no maintainer inbox message sent (reserved for a reappearance).

## What I verified

1. **Systemd drop-in disarming the powers plane — PRESENT and effective.** `/etc/systemd/system/endo-gateway.service.d/zz-containment-20260812.conf` present with SHA-256 `a00e791997e05c7e8a4e074047d1fdbdbb07bf4cce184625c4a47ce3f2a01fc5` (matches the recorded value). Confirmed effective, not just on-disk:
   - `UnsetEnvironment=GATEWAY_ENDO_SOCK` present in the resolved unit (lines 84–86), overriding the `ARMED` fragment's `Environment=GATEWAY_ENDO_SOCK=…` (line 48).
   - Running gateway (MainPID 1574803) has **`GATEWAY_ENDO_SOCK` absent** from its environ (count = 0) — disarmed in the live process.
   - Boot log (latest Aug 23 04:35:18): `powers plane : disabled (GATEWAY_ENDO_SOCK unset — /.well-known fails closed)`. Service `active`.
   - Note: the gateway restarted since the last check (MainPID 1569282 → 1574803, fresh boot Aug 23 04:35). The drop-in survived the restart and the powers plane remained disabled — consistent with a normal restart, not a CD redeploy that re-armed.

2. **The two de-registered `@agent` gateway records — still ABSENT from the active store.** Both `f1d754fc…c56cdd3.json` and `fe0a8e60…cb1748a0.json` are found **only** under `/var/lib/endo-gateway/store/vhosts-revoked-20260812/` (active-store count = 0 each). A scan for `"powers":"@agent"` across the active store (excluding the revoked dir) returns **NONE_ACTIVE**. No CD-redeploy recurrence.

## Follow-ups
- None. Containment unchanged since the original job; no re-registration to reverse. The permanent fix (`minion-town-weblet-powers-host-escape-fix`) remains the standing out-of-scope follow-up.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-minion-town-containment-gateway-endo-sock-1-20260824-025004.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 25 tokens (591365 cached reads)
- Output: 6183 tokens
- Cost: $0.8341555
- Wall-clock: 106s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
