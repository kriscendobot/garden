Fix round 2 is done for endojs/endo-but-for-bots PR #1407: the remaining panel must-fix items are pushed and CI is green, with all 33 checks passing.

**Already on the head before I started.** Commit `fdb9727fcd` was pushed two minutes after the panel-2 review. It covered two of the must-fix items:
- **Breaker, finding 1:** `isGuestBootstrapUnsupported` now matches only the daemon's own "does not serve guest-scoped bootstraps" message. An argument-guard error that names `guestBootstrapPath` no longer triggers the fallback to full host authority.
- **Changeset-auditor, finding 1:** `.changeset/agent-mcp-stdio-guest-bootstrap.md` was rewritten to describe the fallback correctly.

**What I pushed** (three follow-up commits; head went from `fdb9727fcd` to `317302d262`):
- **`23d618cf00`, fix(agent-mcp-stdio) (breaker finding 2, should-fix):** when the formula id includes a node, `resolveScopedGuest` now checks that the socket's guest is on that node too, not just that the number matches. A new broker test shows a socket for the same number on a different node is refused.
- **`2925416bbf`, test(claude):** a new test feeds in the real guard-rejection text the breaker reproduced (`In "guestBootstrapPath" method of (Endo): arg 0: … Must be a string`) and checks the turn does not fall back to the root connection. The panel noted this case had no test.
- **`317302d262`, docs(daemon) (changeset-auditor finding 2):** `.changeset/daemon-guest-bootstrap-path.md` now has one sentence per line.

**Checks run locally:** the `agent-mcp-stdio` broker tests (10) and the `claude` `confined-turn` tests (14) all pass. ESLint shows no errors (its six warnings are about await placement, all in functions these commits didn't change), Prettier is clean, and the `agent-mcp-stdio` type check passes.

**Not addressed:**
- **Purist's should-fix:** the purist asked for a `reason`/`code` property on the error instead of matching message text. I left this because those properties are dropped when the error passes from the daemon to the harness, so matching the exact daemon message is the practical check.
- **Changeset bundling (finding 3):** GitHub's length limit cut this finding off before its verdict, so I couldn't tell if anything was required. Both changesets stay as they are.
- **Comment-only notes:** issued sockets can't be revoked and the issuer's bookkeeping grows for the daemon's whole life. The design doc already lists both as deferred.

**Behavior change for older daemons:** a daemon that predates `guestBootstrapPath`, such as the Go or Rust supervisors, now makes the confined turn fail instead of falling back to the root connection. This came in with `fdb9727fcd`, before this round, and is the safer default. Only a daemon that says it serves no guest sockets (for example on Windows) still falls back.

CI: `ci-wait-merge.sh` returned 0, with 33 checks and 0 failures.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-guest-scoped-daemon-bootstrap-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1504276 cached reads)
- Output: 7976 tokens
- Cost: $1.0026632
- Wall-clock: 1884s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
