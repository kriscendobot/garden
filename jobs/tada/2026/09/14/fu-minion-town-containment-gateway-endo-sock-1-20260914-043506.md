Containment drift check complete — **clean no-change pass**, reported quietly per the job's instructions (no maintainer inbox alert).

## What I did
Ran a **recursive** SSM Run Command scan (`AWS-RunShellScript`, instance `i-0380cd68b90020fad`, us-west-1) of the live vhost store `/var/lib/endo-gateway/store/vhosts/` — enumerating the subdirectory with `find … -type f` (not a root-only glob), matching both filenames and record content whitespace-tolerantly, and cross-checking the revoked store and the per-record `owner`/`powers` fields. The store directory does not exist on this container host; it lives on the deployed minion.town EC2 box, reached read-only over SSM.

## Findings (no change from baseline)
- **All three de-registered records remain ABSENT from the active store** and present in `vhosts-revoked-20260812/`:
  - `f1d754fc1efcf4483edfe1c0aac57070cf39eaece43bc8990b1ed7020c56cdd3`
  - `fe0a8e602d181ffb6e87e4f2dba4701fd790e897165dbcc452a41707cb1748a0`
  - `09201a316203e9d99e3c906b12c9466d8f0ae8dc8baf8db484c918d6698f657f`
  - Both filename and content matches confirmed absent from the active tree; no CD redeploy has restored them.
- **No unexpected active dckc-owned record.** dckc-owned set (Cognito sub `8929a9ae-b001-709d-02ea-e94df6225c0a`) is **20**, identical to the 09-06 baseline: 18 content-only weblets + the same 2 powers-bearing weblets `806fc2ea…`=`counter` and `c016601e…`=`@none`. Both pre-date and survived the 08-31 de-registration, are authorized under issue #58, and were already surfaced to the maintainer inbox on 09-03/09-04 with a pending decision — per "report no-change quietly" I did not re-surface them.
- **No dangerous `@agent`/`@host` escape record is active** (the shape that got `09201a3162…` pulled). Escape-shape grep returned empty.
- Store-wide powers-bearing records unchanged: the same 4 — the 2 dckc (`counter`, `@none`) plus ownerless `f220b5fe…`=`powers-fixture` and non-dckc `a0eeea3c…`=`formula:live-deploy-verification`.
- Total active records: **54**, matching the 09-06 tick.
- Per the retune, I did **not** assert or re-arm the systemd containment drop-in — the powers plane is deliberately open under kriscendobot/minion.town#58; that open state is authorized, not drift.

## Changes
None. Verification-only check; no garden-library edits, no commit/push, no maintainer inbox message (quiet no-change pass, as instructed). Inbox drained — empty.

## Follow-ups
None new. The still-open item is the maintainer's pending decision (from 09-03/09-04) on whether the two known benign dckc powers weblets (`counter`, `@none`) should be revoked or left as authorized #58 experimentation. The check recurs daily.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-minion-town-containment-gateway-endo-sock-1-20260914-043506.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (760515 cached reads)
- Output: 12740 tokens
- Cost: $1.3987704999999997
- Wall-clock: 359s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
