Done. Empty inbox, worktree removed.

## Completion report

**Job:** resolve merge conflict on endo-but-for-bots #572 (design-only, base `llm`)

**What I did:**
- Rebased head branch `design/bytearray-uint8array-view` (6 commits) onto current `origin/llm`.
- Resolved conflicts in `designs/README.md` across two of the head commits. Both hunks were the same design-index table region: `llm` had removed the `[endo-gateway]` row (folded into `gateway-package` per its status note), while the PR added the `[bytearray-uint8array-view]` row and still carried `[endo-gateway]` as context.
  - Commit 1 hunk: kept `llm`'s removal of `endo-gateway`, added the new bytearray row (`2026-06-30 | 2026-06-30`).
  - Commit 2 hunk: took the incoming update to the bytearray row's revision date (`→ 2026-07-01`), kept `endo-gateway` removed.
- Force-pushed with `--force-with-lease` (old tip `7d8a5c577` → new `9958c918c`).

**Verification (net design content invariant):**
- No conflict markers remain.
- Net PR diff vs `llm` is exactly the intended contribution: the new `designs/bytearray-uint8array-view.md` (262 lines) plus the README additions (one design-index table row + its prose entry). No spurious re-introduction of the `endo-gateway` row that `llm` had removed.
- PR #572 state now: `mergeable: CONFLICTING → MERGEABLE`; `mergeStateStatus: DIRTY → UNSTABLE` (CI pending only, no conflict). `headRefOid` matches the pushed `9958c918c`.

**Follow-ups:** None required for the conflict. `mergeStateStatus=UNSTABLE` reflects pending CI checks on the freshly pushed head — expected for a doc-only branch; no action owed by this job. (GitHub also surfaced a pre-existing dependabot vulnerability banner on the repo's default branch, unrelated to this change.)
