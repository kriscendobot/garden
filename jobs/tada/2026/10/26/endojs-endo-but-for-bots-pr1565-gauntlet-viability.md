**Viability gate: endojs/endo-but-for-bots#1565, "feat(exo-git): structured Git.diff with a diffText porcelain sibling"**

The PR is open and not merged, so the gauntlet can go ahead. It is a draft, opened 2026-10-26T07:11Z by job `build-daemon-git-next-steps`, and has no comments or reviews yet. Its base is `llm-d5ac419`, and that base is the current `llm` tip (`llm` is 0 commits ahead of it). I spent nothing on clean, panel, fix, CI-wait or un-draft.

Deciding question: Is the Phase 7 "Structured Result Shapes" work still open on current `llm`, with no other change already delivering structured `GitDiff` or `diffText`?

Evidence:
- **Design still lists the work as open.** On `llm`, the status line of `designs/daemon-git-capability.md` reads "Phase 7 structured shapes open", and the Phase 7 checklist items (land `GitDiff`/`GitFileDiff`/`GitDiffHunk`, add the `*Text` siblings such as `diffText`) are still unchecked.
- **Not implemented on `llm`.** `packages/git/src` on `llm` contains only `index.js`, `native-git-backend.js`, `native-git-backend-types.ts` and `git-askpass-helper.cjs`. There is no `parse-diff.js`, and the only code-search hit for `diffText` is this PR.
- **No competing PR.** Searching open PRs for GitDiff, diffText and "Structured Result" finds no other implementation. The other hits are unrelated (#1501 is a floot edit-preview).
- **Premise still holds.** The PR builds only on landed substrate (Phases 1–5 via #705, #706, #707, #645, #626) and is the first slice of the open parallel Phase 6/7 lane. Its base is current, so nothing on `llm` has moved past it.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1565-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (238344 cached reads)
- Output: 1603 tokens
- Cost: $0.4576888000000001
- Wall-clock: 35s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
