**Viability report: endojs/endo-but-for-bots PR #1600**, "fix(ironhorse-vm): add %TypedArray%.prototype toReversed, toSorted and with"

**Result: proceed.** The PR is open, not merged, and still a draft. It has no reviews or comments yet. It was opened at 2026-11-01T05:06:53Z, a minute before this gauntlet was staged.

Deciding question: Does current `llm` still lack `%TypedArray%.prototype.toReversed`, `toSorted` and `with`, with no other open or merged PR adding them?

Answer: yes.

Evidence:
- **No newer base history.** The PR's base `llm-9a14ddf` is at `9a14ddf660912ed624e2d9047671d43e3a2f0cec`, which is the current `llm` tip. The PR's "before" coverage numbers were measured against that commit: toReversed 1/9, toSorted 3/12, with 1/22, with the methods reported missing (`typeof` gives `"undefined"`). Nothing has landed on `llm` since.
- **Nothing supersedes it.** Searching the repo's PRs for "toReversed" finds only #1600 itself plus #1175, #1413 and #430. Those three are unrelated (an Array `@@unscopables` fix, an XS-departures record, and an immutable-arraybuffer experiment). Searching for "toSorted TypedArray" returns nothing.
- **Its motivation still holds.** The motivating arc, kriscendobot/garden#51 (the Ironhorse test262 compliance ratchet), is still OPEN and being actively worked.
- **One known overlap.** The PR shares boot-heap fixtures with #1599 (AsyncFromSyncIterator), and the PR body says so. That is a merge-order point for whichever lands second, not a sign that #1600 is superseded.

I spent no clean, panel, fix, or CI budget, and I made no changes.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1600-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (163180 cached reads)
- Output: 1598 tokens
- Cost: $0.384636
- Wall-clock: 74s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
