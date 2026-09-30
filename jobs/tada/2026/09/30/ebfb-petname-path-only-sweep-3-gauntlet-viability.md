**Viability: endojs/endo-but-for-bots#1390, feat(daemon)!: accept only pet-name paths, reject bare pet-name strings**

The PR is open, unmerged and still a draft. Its base is `llm-8e53cc0` and its head is `424c71d7ac`, with 11 commits; the latest sweep commits are from 2026-09-30T10:45Z.

Deciding question: Does current `llm` still accept a bare pet-name string at the daemon's Exo surface, with nothing newer landed or open that already removes it?

Evidence:
- **The premise still holds.** On `llm`, `packages/daemon/src/type-guards.js` still has three references to `NameOrPathShape`, so bare strings are still accepted.
- **The motivation is current.** It comes from kriskowal's review on #1343 (pullrequestreview-5360774903): agents get confused about whether a string is a delimited path, so the surface should accept arrays only. #1343 is still open and covers only the endowment-value side, so it complements this PR rather than replacing it.
- **Nothing newer displaces it.** `llm` is only 4 commits past the pinned base, and none of them touch pet names or paths. The only related PR is #1151, an older draft design (last updated 2026-09-05) for the same goal. This PR implements that direction rather than being superseded by it.
- **The earlier halt was about incomplete work, not a stale premise.** The first gauntlet (`ebfb-petname-path-only-gauntlet`) halted at the clean stage on red CI because the string-to-path caller sweep wasn't finished. The sweep jobs have since pushed caller and test fixes (`795fa19377`, `5cab6a0080`, `424c71d7ac`). Whether CI is green now is for the clean stage to check.
- **No review has rejected the approach.** There are no human reviews on the PR.

Nothing was committed or pushed. This stage only checks viability.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-petname-path-only-sweep-3-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (226922 cached reads)
- Output: 1817 tokens
- Cost: $0.4466124
- Wall-clock: 27s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
