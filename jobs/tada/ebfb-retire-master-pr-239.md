Done. The base is retired for PR #239.

**Job: retire the master base for endojs/endo-but-for-bots#239**

What I did:
- Confirmed PR #239 (`mirror: endojs/endo#1967`, head `mirror/endo-1967`, author kriscendobot) is **OPEN**, draft, and was targeting the moving `master`.
- Obtained the base SHA from **upstream endojs/endo master** (`46d4edf31714…`, short7 `46d4edf`) — not from the fork master, per the directive.
- **Reused** the existing fork reflection `master-46d4edf` on endo-but-for-bots and verified its tip is exactly `46d4edf3171…`, an identical mirror of the upstream commit (no new reflection needed; this SHA is already the sweep's current tip, shared by #779/#771).
- Rebased the single mirror commit onto `46d4edf` in an isolated per-job project worktree. **Clean rebase, no conflicts** (head was 1 ahead / 200 behind). The rebased head (`f3f20c5872`) carries the identical 8-file / +83 −5 diffstat as before, and the reflection is now an ancestor of the head.
- Pushed the head with `--force-with-lease` (leased on the prior sha `16d6ce92c4`).
- Set the PR base to `master-46d4edf` via `gh pr edit`.

Final state: PR #239 OPEN, draft, base `master-46d4edf`, head `mirror/endo-1967` @ `f3f20c5872`, **MERGEABLE** (mergeState UNSTABLE = CI running, not a conflict).

Notes / follow-ups:
- The change is test-fixture-only (compartment-mapper policy test for a bundled dependency name collision, mirrored from endo#1967). The rebase applied cleanly against the 200-commit-newer base, so I did not run the full compartment-mapper suite (it requires a heavy monorepo `yarn install`); this was a mechanical base-retirement, not a content change. CI on the PR will exercise it.
- Not stale/wedged — the PR was last updated 2026-07-02 and rebased without conflict, so no maintainer-follow-up condition to record.
- The fork master was never touched.
