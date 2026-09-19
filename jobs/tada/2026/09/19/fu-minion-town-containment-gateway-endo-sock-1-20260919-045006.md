Containment drift check complete — **clean no-change pass**, reported quietly per the job (no maintainer inbox alert warranted).

## What I did
Ran a **recursive** read-only scan of the live vhost store `/var/lib/endo-gateway/store/vhosts/` on the deployed minion.town EC2 host `i-0380cd68b90020fad` (us-west-1) via SSM `AWS-RunShellScript`. The store does not exist on this container host; it lives on the deployed box, reached over SSM. Enumerated the whole subtree with a recursive `find`-equivalent (not a root-only glob), matched the three de-registered hashes whitespace-tolerantly on **both filenames and record content**, and cross-checked owner/powers fields and the revoked store. Used a `set -e`-free compact python summary per the recorded gotcha; it returned RC=0 with full output (no truncation).

## Findings (all clean — no alert)
- **Three de-registered records remain ABSENT from the active store:** `f1d754fc…`, `fe0a8e60…`, `09201a3162…` — each 0 filename hits and 0 whitespace-collapsed content hits across all 54 active records.
- **All three present in the revoked store** `vhosts-revoked-20260812/` (3 files) — de-registration intact, no CD redeploy has restored them.
- **No unexpected active dckc-owned record.** dckc-owned active set = **20**, unchanged from the 09-04/09-06/09-11/09-14/09-15 baseline.
- **Powers-bearing records store-wide = same 4:** the two known-informational dckc weblets `806fc2ea…` and `c016601e…`, plus ownerless `f220b5fe…` (powers-fixture) and non-dckc `a0eeea3c…` (live-deploy-verification). No new powers record.
- **Total active records = 54**, unchanged; 0 unparseable.
- Per the retune, I did **not** assert or re-arm the systemd containment drop-in — the powers plane is deliberately OPEN under kriscendobot/minion.town#58 (authorized state, not drift).

## Changes / follow-ups
None. Verification-only; the scan completed fully so there is no "inability to scan" finding. No garden-library edits, no commit/push, no maintainer message (quiet no-change pass). Inbox drained — empty. Check recurs daily.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-minion-town-containment-gateway-endo-sock-1-20260919-045006.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (506189 cached reads)
- Output: 6433 tokens
- Cost: $0.8573525000000001
- Wall-clock: 101s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
