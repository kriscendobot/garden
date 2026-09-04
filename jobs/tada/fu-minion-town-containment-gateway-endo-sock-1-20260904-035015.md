The recursive containment drift check is complete. No garden-repo changes were required (this is a verify-and-report job).

## Completion report

**Job:** Containment drift check for `kriscendobot/minion.town` gateway records (RETUNED 2026-09-02 version).

**How I ran it:** Scanned the live vhost store on the deployed host `i-0380cd68b90020fad` via SSM Run Command, recursively (`find … -type f`, not a root-only glob), with a whitespace-tolerant content+filename match. I did **not** assert anything about the systemd containment drop-in — the powers plane being open is the authorized 08-27 state, and I did not alarm on it.

**A methodology trap I caught and corrected:** my first scan's `read -d ''` loops failed silently under the host's `/bin/dash` (`Illegal option -d`), which would have produced false confidence on exactly the content-based and dckc-owner checks that matter. Per the job's own warning against manufactured confidence, I re-ran with dash-safe newline iteration (filenames are pure hex) and verified the shell before trusting output. The whitespace tolerance also proved load-bearing: owner values on this host embed a literal space (`…mDaTgjr1m 8929a9ae-…`).

**Core result — PASS (quiet):** All three de-registered records (`f1d754fc…`, `fe0a8e60…`, `09201a3162…`) remain **ABSENT** from the active store (`/var/lib/endo-gateway/store/vhosts/`, 49 records) and are confirmed present in `vhosts-revoked-20260812/`. No CD redeploy has restored them.

**One finding, reported to the maintainer inbox (not a quiet pass):** The recursive scan surfaced **two new dckc-owned records carrying a legacy `powers` field**, absent from the 08-12 baseline and not part of the de-registered set:
- `806fc2ea…` — `powers:"counter"`
- `c016601e…` — `powers:"@none"` (identical contentRoot `31a85b3c…`, no `directoryId`)

Neither is the dangerous `@agent`/host-escape class, and both are legacy-shaped records the post-#51 serve path ignores (inert cruft) — but they are dckc-owned and powers-bearing, the exact attribute pair behind the 08-31 incident, so I surfaced them rather than silently passing or unilaterally acting (they aren't reappearances of the named records, and the powers plane is deliberately open, making de-registration a maintainer call). The other two active powers records (`a0eeea3c` non-dckc `formula:live-deploy-verification`; `f220b5fe` ownerless `powers-fixture`) are the unchanged 08-12 baseline. The remaining 18 dckc records are plain content weblets.

**Follow-up (owned by maintainer):** decide whether `806fc2ea` (counter) and `c016601e` (@none) should be revoked into `vhosts-revoked` or left as known owner experimentation on the opened powers plane. Message delivered: `inbox/maintainer 20260904T035619Z-15ba80`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-minion-town-containment-gateway-endo-sock-1-20260904-035015.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (819324 cached reads)
- Output: 20101 tokens
- Cost: $1.3796347500000001
- Wall-clock: 315s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
