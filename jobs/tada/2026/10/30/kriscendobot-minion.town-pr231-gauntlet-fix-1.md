PR #231 fix round 1: I pushed the panel-1 fixes to the PR head, and CI is green on all 7 checks, including the browser gate on Chromium, Firefox and WebKit.

**Branch:** `kriscendobot/minion.town` `build/shell-captp-session`, moved from `3e34dd03` to `28b8b074`. I added four follow-up commits and pushed them with `safe-push-pr-head.sh` in advance mode.

**Must-fix items (latest panel review, 5708451945)**
- **A client reset could crash the server** (assessor, saboteur, corner-prober). The WebSocket upgrade handler now gets a socket `error` listener before the async login check runs, and drops it once `ws` takes over the socket. `refuseUpgrade` no longer writes to a socket that is already destroyed. A new test resets the socket while the login check is pending. With the listener removed, that test fails with an unhandled error; with it, the test passes.
- **SES `lockdown()` runs in the shell page** (engine-realist). Removing it isn't practical: I built the bundle without `@endo/init` and CapTP failed on load, because it needs the SES `assert` global. So I took the reviewer's other option. The lockdown is now documented as deliberate in `shell-session.js`. A browser-gate check confirms the page's built-in objects are frozen and the settings menu still opens afterwards, and it passed on all three engines in CI.

**Should-fix items also applied**
- **Gate secret fails closed:** `validShellGateToken` now rejects every request in production when `ACCOUNT_GATE_SHARED_SECRET` is empty, matching the Claude route's `assertClaudeAccountGate`. I didn't make the server refuse to start, so a missing secret can't crash-loop prod. The deploy already requires the secret.
- **Bounded memory:** a revoked or expired session is now removed from both maps at once and its timer cleared. Each subject can hold at most 32 live sessions, and minting past that evicts the oldest. There is a new `mintCount` diagnostic.
- **Message size:** the WebSocket now refuses messages over 64 KiB.
- **Session lifetime:** values a Node timer can't hold (zero, negative, `NaN`, non-integer, above 2^31−1 ms) now throw. The random-locator collision loop is capped at 16 attempts.
- **Subject header:** a subject with leading or trailing whitespace is now refused.
- **Client reconnect race:** `discardConnection` now detaches the old socket, so its late close can't start a second session alongside the re-mint.
- **Client hang:** a socket that closes while the CapTP bundle loads, or during the handshake, now fails the attempt and reconnects instead of hanging.
- **Sign-out:** it now always sends the revoke-all request, even when this tab holds no session.
- **Caddy:** the shell-session block now sits in its own comment group instead of between the `@guestSelf` comment and its handle.
- **Bundle drift:** the build script uses `fileURLToPath`. CI now fails if the committed `deploy/aws/www/shell-captp.js` doesn't match a fresh build, and the browser gate also runs when `tools/` build files change.
- **Changeset:** added `.changeset/shell-captp-session.md` (`minion-town` minor), with the new routes, the lockdown, the fail-closed gate, the deploy step and the build change.
- **Comments:** I removed the three redundant comments the pruner flagged.

**Local checks:** typecheck is clean and the 18 shell-session unit tests pass, along with the Chromium browser gate. The full `npm test` run had one failure, in `test/git-remote/capability.test.ts`, which this PR doesn't touch. Firefox and WebKit can't launch on this host because system libraries are missing, so CI is the only run on those two. My first CI wait ran in the background and was killed at its 10-minute limit; I re-ran it in the foreground and it finished with rc 0.

**Not done; open for panel-2 or the maintainer**
- No server-side WebSocket pings yet (comment-only).
- One session can still be opened from several sockets. I kept that so reconnects work, but no test pins it.
- More message-shape edge-case tests (binary, fragmented, `null` frames) haven't been written.
- `liveLocatorCount` still revokes expired sessions when read, so it is not a pure diagnostic.
- PR body edits from the integrator are not done: tone down the "Acceptance: satisfied" claim, state where rung 0b stands, and consider a clearer title.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr231-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 80 tokens (4014121 cached reads)
- Output: 24096 tokens
- Cost: $2.2247522
- Wall-clock: 1719s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
