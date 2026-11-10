Production minion.town is unreachable by name because its DNS records were changed. The app itself is fine, nobody in the fleet has a record of the change, and I've asked the maintainer about it. No jobs were posted, nothing was merged or closed, and no garden code changed.

**What's wrong:**
- **Since about 13:14Z,** Route53's authoritative answer for `minion.town` and `ocap.site` is `34.225.237.208`. The production host is EIP `13.56.17.18`. That new address runs Caddy and serves a static page that says "There are no accounts here". Every app route answers 404 there.
- **The subdomains are gone.** `npm.`, `ci.`, `github-idp.` and `siwe-idp.minion.town` no longer resolve, so the zone seems to have been rewritten down to its apex records.
- **The real host is healthy.** Pinned to `13.56.17.18`, `/mcp` answers 401 and `/soon` answers 200. `main` is still `5111704`, and nothing has merged or deployed since kriscendobot/minion.town#255.
- **The prod probe has been red** since 14:52Z (run 42838548453, then 42849949670 at 15:58Z), raised as alert kriscendobot/minion.town#256. The last green run was 42820303493 at 12:58Z. The 13:35Z tick reported no change because it only looked at the 12:58Z green run.
- **The garden's MCP watchdog** has reported the minion.town connection lost since 13:14Z. That is the same DNS failure.

**What I did:**
- **Maintainer inbox:** one question, message `msg-minion-town-arc-press-20261110-163511-75a23ad64b38`. If the repoint is deliberate, I'll re-baseline the arc and the probe. If it isn't, it may be a zone compromise: someone with credentials needs to restore the records to `13.56.17.18` and check the Route53 change history. This host has no AWS credentials, so I didn't try to revert anything myself.
- **Issue 58:** posted comment https://github.com/kriscendobot/garden/issues/58#issuecomment-6773216247. No checklist box changed.

**Unchanged:**
- **Merge delegation:** still `active`.
- **Open PRs:** none has been updated since 2026-11-08, so there was nothing new to carry.
- **Leader deploy:** the leader still runs `f2788117645`. The EROFS project-checkout failure reproduced again at 16:37Z. The earlier question about the leader deploy is still unanswered.
- **Held re-arms:**
  - weave and then conduct #246
  - re-review panels for #237 and #252
  - the panel and review follow-up for #248
  - extra gauntlet rounds for #254
  - the waitlist browser check

**Follow-ups, once the maintainer answers:**
- If DNS is restored, confirm the prod probe goes green and kriscendobot/minion.town#256 closes.
- If the move was deliberate, re-baseline the issue 58 checklist, the probe targets, and the deployment record.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-arc-press-20261110-163511.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (2050634 cached reads)
- Output: 11591 tokens
- Cost: $1.3189387999999997
- Wall-clock: 327s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
