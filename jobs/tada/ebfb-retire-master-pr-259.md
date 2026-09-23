MERGEABLE against the reflection base. The master base is retired for PR #259. This job mutates only the fork PR (no garden-library change to commit to main2). Done.

## Completion report

**Job:** Retire the `master` base for endojs/endo-but-for-bots#259 under the 2026-07-16 maintainer directive (frozen-base weave).

**Preconditions confirmed:**
- PR #259 is **OPEN** and was targeting the moving `master` branch directly (title: *feat(ses): permit TextEncoder and TextDecoder as universal intrinsics*).
- Base SHA obtained from **upstream `endojs/endo` master** = `46d4edf31714c1488ec1d95492cc1ae9643c1f9f` (sha7 `46d4edf`) — **not** the fork's own `master`, whose tip (`fcbb540`) is a divergent re-mirrored lineage.

**What I did:**
1. Found the fork reflection `master-46d4edf` already exists on endo-but-for-bots and points exactly at the upstream `46d4edf` — reused it (no push needed).
2. The 3 PR commits sat on the old reflection `master-3f601bc`. Rebased just those three onto `46d4edf` with `git rebase --onto 46d4edf 3f601bc`, dropping all intervening mirror commits. **Clean, no conflicts.**
3. Verified with `git range-diff`: all three commits are byte-identical (`=`) — net diff preserved, no content change.
4. Pushed the head with `--force-with-lease` (lease pinned to old tip `7de74b4cdc`): `7de74b4cdc → 0b7ab7590e`.
5. Moved the PR base: `gh pr edit 259 --base master-46d4edf`.

**Result:** PR #259 — state OPEN, base `master-46d4edf`, head `0b7ab7590e`, **MERGEABLE**. The moving `master` base is retired for this PR; it now reviews against a frozen reflection of true upstream endo/master.

**Notes / follow-ups:**
- The fork's own `master` (`fcbb540`) is confirmed to be a **divergent re-mirror** of upstream endo/master (they share ancestry only back at `a7ff191`); this weave correctly avoided anchoring on it, per the directive. Other PRs still targeting the fork `master` would want the same sweep.
- No garden-library change; nothing to push to `main2`. All work is on the fork PR.
