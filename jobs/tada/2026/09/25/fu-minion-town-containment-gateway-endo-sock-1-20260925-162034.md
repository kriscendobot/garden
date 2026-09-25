## Completion report: fu-minion-town-containment-gateway-endo-sock-1-20260925-162034

**Result: nothing changed and the check passed.** I did not alert the maintainer, because the job says to report a clean result quietly.

**How I checked:** I ran one read-only scan on the minion.town host (`i-0380cd68b90020fad`) through SSM Run Command. It walked every subdirectory of `/var/lib/endo-gateway/store/vhosts/`. For each record it checked the filename and also the content with all whitespace removed, so a reformatted record would still match.

**What I found:**
- **All three de-registered records are still gone from the active store.** Neither the filenames nor the whitespace-stripped contents matched `f1d754fc…`, `fe0a8e60…` or `09201a3162…`. All three are still in `store/vhosts-revoked-20260812/`.
- **The active store has 55 record files, and all 55 parse.** That is the same count as on 09-24.
- **dckc still owns 20 active records.** I matched them by dckc's user ID (`8929a9ae-b001-709d-02ea-e94df6225c0a`), not by the Cognito pool ID. That count is unchanged, so there is no unexpected dckc-owned record.
- **The same 4 records carry a `powers` field:**
  - `806fc2ea…` (`counter`) and `c016601e…` (`@none`) belong to dckc. The 09-16 audit found both harmless because they use the old record format and the gateway returns 404 for them.
  - `f220b5fe…` (`powers-fixture`) and `a0eeea3c…` (`formula:live-deploy-verification`) are not dckc's.
- As the retuned job says, I did not check the systemd containment drop-in. It is intentionally open under minion.town issue #58.

**What changed:** Nothing on the host, and nothing was committed to `main2`. I added a one-line entry for this run to my `minion-town-deployed-topology` memory file.

**Follow-ups:** None.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-minion-town-containment-gateway-endo-sock-1-20260925-162034.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (169129 cached reads)
- Output: 2382 tokens
- Cost: $0.4687458
- Wall-clock: 31s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
