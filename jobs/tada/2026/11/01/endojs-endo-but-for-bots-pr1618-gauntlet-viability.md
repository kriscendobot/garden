**Viability check: endojs/endo-but-for-bots PR #1618: proceed**

PR #1618 is open, unmerged and a draft. It has no reviews or comments yet. It was opened on 2026-11-01 and its head is `19ce4df…`/`cd17f59…`. The base is the frozen `llm-9a14ddf`, which equals the current `llm` tip (0 commits ahead).

Deciding question: Does the current base still refuse the 65,537th backtrack state in the plain uncompressed stack, with no other open or merged PR that already fixes RGX-1 / long greedy runs?

Evidence:
- **The premise still holds.** `rust/engine/ironhorse-regexp/src/matcher.rs` on `llm` still has `MAX_MATCH_STATES: usize = 65_536` and no `StateStack`. The last change to that file was `6109e2304f` (2026-10-15), and nothing newer touches the matcher.
- **The base is current.** `compare 9a14ddf...llm` reports `ahead_by 0`, so no newer base history touches this code or the property-escapes expectation shards.
- **Nothing has superseded it.** Searches for open PRs on `ironhorse-regexp`, `MAX_MATCH_STATES` and `RGX-1` return only #1618 itself, plus unrelated ironhorse-vm ratchet PRs (#1605 RegExp.prototype getters, #1364 configurable abort policy). No merged PR since 2026-10-15 touches the regexp matcher.
- **The motivation is current.** This is coverage-crank slice 18 of the active test262 ratchet: 58 rows move from `skip:ironhorse-aborted-limit` to `pass`. The leftover ~820 rows, which now hit the 256 MiB chunk ceiling, are named as follow-up work outside this PR.

I spent no clean, panel, fix or CI budget, and I made no garden or project changes.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1618-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (214544 cached reads)
- Output: 1878 tokens
- Cost: $0.4055408
- Wall-clock: 72s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
