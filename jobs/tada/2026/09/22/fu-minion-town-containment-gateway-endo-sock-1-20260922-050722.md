Containment drift check complete — **clean no-change pass**, reported quietly per the job (no maintainer inbox alert).

## What I did
Ran a **recursive**, read-only scan of the live vhost store `/var/lib/endo-gateway/store/vhosts/` on the deployed minion.town EC2 box `i-0380cd68b90020fad` (us-west-1) via SSM Run Command (`AWS-RunShellScript`). Used the `set -e`-free compact Python summary (per the 09-15 gotcha), walking the subdirectory with `os.walk` (not a root-only glob), matching each target on both filenames and whitespace-collapsed content, and parsing `owner`/`powers` per record.

## Findings (all clean)
- **Three de-registered records remain ABSENT.** `f1d754fc…`, `fe0a8e60…`, and `09201a316203e9d99e3c906b12c9466d8f0ae8dc8baf8db484c918d6698f657f` each returned **0 filename hits and 0 whitespace-tolerant content hits** across all 54 records. No CD redeploy has restored them.
- **No unexpected active dckc-owned record.** dckc-owned set (Cognito sub `8929a9ae-b001-709d-02ea-e94df6225c0a`) = **20**, identical to the 09-04→09-18 baseline. The only two dckc records carrying a `powers` field are the same known-informational weblets `806fc2ea…` (`counter`) and `c016601e…` (`@none`) — already surfaced, maintainer decision pending; not re-flagged, not new.
- **Store-wide powers-bearing records = same 4:** those 2 dckc weblets + ownerless `f220b5fe…` (powers-fixture, safe) + `a0eeea3c…` (non-dckc live-deploy-verification). No new powers record.
- **Total records = 54**, unchanged; **0 unparseable**. Recursive scan completed fully — no "inability to scan" finding.
- Per the retune, I did **not** assert or re-arm the systemd containment drop-in — the powers plane is deliberately OPEN under kriscendobot/minion.town#58; that state is authorized, not drift.

## Changes / follow-ups
None. Verification-only check; no garden-library edits, no commit/push, no maintainer inbox message (quiet no-change pass, as instructed). Inbox drained — empty. Still-open (unchanged) item: the maintainer's pending decision on the two benign dckc powers weblets. The check recurs daily.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-minion-town-containment-gateway-endo-sock-1-20260922-050722.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (491470 cached reads)
- Output: 5724 tokens
- Cost: $1.146178
- Wall-clock: 94s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
