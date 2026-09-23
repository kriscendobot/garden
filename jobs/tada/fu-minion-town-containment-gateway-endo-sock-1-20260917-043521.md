Inbox empty. The recursive containment drift check is a clean no-change pass, so I am reporting quietly with no maintainer alert and no garden-repo changes.

## Completion report

**Job:** Containment drift check for `kriscendobot/minion.town` gateway de-registered records (retuned 2026-09-02 version).

**How I ran it:** Read-only **recursive** scan of the live vhost store `/var/lib/endo-gateway/store/vhosts/` on prod host `i-0380cd68b90020fad` (us-west-1) via AWS SSM Run Command (`garden-fleet` creds). Each de-registered hash was checked three ways per file — filename, plain-content grep, and **whitespace-tolerant** content match (`tr -d '[:space:]'`, records are pretty-printed JSON). Owner/powers tallies were done with a JSON parser to survive the spacing. `find` walked the whole tree (not a root-only glob) — the store holds 54 files across 1 directory (flat, but enumerated recursively so a nested record could not hide).

**Findings — CLEAN no-change pass (baseline unmoved from 2026-09-16):**
- **Three de-registered records ABSENT** from the active store — `f1d754fc…`, `fe0a8e60…`, and `09201a316203e9d99e3c906b12c9466d8f0ae8dc8baf8db484c918d6698f657f`: zero hits by filename, plain content, and whitespace-tolerant content across all 54 active records. All three confirmed still present in `vhosts-revoked-20260812/`. No CD redeploy restored them.
- **Active record count = 54** — unchanged baseline.
- **dckc-owned active set = 20** (owner sub `8929a9ae-b001-709d-02ea-e94df6225c0a`) — exactly the established baseline; no new/unexpected dckc record.
- **Powers-bearing records = 4**, all baseline and benign: `806fc2ea…`=`counter`, `a0eeea3c…`=`formula:live-deploy-verification`, `c016601e…`=`@none`, `f220b5fe…`=`powers-fixture`. **No host-shaped (`@agent`/`@host`/`@self`/`@main`) powers string anywhere.**
- No unparseable/anomalous files.

**What NOT verified (correctly):** Did not assert or re-arm the systemd containment drop-in — the powers plane is authorized-open under `kriscendobot/minion.town` issue #58; OPEN is the authorized state, not drift.

**Reporting:** No-change → reported quietly. No maintainer inbox alert (reserved for reappearance / unexpected active dckc record / inability to scan; none occurred). Inbox drained, empty.

**Changes:** None to the garden repo (operational verify-only job).

**Follow-ups:** None. Recurring daily check; next tick continues the same recursive-scan procedure.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-minion-town-containment-gateway-endo-sock-1-20260917-043521.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (676607 cached reads)
- Output: 7622 tokens
- Cost: $1.0019164999999999
- Wall-clock: 137s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
