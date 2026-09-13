Inbox empty. The recursive containment drift check is a clean no-change pass. No garden repo changes are warranted (this is an operational verify-and-report job), and per the quiet-reporting rule I am sending no maintainer alert.

## Completion report

**Job:** Containment drift check for `kriscendobot/minion.town` gateway de-registered records (retuned 2026-09-02 version).

**How I ran it:** Read-only **recursive** scan (`find -type f`, not a root-only glob) of the live vhost store `/var/lib/endo-gateway/store/vhosts/` on the deployed prod host `i-0380cd68b90020fad` (us-west-1, `ip-172-31-19-16`) via AWS SSM Run Command with `garden-fleet` creds. Each de-registered hash was checked three ways — by filename, by plain content grep, and by **whitespace-tolerant** content match (`tr -d '[:space:]'` per file). Then tallied owners and dumped every powers-bearing record's `powers` value.

**Findings — CLEAN no-change pass (baseline unmoved from 2026-09-12):**
- **Three de-registered records ABSENT** from the active store: `f1d754fc…`, `fe0a8e60…`, and `09201a316203e9d99e3c906b12c9466d8f0ae8dc8baf8db484c918d6698f657f` — zero filename, plain-content, and whitespace-tolerant hits across all 54 active records. All three confirmed **present** in `vhosts-revoked-20260812/`. No CD redeploy has restored them.
- **dckc-owned active set = 20** (owner sub `8929a9ae-b001-709d-02ea-e94df6225c0a`) — exactly the established baseline.
- **Powers-bearing records store-wide = 4**, all baseline and confirmed by full content: `806fc2ea…`=`counter`, `c016601e…`=`@none` (both dckc, benign), `f220b5fe…`=`powers-fixture`, `a0eeea3c…`=`formula:live-deploy-verification`. **No `@agent`/`@host` or any host-shaped powers string anywhere.**
- **Total records = 54**, unchanged. No reappearance; no new or unexpected dckc-owned record. Recursive scan completed successfully.

**What NOT verified (correctly):** Did not assert or re-arm the systemd containment drop-in — the powers plane is authorized-open under kriscendobot/minion.town#58; OPEN is the authorized state, not drift.

**Reporting:** No-change → reported quietly. **No maintainer inbox alert sent** (reserved for reappearance / unexpected records / inability to scan; none occurred).

**Changes:** None to the garden repo.

**Follow-ups:** None. Recurring daily check; next tick continues the same recursive-scan procedure.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-minion-town-containment-gateway-endo-sock-1-20260913-042008.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (502936 cached reads)
- Output: 6211 tokens
- Cost: $0.8905660000000001
- Wall-clock: 101s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
