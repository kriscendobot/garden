---
arc: minion-town-mcp-ocapn
role: designer
tier: mentor
fallback-tier: minion
requires: host=endolin-garden-ece02cb4
dispatch: automatic
---
Open-PR handoff for design job `design-endo-but-for-bots-ocapn-noise-session-reconnect` (claimed on oros-studio-garden-ce242c49, whose bot PAT gets a 403 on endojs `createPullRequest`). The design is written, committed, and pushed. Your only task is to open its draft PR from this host, then complete with the PR named in your report so the completion machinery stages the design-panel gauntlet. Do NOT edit the design.

- Repo: endojs/endo-but-for-bots
- Head: `design/ocapn-noise-session-reconnect-protocol` (commit 75a361e7e, adds only `designs/ocapn-noise-session-reconnect-protocol.md`)
- Base: the frozen `llm-92b91a7` (already exists, equals the `llm` the design was written against)

Steps:
1. `P=$(scripts/jobs/ensure-project-worktree.sh <your-job-base> endojs/endo-but-for-bots design/ocapn-noise-session-reconnect-protocol)`, then cd "$P". ensure-pr.sh must run with cwd = the project worktree.
2. Write the PR body below (between the BODY markers) to a file F and run:
   `scripts/jobs/gardening/ensure-pr.sh design-endo-but-for-bots-ocapn-noise-session-reconnect endojs/endo-but-for-bots design/ocapn-noise-session-reconnect-protocol llm-92b91a7 --title "docs(designs): ocapn-noise session reconnect protocol and build breakdown" --body-file F`
   The first argument is the ORIGINAL design job base, on purpose: the marker then ties the PR to that design job. Leave the PR draft.
3. In the report, cite the draft PR first and add a `## Follow-ups` section naming the build: slices B1–B4 and D1 of `designs/ocapn-noise-session-reconnect-protocol.md`. Sequence them per the design's Build Breakdown, because B2, B4, and D1 must wait for #1483, #1482, and #1487 to merge.

----- BODY -----
Refs: #252, #1476, #1478, #1481, #1482, #1483, #1487, #1506

## Description

This adds `designs/ocapn-noise-session-reconnect-protocol.md`, a companion to `designs/ocapn-noise-session-reconnect.md` (design PR #252). It firms up the Proposed design against the open stack: #1476 → #1478 → #1481 → #1482 → #1483.

- **Protocol:** the reconnect protocol as the stack builds it, written as rules R1–R12, with a state diagram and a sequence diagram. It covers Rekey only, the session token as the resume capability, which epochs are accepted, refusal by an epoch-0 hello, exactly-once replay by session frame index, crossed hellos, and bounded retention. Two rules correct the parent design. R5 withdraws § 4's CapTP-layer dedup requirement, because the network already replays each frame exactly once. R12 pins `sessionId` (#1506) to the epoch-0 handshake hash.
- **Build breakdown:** B1 adds conformance tests. B2 bounds retention (at `9cc4169`, nothing caps the queue while a session is detached). B3 tests that `sessionId` stays stable across epochs. B4 turns reconnect on in the daemon. D1 folds this document back into the parent design and its README row. Each slice names its files and says whether it must wait for a stack PR to merge.

**No file overlap.** This PR adds one new file. It does not edit `designs/ocapn-noise-session-reconnect.md` (edited by #1481, #1482, #1487) or `designs/README.md` (edited by #1482, #1487). The README row is deferred to D1 for that reason, which departs from `designs/AGENTS.md` until D1 lands.

**Open questions for @kriskowal:** C1, confirming Rekey-only as requested on #1487; whether the daemon should turn reconnect on by default; and B2's retention defaults.

### Security Considerations

R1 (Rekey only) rules out `(key, nonce)` reuse. Under R2, resume authority is the session token from an authenticated channel, not an identity check.

### Scaling Considerations

R10 bounds the memory each session can hold for replay.

### Documentation Considerations

Design only.

### Testing Considerations

Design only. Both mermaid diagrams pass a parse check.

### Compatibility Considerations

None. The design describes the wire format #1481 and #1483 already define.

### Upgrade Considerations

None.

🤖 Generated with [Claude Code](https://claude.com/claude-code)
----- END BODY -----
