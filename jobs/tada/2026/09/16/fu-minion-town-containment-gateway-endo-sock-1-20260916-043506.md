Inbox empty. The check is a clean no-change pass — nothing to commit (operational verify-only job) and no maintainer alert warranted under the quiet-reporting rule.

## Completion report

**Job:** Containment drift check for `kriscendobot/minion.town` gateway de-registered records (retuned 2026-09-02 version).

**How I ran it:** Read-only **recursive** scan of the live vhost store on prod host `i-0380cd68b90020fad` (us-west-1) via AWS SSM Run Command with `garden-fleet` creds. Records are pretty-printed JSON, so each de-registered hash was checked three ways per file — filename, plain-content grep, and **whitespace-tolerant** content match (`tr -d '[:space:]'`) — and owner/powers tallies were done with a JSON parser to survive the spacing.

**Findings — CLEAN no-change pass (baseline unmoved from 2026-09-13):**
- **Three de-registered records ABSENT** from the active store `/var/lib/endo-gateway/store/vhosts/`: `f1d754fc…`, `fe0a8e60…`, and `09201a316203e9d99e3c906b12c9466d8f0ae8dc8baf8db484c918d6698f657f` — zero hits by filename, plain content, and whitespace-tolerant content across all 54 active records. All three confirmed present in `vhosts-revoked-20260812/`. No CD redeploy restored them.
- **Active record count = 54** — unchanged baseline.
- **dckc-owned active set = 20** (owner sub `8929a9ae-b001-709d-02ea-e94df6225c0a`) — exactly the established baseline; no new/unexpected dckc record.
- **Powers-bearing records = 4**, all baseline and benign: `806fc2ea…`=`counter`, `a0eeea3c…`=`formula:live-deploy-verification`, `c016601e…`=`@none`, `f220b5fe…`=`powers-fixture`. **No `@agent`/`@host`/`@self`/`@main` (host-shaped) powers string anywhere.**
- Recursive scan completed successfully (whole store tree enumerated, not a root-only glob).

**What NOT verified (correctly):** Did not assert or re-arm the systemd containment drop-in — the powers plane is authorized-open under `kriscendobot/minion.town` issue #58; OPEN is the authorized state, not drift.

**Reporting:** No-change → reported quietly. No maintainer inbox alert sent (reserved for reappearance / unexpected active dckc record / inability to scan; none occurred). Inbox drained, empty.

**Changes:** None to the garden repo (operational verify-only job).

**Follow-ups:** None. Recurring daily check; next tick continues the same recursive-scan procedure.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-minion-town-containment-gateway-endo-sock-1-20260916-043506.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (731427 cached reads)
- Output: 12504 tokens
- Cost: $1.3216864999999998
- Wall-clock: 172s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
