Verification complete. No drift found — containment is fully intact.

## Completion Report — `fu-minion-town-containment-gateway-endo-sock-1`

**Outcome: no change. Containment holds; nothing to re-do.** Read-only drift check against the deployed minion.town host (`i-0380cd68b90020fad`, us-west-1) via SSM Run Command. No garden-repo changes, nothing committed. Per the job's instruction, reporting the no-change result quietly — **no maintainer inbox message sent** (that is reserved for a reappearance).

### What I verified against the original containment report

1. **Systemd drop-in disarming the powers plane — PRESENT and intact.**
   `/etc/systemd/system/endo-gateway.service.d/zz-containment-20260812.conf` exists with its original contents (`UnsetEnvironment=GATEWAY_ENDO_SOCK`, `SupplementaryGroups=` reset then `endo-weblet-store`). Confirmed it is *effective*, not just on-disk:
   - `UnsetEnvironment=GATEWAY_ENDO_SOCK` present in the resolved unit.
   - Running gateway process (MainPID 1506075) has **`GATEWAY_ENDO_SOCK` absent** from `/proc/<pid>/environ` — the powers plane is actually disarmed in the live process, not merely configured.
   - Latest boot log (Aug 12 22:45:13): `powers plane : disabled (GATEWAY_ENDO_SOCK unset — /.well-known fails closed)`. Service `active (running)`.
   - `SupplementaryGroups=endo-weblet-store` only (the `endo-daemon` socket group stays dropped, content plane preserved).

   *(Note: `systemctl show -p Environment` still lists `GATEWAY_ENDO_SOCK` — that is expected systemd display behavior; `UnsetEnvironment=` is a separate exec-time property and does not rewrite the `Environment=` show output. The running-process environ check is the authoritative one, and it is unset.)*

2. **The two de-registered `@agent` gateway records — still ABSENT from the active store.**
   Both `f1d754fc…c56cdd3.json` and `fe0a8e60…cb1748a0.json` are absent from `/var/lib/endo-gateway/store/` and remain preserved in `/var/lib/endo-gateway/store/vhosts-revoked-20260812/` (original mtimes 21:04 / 21:35). A `grep` for `"powers":"@agent"` across the active store returns **no active records**. No CD-redeploy recurrence.

### Follow-ups
- None. Containment unchanged since the original job; no re-registration to reverse. The permanent fix (`minion-town-weblet-powers-host-escape-fix`) remains the standing follow-up, out of scope here.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-minion-town-containment-gateway-endo-sock-1-20260812-230502.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 15 tokens (337299 cached reads)
- Output: 6162 tokens
- Cost: $0.6913285
- Wall-clock: 117s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
