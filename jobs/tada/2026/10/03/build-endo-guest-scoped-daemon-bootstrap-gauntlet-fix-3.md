I pushed the round-3 fixes for PR #1407, but CI hadn't finished by the 3600s deadline, so this stage ends as still-pending. 32 of 33 checks passed. The last one, `test (24.x, macos-15)`, was still running when I stopped. The driver will re-post this stage.

**Must-fix items**
1. **Old daemons now fall back cleanly, without matching error text.** `issueGuestBootstrapPath` checks `__getMethodNames__()` on the daemon. If the daemon has no `guestBootstrapPath` method, it returns `undefined` instead of throwing. A daemon that serves no guest sockets (Windows) now also answers `undefined`, so `makeGuestConnect` uses the root connection only on `undefined`. The text match on the error message is gone from both `manager.js` and the test. I added a test against fake daemons on a real socket covering four cases: method missing, `undefined`, a returned path, and a refusal.
2. **Removing a guest now revokes its socket.** Guest-socket connections now register with the daemon's connection tracker, as root-socket connections do. The issuer has a new `revoke`. When a guest is collected, its listener closes, the socket file is removed, and open connections are closed. An end-to-end daemon test confirms that after removal a new connection is refused and an open one is closed, and there are unit tests for `revoke`. The docs, changeset and design doc no longer say the socket lives until the daemon restarts.
3. **PR description rewritten.** It uses the current `socketPath`/`guestSocketPath` names. It states the root-connection fallback and that it carries the whole host's authority. Its compatibility section now matches the changesets, and it notes that the `@endo/claude` `test:xs` stub predates this PR because the package is Node-only. It is also shorter.
4. **Summary comment posted** covering the four round-2 commits and the three new ones: https://github.com/endojs/endo-but-for-bots/pull/1407#issuecomment-5965410800
5. **`makeGuestConnect` is now re-exported** from `packages/claude/index.js`.

I also took one should-fix item: daemon tests for a remote-node id, an unknown id and a malformed id.

**Commits** (one per package; head was `317302d262`, now `68b86b940d`):
- `dbee28a097` daemon
- `858fe65ddb` agent-mcp-stdio
- `68b86b940d` claude

**Local checks:** the daemon guest-bootstrap tests (12), the full agent-mcp-stdio suite (64) and the full claude suite (86) pass. eslint shows no errors, `tsc` shows no errors in the changed files, and prettier is clean. To run the daemon tests on this host I replaced the shared `better-sqlite3` native binary in the project worktree with a Node 22 build, after breaking its shared file link so other checkouts were not affected.

**CI:** the first run on the new head was cancelled by GitHub ("higher priority waiting request"), with no newer run to replace it. I re-ran it. Everything has passed except the one macOS cell above.

**Not done (should-fix items left open):**
- The new tests in `confined-turn.test.js` still hardcode `/tmp`.
- The bare-formula-number node check in `resolveScopedGuest` is unchanged.
- The earlier commit history is not regrouped by package.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-guest-scoped-daemon-bootstrap-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 150 tokens (8618611 cached reads)
- Output: 35235 tokens
- Cost: $3.612694200000001
- Wall-clock: 4764s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
