## Completion report — containment drift check for `kriscendobot/minion.town` gateway records (RETUNED 2026-09-02)

**How I ran it:** Recursive scan of the live vhost store `/var/lib/endo-gateway/store/vhosts/` on the deployed host `i-0380cd68b90020fad` via SSM Run Command, using `find … -type f` (not a root-only glob) with whitespace-tolerant content+filename matching. Confirmed the host shell is `dash` and wrote the remote script dash-safe (newline iteration, no `read -d`; the owner values embed a literal space, matched tolerantly). Did **not** assert or re-arm the systemd containment drop-in — the powers plane is authorized-open under kriscendobot/minion.town#58, and I did not alarm on it.

**Core result — PASS (quiet):**
- All three de-registered records — `f1d754fc…`, `fe0a8e60…`, and `09201a316203e9d99e3c906b12c9466d8f0ae8dc8baf8db484c918d6698f657f` — remain **ABSENT** from the active store (no filename or content hits across 53 active records) and are confirmed **present** in `vhosts-revoked-20260812/`. No CD redeploy has restored them.
- No `@agent`/EndoHost-escape powers record is active.
- Only four powers-bearing active records, all the established baseline: two dckc-owned (`806fc2ea` `counter`, `c016601e` `@none`), ownerless `f220b5fe` `powers-fixture`, and non-dckc `a0eeea3c` `formula:live-deploy-verification`. dckc owner count stable at 20.

**No new or unexpected dckc-owned record appeared.** The two dckc powers records (`806fc2ea`/`c016601e`) are unchanged and were already surfaced to the maintainer inbox on 09-03 and 09-04 with a pending decision; they are benign (non-`@agent`, resolve attenuated/powerless), so per "report no-change quietly" I did **not** re-surface them a third time. No reappearance, no scan failure — no maintainer message warranted.

**Changed:** nothing in the garden repo (verify-and-report job). No follow-ups beyond the still-open maintainer decision on whether the two known dckc powers weblets should be revoked or left as authorized #58 experimentation.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-minion-town-containment-gateway-endo-sock-1-20260905-035032.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (629385 cached reads)
- Output: 8825 tokens
- Cost: $1.0163414999999998
- Wall-clock: 140s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
