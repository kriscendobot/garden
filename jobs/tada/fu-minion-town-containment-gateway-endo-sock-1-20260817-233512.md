All containment invariants hold — no drift, no reappearance, no action required. This is a read-only SSM check with no repo change, so nothing to commit.

---

**Outcome: No containment drift detected.** Read-only drift check against the deployed minion.town host (`i-0380cd68b90020fad`, us-west-1) via SSM Run Command (`CommandId 92573baf-6f17-4b74-b306-e4499fd6a7fc`, Success), verified against the original `minion-town-containment-gateway-endo-sock` report and consistent with the prior daily (08-16).

- **Drop-in intact** — `/etc/systemd/system/endo-gateway.service.d/zz-containment-20260812.conf` PRESENT with original contents (full containment header comment unchanged; `UnsetEnvironment=GATEWAY_ENDO_SOCK`; `SupplementaryGroups=` reset then re-added `endo-weblet-store`).
- **Powers plane disarmed live** — `endo-gateway.service` active; `GATEWAY_ENDO_SOCK` **absent** from the running process environ (count=0), not merely configured. Boot log confirms `powers plane : disabled (GATEWAY_ENDO_SOCK unset — /.well-known fails closed)`.
- **Both de-registered records still absent** — `f1d754fc…c56cdd3.json` and `fe0a8e60…cb1748a0.json` both absent from the active store `/var/lib/endo-gateway/store/{,vhosts/}` and still preserved (225 bytes each, original 08-12 timestamps) in `vhosts-revoked-20260812/`.
- **No recurrence** — `grep '"powers":"@agent"'` across the active store returns **0** records outside the revoked dir.

**Notable this cycle (does not constitute drift):** the gateway *did* restart since the 08-16 check — MainPID moved `1523162 → 1537000`, with a fresh boot log line stamped `Aug 17 23:38:03Z`. This is exactly the CD-redeploy scenario the job warns about ("a redeploy leaves the drop-in intact but can restore the two records"). In this case the drop-in survived the restart **and** the two records did **not** reappear — the containment held cleanly across the redeploy. No re-registration was needed.

**Actions taken:** none required — no de-registration to re-run, no maintainer notification (reserved for a reappearance), no repo change, no commit/push. Reported quietly per the job's instruction.

**Follow-ups:** none new. The permanent fix (`minion-town-weblet-powers-host-escape-fix`) remains the standing out-of-scope follow-up that would let this daily drift check be retired.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-minion-town-containment-gateway-endo-sock-1-20260817-233512.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 19 tokens (469602 cached reads)
- Output: 5203 tokens
- Cost: $0.7911719999999998 (1 engagement(s) unpriced)
- Wall-clock: 84s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
