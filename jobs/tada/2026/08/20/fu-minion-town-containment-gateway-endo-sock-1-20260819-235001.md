All containment invariants hold — no drift, no reappearance. The check is complete and read-only (nothing to commit). Note the MainPID (1538609) is unchanged from the 08-18 check, so the gateway hasn't even restarted since the last verification.

# Completion Report — `fu-minion-town-containment-gateway-endo-sock-1-20260819-235001`

**Outcome: No containment drift detected. No action required.** Read-only drift check against the deployed minion.town host (`i-0380cd68b90020fad`, us-west-1) via SSM Run Command (`CommandId 9f8b7ec5-43be-4744-b44e-6b6dffa1296a`, Success), verified against the original `minion-town-containment-gateway-endo-sock` report.

- **Drop-in intact** — `/etc/systemd/system/endo-gateway.service.d/zz-containment-20260812.conf` PRESENT, contents byte-for-byte original (full containment header comment; `UnsetEnvironment=GATEWAY_ENDO_SOCK`; `SupplementaryGroups=` reset then re-added `endo-weblet-store`). sha256 `a00e7919…a01fc5`.
- **Powers plane disarmed live** — `endo-gateway.service` active; `GATEWAY_ENDO_SOCK` **absent** from the running process environ (count=0), not merely configured. Boot log confirms `powers plane : disabled (GATEWAY_ENDO_SOCK unset — /.well-known fails closed)`.
- **Both de-registered records still absent** — `f1d754fc…c56cdd3.json` and `fe0a8e60…cb1748a0.json` both absent from the active store and still preserved (225 bytes each, original 08-12 timestamps) in `vhosts-revoked-20260812/`.
- **No recurrence** — `grep '"powers":"@agent"'` across the active store returns **0** records outside the revoked dir.

**Notable:** unlike the last several cycles, the gateway did **not** restart since the 08-18 check — MainPID steady at `1538609`. No CD redeploy this cycle; containment held trivially.

**Actions taken:** none — no de-registration to re-run, no maintainer notification (reserved for a reappearance), no repo change, no commit/push. Reported quietly per the job's instruction.

**Follow-ups:** none new. The permanent fix (`minion-town-weblet-powers-host-escape-fix`) remains the standing out-of-scope follow-up that would let this daily drift check be retired.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-minion-town-containment-gateway-endo-sock-1-20260819-235001.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 2 host(s) (3 unmetered)
- Input: 11 tokens (264491 cached reads)
- Output: 5633 tokens
- Cost: $0.6831514999999999 (3 engagement(s) unpriced)
- Wall-clock: 180s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
