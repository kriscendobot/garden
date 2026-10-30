## Gauntlet FIX round 2: kriscendobot/minion.town PR #231 (CI green)

I applied the panel-2 must-fix items, plus most of the should-fix and summary-fix items, from review 5708674741. The four commits are pushed to `build/shell-captp-session` as follow-ups (head moved from `28b8b074` to `37fb8153`). CI is green on all 7 checks (`ci-wait-merge` exit code 0). The first CI waiter ran into the 10-minute background limit, so I restarted it and it then reported green.

**Commits:**
1. `7ae80501` **fix(shell): evict only past the per-subject locator cap.** Raised by assessor, saboteur and breaker.
   - **Eviction bug:** `evictOverflow` now clamps the excess with `Math.max(0, …)`. Before, a negative `slice` end meant a subject holding 16 or more of its 32 locators lost its oldest sessions on every new mint.
   - **Async handlers:** the three Express handlers are wrapped, so a rejecting authenticator returns 500 with `no-store` instead of hanging.
   - **Message handling:** parsing a CapTP frame is now separate from dispatching it. A bad frame closes with 1003, a dispatch failure closes with 1011, and log lines name the subject. Null and primitive JSON frames are refused with 1003.
   - **`info()` on an expired facet:** it now refuses before the socket is closed, so the client actually receives the refusal.
   - **Other guards:** a whitespace-only Cookie is refused, and one locator can hold at most 4 sockets (`SHELL_SESSION_MAX_SOCKETS_PER_LOCATOR`).
   - **New tests:**
     - eviction below the cap (cap 5), at a cap of 1, and eviction closing an open socket;
     - the cookie guard pinned with an authenticator that always admits;
     - `sec-fetch-site` same-site or cross-site sent with the correct Origin;
     - CSRF and login checks on both DELETE routes;
     - revoking an unknown id, an already-revoked id, or the collection with a trailing slash;
     - the 500 path, and the locator-collision 500;
     - null or primitive frames;
     - `info()` after expiry, and the socket cap.
   - I deleted the jargon header comment in the test file.
2. `2ac24ed6` **test(shell): exercise the production authenticator.** Raised by prover.
   - The production authenticator is moved out of `createApp` into an exported `makeShellAccountAuthentication` in `src/http.ts`, so tests can reach it.
   - The new `test/shell-session-app.test.ts` covers it through `createApp`: a valid guest subject, a missing or wrong gate token, a subject without the guest scope, and a missing subject.
   - It also tests the function directly: padded subjects, and a throwing account store, which refuses rather than rejects.
3. `a2ef292a` **fix(shell): client refresh delay and late mints.** Raised by corner-prober.
   - The refresh delay is now at least 30 seconds and at most 2^31-1 ms, the largest delay a timer can hold. This stops the 0 ms refresh loop when the client clock runs ahead or `expiresAt` is in the past, and the immediate fire when the delay is too large.
   - A locator whose mint finishes after `close()` is now revoked instead of staying alive until it expires.
   - The new `test/shell-session-client.test.ts` covers these cases.
4. `37fb8153` **docs(changeset).** Raised by releaser and pruner.
   - The changeset now uses the releaser's suggested body: one `New:` line and one `Migration:` line that includes the `ACCOUNT_GATE_SHARED_SECRET` requirement. The `Build:` and implementation-detail lines are gone.
   - I deleted the narrating clause from the comment in the browser test.

**Local checks:** `npm run typecheck` is clean, the shell-session suites pass (40 tests), and the generated `shell-captp.js` bundle did not change. The full `npm test` run had one failure, `test/git-remote/capability.test.ts`, which is in code this PR doesn't touch. My notes record that test as failing falsely on local runs, and it passed in CI.

**Not done:** I left out one pruner nit, the "Map iteration is insertion order" comment, because my rewrite of `evictOverflow` replaced that comment with one explaining the clamp. I added no extra tests for the "revoke-all while a sibling tab is mid-open" race or for a query-string upgrade, which was already pinned as refused. Panel-3, which the driver posts, should confirm what remains.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr231-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 70 tokens (3447298 cached reads)
- Output: 27184 tokens
- Cost: $2.1752516000000006
- Wall-clock: 1743s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
