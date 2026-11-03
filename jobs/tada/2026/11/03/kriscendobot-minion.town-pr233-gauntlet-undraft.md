**Gauntlet stage UNDRAFT: kriscendobot/minion.town PR #233**

PR #233 (https://github.com/kriscendobot/minion.town/pull/233) is now ready for review, un-drafted at the panel-passed head `899114970ca9aebe56f99f5f14d14cf151a5add7`.

- **Before un-drafting:** the PR was OPEN, still a draft, and its head matched exactly.
- **After un-drafting:** `isDraft` is false and the head is unchanged.
- **Changes:** I changed no code and made no garden commits.

**Advisory appellate pass (non-blocking)**

I ran `claude -p` on Sonnet over the PR diff, and none of this gated the un-draft. I didn't check these three findings against the code, and I haven't posted them on the PR, so this report is their only record:

1. **Liveness check can be skipped (`src/endo/guest-tools.ts`, `registerInviteTools`/`assertLive`):** if `facet.identify` is absent or returns `undefined`, the check is skipped. A link whose daemon slot was removed or rebound then reaches `acceptLocal` with a stale locator instead of failing as `invitation-unavailable`. The real socket adapter always defines `identify`, so this only matters for a degraded or older daemon.
2. **Superseded links can become uncancellable (`src/endo/guest-tools.ts`, superseded retire path):** `held.delete(petName)` runs before `await superseded()`, and the catch only logs. If the cancel throws or returns `"in-flight"`, the old link stays pending with no held cancel, so `cancelInvite` can't void it.
3. **Unbounded memory growth (`src/web/local-invitations.ts`):** accepted and spent entries stay in the `invitations` map until cancelled, and `inviters` and `held` are never pruned. An authenticated MCP caller looping invite and accept could grow memory without limit, though the impact is low.

**Follow-up (optional):** findings 1 and 2 compound, so they are the ones worth checking in a fixer pass or during maintainer review. I didn't post a follow-up job.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr233-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (160202 cached reads)
- Output: 2138 tokens
- Cost: $0.38448040000000006
- Wall-clock: 133s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
