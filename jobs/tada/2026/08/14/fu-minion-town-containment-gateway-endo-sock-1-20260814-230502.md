No drift. All containment invariants hold exactly as recorded. Reporting quietly — no maintainer inbox message (reserved for a reappearance), no production change, nothing to commit.

---

**Outcome: No containment drift detected.** Read-only drift check against the deployed minion.town host (`i-0380cd68b90020fad`, us-west-1) via SSM Run Command (`CommandId 15017946-7c18-49fe-832e-1d10d671df6a`, Success).

Verified against the original `minion-town-containment-gateway-endo-sock` report:

- **Drop-in intact** — `/etc/systemd/system/endo-gateway.service.d/zz-containment-20260812.conf` PRESENT with original contents (`UnsetEnvironment=GATEWAY_ENDO_SOCK`; `SupplementaryGroups=` reset then `endo-weblet-store`). Effective in the resolved unit (`UnsetEnvironment=GATEWAY_ENDO_SOCK`, `SupplementaryGroups=endo-weblet-store`).
- **Powers plane disarmed live** — `endo-gateway.service` active (MainPID 1518723); `GATEWAY_ENDO_SOCK` **absent** from the running process environ, not merely configured.
- **Both de-registered records still absent** — `f1d754fc…c56cdd3.json` and `fe0a8e60…cb1748a0.json` both absent from the active store `/var/lib/endo-gateway/store/` and still preserved in `vhosts-revoked-20260812/`.
- **No recurrence** — `grep '"powers":"@agent"'` across the active store returns **0** records. No CD-redeploy restoration.

**Actions taken:** none required — no de-registration to re-run, no maintainer notification, no repo change, no commit/push.

**Follow-ups:** none. The permanent fix (`minion-town-weblet-powers-host-escape-fix`) remains the standing out-of-scope follow-up.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-minion-town-containment-gateway-endo-sock-1-20260814-230502.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (455041 cached reads)
- Output: 6850 tokens
- Cost: $0.7982064999999999
- Wall-clock: 95s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
