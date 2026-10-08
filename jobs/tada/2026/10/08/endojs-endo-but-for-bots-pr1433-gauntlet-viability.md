**Viability report: endojs/endo-but-for-bots PR #1433**, "design(daemon): make formula shares independently revocable"

**Verdict: proceed.** The PR is open, unmerged and still a draft. Base `llm-7d2eb30`, head `69e45989`, opened 2026-10-08 by job `design-endo-formula-identifier-indirection`. It has no reviews or comments yet.

**Deciding question:** Does current `llm` still put formula identifiers directly into locators and pet-store entries, with no newer design or implementation already adding a revocable per-share indirection?

**Evidence:**
- **The premise still holds on current `llm`.** `packages/daemon/src/locator.js` still writes the formula number into every locator and returns it when one is parsed (lines 158–222). No commits have touched `packages/daemon/src` on `llm` since 2026-10-07.
- **Nothing has replaced it.** There is no indirection or revocable-share design under `designs/` on `llm`. The design files that are there (`daemon-locator-reference.md`, `daemon-256-bit-identifiers.md`, `sturdy-refs-endor-syscall.md`) come before this proposal, and it builds on them.
- **The nearby PRs are covered by the design itself.**
  - It explicitly rejects #1124 (formula-nonce locator) as the new public format, because that still exports the formula number.
  - It names how #539, #695, #697 and #1389 relate to it, and says #697 must change.
  - The other matches from a PR search (#1344, #1398, #1399, #1332, #1333) deal with related surfaces but none of them adds per-share revocation.
- **The direction is current.** The design cites the maintainer's direction of 2026-10-08 (today), and the PR was opened about two hours before this check.

I spent nothing on clean, panel, fix, CI-wait or un-draft, and made no changes to the garden or the project.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1433-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (249115 cached reads)
- Output: 2228 tokens
- Cost: $0.404895
- Wall-clock: 66s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
