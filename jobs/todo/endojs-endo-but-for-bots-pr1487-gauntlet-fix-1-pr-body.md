---
role: gardener
requires: host=endolin-garden-ece02cb4
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Update PR body and title on endojs/endo-but-for-bots#1487 (gauntlet fix-1 follow-through)

The gauntlet fix-1 stage (job `endojs-endo-but-for-bots-pr1487-gauntlet-fix-1`) pushed its fix commits (head 39676fa965e) from host oros-studio, whose PAT gets 403 on `updatePullRequest` for endojs. Do ONLY this:

1. Write the body below (between the BODY markers) to a file and run
   `gh pr edit https://github.com/endojs/endo-but-for-bots/pull/1487 --body-file <file> --title "docs(ocapn-noise): key-confirmation test, np/1 wire contract, and Rekey-only reconnect (cryptographic review R1, R3, R4)"`.
   Keep the trailing `<!-- garden-job: ... -->` marker exactly as given.
2. Do not push commits, review, or touch the gauntlet.

The new body addresses panel round-1 findings: pruner (concision), integrator (title prefix: no behavior change, so not `feat`), decomplector must-fix (ask kriskowal to confirm the reversal of the #252 C1 decision), and the #1475 landing order.

----- BODY -----
Refs: #1475

## Description

This builds the recommendations of the OCapN-Noise cryptographic review (design PR #1475) that need no further design work. It is based on the frozen `llm-a794753`, because the `np` network code and the session-reconnect design exist only on `llm`.

- **R1, key confirmation (test).** `packages/ocapn-noise/test/network.test.js` adds "a key-compromise-impersonation SYN never graduates": a forger holding the responder's key sends a SYN claiming a victim, cannot answer `op:start-session`, and the responder hangs up without graduating a session. `network.js` already behaves this way; the test guards it.
- **R1, R4, R5 (docs).** `packages/ocapn-noise/README.md` gains an `np/1` "Wire contract" section, including the normative key-confirmation and no-0-RTT rules.
- **R3, Rekey (design).** `designs/ocapn-noise-session-reconnect.md` settles C1 as Rekey on every reconnect and removes Resume and the rekey cap. The reconnect record stays abstract, so it composes with #1481.

**Maintainer confirmation needed (@kriskowal).** The R3 commit reverses your tentative C1 decision on #252 ("Tentatively run with resume and rekey-cap with a provisional figure for the cap."). The reasons: with IK a Rekey is one round trip and 213 bytes, and carrying a CipherState across connections risks `(key, nonce)` reuse. Please confirm here or on #1475. The design keeps C1 listed as an open question until then.

**Landing order.** The design cites R3 in `ocapn-noise-cryptographic-review.md` § 6 as rewritten by #1475, so this PR should land after #1475. If #1475's review changes R3, drop the design commits.

**Not built: R2** (per-connection `sessionId`). It waits on the review's open question Q2 and is parked as job `endo-but-for-bots-ocapn-noise-session-id-r2-build`.

<!-- garden-related-design: 1475,1481 -->

### Security Considerations

No behavior change. The test pins the property that makes IK's key-compromise-impersonation weakness harmless, and the README makes it and the no-0-RTT rule normative. The design amendment removes the only path that could reuse a ChaCha20-Poly1305 `(key, nonce)` pair.

### Scaling Considerations

None.

### Documentation Considerations

Package README and the session-reconnect design, as above.

### Testing Considerations

The new test fails when the responder is mutated to graduate after a failed `op:start-session` exchange. `yarn test test/network.test.js` in `packages/ocapn-noise` passes (38/38).

### Compatibility Considerations

None. There is no wire or API change.

### Upgrade Considerations

None.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

<!-- garden-job: endo-but-for-bots-ocapn-noise-cryptographic-review-open-pr -->
----- END BODY -----
