Viability verdict: proceed. PR #1485 is still open and in draft, nothing newer has replaced it, and the core fallback it removes is still on `llm`.

Deciding question: Does `llm` still run `op:start-session` and the `connect`/plaintext-hello fallback inside OCapN core, with no newer implementation or design moving them out?

Evidence:
- **PR state:** #1485 (`feat(ocapn)!: move op:start-session out of core into a network adapter`) is OPEN and draft, based on the frozen `llm-a794753`. It was opened 2026-10-16 and has no reviews or comments yet.
- **Design:** it implements design PR #1480, opened 2026-10-16. That design rewrote `designs/ocapn-tcp-for-test-extraction.md` to match current code. #1480 is still open and has one critic review, which is comment-only and calls the approach sound.
- **Older design:** the earlier revision, #1430 (2026-10-07), is a draft whose gauntlet halted. It is the predecessor #1480 replaced, so #1430 does not displace #1485.
- **Current `llm`:** `packages/ocapn/src/client/handshake.js` still exists, and `client/index.js` still calls `asNetlayer.connect(location)` (line 500) and `asNetwork.sendSessionHandshake` (line 518). There is no `adoptSession` and no `netlayers/start-session.js` (only `tcp-test-only.js` and `websocket.js`). So the work is not done on `llm`, and the premise still holds: a network that implements only `connect` still gets core's plaintext hello.
- **Base drift:** the GitHub compare of `llm-a794753...llm` shows `llm` 0 commits ahead with 0 changed `packages/ocapn/` files. I did not confirm whether that means the base is exactly at `llm`'s tip, but either way no newer OCapN work sits on top of it.
- **Other open PRs:** a search of open PRs found no competing implementation. The session-reconnect PRs #1476, #1478, #1481 and #1483 touch ocapn-noise heartbeats and reconnect, not the start-session extraction.

Follow-up for later stages: by the PR's own account, it lacks a byte-capture wire-parity test and new adapter-specific crossed-hello tests. The goblin-chat, Guile interop, python and XS suites were not run locally, so CI is the only check on them.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1485-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (235217 cached reads)
- Output: 2262 tokens
- Cost: $0.47616340000000007
- Wall-clock: 42s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
