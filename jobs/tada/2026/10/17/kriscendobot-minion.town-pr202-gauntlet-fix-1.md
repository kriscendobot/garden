I pushed the round-1 must-fixes to PR #202. CI hasn't finished: the `test` job passed, but the two Claude-harness jobs never got a runner in the hour after the push. So this stage ends as **fix=still-pending**.

**Must-fix items applied** (commit `a59cf49` on `feat/chat-clip`, pushed with `safe-push-pr-head.sh` from `761001a` to `a59cf49`):

1. **Own handle as a "peer" exposed the whole mailbox** (raised by locksmith, saboteur, breaker and wire-watcher). The attack worked: a URL bearer could import the owner's own handle under a peer name, and every message then counted as "with that peer". With the old code, the new test listed the whole mailbox. In `src/endo/gateway/new-clip.ts` the power now:
   - looks up the owner's own handle with `E(agent).locate('@self')`;
   - refuses a peer that matches it, and leaves it out of `listPeers`;
   - keeps only messages sent between the owner and that peer.
2. **`adoptValue` had no direction check** (purist, wire-watcher, warden, breaker). It now accepts only a package the peer sent. A value the owner sent from the guest's root can no longer be pulled into the clip.
3. **Inline `import()` types in `clips/new-clip/main.js`** (typist). Replaced with one `@import { ChatMessage, Creator }` at the top of the file.
4. **Browser demo not in CI** (coverage-auditor). The rule accepts a stated reason, so I added one to the PR body rather than wiring it in: Playwright isn't a dependency of the repo and the self-hosted runners have no Chromium. #201's browser demo is local-only for the same reason.

**Smaller items I also took:**
- Direction is now a single `inbound` flag; the code no longer reuses the `from` field to mean something else.
- `locatorKey` drops connection hints from the locator.
- A rejection reason of `''` is now kept instead of becoming "Declined".
- `dismissMessage` still works in both directions, and that is now stated on purpose in the code and the design.
- `designs/chat-clip.md` § 3 is corrected: it no longer says the chat sends no capabilities, since `resolveRequest` does. The meta-hedge line the pruner flagged is gone.
- The test that lists which agent methods the power may call now includes `locate`, and checks it is only ever called with `'@self'`.

**Tests:**
- `test/chat-clip-daemon.test.ts` gained two cases: an imported own handle is refused and not listed, and adopting from the owner's outbound package is refused. Both fail on the old code and pass with the fix, run against the pinned endo commit `1706e632`.
- Locally, `test/new-clip-daemon.test.ts` passes 2/2, the unit tests pass 17/17, and the typecheck and build are clean.
- In the full local `npm test`, 88 files pass. The one failure, `git-remote/capability.test.ts`, is the known false failure caused by this host's git wrapper and is unrelated to this PR.
- The PR body's authority and evidence sections are updated. It notes the browser demo's 15/15 run was on the previous head, `761001a`.

**CI:** in run 39041870027, `test` passed. `Claude harness (amd64)` and `Claude harness (arm64)` stayed queued from 14:42Z to past 15:44Z. `ci-wait-merge.sh` returned rc 4 (still pending). This looks like the known `ci.minion.town` runner stall from the GitHub rate limit, which clears on the hourly reset.

**Not addressed (should-fix):**
- Use `makeExo` with an interface guard instead of `Far`.
- Give the power a narrower mailbox object instead of the whole guest agent.
- A refused poll should send the page back to the peer list instead of the fatal error screen.
- Stop overlapping refreshes from painting stale messages.
- Move the `ChatMessage` type to a types module.
- Trim the PR body and repeated comments, as the pruner asked.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr202-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 78 tokens (3822596 cached reads)
- Output: 18444 tokens
- Cost: $2.0085272000000005
- Wall-clock: 3965s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
