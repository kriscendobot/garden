**Report: minion-town-claude-bot-restart-canary**

**Result: item 6 can't be shown yet.** minion.town has no Claude bot that comes back after a daemon restart, so there was nothing to test. I wrote up the gap (step 3 of the job) instead of gathering evidence.

**Code path** (read-only, minion.town `main` @ `be0edb8`, pinned Endo `1706e63247fb`):
- **The Endo side is ready.** The pinned Endo commit is 211 commits ahead of endojs/endo-but-for-bots#1306's implementation commit `9e16e50b1`, with 0 behind. So the daemon minion.town runs already has `provideGuest(..., { pins })`, the per-guest pin directories, and the wake on every mailbox delivery.
- **minion.town doesn't use it:**
  - `src/endo/root-host-socket.ts:383` calls `provideGuest(petName, { agentName })` without `pins`.
  - Nothing in `src/` references `@pins` or `followMessages()`.
  - No per-guest responder is ever created.
  - `src/endo/claude/inbox-watch.ts` (`makeInboxWatcher`) has no callers outside its tests.
- **Today a Claude agent only runs when a caller invokes `infer`** (an MCP tool call or a delegated peer). The only things that survive a restart are bookkeeping: credentials, the delegation tree and quota reservations (`delegation-store.ts`, reloaded in `wiring.ts` `subscriptionFor`), and reauth events. Nothing wakes a bot when a message arrives.

**What I did:**
- Posted the gap report on garden issue 89: https://github.com/kriscendobot/garden/issues/89#issuecomment-6019847604. It lists the five missing pieces from endojs/endo-but-for-bots#1227's pattern, ending with the test that would prove it (restart a scratch daemon, send a message, check the effect with a store read).
- Posted one builder job, `build-minion-town-claude-pinned-responder`, for the gap. It asks for a draft PR adding a pinned responder per opted-in guest that drives `makeInboxWatcher`, plus that restart test.

I didn't restart the production daemon, touch any credential, switch identity, or ferry. I made no garden repo changes, so there was no commit.

**Follow-ups:**
- Item 6 stays unchecked until that build lands and deploys.
- Then the evidence run: wait for the next natural CD restart of `endo-daemon`, send one message, and confirm the result with a server-side store read.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-claude-bot-restart-canary.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (692398 cached reads)
- Output: 5980 tokens
- Cost: $0.7238156
- Wall-clock: 77s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
