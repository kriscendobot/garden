Viability check for endojs/endo-but-for-bots PR #1571 ("feat(exo-git): structure Git stash results"): **proceed**. The PR is current and nothing has replaced it.

**PR facts:** The PR is open, unmerged and in draft. It was created 2026-10-26T17:51Z, and its head is `7c80ef76cf`. Its base is the frozen `build-daemon-git-next-steps-structured-rebase-6360fc5`. It sits on top of #1570 (structured `Git.rebase`), which is still open and in draft. There are no reviews or comments yet.

**Deciding question:** Does `llm` still return plain strings from `Git.stashList()` and `Git.stashShow()`, while the design still lists "structured stash" as unfinished Phase 6 work that no other PR covers?

**Evidence:**
- **Code on `llm` is unchanged:** `packages/exo-git/src/types.ts` still declares `stashList: () => Promise<string[]>` and `stashShow: (index?) => Promise<string>`. No structured stash shape or `*Text` sibling has landed. The last commit touching `packages/exo-git/src` is `b62a180cb9` (2026-09-20), which has nothing to do with stash.
- **The design still needs it:** `designs/daemon-git-next-steps.md` on `llm` (status In Progress) lists "structured stash" among the planned Phase 6 shapes, mapped to daemon-git-capability § Phase 7. The PR's evidence ledger matches this: Phase 6 is partial, and a named successor (`build-daemon-git-next-steps-read-only-type-narrowing`) owns the remaining `readOnly()` typing.
- **No competing PR:** a search of PR titles in the repo for "stash" returns only #1571.
- **The stack ancestor is alive:** #1570 is open, so this slice's base is current.

The gauntlet can start. It should follow the stack order, behind #1570.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1571-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (177706 cached reads)
- Output: 1465 tokens
- Cost: $0.4346172
- Wall-clock: 21s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
