The rebase was clean and the base is retargeted. PR #533 is now MERGEABLE. No garden-library (main2) changes were needed.

**Completion report — `ebfb-retire-master-pr-533`** (weaver)

**Outcome: DONE.** The `master` base is retired for endojs/endo-but-for-bots#533; it now targets the upstream-endo reflection.

**Preconditions confirmed**
- PR #533 ("fix(compartment-mapper): re-export from exit module via modules map") was **OPEN**, draft, targeting the live moving **`master`** (base OID `7c259920`). Both head and base live on `endojs/endo-but-for-bots` (internal PR, not a fork PR). Head branch `fix/cm-archive-exit-reexport`, 2 commits.
- Base SHA sourced from **upstream `endojs/endo` master** per directive: `46d4edf31714c1488ec1d95492cc1ae9643c1f9f` (sha7 `46d4edf`) — not the repo's own `master`.

**Work done** (isolated project worktree keyed to this job base)
1. **Reused** the existing reflection branch **`master-46d4edf`** on `endojs/endo-but-for-bots` — verified it points exactly at upstream endo master `46d4edf3…` (same reflection the sibling #586/#629 sweeps used; no new branch needed).
2. Rebased the 2 head commits `--onto 46d4edf 7c259920`. **Clean, no conflicts.**
3. Verified the post-rebase net diff is **byte-identical** to pre-rebase (101 lines; the PR still introduces only the changeset + `import-hook.js` / `exit.test.js` / `fixtures-exit/reexport.js` edits). No trunk churn leaked in.
4. Pushed the rebased head (`8f0550148` → `912f3bfb4`) with `--force-with-lease` (leased on the prior head OID).
5. Retargeted the PR base to **`master-46d4edf`** via `gh pr edit`.

**Final state:** PR #533 OPEN (still draft), base `master-46d4edf` (`46d4edf31`), head `fix/cm-archive-exit-reexport` (`912f3bfb4`), **mergeable=MERGEABLE**. Its landing path is now the boatman's ferry upstream, not a fork-master merge.

**Follow-ups:** None. Not a stale/idle mirror — a real 2-commit change that rebased cleanly. No repo `master` was touched. No garden-library (main2) commit was part of this weave.
