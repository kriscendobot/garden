**PR #1430 viability: proceed.** The PR has not been superseded, and the problem it addresses is still present on `llm`. I spent no clean, panel, fix, or CI budget on this check.

- **PR facts:** #1430 is open, unmerged and a draft. It is titled "design(ocapn): network-owned identity exchange (revise tcp-for-test extraction)". The base is frozen at `llm-f1e3065` (`f1e30658`) and the head is `75e7151b`. The bot opened it at 2026-10-07T14:51Z, about two minutes before this check. It has no reviews or comments yet. It changes only design docs: `designs/{README,ocapn-noise-network,ocapn-tcp-for-test-extraction,ocapn-tcp-syrup-framing}.md`.

Deciding question: Does current `llm` still have the core `op:start-session` fallback hooks (`sendSessionHandshake` and friends) with no shared start-session wrapper, and has no newer PR or commit already redesigned or implemented network-owned identity exchange?

Evidence:
- **`llm` has not moved.** Comparing `f1e30658...llm` shows 0 commits ahead, so the design was written against the current tip.
- **The core fallback is still there.** `sendSessionHandshake` still appears in `packages/ocapn/src/client/index.js`, `packages/ocapn/src/client/types.js` and `packages/ocapn/src/netlayers/tcp-test-only.js`. Removing those hooks is the design's phase 4, so that work is still undone.
- **The wrapper doesn't exist yet.** `makeStartSessionNetwork` has no code hits in the repo, and `packages/ocapn/src/start-session.js` is absent on `llm`.
- **No competing PR.** Searching the repo's PRs for the extraction design and start-session titles turns up only #1430. The related OCapN PRs (#1013, #1396, #1397, #693) cover other topics.
- **The PR is itself the up-to-date revision.** It already takes into account the things that made the earlier draft stale: Noise's `provideSession` bypass, Iroh's dependence on the core fallback, the one-hint-per-transport model from merged #1071, and the framing work landed as `bdb9ddc50d`.

The gauntlet can begin. There are no follow-ups.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1430-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (164155 cached reads)
- Output: 1819 tokens
- Cost: $0.393067
- Wall-clock: 24s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
