**Fix round 5 for kriscendobot/minion.town PR #178: the panel's one must-fix is pushed and CI is green.**

The fix is commit `193471e`, pushed to `git-remote-push-caps` (it advances `c5294c5`).

**Must-fix applied (assessor finding 1).** A client that hung up while the server was measuring the partition's size could leave `git http-backend` running forever. Every later push to that partition then queued behind it.
- **Router (`src/endo/git-remote/git-http.ts`):** after the size walk it checks again whether the client is still connected. If not, it releases the partition's push slot without starting git.
- **`runHttpBackend` (`src/endo/git-remote/git-backend.ts`):** if the response is already closed when it starts, it kills the child immediately. Before, it registered its kill listener after the `close` event had already fired, so the listener never ran.

**Should-fix items also handled:**
- **Assessor finding 3:** the `runHttpBackend` call is now wrapped in try/catch, so an error thrown before the child exists releases the slot and returns a 500.
- **Assessor finding 2 / breaker finding 1 (no time limit on a held slot):** I added no new timeout. Instead the slot's comment now says that Node's default `requestTimeout` (300 s, which the service keeps) bounds a stalled client. When it fires it closes the connection, which kills git or drops the queued push.

**Test.** I added "stops the CGI when the client hung up before it started" to `test/git-remote/git-remote-limits.test.ts`. I confirmed it fails with the backend fix removed and passes with it.

**Verification:**
- The type-check passes, and the limits suite passes (23 tests).
- Across the whole git-remote test directory, one test fails locally: "projectPartition > propagates a git failure" in `capability.test.ts`. It covers code this diff doesn't touch, and I didn't re-run it without my change, so I'm only assuming it's an environment issue. CI's `test` job passed.
- One earlier local run had about ten timeouts in other git-remote tests, right after I'd been killing leftover `http-backend` processes. Two clean re-runs showed only the failure above.
- CI (`ci-wait-merge`, rc 0): all 3 checks pass (`test`, `Claude harness (amd64)`, `Claude harness (arm64)`).

**Follow-ups, not done here:**
- Prover's three should-fix test gaps: no test pins `receive.unpackLimit=1`, the probe exemption, or the `Math.max(1, …)` grant floor.
- Migrator's suggestion of a startup warning for partitions already over the size cap.
- Packager's suggestion to squash the commits whose mechanisms were later replaced.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr178-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 76 tokens (3435745 cached reads)
- Output: 17315 tokens
- Cost: $1.8190170000000003
- Wall-clock: 1800s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
