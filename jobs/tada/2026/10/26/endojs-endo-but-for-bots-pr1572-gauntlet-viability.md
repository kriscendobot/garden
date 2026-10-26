PR #1572 can enter the gauntlet: it is open, not superseded, and the bug it fixes is still present on `llm`. I spent no gauntlet budget.

**Deciding question:** Does current `llm` still pick the Git facet from the mount's read-only flag alone, so that `provideGit(writableMount, name, { readOnly: true })` still hands back a writable Git, with no newer PR fixing that?

**Answer:** Yes. So the PR is not superseded and its reason for existing still holds.

**Evidence:**
- **PR state:** open, draft, not merged, opened 2026-10-26T18:03Z. Its base is a frozen snapshot of #1571 (`build-daemon-git-next-steps-structured-stash-9e885d3`). #1571, the structured-stash PR underneath it, is also an open draft. There are no comments or reviews yet.
- **Current `llm` code:** in `packages/daemon/src/manager.js` on `llm`, the `git` formula still calls `makeGit(..., { readOnly: backing.readOnly, allowHistoryRewrite })`. The facet is still chosen from the mount alone and no `readOnly` flag is saved in the formula. That is the bug the PR describes: `designs/endo-workflow.md` gives reviewers a Git provisioned this way as their read-only grant, so a reviewer could commit through it.
- **Not superseded:** a search for `readOnly provideGit` finds no competing PR. Related merged work covers different ground: #920 rejects a writable Git over a read-only mount, and #835 distinguishes Git authority postures. Neither records a declared read-only setting over a writable mount.
- **Design context:** the PR is the last Phase 6 item in `designs/daemon-git-next-steps.md` (it also finishes Phase 7 of `designs/daemon-git-capability.md`). Phases 1–4 are already merged (#705, #706, #707, #645), so this is the planned next step on top of the stack #1565→#1571.

**Follow-up:** because the PR sits on a frozen snapshot of #1571, it will need re-pinning (a weave) once #1571 lands or moves.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1572-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (180803 cached reads)
- Output: 1439 tokens
- Cost: $0.4386766
- Wall-clock: 28s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
