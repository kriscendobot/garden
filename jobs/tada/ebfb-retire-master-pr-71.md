Retired the moving `master` base for endojs/endo-but-for-bots PR #71.

**Preconditions confirmed**
- PR #71 is OPEN and was targeting `master` (title: *test(env-options,marshal): per-compartment options are scoped (#2879)*).
- Base SHA taken from **upstream `endojs/endo` master** = `46d4edf31714c1488ec1d95492cc1ae9643c1f9f` (sha7 `46d4edf`), **not** from the drifted endo-but-for-bots master (`fcbb540…`).

**Work performed**
- Reflection branch `master-46d4edf` already existed on `endojs/endo-but-for-bots` pointing at the correct upstream commit — reused it (push was a no-op "Everything up-to-date"). No new base branch created.
- The 3 head commits (`test(...) #2879`, `fix(marshal) #2879`, `chore: Update yarn.lock`) branched from merge-base `401fd20`, an ancestor of both masters. Rebased them onto `46d4edf` — **clean, no conflicts** (3/3). Focused, test-only diff (marshal env-options-in-compartment fixtures/tests + one yarn.lock line, 187 insertions).
- Force-with-lease pushed the rebased head (`8cf0cb6321…` → `58240c0ffa…`), lease honored.
- Set PR base to `master-46d4edf` via `gh pr edit`.

**Final state**
- PR #71 OPEN, base `master-46d4edf`, head `58240c0ffaafa4e9bcad671020287535ba02c971`, mergeable = **MERGEABLE**.

**Note for maintainer follow-up**
- The PR was somewhat idle (last updated 2026-06-07, ~5.5 weeks before this sweep), but it is **not** a wedged/stale mirror: the rebase applied cleanly and the result is mergeable, so the sweep proceeded normally. No fork `master` branch was touched. No conflict requiring a broader weave.
