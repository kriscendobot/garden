Containment drift check complete — **clean no-change pass**, reported quietly per the job's instructions (no maintainer inbox alert).

## What I did
Ran a read-only recursive scan of the live vhost store `/var/lib/endo-gateway/store/vhosts/` on the deployed minion.town host (`i-0380cd68b90020fad`, us-west-1) via SSM Run Command. The store is not present on this endolin garden host, so — as every prior tick has — the check was executed remotely against the live gateway. Confirmed the remote shell is `/usr/bin/dash` and wrote the script dash-safe (base64-piped, newline iteration, POSIX `[[:space:]]` matching). Scanned the store **subdirectory recursively** (`find … -type f`, not a root-only glob), matching both filenames and record content with whitespace-tolerant hash patterns.

## Findings — PASS, identical to the 2026-09-06 baseline
- **All three de-registered records remain ABSENT** from the active store — `f1d754fc…`, `fe0a8e60…`, and `09201a316203e9d99e3c906b12c9466d8f0ae8dc8baf8db484c918d6698f657f` — no filename hit and no content hit anywhere in the recursive tree. No CD redeploy has restored them.
- **All three confirmed present in the revoked store** `vhosts-revoked-20260812/` (1 hit each).
- **No unexpected active dckc-owned record.** dckc-owned count is **20**, unchanged. Total active records = **54**, unchanged.
- **Powers-bearing records unchanged** — the same 4: two dckc (`806fc2ea…`=`counter`, `c016601e…`=`@none`) and two non-dckc (`f220b5fe…`=`powers-fixture`, `a0eeea3c…`=`formula:live-deploy-verification`).
- **No `@agent`/`@host` escape-shape record is active** (empty escape scan).

Per the retune, I did **not** assert or re-arm the systemd containment drop-in — the powers plane is authorized-open under kriscendobot/minion.town#58; that open state is the authorized state, not drift. The two dckc powers weblets (`counter`/`@none`) are unchanged and were already surfaced to the maintainer inbox on 09-03/09-04 with a pending decision; per "report no-change quietly" I did not re-surface them.

## Changes
None — verification-only job. No garden-library edits, no commit, no maintainer inbox message (quiet no-change pass).

## Follow-ups
None. The check recurs daily; next tick re-runs the same recursive SSM scan. The only still-open item is the pre-existing maintainer decision on whether the two known dckc powers weblets should be revoked or left as authorized #58 experimentation — unchanged by this tick.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-minion-town-containment-gateway-endo-sock-1-20260909-040510.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (437108 cached reads)
- Output: 7897 tokens
- Cost: $0.875342
- Wall-clock: 197s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
