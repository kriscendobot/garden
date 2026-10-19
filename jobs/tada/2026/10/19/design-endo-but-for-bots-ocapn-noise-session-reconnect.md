---
handed-off: design-endo-but-for-bots-ocapn-noise-session-reconnect-open-pr
deliverable-complete: false
---
I wrote the companion design and pushed it, but couldn't open its draft PR from this host, so I've handed that step to a successor job pinned to the endolin host.

The bot token on this host gets a 403 when creating pull requests on endojs; pushing works. A design isn't done until it has a PR, so this run ends as a handoff, not a clean completion.

**Design file:** `designs/ocapn-noise-session-reconnect-protocol.md` on endojs/endo-but-for-bots, branch `design/ocapn-noise-session-reconnect-protocol` (commit `75a361e7e`), based on the frozen `llm-92b91a7`. The two diagrams pass a mermaid parse check.

**Why a new file instead of editing the parent design:** #1481, #1482 and #1487 all edit `designs/ocapn-noise-session-reconnect.md`, and #1482 and #1487 edit `designs/README.md`. My PR adds only the new file, so it touches nothing that #1478, #1482 or #1483 touch. One consequence: the design isn't yet listed in `designs/README.md`, which the project's design conventions require. That row is deferred to slice D1, after those PRs merge.

**Reconnect protocol:** I wrote it as rules R1–R12, as the stack (#1476→#1478→#1481→#1482→#1483) actually builds it at `9cc4169`:
- **Rekey only:** every reconnect runs a full new Noise handshake, and Resume is withdrawn pending your answer on C1.
- **Resuming:** a new connection names the session it continues with `op:session-hello` and a session token. A peer that no longer holds the session refuses with an epoch-0 hello, and the dialer gives up at once.
- **Epochs:** a reconnect may jump past the next epoch, and messages from an older epoch are dropped.
- **Who dials:** either side redials. If both do, the side with the greater handshake key keeps its dial, for at most `SESSION_TIMEOUT`.
- **Two corrections to the parent design:**
  - R5: replay is exactly-once at the network layer, using a session-wide frame count. The parent's requirement that CapTP deduplicate replayed messages is withdrawn.
  - R12: with #1506, `sessionId` must come from the session's first handshake, so it stays the same across reconnects.
- **A gap in the stack:** at `9cc4169` I found no limit on how many messages a disconnected session queues. R10 calls for one.

**Build breakdown:**

| Slice | What it does | When it can start |
|---|---|---|
| B1 | Conformance tests for the rules, in a new test file | Now, stacked on #1483 |
| B2 | Limit on retained messages (`network.js`) | After #1483 merges |
| B3 | Test that `sessionId` stays stable across reconnects | After #1506 and #1481 land |
| B4 | Daemon turns reconnect on | After #1483 merges |
| D1 | Fold this back into the parent design and add the README row | After #1482 and #1487 merge |

**Open questions for kriskowal:**
- C1: does he confirm Rekey-only reconnect, as #1487 asks?
- Should the daemon turn reconnect on by default?
- Are 64 messages / 1 MiB the right retention limits?

## Follow-ups
- **`design-endo-but-for-bots-ocapn-noise-session-reconnect-open-pr`** (posted, pinned to `endolin-garden-ece02cb4`) opens the draft PR with `ensure-pr.sh`, using this job's base as the marker and the PR body included in the job. It then names the PR and slices B1–B4 and D1 so the review panel and build hand-off kick in.
- If endolin stays unclaimed for about an hour (it has stalled before because of its token cap), someone needs to message the maintainer or open the PR by hand.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-endo-but-for-bots-ocapn-noise-session-reconnect.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 82 tokens (3718708 cached reads)
- Output: 26944 tokens
- Cost: $2.2088536
- Wall-clock: 478s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
