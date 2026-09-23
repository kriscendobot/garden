Merge confirmed: `state=MERGED`, merge commit `252d5c6b`, merged at 2026-07-12T14:56:50Z onto `feat/mount-glob-delegated` (the intended stacked base). #681 remains OPEN on the preserved head branch — stack intact.

## Completion report

**Job:** Finalize (curate → merge) endojs/endo-but-for-bots PR #680, "feat(daemon): EndoMount.grep decoupled from glob, delegating to @endo/platform/fs/search (C′ of #127)".

**What I did (conductor role):**
- Re-verified the guards before merging: bot repo (`endojs/endo-but-for-bots`) ✓; PR OPEN, `mergeable=MERGEABLE`, `mergeStateStatus=CLEAN` ✓; not draft (no un-draft needed) ✓; all 23 CI checks passing ✓.
- Determined the base `feat/mount-glob-delegated` is a **legitimate stacked-PR base** (head of the still-open #679, B′), not a frozen-base snapshot (`^(llm|main|master)-<sha>$`), so the unfreeze step did not apply.
- No fixer-follow-up tidy was warranted (approved as-is); merged with `gh pr merge 680 --merge` (merge-commit shape, per conductor discipline).
- Detected that **#681 (T of #127) is stacked on #680's head branch** (`feat/mount-grep-delegated`), so I deliberately did **not** pass `--delete-branch`, preserving #681's base.

**Verified outcome:**
- #680 → `state=MERGED`, merge commit `252d5c6bac2577dedde39b5f39fe7e4b5b980839`, `mergedAt=2026-07-12T14:56:50Z`.
- #681 remains OPEN on its intact base `feat/mount-grep-delegated`.

**Changes:** Upstream only (the merge). No garden-repo (`main2`) changes.

**Follow-ups (conductor does not post these; noted for the next triager tick):**
- The stack continues: #679 (B′, base of #680) and #681 (T, stacked on #680's head) are both still OPEN — merging #680 into `feat/mount-glob-delegated` advances #679's branch content. When their approvals land, they are the next merge candidates in stack order.
- The head branch `feat/mount-grep-delegated` was intentionally left undeleted because #681 depends on it; it becomes eligible for cleanup once #681 merges or retargets.
