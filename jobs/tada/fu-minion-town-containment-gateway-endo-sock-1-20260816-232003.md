All containment invariants hold — no drift. Read-only SSM check succeeded and matches the original containment report and the prior daily.

---

**Outcome: No containment drift detected.** Read-only drift check against the deployed minion.town host (`i-0380cd68b90020fad`, us-west-1) via SSM Run Command (`CommandId 8d9a0aca-c7d7-438a-97e8-d714fc200752`, Success), verified against the original `minion-town-containment-gateway-endo-sock` report and consistent with the prior daily (08-15).

- **Drop-in intact** — `/etc/systemd/system/endo-gateway.service.d/zz-containment-20260812.conf` PRESENT with original contents (`UnsetEnvironment=GATEWAY_ENDO_SOCK`; `SupplementaryGroups=` reset then re-added `endo-weblet-store`), full containment header comment unchanged.
- **Powers plane disarmed live** — `endo-gateway.service` active (MainPID 1523162, unchanged since the 08-15 check — no restart since); `GATEWAY_ENDO_SOCK` **absent** from the running process environ, not merely configured. Boot log confirms `powers plane : disabled (GATEWAY_ENDO_SOCK unset — /.well-known fails closed)`.
- **Both de-registered records still absent** — `f1d754fc…c56cdd3.json` and `fe0a8e60…cb1748a0.json` both absent from the active store `/var/lib/endo-gateway/store/` and still preserved (225 bytes each, original 08-12 timestamps) in `vhosts-revoked-20260812/`.
- **No recurrence** — `grep '"powers":"@agent"'` across the active store returns **0** records. No CD-redeploy restoration.

**Actions taken:** none required — no de-registration to re-run, no maintainer notification (reserved for a reappearance), no repo change, no commit/push.

**Follow-ups:** none new. The permanent fix (`minion-town-weblet-powers-host-escape-fix`) remains the standing out-of-scope follow-up that would let this daily drift check be retired.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-minion-town-containment-gateway-endo-sock-1-20260816-232003.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (348039 cached reads)
- Output: 4699 tokens
- Cost: $0.6610805
- Wall-clock: 66s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
