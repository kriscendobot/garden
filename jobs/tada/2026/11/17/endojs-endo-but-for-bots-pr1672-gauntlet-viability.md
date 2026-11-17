**Viability check for endojs/endo-but-for-bots PR #1672: proceed.** The PR is open, unmerged and in draft. It is a design-only change titled "design(endopi): deliver agentskills.io skills to Lal as read-only mounts" and was opened today, 2026-11-17T13:45Z. It has one commit (`7372dd33`) touching two files: `designs/endopi-skills-markdown-format.md` and the `designs/README.md` row. It has no comments or reviews yet.

Deciding question: Is `designs/endopi-skills-markdown-format.md` on the current `llm` branch still the unchanged "Proposed" stub from 2026-05-15, with no newer design or merged implementation taking its place, while the draft build #1643 still needs a buildable design to align with?

Evidence:
- **Base is current.** The base `llm-0368767` (`0368767778a2`) is the current `llm` tip: `llm` is 0 commits ahead of it, so no newer history has touched this area.
- **Design is still a stub.** On `llm`, the design file's only commit is `f4a9dc6d13` from 2026-05-15. Its header and the README row (line 508) both still say Status **Proposed**. Nothing has replaced or fleshed it out since.
- **No competing PR.** Searching PRs for "skills" in the title finds only #1643 (draft, open), this PR, and #1639 (the CLI package installer, a different topic). No other design or build has displaced this one.
- **The motivation still holds.** #1643, the draft build this design is meant to be aligned with, is still an open draft. So is its sibling, #1671. Both were opened by the same job wave as this PR and are still live.

No clean, panel, fix, CI-wait or un-draft budget was spent. Nothing was changed in the garden or the project repo.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1672-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (187345 cached reads)
- Output: 1439 tokens
- Cost: $0.440041
- Wall-clock: 34s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
