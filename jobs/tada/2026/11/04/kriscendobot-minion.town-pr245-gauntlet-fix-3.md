**FIX round 3 for PR #245: must-fix items applied and pushed, CI green.** I pushed `9987418a` and `ef92334e` to `feat/api-key-agent-responder-ui`, advancing it from `bbcf120c`.

CI on `ef92334e` passed both Actions runs: `test (typecheck + vitest)` and `clip frame browser gate`. The bot's token can't read commit statuses or non-Actions checks, so those weren't visible. Locally, typecheck and the endpoint tests pass, and the browser tests pass on Chromium only.

**`9987418a`: daemon adapter**
- **wire-watcher:** `retryMail` no longer goes through the automatic session replay. `withDaemonSession` gained a `{ replay: false }` option, so a lost reply now reaches the owner as `daemon-unavailable`.
- **prover:** a new test uses distinct retry and dismiss fakes to pin the forwarding to `retryMail`. Another test pins the single attempt after a lost reply, followed by reconnecting on the owner's next request.
- **fast-checker:** a 100-run property test checks exactly-once admission across generated message numbers and 2–5 repeats. It runs against `FakeAgents`, so it proves the route and fake contract, not the real daemon's behavior.

**`ef92334e`: UI**
- **breaker (must-fix):** the mail-action lock is now held at module level, so a render during an action keeps the buttons disabled.
- **saboteur and breaker (should-fix):** one poller now follows all of an agent's retried messages. A failed or overtaken read polls again within the existing 15-try limit, instead of ending the follow.
- **decomplector:** the client shows `retryAt` exactly as the daemon sent it, falling back to "soon", and the date parser and formatter are gone. This also resolves these findings:
  - corner-prober's invalid-date finding
  - stylist's `pad` and `utcDay` renames
  - spec-keeper's midnight flake and comment-only note
- **corner-prober:** a new test covers a retried message being held again and asserts that polling then stops.
- **stylist:** `RETRY_FOLLOW_MS` is now `RETRY_FOLLOW_MILLISECONDS`.
- **engine-realist:** statuses now come from one map per agent summary, and the reason table is hoisted.

I checked the two new browser tests by temporarily undoing the lock and the keep-polling behavior; both tests failed, and I then restored the code.

**Not done and behavior changes**
- **Declined:** spec-keeper's should-fix to capture primordials and call them through `Reflect.apply`. `provider-ui.js` doesn't use primordials anywhere, and the arrays come from `publicAgent`'s `.map`, so it would be a one-off pattern.
- **Visible change:** retry times now appear as raw ISO timestamps rather than friendly UTC text.
- **Visible change:** if a daemon session has died without being noticed, the owner's first **Retry now** fails with `daemon-unavailable` and has to be clicked again. No-replay makes this unavoidable.

The panel was not re-run; the driver posts panel-4.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr245-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (967126 cached reads)
- Output: 24474 tokens
- Cost: $1.4821692000000002
- Wall-clock: 832s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
