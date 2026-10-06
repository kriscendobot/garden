I applied the round-2 must-fix items to PR #165 and pushed them as commit `a0be086`. CI is green, and the live Endo daemon test passed in CI. That test shows the responder is restored after a daemon restart and still answers a message with the new wiring. One thing will still flag on panel-3: the design's phase-and-evidence check reports phases 1 and 3–6 and the acceptance row as open. They really are open, because the production canaries haven't run.

**Must-fix items**
- **Agent proxy visible to the child (locksmith):** the bridge no longer stores the agent proxy under the child guest's own names. The responder now receives a separate per-child directory naming the guest and the proxy, so the child can't call the proxy or pass it on.
- **Rate limit defined twice (curator):** `agents.ts` now passes the shared `DEFAULT_INBOX_WATCH_RATE` constant. The caplet has no default of its own and refuses to start without a rate.
- **Abbreviated name (stylist):** `sub` is now `callerHost` in `enableInboxResponder`.
- **Missing docs (archivist):** added doc comments for `provideChild`'s `withInboxPins` option, `enableInboxResponder`, what `removeChild` tears down, and the new context members.
- **Phase and evidence ledger (integrator and the pre-pass check):** added to the PR body in the same shape as #150, which merged with open rows. Phase 2 is marked satisfied; phases 1 and 3–6 and acceptance are open. The check's structural complaints are gone. It still reports those open rows, and only running the production canaries can close them.
- **Summary comment (scribe):** posted on the PR, covering rounds 1 and 2 and what was declined: https://github.com/kriscendobot/minion.town/pull/165#issuecomment-6023794737

**Should-fix items also addressed**
- **Interrupted install:** the responder's record is saved as pending before the daemon-side install and marked installed afterwards. A leftover pending record is installed again under a fresh token.
- **Token mismatch:** the proxy is reinstalled with the current token on every enable. A child created without `@pins` is refused before anything is installed.
- **Teardown order:** teardown revokes the child's token before removing the child.
- **Mailbox loop:** each message is handled separately, so one failure no longer stops the responder for good.
- **Messages not addressed to the responder:** replies, outgoing copies and other message types now stay in the mailbox instead of being dismissed.
- **Prompt text:** the prompt now joins all text segments, and empty prompts are skipped.
- **Endpoint exposure:** the internal endpoint refuses anything that isn't from loopback, and any request carrying proxy forwarding headers.
- **Proxy hardening:** the proxy reuses the existing `ClaudeAgent` guard, accepts only the known `infer` result shapes, and logs failures.
- **Options with undefined values:** `createClaudeAgent` leaves out unset options instead of sending them as `undefined`.
- **Tests:** added tests at the tool level, for pending re-provisioning, for the shared rate, for recovery after one message fails, and for refusing forwarded requests.

**Verification:** typecheck and build are clean. The full suite has 900 passing and 1 failing. The failure is in `test/git-remote/capability.test.ts` and is unrelated to this change: it's the known host-environment failure that also happens on main. The CI result came from the watcher returning 0.

**Declined or deferred, all noted in the PR comment:**
- Retitling `94a3689` would rewrite history, which this stage doesn't do.
- I didn't rename the fields of the existing `InboxWatchRate` type.
- I kept one stored record per answered message rather than switching to a single high-water mark.
- The responder still gets the whole guest rather than a narrower interface.
- Old rate-limit entries are never cleaned up.
- A child restored from a delegation can still be re-recorded with the wrong model.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr165-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 124 tokens (7999181 cached reads)
- Output: 40735 tokens
- Cost: $3.7701602
- Wall-clock: 633s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
