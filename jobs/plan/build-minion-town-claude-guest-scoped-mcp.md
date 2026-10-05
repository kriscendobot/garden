---
gate: blocked
blocked_on: https://github.com/endojs/endo-but-for-bots/pull/1407
priority: normal
posted_by: producer
posted_at: 2026-10-04T17:30:58Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# build: minion.town Claude CLI backend — guest-scoped bootstrap for the confined session's MCP command

Repo: kriscendobot/minion.town (base `main`). Issue: https://github.com/kriscendobot/minion.town/issues/149
Authorization: kriskowal approved the fix: https://github.com/kriscendobot/minion.town/issues/149#issuecomment-5982572411

This job stays parked until endojs/endo-but-for-bots#1407 merges or closes. #1407 adds the daemon's
`guestBootstrapPath(id)`, a per-guest unix socket whose CapTP bootstrap is the guest facet. It also adds
`connectToGuestBootstrap` / `issueGuestBootstrapPath` in `@endo/agent-mcp-stdio` and the
`endo-claude-turn --guest-socket` option.

**If #1407 CLOSED without merging:** do not build. Tell the maintainer (message-user.sh) and on issue #149
that the upstream prerequisite was dropped, then complete.

**If #1407 MERGED** (into a frozen `llm-*` base or `llm`, so confirm the merge commit is reachable from live `llm`):

1. **Selection becomes structure (item 1).** In `src/endo/claude/claude-guest-bridge.ts` `brokerFor`, issue the
   guest's socket over the root connection (`guestBootstrapPath(guestFormulaId)`). Then launch the MCP command with
   only that guest socket path, not `ENDO_SOCK` + `ENDO_GUEST_FORMULA_ID`. Use whatever stdio entry/env/flag #1407
   exposes for a guest-scoped connection. The root socket path must no longer appear in the confined session's
   `mcp.json` or the command's env/argv. Update the argv pin in `test/claude-cli-backend.test.ts` so it asserts that
   `ENDO_SOCK` is ABSENT and the guest socket is present. Revoke or let the daemon reap the socket when the child
   is removed, matching #1407's revocation semantics.
2. **Endo pin bump.** Bump `ENDO_COMMIT` (deploy/aws/scripts/deploy-endo-daemon.sh) and `PINNED_ENDO_COMMIT`
   (src/endo/root-host-socket.ts) to an `llm` commit containing #1407. CAUTION: a past bump (to 89481580)
   crash-looped prod over a missing migration. Run the live-daemon/registry tests and the upgrade preflight before
   proposing the bump. If newer `llm` carries an unlanded migration hazard, pin to the narrowest commit that has
   #1407, and document why.
3. **Same-unix-user (item 2).** Re-evaluate the threat model now that the MCP command holds only a guest socket.
   Update the bridge's header comment and the design doc to say the residual exposure is the guest's own authority,
   not the root host's. Running the MCP command as a separate unix user is OPTIONAL per the issue. Do it only if it
   is cheap and compatible with #1407's `0700` guest-socket directory. Otherwise, name the follow-up in the PR
   rather than building it.
4. **Item 3 (mail edge)** already landed on main in f3235e1 (per-caller child host). Verify it still holds and
   mention it in the PR. Do not redo it.

Open a DRAFT PR with ensure-pr.sh. In its body, reference #149 ("Fixes #149" only if items 1 and 2 are both fully
addressed). Then post a short reply on issue #149 linking the PR.

<!-- garden-annotation: key=press-20261005-1407-redesign by=gardener at=2026-10-05T07:36:50Z -->

Spec superseded by #1407's redesign (press 2026-10-05). kriskowal CHANGES_REQUESTED #1407 2026-10-05 04:36Z (https://github.com/endojs/endo-but-for-bots/pull/1407#pullrequestreview) rejecting per-guest Unix sockets: the stdio MCP connects to the Endo root socket, does one lookupById for the guest formula id, and routes all tool calls through that facet. Commit 06780c2731 REMOVED guestBootstrapPath / connectToGuestBootstrap / issueGuestBootstrapPath / --guest-socket. When this promotes, build against #1407's merged API (single root socket + lookupById), not the per-guest socket named above; first check whether minion.town's existing confined launcher already satisfies issue #149 under that shape, and if so report that on #149 rather than adding code.
