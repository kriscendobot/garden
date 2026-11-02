---
orchestration-failed: true
---
orchestration-failed: true

## Gauntlet fix round 5: PR #1586

**Outcome:** I applied the panel's items and pushed them, but CI ended RED (`ci-wait-merge` rc 3), so there is no `fix=done`. The one failure looks unrelated to this diff.

**Failing check:** `cover (22.x, ubuntu-latest)`, in `@endo/sandbox#test:c8`, test "bwrap timeout and repeated cancellation reap process groups" ([run 41391865236](https://github.com/endojs/endo-but-for-bots/actions/runs/41391865236/job/125104905353)).
- **Why it looks unrelated:** this PR doesn't change `packages/sandbox`. The same test is a known failure across PRs on the base, and its fix, #1591, is still open.
- **Other checks:** the other 35 passed, including `cover (24.x)` and all four `test` jobs.
- **Not rerun:** this host's token can't rerun Actions jobs, so the failure hasn't been retried. I made no further pushes for it.

**Pushed:** head moved from `4c8515576` to `7f897e6fa` on `build/fs-interface-reconciliation`, using `safe-push-pr-head.sh`.

| Commit | Change | Panel seat |
|---|---|---|
| `239c7549f` | The viewer section now treats a reader that closes immediately as point-in-time, matching D6. | archivist must-fix |
| `7f897e6fa` | Dropped the stale `@endo/exo-git` major and its sentence from the changeset. | changeset-auditor must-fix, archivist |
| `f708d1454` | Replaced the new inline `import()` types with top-level imports and added a `makeFile` note. | typist |
| `f708d1454` | Moved the closed-reader contract into the `SnapshotTree` JSDoc and removed comments that restated the code. | archivist, pruner |
| `239c7549f` | `subView` withholding and `streamRead` supersession are each stated once, and the performance disclaimer is one sentence. | pruner |

**Decisions the next panel may want to check:**
- **`@endo/exo-git`:** its `Directory` alias still reaches `SnapshotTree` through `Directory.snapshot()`. I still dropped the major because the reason for it (`Directory` requiring `subView` and `makeFile`) is gone, and the `@endo/platform` note covers the requirement.
- **`@endo/platform: major`:** kept. npm returns a 404 for the package, so the first release is `1.0.0` under the changeset rule, and another changeset already declares `major`. I didn't add an "unreleased" sentence to the changeset.
- **Pruner item declined in part:** design decision 6 keeps a short pointer to the `streamRead` catalog row, because without it the decision reads as live.
- **Left unchanged:** the two comment-only items, the `ReaderRef` / `PassableReader` naming and the changeset bundling.

**Local checks:**
- **`@endo/platform`:** `tsc`, `test:types` and all 380 tests pass.
- **`@endo/daemon`:** `test:types` and `mount.test.js` (87 tests) pass. I didn't run the full daemon suite locally; its only source changes are comments and types, and the CI `test` jobs passed.
- **Formatting and lint:** Prettier passes on all changed files. ESLint on three of the changed source files shows only warnings (0 errors).

**PR body and round-5 comment:** this host gets a 403 on PR writes, so I posted relay job `endojs-endo-but-for-bots-pr1586-gauntlet-fix-5-pr-body`, pinned to `endolin-garden-ece02cb4`. Its last check shows the trimmed PR body and one round-5 comment are now live on the PR.

**Follow-ups:**
- The driver needs to rerun the failed job from a host that can, or wait for #1591 to land.
- The `cover` failure is now recorded in the `ebfb-ci-ubuntu-2604-sandbox-ulimit` memory.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1586-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (2564094 cached reads)
- Output: 26740 tokens
- Cost: $2.0037068
- Wall-clock: 3978s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
