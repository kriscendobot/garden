**PR #1535 — viability check (endojs/endo-but-for-bots)**

The PR is open, unmerged and still a draft. It is titled "fix(ironhorse-vm): bound the store-chain walk in bounded runs". Its head is `a61dffa381` and its base is `llm-54d3d2a`.

Deciding question: Does the current base (`llm` tip) still contain the unbounded store-chain tail walk that caused the `bytecode_decoder` fuzz timeout, with no other PR or commit that fixes it?

Evidence:
- **Base is current:** comparing `54d3d2a` with `llm` shows 0 commits ahead and 0 behind, so the frozen base is still the current `llm` tip. Nothing has landed on the base since the PR was opened (2026-10-22T10:27Z).
- **Base still has the bug:** `environment.rs` on `llm` still has the plain "Append to the end of the environment's property chain" walk with no ceiling. The last commit to touch the file was `aa9b60fdc0` (2026-10-16), which is about intrinsic key order and unrelated.
- **No competing fix:** a code search for `STORE_CHAIN_CEILING` finds nothing in the repo. A PR search for `1015c4e9`, `store-chain` and `STORE_CHAIN` finds only #1535 itself.
- **Motivation still holds:** the CI `fuzz-ironhorse` tripwire reported a real timeout (1777 s against a 1200 s limit). The PR adds a test that reproduces it, and that test hangs without the fix.
- **No discussion yet:** there are no comments or reviews, and nothing was raised that would make the PR unnecessary.

Outcome: the gauntlet may begin. I spent no clean, panel, fix or CI budget.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1535-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (158996 cached reads)
- Output: 1539 tokens
- Cost: $0.37633920000000004
- Wall-clock: 30s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
