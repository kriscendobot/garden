**Botanist report: endojs/endo-but-for-bots #1654** (Dependabot `all-minor-patch` group, 15 updates, base `llm`)

**Verdict: HELD, not MERGE-NOW.** CI is red because of this PR, so I escalated to a fixer. Everything else about the upgrade looks fine and the maturity window has passed. Once CI is green the expected verdict is MERGE-NOW.

**Checks**
- **Diff shape:** only manifests and `yarn.lock` change.
- **Superseded?** No. None of the other open Dependabot PRs (#1655–1658, #1633, #1629) touch these packages. Base `llm` @ `48d6f3e08` is still on every old version, and the head is 1 ahead and 0 behind.
- **Version set:** I compared the base and head lockfiles. Two packages are new: `@types/estree@1.0.10` and `@rollup/rollup-android-x64@4.67.4`.
- **Maturity:** the newest moved version is `globals@17.14.0`, published 2026-11-01T11:01:01Z. The 7-day window ended 2026-11-08T11:01Z.
- **Provenance:** no package changed publisher, and attestations are present on both sides wherever the old version had them. No new install scripts, no license changes.
- **Advisories:** OSV is clean on both sides for every moved version.
- **Source read:** I diffed the tarballs for ws, marked, amaro, openai, ava, globals and type-coverage-core. There is no new network, child-process or eval surface.

**Not done**
- **Scripts-disabled install:** skipped. `ensure-project-worktree.sh` failed on the known read-only bare-repo problem in the monk sandbox (it could not write `FETCH_HEAD`). I did the review from registry tarballs and the GitHub API instead.
- **Jev pre-classification:** I read no upstream prose, because the review relied on lockfiles, registry metadata and source diffs. So none was needed.

**Blocker**
ava 8.3.0 now fails any test that runs past its `t.timeout(ms)` deadline, even if the timeout timer never fired. 8.4.0 behaves the same way. Under 8.1.2 those tests passed. These tests are new reds on this PR and pass on base `llm`:
- `cover` 22.x and 24.x: three `@endo/sandbox` spawner tests, plus one bwrap test on 22.x.
- `test (22.x, macos-15)`: the `@endo/platform` node-fs watch test.

The `test-xs` red (benchmark threshold and the hardened262 ThrowTypeError baseline) fails the same way on base, so it predates this PR.

I didn't push a fix myself. It means re-judging timeout budgets in test code across several packages, which is a call about each test's hang-guard purpose rather than a fix that follows mechanically from the upgrade.

**Actions taken**
- Posted fixer job `endojs-endo-but-for-bots-pr1654-ava-timeout-fix` with the full diagnosis. It will push to the PR head branch.
- Posted the verdict comment: https://github.com/endojs/endo-but-for-bots/pull/1654#issuecomment-6726767202
- Wrote the ledger row: `journal/entries/2026/11/08/203412Z-message-botanist-c57a23.md`. It stays open until a final verdict.
- The daily `dependabotany-recheck-endo-but-for-bots` recheck already exists. It will give the final verdict after the fix lands (MERGE-NOW via `ci-wait-merge.sh --dependabot-auto-merge`).

**Follow-ups**
- Separate from this PR, `test-xs` is red on base `llm` itself.
- ava 8.4.0 is already published with the same timeout behaviour, so the fixer's change should hold for the next ava bump too.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1654-dependabot.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 64 tokens (3334713 cached reads)
- Output: 19170 tokens
- Cost: $2.0286626
- Wall-clock: 1595s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
