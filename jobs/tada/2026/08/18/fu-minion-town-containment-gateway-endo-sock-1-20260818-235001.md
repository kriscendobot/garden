All containment invariants hold. No drift, no reappearance. This is a read-only check with no repo changes to commit.

# Completion Report — `fu-minion-town-containment-gateway-endo-sock-1-20260818-235001`

**Outcome: No containment drift detected. No action required.** Read-only drift check against the deployed minion.town host (`i-0380cd68b90020fad`, us-west-1) via SSM Run Command (`CommandId a7fb46a5-6f53-4055-95bc-26951c5ce404`, Success), verified against the original `minion-town-containment-gateway-endo-sock` report and consistent with the prior daily (08-17).

- **Drop-in intact** — `/etc/systemd/system/endo-gateway.service.d/zz-containment-20260812.conf` PRESENT with original contents byte-for-byte (full containment header comment unchanged; `UnsetEnvironment=GATEWAY_ENDO_SOCK`; `SupplementaryGroups=` reset then re-added `endo-weblet-store`).
- **Powers plane disarmed live** — `endo-gateway.service` active; `GATEWAY_ENDO_SOCK` **absent** from the running process environ (count=0), not merely configured. Boot log confirms `powers plane : disabled (GATEWAY_ENDO_SOCK unset — /.well-known fails closed)`.
- **Both de-registered records still absent** — `f1d754fc…c56cdd3.json` and `fe0a8e60…cb1748a0.json` both absent from the active store (excluding the revoked dir) and still preserved (225 bytes each, original 08-12 timestamps) in `vhosts-revoked-20260812/`.
- **No recurrence** — `grep '"powers":"@agent"'` across the active store returns **0** records outside the revoked dir.

**Notable this cycle (does not constitute drift):** the gateway restarted again since the 08-17 check — MainPID moved `1537000 → 1538609`. This is again the CD-redeploy scenario the job warns about. As before, the drop-in survived the restart **and** the two records did **not** reappear — containment held cleanly across the redeploy. No re-registration needed.

**Actions taken:** none — no de-registration to re-run, no maintainer notification (reserved for a reappearance), no repo change, no commit/push. Reported quietly per the job's instruction.

**Follow-ups:** none new. The permanent fix (`minion-town-weblet-powers-host-escape-fix`) remains the standing out-of-scope follow-up that would let this daily drift check be retired.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-minion-town-containment-gateway-endo-sock-1-20260818-235001.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 13 tokens (301626 cached reads)
- Output: 5642 tokens
- Cost: $0.6784799999999999
- Wall-clock: 98s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
