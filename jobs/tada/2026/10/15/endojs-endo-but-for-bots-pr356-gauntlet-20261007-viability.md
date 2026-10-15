**Viability report: PR #356 (`design(gateway): packaging + AWS deployment + AWS-attuned Gateway`)**

**Verdict:** the PR can enter the gauntlet (`viability=proceed`). Nothing has replaced it, and the reason it was written still holds.

**PR state:** open, not merged, not a draft. Base is `llm-b1c3f4d` and head is `design/gateway-packaging-aws-stack`. The last activity was on 2026-08-31: a round-1 design-panel review said must-fix, and CI then went green on head `18b52cac`.

**Deciding question:** Is there anything on current `llm`, or in another open or merged PR, that already covers gateway packaging CI, AWS deployment or the AWS-attuned gateway? And does `llm` still treat #356 as the pending vehicle for those designs?

**Evidence:**
- None of the three proposed designs exists on `llm` yet: `designs/gateway-packaging-ci.md`, `gateway-aws-deployment.md` and `gateway-aws-attuned.md` all return 404.
- The parent design PR #343 (`gateway-package.md`) was merged on 2026-06-30. That design has the OS-packaging feature (Feature 10), but its text has no CI, signing (sigstore/GPG) or AWS plan, so the gap #356 fills is still there.
- `designs/README.md` on `llm` lists all three designs as "Proposed" with links to PR #356. Its milestone table names #356 as the "In Review" vehicle for the AWS-hosting phase (P2, milestone M5). The base branch still expects this work.
- Related PRs build on #356 or sit beside it rather than replacing it:
  - #463 (AWS Marketplace path) explicitly builds on "the AWS-stack siblings (PR #356)".
  - #674 covers a separate topic (OAuth redirect relay).
  - #412 and #410 implement packaging recipes; they are not the CI or deployment design.
- The maintainer has made no comment or review on #356 that closes it or redirects the work.

**Notes for later stages:**
- The PR diff still includes `designs/gateway-package.md`, which is already on `llm` since #343 merged, plus some inherited workflow and tsconfig files. That comes from the stale frozen base, which a later weave would fix. It doesn't affect whether the PR is still worth doing.
- The round-1 must-fix panel findings from 2026-08-31 still need to go through the fix loop.

I made no changes and spent no clean, panel, fix or CI budget.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr356-gauntlet-20261007-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (265465 cached reads)
- Output: 2675 tokens
- Cost: $0.468873
- Wall-clock: 56s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
