Viability is **proceed**. PR #1487 is open and still a draft. It was created at 2026-10-17T01:31Z, it is based on frozen `llm-a794753`, and nothing newer has displaced it.

Deciding question: Is there still nothing on `llm` that delivers this PR's work (the key-compromise-impersonation test, the `np/1` wire contract in the README, and the change of the reconnect design to Rekey-only), and do the recommendations from the #1475 cryptographic review that motivated it still stand? **Yes.**

Evidence:
- **Base is current:** `llm` is 0 commits ahead of the PR's base `a7947533`, so nothing has landed on `llm` since the PR was cut.
- **The reconnect design still needs this change:** `designs/ocapn-noise-session-reconnect.md` on `llm` still describes the Resume option ("Option Resume (preferred)", the `RESUME`/`RESUME-ACK` records) and still lists C1 as an open question. That is exactly what this PR's R3 amendment settles.
- **The motivating review still stands:** design PR #1475 is open and not merged. Its only review is the bot's design-panel "round 1: pass" comment, with should-fix notes but no rejection, and there are no maintainer reviews. Nothing overturns R1, R3 or R4.
- **No competing PR:** among the open OCapN-Noise PRs, #1476, #1478, #1481, #1482 and #1483 are session-reconnect phases, and #1481 composes with this PR's abstract reconnect record. None adds the key-compromise test or the wire contract. The merged #1386 hardened the handshake but is older, and this PR builds on it.
- **Caveat carried forward:** the PR says that if the #1475 review changes R3, its commit to the reconnect design should be dropped. That is a review-time concern, not grounds for refusing the gauntlet now.

No clean, panel, fix or CI budget was spent, and no changes were made.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1487-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (172551 cached reads)
- Output: 1797 tokens
- Cost: $0.42255419999999994
- Wall-clock: 25s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
