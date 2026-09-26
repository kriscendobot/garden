All containment invariants hold. No drift. Reporting quietly per the job's contract — no maintainer inbox message (reserved for a reappearance), no de-registration to re-run, no production change, nothing to commit.

---

**Outcome: No containment drift detected.** Read-only drift check against the deployed minion.town host (`i-0380cd68b90020fad`, us-west-1) via SSM Run Command (`CommandId d8cfde07-a8fc-4cc0-86f9-8cb57a691690`, Success), verified against the original `minion-town-containment-gateway-endo-sock` report and consistent with the prior daily (08-14).

- **Drop-in intact** — `/etc/systemd/system/endo-gateway.service.d/zz-containment-20260812.conf` PRESENT with original contents (`UnsetEnvironment=GATEWAY_ENDO_SOCK`; `SupplementaryGroups=` reset then `endo-weblet-store`). Effective in the resolved unit (fragment still ships `Environment=GATEWAY_ENDO_SOCK=…`/`SupplementaryGroups=endo-daemon endo-weblet-store`, but the drop-in overrides both — net: `UnsetEnvironment=GATEWAY_ENDO_SOCK`, `SupplementaryGroups=endo-weblet-store`).
- **Powers plane disarmed live** — `endo-gateway.service` active (MainPID 1523162); `GATEWAY_ENDO_SOCK` **absent** from the running process environ, not merely configured. (PID differs from 08-14's 1518723 — the service restarted at some point, but rebooted disarmed, confirming the drop-in's persistence across restart.)
- **Both de-registered records still absent** — `f1d754fc…c56cdd3.json` and `fe0a8e60…cb1748a0.json` both absent from the active store `/var/lib/endo-gateway/store/` and still preserved (225 bytes each, original timestamps) in `vhosts-revoked-20260812/`.
- **No recurrence** — `grep '"powers":"@agent"'` across the active store returns **0** records. No CD-redeploy restoration.

**Actions taken:** none required — no de-registration to re-run, no maintainer notification, no repo change, no commit/push.

**Follow-ups:** none new. The permanent fix (`minion-town-weblet-powers-host-escape-fix`) remains the standing out-of-scope follow-up that would let this daily drift check be retired.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-minion-town-containment-gateway-endo-sock-1-20260815-232002.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 18 tokens (394775 cached reads)
- Output: 5969 tokens
- Cost: $0.7248935
- Wall-clock: 84s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
