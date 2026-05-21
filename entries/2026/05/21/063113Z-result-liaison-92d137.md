---
ts: 2026-05-21T06:31:13Z
kind: result
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/21/062400Z-dispatch-liaison-92d137.md
  - entries/2026/05/21/062944Z-result-boatman-e5dc73.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 75
    role: source
  - repo: endojs/endo
    pr: 3232
    role: target
---

Recompute-from-master re-ferry of #75 closed. **Advanced from CONFLICTING to MERGEABLE**.

- Upstream PR head: `6fbe4b06a` → `71055ef1780339fece1b13eedc48a8a1f37e9164` via force-push-with-lease (lease satisfied; pre-flight check passed).
- **11 commits** in order, all author + committer `Kris Kowal <kriskowal@kriskowal.com>`, zero bot trailers (source's endolinbot attribution rewrote cleanly via `--reset-author`):
  - `c5d08db77` feat(random): @endo/random samplers
  - `6bc35af94` feat(chacha12): @endo/chacha12 keystream
  - `8ec16285d` feat(chacha12-fast-check-test): test-package shape
  - `ce8c3370e` refactor(hex)
  - `5b9c35ee7` refactor(ocapn)
  - `91cda2581` fix(ses) tuple-typed args
  - `15bfaee23` style(evasive-transform)
  - `f27fb8c31` docs: thunk-module policy
  - `8c8205b0f` chore: tsconfig + typedoc
  - `f161c4219` docs(random,chacha12): changeset
  - `71055ef17` chore: Update yarn.lock
- **Cherry-pick conflicts** were minimal: three commits triggered "Auto-merging" (commit 5 on `packages/ocapn/package.json`, commit 9 on `tsconfig.composite.json`, commit 11 on `yarn.lock`), all 3-way merges resolved by git without manual edits. No regenerated yarn.lock was needed.
- **Mergeability**: advanced from CONFLICTING (long-standing on this PR) to MERGEABLE; `mergeStateStatus: BLOCKED` (needs-review gate).
- Source-side cross-link on #75: [issuecomment-4505395388](https://github.com/endojs/endo-but-for-bots/pull/75#issuecomment-4505395388).
- Title and body untouched.

Worktree-index marked collected; dispatch root torn down (#79 boatman still in flight on the other parallel track).

Self-improvement: nothing structural this turn — the recompute-from-master shape applied cleanly and the 11-commit preservation succeeded without intervention. The 3-way auto-merges on package.json / tsconfig.composite / yarn.lock are noteworthy as the typical "mostly clean" pattern when bot-fork master lags upstream master by a few commits worth of unrelated edits; git's 3-way handles them naturally.
