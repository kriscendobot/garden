Fix round 4 for endojs/endo-but-for-bots#1428 is pushed, and CI is green on the new head `916613af35` after one rerun of an unrelated failing test.

**Panel must-fix items (review 5425119987):**
- **stylist:** In `scripts/git-clean-args.test.mjs`, renamed `i` → `negatedExcludeIndex`, `pkg` → `packageJson` and `arg` → `argument`. Commit `916613af35`.
- **archivist:** The step 1 note in `scripts/pack-all.mjs` no longer claims that `-e /dist` or `dist/` apply to step 1; only step 6 passes `-e /dist`. Commit `add3d88441`.
- **scribe:** The round-3 summary had left out integrator's three should-fix items. The new summary comment covers them (issuecomment-6011568678):
  - **Folding the `docs(scripts)` commits and dropping the empty `75c4c7de2e`:** deferred to merge time, by squash-merge or at un-draft. Rewriting history now would change the commit SHAs the panels reviewed, and the push helper only moves the head forward.
  - **The macOS check:** the description now says no change here targets it, it passes on this branch, and we treat the upstream failure as a flake.
  - **The commit list in the description:** replaced with a description of the two changes, which also mentions the new test.

The modified test file passes locally (3/3), and `prettier` and `eslint` are clean on both touched files. Both commits went up with `safe-push-pr-head.sh`, moving the head forward from `400657abe4`.

**CI:** The first wait ended red (rc 3) on one job, `test (24.x, ubuntu-latest)`. The failing test was `@endo/patterns` `copySet › setIsSuperset`, a fast-check property test that uses a random seed (506278991). This PR doesn't touch that package. I reran only the failed job, and the second `ci-wait-merge` returned rc 0: 14 of 14 checks green.

**Follow-ups:**
- When this lands, squash-merge or fold the commits.
- That fast-check property test may be a real flake in `@endo/patterns` worth a separate look.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1428-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (1641684 cached reads)
- Output: 8618 tokens
- Cost: $1.0721608
- Wall-clock: 921s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
