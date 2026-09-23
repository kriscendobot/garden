The PR is now green: `mergeStateStatus: CLEAN`, `mergeable: MERGEABLE`, zero FAILURE checks. The job is complete.

## Completion report

**Job:** Shepherd `endojs/endo-but-for-bots` PR #654 (`test/mount-glob-rust-parity-runner`, the #127 Rust-side mount-glob parity runner) to green — 4 failing CI checks.

**Diagnosis.** All 4 failing checks were the `test` matrix jobs (22.x/24.x × ubuntu/macos), and across two runs they failed on the daemon test `mount-revocation › revocation: an open followNameChanges stream fails after revoke` ("Promise returned by test never resolved") plus a flaky chat test. PR #654 is a **Rust-only diff** (`Cargo.*`, `rust/mount_parity/*`) — it touches zero JavaScript, so it could not itself break a daemon test. The real cause: #654's **frozen base branch `feat/mount-glob-e2abb76` was stale**. The live `feat/mount-glob` (green on #653) had been rebased to include `39f06ba6 fix(daemon): wake open followNameChanges streams on mount revoke` — the exact fix for the hanging test — while the pinned snapshot predated it. #654 was riding a base missing that fix.

**Action (frozen-base-branch rebase, "move both base and head").**
- Pushed a fresh frozen base `feat/mount-glob-6680a60` snapshotting the live, fixed `feat/mount-glob` tip.
- Rebased #654's two own commits (Rust runner + `chore: Update Cargo.lock`) onto it — clean, no conflicts; the PR diff remains exactly the 7 Rust files.
- Force-pushed the head (`259fa0530e`) and moved the PR's `--base` to `feat/mount-glob-6680a60`.

**Result.** Fresh CI ran green. The 4 formerly-failing `test` matrix jobs all pass; the full rollup has **0 FAILURE / 0 PENDING** checks. PR #654 is `MERGEABLE`, `mergeStateStatus: CLEAN`. (It remains a draft, as expected — shepherding drives CI to green; un-drafting/merge is a separate step.)

**Changes:** project repo only (new `feat/mount-glob-6680a60` branch on the fork, rebased #654 head, PR base moved). No garden `main2` changes were needed.

**Follow-ups:** The old `feat/mount-glob-e2abb76` snapshot is left in place per the frozen-base convention (swept on PR close). When #653/#654 next rebase or approach merge, the base should continue to track the live `feat/mount-glob`.
