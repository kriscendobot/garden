## Job ebfb-pr1343-endowments-fix: completion report

**Outcome:** I resolved all four asks from kriskowal's CHANGES_REQUESTED review on endojs/endo-but-for-bots#1343. The fix is pushed and all 26 CI checks pass. The PR is still a draft.

**Commit:** `eaa3fd3534`, pushed to `kriscendobot:issue982-build-special-names` (the old head was `6c49234d80`, so this was a fast-forward). The commit message is `refactor(daemon)!: one @-partitioned endowments option with pet-name-path values`.

### Resolution of each ask
1. **Endowment values are pet name paths (review body):** each value in `endowments` must now be an array of path components, such as `['calendar']` or `['services', 'calendar']`. The daemon rejects bare strings and never takes formula ids. The provisioner resolves a path with `identify(...path)`.
2. **Remove `introducedNames` for guests (shapes.js:71):** it was obviated, so I removed it from `MakeGuestOptionsShape` and the `MakeGuestOptions` type. `endowments` now works for every guest, retained or not. For a guest that already exists, ordinary endowments are written into the agent behind its handle. Special (`@`) endowments are accepted only when the guest is created. `provideHost` still accepts `introducedNames`.
3. **Pet name path on the value side (shapes.js:72):** yes, per item 1.
4. **One `endowments` option split on `@` (host.js:1918):** the internal `makeGuest` now takes a single `endowments` map of names to already-resolved ids. It replaces the separate `introducedNames` and `specialNames` options and splits the map on the `@` prefix. The checks for reserved names and collisions moved into shared helpers (`assertEndowments`, `resolveEndowments`).

### Other changes
- **Callers migrated:**
  - `endo mkguest --introduce host:guest` keeps its flag and now translates to `endowments`.
  - agentry translates its own spec's `introducedNames` into `endowments` when it calls `provideGuest`. This also fixes a break the PR had introduced on its path that passes authority.
  - fae, jaine, lal and claude-sandbox are updated.
- **Docs updated:** the daemon's README, `help.md` (help-text-data regenerated) and AGENTS.md, plus the fae and lal docs.
- **Changeset:** `@endo/daemon` is now a major bump and `@endo/cli` a patch.
- **PR body:** rewritten to describe the new design.

### Verification
- **Passing:**
  - daemon `provision-lifecycle` suite: 5/5, including a new test for endowing a guest without retained authority and checks that reject bare strings and `introducedNames`.
  - agentry provision and pi-extension suites: 61/61.
  - daemon `lint:types` and `test:types`, repo-root `tsc -p tsconfig.json`, and eslint (no errors).
  - all 26 CI checks.
- **Local failures:** 23 tests in the full local daemon run (channel, channel-relay, content-store-gc, content-store-gc-invariants, error-trace, gateway) fail with `endo.sock` ENOENT. That is the known long-socket-path limit for deep worktree paths, not this change; the same suites passed in CI.
- **Local env fix:** I rebuilt the better-sqlite3 native module in the job's own `node_modules` store after breaking its hardlinks first. Nothing tracked changed.

### GitHub replies
- Inline replies with the resolving commit: r4141182970, r4141183135, r4141183267.
- A summary PR comment (issuecomment-5904919462) points to the follow-up job `ebfb-petname-path-only`. That job was already on the board, so I didn't post it again.

### Follow-ups
- agentry's own spec field is still called `introducedNames`, mapping host names to guest names. It is only translated at the daemon call; renaming it is optional.
- The PR is ready for re-review.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-pr1343-endowments-fix.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 172 tokens (9620132 cached reads)
- Output: 43313 tokens
- Cost: $3.9246144000000007
- Wall-clock: 4868s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
