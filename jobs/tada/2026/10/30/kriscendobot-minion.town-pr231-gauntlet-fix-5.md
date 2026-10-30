# Gauntlet fix round 5: kriscendobot/minion.town PR #231

All six must-fix items from the panel-5 review are applied, plus most should-fix items. I pushed three follow-up commits (head `3587ce20`) with `safe-push-pr-head.sh`. CI is **green**: `ci-wait-merge.sh` returned rc 0 with 7/7 checks passing, including the browser gate on Chromium, Firefox and WebKit, unit tests with typecheck, and the Claude harness on amd64 and arm64.

**Must-fix items applied (commit `4072fc01` unless noted):**
- **locksmith (revocation by identity):** revoking now requires holding a capability, not matching the signed-in subject.
  - Each mint returns a per-locator `revoker` and a shared `sessionsRevoker` for the subject's group of sessions. A new group gets a fresh `sessionsRevoker`, so a stale copy can't reach later sessions.
  - Both are sent in an `X-Shell-Session-Revoker` header, never the URL.
  - The test that pinned the old subject-equality check is replaced with tests that revoke by possession.
- **breaker (endless reconnect):** a browser hides the status of a refused WebSocket handshake. So after a failure before the socket opens, the client now asks a new `GET /account/shell-session` login check and stops for good on 401/403. There are tests for both outcomes.
- **wire-watcher (sign-out ordering):** sign-out now always attempts revoking all sessions, even if an earlier per-locator revocation failed, then reports that failure. A test covers it.
- **engine-realist (shutdown hang):** sockets still waiting on authentication are tracked and destroyed when the plane closes. A test uses an authenticator that never answers. Its should-fix item is done too: sessions are grouped per subject, so mint, eviction and sign-out only touch that subject's sessions.
- **integrator (overstated "owner facet"):** I renamed rather than wired it to the guest facet. It is now `ShellSessionFacet`, described as a lease probe with no owner authority. The code, changeset, design doc and PR body are corrected (also in `3587ce20`).
- **typist:** `createApp` now documents that `attachShellSessionPlane(app, server)` must be called on the server, and what goes wrong if it isn't (`3587ce20`).

**Should-fix items done:**
- **stylist:** `all` renamed to `revokeAllSessions`; `ids` removed.
- **corner-prober:** a test for the maximum allowed lifetime, `2**31-1`.
- **transplanter:** the browser test uses a checked-in loopback certificate, so it no longer needs `openssl` (`a0d62131`).
- **archivist:** the design's status line now says the shell is implemented and the overall design is partially implemented.
- **decomplector:** the design explains why this needs its own path beside the existing guest reveals.
- **changeset-auditor:** the changeset has one sentence per line.
- **benchmarker:** a note in the PR body explains why the minification isn't benchmarked.
- **pruner:** the PR body is trimmed.
- **scribe:** a new summary comment anchored to the head commit: https://github.com/kriscendobot/minion.town/pull/231#issuecomment-6518354699

**Declined, with reasons in the PR comment:**
- **packager:** splitting the generated `shell-captp.js` out of commit `6ab3cd5` would rewrite reviewed history; CI already checks that the bundle matches its build.
- **pruner (evidence ledger):** the ledger stays because the garden's phase-evidence gate reads it.
- **purist:** starting the session lazily is left to the later step that adds the first real use of it.

**Follow-ups:**
- The production evidence is from app `33e5d30d`. The new head changes how revocation requests are sent and adds the login check. CI's browser gate covers both, but production hasn't seen them yet; they need checking after the next deploy.
- Locally, `test/git-remote/capability.test.ts` ("propagates a git failure") failed. That file is untouched, and the same suite passes in CI.
- The first CI wait was killed by the tool's time limit after about 19 minutes with only the arm64 harness leg left; I reran it in the foreground and it returned green.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr231-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 102 tokens (6072164 cached reads)
- Output: 44048 tokens
- Cost: $3.2392407999999993
- Wall-clock: 2277s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
