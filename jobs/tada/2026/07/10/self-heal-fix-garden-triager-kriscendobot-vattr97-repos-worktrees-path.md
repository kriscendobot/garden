All three watcher defaults now point at `worktrees/` on `origin/main2`, no stale `repos/` default remains, and my inbox is clear.

---

**Completion report**

**Root cause:** The per-repo watchers FATALed `no bare clone at .../repos/<slug>.git` on every leader tick because `GARDEN_REPOS` defaulted to `$GARDEN_ROOT/repos` (a directory that never exists) instead of the canonical bare-clone shelf `$GARDEN_ROOT/worktrees` (where `clone-keeper.sh` / `ensure-project-worktree.sh` keep `worktrees/<owner>-<repo>.git`).

**What I changed:**
- Fixed the `GARDEN_REPOS` default in `scripts/jobs/triager.sh`, `scripts/jobs/comment-watcher.sh`, and — critically — `scripts/jobs/fork-watch-provisioner.sh` (`$GARDEN_ROOT/repos` → `$GARDEN_ROOT/worktrees`), plus the provisioner's header-comment `default repos/` → `worktrees/`.
- Checked `ci-watcher.sh`: it resolves state via `gh api`, not a bare clone, so it needed no change. No other `$GARDEN_ROOT/repos` defaults exist.

**Rebase interaction:** A sibling self-heal had already landed the triager + comment-watcher fixes on `main2` while I worked. The rebase collapsed my identical triager/comment-watcher edits into theirs (I took their more-detailed header comment on conflict), leaving **`fork-watch-provisioner.sh` as the net new contribution** — the exact piece the sibling missed. This matters because the provisioner *writes* the triager clone the other two *read*, so they must agree on the path; without it the provisioner would materialize clones into a dead `repos/` shelf. Pushed as commit `9ad9c72931` to `origin/main2`.

**Verification:** All three watcher defaults on `origin/main2` now read `$GARDEN_ROOT/worktrees`; `git grep` confirms zero remaining `repos` defaults. Ran the affected suites clean: triager-test 37/0, comment-watcher-test 213/0, fork-watch-provisioner-test 16/0.

**Sibling dedup:** The three still-live sibling gardeners (agoric-3-proposals, cosgov, ocapn) were messaged on the bus explaining the root cause is fully resolved in `main2` and to wrap up as no-ops — one change covers all watched repos. (The agoric-sdk, endo, finbot, and minion.town siblings were already in `tada/`, done.)

**Follow-ups:** None. The fix is deployed to `main2` and will reach running instances via the normal deliberate-deploy path.
