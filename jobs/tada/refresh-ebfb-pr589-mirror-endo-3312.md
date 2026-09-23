Completed the refresh of fork mirror #589 against canonical upstream #3312.

## What I did

**Reconciled with #3312 (step 1).** Fetched the current head of `endojs/endo#3312` (`chore/retire-function-keyword`, `81e62258`) and discovered that **#589's head tree was already byte-identical to #3312's head tree** (`9495bc82…`). Both PRs sat on the *same* endo base commit `0594e99` and carry the identical 19-commit transformation, so #3312 carried **no un-applied review changes** — content reconciliation was already complete. No cherry-pick of #474's old commits was needed or done.

**Refreshed onto a fresh frozen base (step 2).** Confirmed the ebfb fork's upstream is `endojs/endo` and that the old frozen base `master-0594e99` was literally endo master commit `0594e99` (2026-06-29). Snapshotted the **current** upstream endo master `2708caccafa7…` (2026-07-14) as frozen base **`master-2708cac`** (it already existed on the fork pointing at exactly that commit, so it was reused per frozen-base discipline — no mutable `master` recreated). Rebased #589's 19 commits `--onto` it: **clean, zero conflicts** (the 0594e99→2708cacc endo drift is only 9 files — CI workflows + a changeset — none touched by the transformation). Force-pushed the head with a lease (`a97452b…` → `4f14a7f6f`) and moved #589's base field `master-0594e99` → `master-2708cac`.

**Kept #589 intact + repointed to #3312 (step 3).** Title and draft state preserved. The body had **no #3318 reference** to repoint; I added a short "Upstream counterpart" note naming `endojs/endo#3312` as canonical and noting the closed #3318 is not tracked.

## Verification
- Pushed head `4f14a7f6f` vs canonical #3312 head `81e62258`: differs by **only the 9 trivial endo-drift files** — the retire-function-keyword transformation is byte-identical to the reviewed #3312.
- Net transformation preserved (55 files, 858+/526−); converted files carry no reintroduced `function` keywords beyond the documented exceptions #3312 already carries.
- Final PR state: base `master-2708cac`, head `chore/retire-function-keyword-v2`, **draft**, **open**, title unchanged.

## Links / follow-ups
- Fork PR: endojs/endo-but-for-bots#589 · Canonical upstream: endojs/endo#3312 · New frozen base: `master-2708cac` (= endo master `2708cacc`).
- No conflicts to report. No garden-library (main2) changes were required — this job mutated only the ebfb fork.
- Note: #589 is now on a *newer* endo base than #3312 (which still sits on `0594e99`); if #3312 later rebases forward, the two will re-converge. Optional future follow-up: refresh #3318's dangling frozen bases if any were left behind (not in scope here).
