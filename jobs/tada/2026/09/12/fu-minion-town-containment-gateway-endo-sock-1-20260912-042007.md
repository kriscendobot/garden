Inbox is empty. The recursive containment drift check is complete — a clean no-change pass. No garden repo changes are warranted (this is an operational verify-and-report job), and per the quiet-reporting rule I am sending no maintainer alert.

## Completion report

**Job:** Containment drift check for `kriscendobot/minion.town` gateway de-registered records (retuned 2026-09-02 version).

**How I ran it:** Read-only **recursive** scan of the live vhost store `/var/lib/endo-gateway/store/vhosts/` (a subdirectory — `find -type f`, not a root-only glob) on the deployed prod host `i-0380cd68b90020fad` (us-west-1) via AWS SSM Run Command with `garden-fleet` creds. Checked each de-registered hash by filename, plain content grep, **and** whitespace-tolerant content match (`tr -d '[:space:]'` then grep). Then dumped the record schema and tallied owners to assess "no unexpected active dckc-owned record."

**Findings — CLEAN no-change pass (baseline unmoved from 2026-09-11):**
- **Three de-registered records ABSENT** from the active store: `f1d754fc…`, `fe0a8e60…`, and `09201a316203e9d99e3c906b12c9466d8f0ae8dc8baf8db484c918d6698f657f` — zero filename, plain-content, and whitespace-tolerant hits across all 54 active records. All three confirmed **present** in `vhosts-revoked-20260812/`. No CD redeploy has restored them.
- **dckc-owned active set = 20** (owner sub `8929a9ae-b001-709d-02ea-e94df6225c0a`), exactly the established baseline: 18 content-only + the 2 known powers weblets `806fc2ea…`=`counter` and `c016601e…`=`@none` (both previously surfaced 09-03/09-04, benign, non-`@agent`).
- **No `@agent`/`@host` powers record anywhere** in the store.
- **Powers-bearing records store-wide = 4**, all baseline (`counter`, `@none`, `powers-fixture`, `formula:live-deploy-verification`); none carries an exposed/host power.
- **Total records = 54**, unchanged (no growth). No reappearance; no new or unexpected dckc-owned record. Recursive scan completed successfully.

**What NOT verified (correctly):** Did not assert or re-arm the systemd containment drop-in — the powers plane is authorized-open under kriscendobot/minion.town#58 (the drop-in is renamed `…disabled-issue58`); OPEN is the authorized state, not drift.

**Reporting:** No-change → reported quietly. **No maintainer inbox alert sent** (reserved for reappearance / unexpected records / inability to scan; none occurred).

**Changes:** None to the garden repo (operational verify-and-report job).

**Follow-ups:** None. Recurring daily check; next tick continues the same recursive-scan procedure.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-minion-town-containment-gateway-endo-sock-1-20260912-042007.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (839749 cached reads)
- Output: 10787 tokens
- Cost: $1.2808125
- Wall-clock: 174s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
