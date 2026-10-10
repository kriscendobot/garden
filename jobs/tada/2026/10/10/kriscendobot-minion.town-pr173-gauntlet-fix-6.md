Fix round 6 for kriscendobot/minion.town PR #173 is done: the fix is pushed and CI passed. I checked again in this session: the PR head is still commit `077ff6c5c05` and all 3 checks report SUCCESS.

**Must-fix applied (the critic's finding 1).** The design contradicted itself about when a `robots.txt` hit alerts. I made the tripwire and the honeypot observe-only until the § 3.4 report promotes them, which matches the § 2 table ("observe; alert after the gate"). Two edits in `designs/ocap-site-crawler-leak-rotation.md`:
- **§ 4.2:** only signals that § 2 puts in the alert tier now alert regardless of timing. Tripwire and honeypot hits are recorded in `events()` but leave `state` unchanged until the gate. The text explains why: anyone holding a link can fetch `robots.txt`, so alerting on it would let them put the owner in `Alerted` whenever they like.
- **§ 8.1 canary step 3:** the canary now checks that `events()` records the tripwire hit, that `state` stays `Quiet` and that the label is unchanged. Before, it asserted `state = 'alerted'`.

The commit was pushed to `design/ocap-site-crawler-leak-rotation` with `safe-push-pr-head.sh`. `ci-wait-merge.sh --no-merge` returned 0.

**Not addressed:** the should-fix and comment-only items, left for a later round or the maintainer:
- No push channel delivers alerts to the owner.
- Gate 5 has no pre-floor baseline and no positive control for the vendor-range match.
- The vendor range snapshot may be too heavy for what it feeds.
- The warden's read access to the gateway's journald logs and the 14-day retention aren't checked as preconditions.
- The design doesn't state that `no-store` on private clips gives up long-lived caching.
- The claim that a crawler fetch means a link was pasted somewhere is still unverified.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr173-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 16 tokens (411719 cached reads)
- Output: 3410 tokens
- Cost: $1.035402
- Wall-clock: 45s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
