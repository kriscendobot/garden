Verification-only job — no garden-library edits, no commit/push, no maintainer message (quiet no-change pass per the job's reporting rule). Inbox is empty.

## Completion report

**Containment drift check for kriscendobot/minion.town gateway records — CLEAN no-change pass.** Reported quietly per the job; no maintainer inbox alert warranted.

**What I did:** Ran a **recursive** read-only scan of the live vhost store `/var/lib/endo-gateway/store/vhosts/` on the deployed minion.town EC2 host `i-0380cd68b90020fad` (us-west-1) via SSM `AWS-RunShellScript` (garden-fleet creds, account 292378781985). The store does not exist on this container host; it lives on the deployed box. Enumerated the whole subtree with `os.walk` (not a root-only glob), matched the three de-registered hashes whitespace-tolerantly on both filenames and whitespace-collapsed record content, and cross-checked owner/powers fields and the revoked store. Used a `set -e`-free base64-delivered python summary per the recorded gotchas (avoids SSM shorthand mangling and the spurious no-match "Failed" status); RC=0, full output, no truncation.

**Findings (all clean — no alert):**
- **Three de-registered records ABSENT from the active store:** `f1d754fc…`, `fe0a8e60…`, `09201a3162…` — 0 filename hits and 0 whitespace-collapsed content hits across all 54 active records.
- **All three present in the revoked store** `vhosts-revoked-20260812/` (3 files) — de-registration intact; no CD redeploy has restored them.
- **No unexpected active dckc-owned record.** dckc-owned active set = **20**, unchanged from the 09-04→09-16 baseline. (Caught and corrected a first-pass over-count: classifying by the shared Cognito *pool* string inflates to 50; the baseline classifies by dckc's *sub* `8929a9ae…` — sub-only gives the true 20.)
- **Powers-bearing store-wide = same 4:** the two known-inert dckc weblets `806fc2ea…`=`counter` and `c016601e…`=`@none`, plus non-dckc `f220b5fe…`=`powers-fixture` and `a0eeea3c…`=`formula:live-deploy-verification`. No new powers record.
- **Total active records = 54, unchanged; 0 unparseable.**

**Per the job:** deliberately did NOT assert the systemd containment drop-in — the powers plane is authorized-OPEN under issue #58 (drop-in `…disabled-issue58`), which is the intended state, not drift. The scan completed fully, so there is no "inability to scan" finding.

**Follow-ups:** None. Verification-only; no garden-library edits, no commit/push, no maintainer message (quiet no-change pass). Recorded the 09-20 datapoint in the `minion-town-deployed-topology` memory. Check recurs daily.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-minion-town-containment-gateway-endo-sock-1-20260920-045008.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (698771 cached reads)
- Output: 12195 tokens
- Cost: $1.2114844999999999
- Wall-clock: 188s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
