## Gauntlet fix round 3: endojs/endo-but-for-bots#1391

I applied the must-fix and most of the should-fix items from panel round 3 (review 5415514794), pushed them, and CI is green on head `d0057d62b4`.

The first CI run went red on one leg, `test (22.x, macos-15)`. The failing test was `@endo/daemon` › `daemon-teardown` › "an orphaned daemon shuts itself down…". This PR's net diff does not touch `packages/daemon`. I reran only the failed job once and it passed. `ci-wait-merge.sh --no-merge` then returned rc 0 with 33 checks and 0 failed.

**Commits pushed** (with `safe-push-pr-head.sh`, a fast-forward from `740f94e9b2`):
- **`12f2ae1d46` (must-fix, from packager and integrator):** the `ses` changeset now says the `SturdyRef` `prototype` must be non-writable and non-configurable, and that a plain `function` with a writable `prototype` makes `lockdown` throw.
- **`2383625579` (purist should-fix 1):** the `@endo/sturdyref` shim now captures `Promise`, `TypeError` and `WeakMap` when its module loads. Before this, the shared constructor picked them up later from the start compartment's globals, which stay writable after `lockdown`.
  - A new test in `sturdyref-prelockdown.test.js` replaces the start compartment's `Promise` and checks that a child compartment's `enliven` still works. It fails without the fix and passes with it.
  - There is a new patch changeset for `@endo/sturdyref`.
  - The package's tests, `lint:types` and eslint pass locally.
- **`d0057d62b4` (purist should-fix 2 and 3):** comment-only changes.
  - The permit comment now explains why `SturdyRef` is treated differently from `HandledPromise`: the `HandledPromise` shim sets a plain configurable global, while this shim locks its global so that duplicate copies of the library end up sharing one constructor. It also notes that `SturdyRef` instances are not passable.
  - The `firstWinsPropertyNames` comment says each entry needs its own shape check next to it.

**PR body (pruner):** I deleted the empty Scaling and Documentation sections. I cut the #695 open-threads section down to one sentence rather than deleting it, because the integrator seat counted it as the PR's reconciliation with that design.

**Summary comment (scribe):** I posted https://github.com/endojs/endo-but-for-bots/pull/1391#issuecomment-5995928227. It covers this round and the earlier push `740f94e9b2`, which never got a summary.

**Not done:**
- **Integrator should-fix 1:** dropping the four daemon commits that cancel each other out (`e703fad05d`, `d6d07ab446`, `14381fc8f5`, and the revert `0ebeab85eb`) and folding in the fix-up commits would mean rewriting the branch's history. A fix round only adds follow-up commits, so this should be a retcon before merge.
- **Benchmarker follow-up:** the PR comment records that no benchmark is planned for the descriptor-read gating in `74d5f83c2a`.

**Follow-up:** the macOS `daemon-teardown` orphan test fails intermittently. It is the same test that the reverted daemon commits in this PR tried to fix.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1391-gauntlet-20261005-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 72 tokens (2777034 cached reads)
- Output: 13036 tokens
- Cost: $1.5037588000000002
- Wall-clock: 4603s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
