Clean no-change pass, identical to the 2026-09-09 baseline. No maintainer inbox alert needed (reported quietly per the job's instructions).

## Containment drift check — 2026-09-10

**Access:** The store is not on this endolin garden host; scanned the live gateway on the deployed minion.town EC2 host (`i-0380cd68b90020fad`, us-west-1) via SSM `AWS-RunShellScript`, base64-piped to the remote `/usr/bin/dash`, iterating `find … -type f` **recursively** over the `vhosts/` subdirectory with whitespace-tolerant filename + content matching (not the retune-corrected root-only glob).

**Findings — PASS:**
- **All three de-registered records ABSENT** from the active store `/var/lib/endo-gateway/store/vhosts/` — `f1d754fc…`, `fe0a8e60…`, and `09201a316203e9d99e3c906b12c9466d8f0ae8dc8baf8db484c918d6698f657f` — zero filename hits and zero content hits anywhere in the recursive tree. No CD redeploy has restored them.
- **All three confirmed present in the revoked store** `vhosts-revoked-20260812/` (1 filename hit each).
- **No unexpected active dckc-owned record.** dckc-owned count = **20**, unchanged from the 09-09 baseline. Total active records = **54**, unchanged.
- **Powers-bearing records unchanged** — the same 4: two dckc (`806fc2ea…`=`counter`, `c016601e…`=`@none`) and two non-dckc (`f220b5fe…`=`powers-fixture`, `a0eeea3c…`=`formula:live-deploy-verification`).
- **No `@agent`/`@host` escape-shape record** is active (empty escape scan).

Per the retune I did **not** assert or re-arm the systemd containment drop-in — the powers plane is authorized-open under kriscendobot/minion.town#58, which is the authorized state, not drift. The two known dckc powers weblets (`counter`/`@none`) are the pre-existing maintainer-decision item already surfaced 09-03/09-04; per "report no-change quietly" I did not re-surface them.

## Changes
None — verification-only. No garden-library edits, no commit, no maintainer inbox message (quiet no-change pass).

## Follow-ups
None new. The only still-open item is the unchanged, pre-existing maintainer decision on the two known dckc powers weblets. The check recurs daily.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-minion-town-containment-gateway-endo-sock-1-20260910-040511.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (429152 cached reads)
- Output: 6633 tokens
- Cost: $0.847914
- Wall-clock: 119s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
