**Gauntlet viability: kriscendobot/minion.town PR #167, proceed**

PR #167 is open, unmerged and a draft. It adds one file, `designs/root-canary-principal.md`, and was opened at 2026-10-07T22:07Z. Its head is `e0b7702d`.

Deciding question: Has nothing newer replaced this design, and is the fleet still unable to run the production Claude canary (garden#89 items 4–5) on the #165 deployment because it has no non-interactive root session?

Evidence:
- **No newer base history.** The PR's base, `main-d750b09`, is pinned to `d750b09b`, the #165 merge. That commit is still the tip of `main`.
- **No competing PR.** A search for "root canary principal" finds only #167. The nearby PRs either already merged (#87, #97, #98, #120, #150, #165) or deal with other things (#106 and #115 are inference backend prototypes).
- **No competing design.** No other design about a root, canary or principal exists in `designs/` on `main`.
- **The motivating need still holds.** The PR body says kriskowal asked for it at the 2026-10-07 muster after the #165 deploy validation stopped at the missing root session. Nothing on `main` since then adds a root canary principal or a client for it.
- **No reviews or comments yet**, so nobody has rejected or redirected it.

The design has eight open questions for the maintainer. The main two are who does the one-time kriscendobot sign-in and whether full root over MCP is acceptable. Those are for review to settle and don't affect viability.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr167-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (111614 cached reads)
- Output: 1029 tokens
- Cost: $0.35946279999999997
- Wall-clock: 16s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
