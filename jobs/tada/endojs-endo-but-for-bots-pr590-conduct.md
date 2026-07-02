PR #590 is merged. Base was the live trunk `llm` (not a frozen snapshot), merge-commit `1132289` created, head branch deleted by the spine.

## Completion report

**Job:** Finalize (curate → merge) endojs/endo-but-for-bots PR #590 — "refactor: repoint @endo/far consumers and deprecate its plain re-exports (#548 follow-up, stage 1)".

**Guards re-verified before merging:**
- Bot repo only — `endojs/endo-but-for-bots` ✓ (not agoric-sdk or upstream endo).
- OPEN, not draft, `mergeable=MERGEABLE`, `mergeStateStatus=CLEAN`, all 24 checks `SUCCESS` ✓.
- Base `llm` is the live trunk (no `-<sha>` frozen-snapshot suffix) — no unfreeze needed ✓.
- Not already merging/merged (`autoMergeRequest=null`, `state=OPEN`) at claim time ✓.

**Action:** Ran the conductor's deterministic spine `ci-wait-merge.sh endojs/endo-but-for-bots 590 --merge`. It confirmed the rollup terminal-green (24/24, 0 failed) and merged with the merge-commit method + `--delete-branch`.

**Result (verified via `gh pr view`):** `state=MERGED`, `mergedAt=2026-07-02T14:32:55Z`, `baseRefName=llm`, merge commit `1132289243ba5a714efec1008693bcefbfbeb438`. Head branch `refactor/inter-package-far-repoint-deprecate` deleted by the spine.

**Follow-ups:** None from me — the conductor does not post follow-ups. This PR is the "#548 follow-up, stage 1", so a later triager tick may surface subsequent stages, but nothing is owed by this job. No garden-repo (main2) changes were needed; this was a pure project-merge job.
