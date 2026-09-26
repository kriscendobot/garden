No drift detected — containment fully intact. No remediation, maintainer notification, or repo changes needed.

---

# Completion Report — `fu-minion-town-containment-gateway-endo-sock-1-20260823-024849`

**Outcome: no change. Containment holds; nothing to re-do.** Read-only drift check against the deployed minion.town host (`i-0380cd68b90020fad`, us-west-1) via SSM Run Command `02bf5791-761c-40ce-821a-3d236ec4f3c8` (Status: Success). No garden-repo changes; nothing committed. Per the job's instruction, reporting the no-change result quietly — no maintainer inbox message sent (reserved for a reappearance).

## What I verified

1. **Systemd drop-in disarming the powers plane — PRESENT and intact.** `/etc/systemd/system/endo-gateway.service.d/zz-containment-20260812.conf` present with SHA-256 `a00e791997e05c7e8a4e074047d1fdbdbb07bf4cce184625c4a47ce3f2a01fc5` (matches the recorded `a00e7919…a01fc5`). Confirmed *effective*, not just on-disk:
   - `UnsetEnvironment=GATEWAY_ENDO_SOCK` present in the resolved unit.
   - Running gateway (MainPID 1569282) has **`GATEWAY_ENDO_SOCK` absent** from its environ (count=0) — disarmed in the live process.
   - Latest boot logs (through Aug 22 05:56:01): `powers plane : disabled (GATEWAY_ENDO_SOCK unset — /.well-known fails closed)`. Service `active`.

2. **The two de-registered `@agent` gateway records — still ABSENT from the active store.** Both `f1d754fc…c56cdd3.json` and `fe0a8e60…cb1748a0.json` are found **only** under `/var/lib/endo-gateway/store/vhosts-revoked-20260812/` (original mtimes 21:35 / 21:04), not in the active store. A scan for `"powers":"@agent"` across the active store (excluding the revoked dir) returns **NONE_ACTIVE**. No CD-redeploy recurrence.

## Follow-ups
- None. Containment unchanged since the original job; no re-registration to reverse. The permanent fix (`minion-town-weblet-powers-host-escape-fix`) remains the standing out-of-scope follow-up.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-minion-town-containment-gateway-endo-sock-1-20260823-024849.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (344791 cached reads)
- Output: 4541 tokens
- Cost: $0.6733235
- Wall-clock: 70s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
