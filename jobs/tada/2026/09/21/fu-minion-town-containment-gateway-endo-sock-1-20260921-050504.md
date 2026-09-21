Containment drift check complete — clean no-change pass, reported quietly per the job.

## What I did
Ran a **recursive** scan of the live vhost store `/var/lib/endo-gateway/store/vhosts/` on `i-0380cd68b90020fad` (minion-town-garden) via SSM Run Command, read-only. Used a whitespace-collapsing match on both filenames and file contents (the method that distinguished the third record). Followed the 09-15 gotcha: a `set -e`-free compact Python summary (`os.walk` recursion) rather than a verbose scan that trips a spurious SSM "Failed" on a no-match grep.

## Findings (all clean — no maintainer alert warranted)
- **Three de-registered records ABSENT.** `f1d754fc…`, `fe0a8e60…`, and `09201a3162…` each returned 0 filename hits and 0 whitespace-collapsed content hits across all 54 records. No reappearance.
- **No unexpected active dckc-owned record.** dckc-owned active set = **20**, unchanged from the 09-04/09-06/09-11/09-15 baseline.
- **Powers-bearing records = same 4**, unchanged: two dckc weblets `806fc2ea…`=`counter` and `c016601e…`=`@none` (both known-informational, neither host-shaped), plus non-dckc `f220b5fe…`=`powers-fixture` (ownerless-safe) and `a0eeea3c…`=`formula:live-deploy-verification` (inert). No new powers record.
- **Total records = 54**, unchanged; 0 unparseable.
- Per the retuned job, I did **not** assert the systemd containment drop-in — the powers plane is deliberately OPEN under issue #58; open is the authorized state, not drift.

## Notes / follow-ups
- The recursive scan completed fully, so there is no "inability to scan" finding.
- No garden code changes; nothing to commit. Inbox drained (empty) at the checkpoint.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-minion-town-containment-gateway-endo-sock-1-20260921-050504.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (571980 cached reads)
- Output: 7251 tokens
- Cost: $0.9510580000000002
- Wall-clock: 233s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
