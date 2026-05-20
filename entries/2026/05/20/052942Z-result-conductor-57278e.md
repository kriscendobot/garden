---
ts: 2026-05-20T05:29:42Z
kind: result
role: conductor
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
dispatch_id: cb04ea
prs:
  - repo: endojs/endo-but-for-bots
    pr: 307
    role: stalled
---

**Stalled PR #307** (`designs: @endo/patterns diagnostic feedback (3 axes)`) at the merge step. **Reason: `rebase conflict` (needs weaver).** Did not attempt resolution per the dispatch prompt's explicit instruction.

**Pre-action state.**

- `state=OPEN`, `isDraft=true`, `reviewDecision=APPROVED` (kriskowal at 2026-05-20T05:27:06Z on commit `20dad47f5`).
- `mergeable=CONFLICTING`, `mergeStateStatus=DIRTY`. GitHub's own merge-tree calc reports conflicts against current base.
- `headRefOid=20dad47f5e171a8570d7f8ae9d465069c9da63b3` (matches dispatch's named branch tip).
- PR's recorded `baseRefOid=65d3093cc1f7d934050c2a4de4a10dccbec74eb1`; current `origin/llm` is at `2d12449a0` (the 04:49 conductor's merge of PR #304). Merge-base of head vs `origin/llm` is `68246ad92`, so the PR is 91 commits behind base.
- `autoMergeRequest=null`.
- `statusCheckRollup` empty (no CI runs against the PR head; the conflict prevents the on-PR ephemeral merge commit from being constructed, so the docs-only checks haven't been computed against an integrable tree).

**Action taken.** None on GitHub. Per the dispatch prompt: "If the PR has merge conflicts with current base, do NOT resolve them — abort and dispatch a weaver instead (return that signal to the steward)." Confirmed conflict via two independent reads of `gh pr view 307 --json mergeable,mergeStateStatus`; both reported `CONFLICTING / DIRTY`. Aborted before any push or merge command.

**Second blocker noted but not acted on.** The PR is still `isDraft=true`. The judge un-drafts on PR-creation-flow termination, which has not happened for #307. The maintainer's APPROVED review explicitly says "Please dispatch to the conductor and then a builder to implement," which reads as an authorization to merge the design PR despite the draft flag (designs ship to the `<project>/designs/` lane separately from the gamut). Even so, `--merge` on a draft PR is rejected by GitHub; an un-draft step is needed before the conductor's re-dispatch will succeed. Flagging this for the steward so the weaver dispatch is paired with an un-draft (`gh pr ready 307`) before the conductor re-attempts.

**Next steward action.** Dispatch a weaver to rebase `design/patterns-diagnostic-feedback` onto current `llm` (`2d12449a0`). Designs-only PR; conflict surface is plausibly `designs/README.md` (the 91-commit window is dominated by README/status sweeps from PR #304 and earlier roadmap-calibration commits). After the weaver's force-with-lease push lands and CI converges, mark the PR ready-for-review (`gh pr ready 307` — per-action authorization needed, since un-drafting a maintainer-approved design PR is an upstream mutation outside the conductor's "drain the merge queue" implicit authority) and re-dispatch the conductor.

**Unblocked downstream.** None (PR not merged).

**Self-improvement:** nothing this time. Two prior 2026-05-20 conductor runs (`4e509c` at 03:10, `38cdbc` at 03:51) on this same PR also stalled with `rebase conflict`; the pattern is stable and the rebase-before-merge gate is doing its job. The draft-flag side-blocker is novel for design-lane PRs in this engagement; recording it inline above lets the steward stage the un-draft alongside the weaver re-dispatch without a separate skill-level fix.
