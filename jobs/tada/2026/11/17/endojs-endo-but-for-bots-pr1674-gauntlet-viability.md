**PR #1674 viability check: `viability=proceed`.** PR #1674 is still open, has not been superseded, and its reason for existing still holds, so the gauntlet can begin.

- **State:** Open and unmerged, still a draft. It is titled "design(endopi): specify extension package manifest lifecycle" and was opened 2026-11-17T21:13Z. Its head is `design/endopi-extension-package-manifest` @ a951879b0b and its base is `llm-0368767`.

Deciding question: Is the current `designs/endopi-extension-package-manifest.md` on `llm` still the original M10 outline from #265, with no newer design or merged change replacing it, while the implementation draft #1639 it is meant to steer is still open and not yet reworked?

Evidence:
- The PR changes only `designs/endopi-extension-package-manifest.md` (+290/−86). On `llm`, the last change to that file was f4a9dc6d13 (2026-05-15), which is the #265 outline this PR builds on. Nothing has changed the file since.
- `llm` and the PR's pinned base `llm-0368767` (0368767778) are identical (0 commits ahead, 0 behind), so the PR is current with its base.
- No other PR, open or closed, specifies the endopi extension package manifest. The searches found only #1674 itself.
- The PR's stated purpose is to give the open implementation draft #1639 ("install packages of skills and prompts with one command") a list of changes to make. #1639 is still an open draft and was last updated 2026-11-03, so it has not yet been reworked.
- The two designs this one follows, #1671 (prompt templates, open and ready for review) and #1672 (skills as read-only mounts, open draft), are both still open. Neither has been replaced, so this design is the next one in that series.
- The PR has no reviews or comments that dispute what it is for.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1674-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (186193 cached reads)
- Output: 1506 tokens
- Cost: $0.43675060000000004
- Wall-clock: 29s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
