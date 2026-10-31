**PR #1597 viability: proceed.** The PR is open, unmerged and still a draft. Its base `llm-9a14ddf` is the current `llm` tip, and the work it does is still undone on `llm`.

Deciding question: On current `llm`, is the Phase 5 item "Extend the `473b718b3` contract test" in `designs/daemon-agent-tools.md` still unchecked, with no other PR delivering a runtime contract test and the `GIT_READONLY_MEMBERS` drift still present?

Answer: yes. Evidence:
- **Facts from `gh pr view`:** the PR is OPEN, `isDraft=true` and was opened 2026-10-31T19:31Z. Head is `ca6f7c53`; base is `9a14ddf6` (`llm-9a14ddf`). It came from build job `build-daemon-agent-tools-phase-five-contract-test`. It has no reviews or comments yet.
- **No newer base history:** comparing `9a14ddf…llm` shows `ahead_by=0`. The base is the current `llm` tip, so no newer commit on `llm` could have overtaken it.
- **The motivating gap still holds on `llm`:**
  - The Phase 5 checklist item `- [ ] Extend the 473b718b3 contract test` is still unchecked. Every other item in that phase is ticked.
  - `packages/agent-tools/scripts/code-mode-git-extract.js` still defines `GIT_READONLY_MEMBERS` (line 70) and still filters through it (line 157). That is the hand-kept list the PR replaces, which leaves the root followers and `help` out of the read-only declaration.
- **Nothing supersedes it:** searching for `git-surface-contract` / `GIT_READONLY_MEMBERS` turned up only this PR. The nearby open exo-git and agent-tools PRs (#1565, #1569, #1571, #1589, #1557) add features. None of them adds a contract test across guards, types and declarations.

No PR or repository was changed.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1597-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (239151 cached reads)
- Output: 1661 tokens
- Cost: $0.4544102
- Wall-clock: 25s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
