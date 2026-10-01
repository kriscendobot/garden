## Completion report: build-endo-guest-scoped-daemon-bootstrap

The daemon can now issue a bootstrap scoped to a single guest, and `runConfinedTurn` connects through it, so the harness no longer holds the root host. The broker's contract is unchanged. Draft PR: https://github.com/endojs/endo-but-for-bots/pull/1407. Head is `bot/build/guest-scoped-daemon-bootstrap`. Base is the frozen `llm-d4124e6`, which is the current `llm` tip after #1371 merged. CI is green except one macOS test leg that failed twice on different tests (details below).

### What changed (commit aa79a93cce)
- **`@endo/daemon`**
  - New method `EndoBootstrap.guestBootstrapPath(id)`. It serves one local guest on its own Unix socket at `<sock>-guests/<24-hex>.sock`, in a `0700` directory beside the daemon socket.
  - That socket's CapTP bootstrap (export offset 0) is the guest facet itself, so a connection there has no `host()` or `terminate()`.
  - Calling it again for the same guest returns the same path, and it accepts a bare formula number. It refuses anything that isn't a local guest.
  - The new `src/serve-guest-path.js` holds the logic. It is wired into both `manager-node.js` and `bus-manager-node.js` through `makeNodeGuestPathIssuer`. Windows, Go and Rust daemons serve no guest sockets.
  - Interface, types and `help.md` are updated, and the help text is regenerated.
- **`@endo/agent-mcp-stdio`**
  - New exports: `connectToGuestBootstrap`, `issueGuestBootstrapPath` and `resolveScopedGuest`.
  - `startGuestBroker` keeps its signature and accepts either kind of connection:
    - A guest-scoped connection is accepted only if the facet's `@agent` id matches the configured formula number and it has the guest interface.
    - A root-host connection is still narrowed with `lookupById`.
- **`@endo/claude`**
  - `runConfinedTurn({ guestSockPath })` and `endo-claude-turn --guest-socket` are new.
  - Without a socket path, the turn issues one over the root socket and closes that root session before the broker starts.
- **Docs:** the design `designs/endo-guest-stdio-mcp.md` has an updated status, and its open question on the scoped bootstrap is marked resolved. Both READMEs are updated, and there are two changesets.

### Verification
- **New daemon integration test** (`test/guest-bootstrap-path.test.js`, 2 tests, real daemon) passes. It checks:
  - the private directory and repeat issuing;
  - that the scoped session identifies as the guest, reads its names, and lacks the root's methods;
  - that host ids and value ids are refused.
- **New unit tests:**
  - broker: a guest-scoped connection works, and a socket for the wrong guest or one whose bootstrap isn't a guest is refused;
  - confined-turn: a turn over a guest-scoped connection works, and by default it connects to `guestSockPath`, not `ENDO_SOCK`.
- **Suites:** agent-mcp-stdio (58) and claude (80) pass. The daemon help-text and teardown tests pass.
- **Static checks:** `tsc` for the three packages and the repo-root `tsc` pass. eslint shows no errors, and prettier is clean.
- **End-to-end:** a scratch run against a real daemon (not committed) went issue → connect → broker → MCP `tools/call list`, and returned the guest's names.
- **CI:** everything passes except `test (24.x, macos-15)`.
  - The first run timed out in a `hosted-agent` provider-worker test.
  - The re-run failed `daemon-teardown › orphaned daemon…`. That same test also fails on the base `llm` @ d4124e6 macOS run, and it passes locally with this change.
  - I noted this on the PR. I think both are macOS flakes that were already there, not something this diff caused.

### Cross-links
- #1407's body says `Refs: #1371`.
- I posted a comment on #1371 pointing to #1407: https://github.com/endojs/endo-but-for-bots/pull/1371#issuecomment-5928618769

### Follow-ups (not built)
- Revoking an issued socket without restarting the daemon.
- Re-issuing automatically after a restart. Callers re-issue for now, and that call is idempotent.
- Guest sockets from the Go and Rust supervisors.
- An `endo` CLI command for issuing.
- One thing for reviewers: guests have their own `lookupById`, so a guest-scoped session can still resolve whatever ids that guest's own authority allows. That matches the design, where the guest facet is the limit.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-guest-scoped-daemon-bootstrap.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 194 tokens (12959201 cached reads)
- Output: 61258 tokens
- Cost: $5.258608200000001
- Wall-clock: 4300s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
