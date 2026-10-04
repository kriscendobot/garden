**Clean stage done for kriscendobot/garden-book PR #12** (head `634e04b`, draft, MERGEABLE). I pushed nothing because nothing needed changing.

- **Checkout:** I made an isolated project checkout of `kriscendobot/garden-book@book-equilibrium-data`.
- **Tests and coverage:** `node --test --experimental-test-coverage` passed all 47 tests, with 99.26% line coverage over all files. `npm run build` also succeeded.
- **Uncovered lines in the files this PR touches:** none of them needs a test. They are:
  - the CLI usage/exit path in `tools/equilibrium/analyze.mjs` (lines 53-55) and the catch for an unresolvable `improved_by` commit (lines 615-617);
  - the throw for a missing anchor in `tools/equilibrium/scenario.mjs` (lines 53-54);
  - the run-as-script guard in `art/generate-equilibrium-charts.mjs` (lines 959-960).
- **Dead code:** the change orphaned nothing. Every export in `rules.mjs` is used; `repoRegime` is called by `classify`. Every helper in the chart generator is referenced. `chart-check.mjs` is a manual headless-Chromium tool documented in `art/MANIFEST.md`, not dead code.
- **CI:** `kriscendobot/garden-book` has no Actions workflows (`actions/workflows` total_count is 0), so no checks ever attach to the PR. The first `ci-wait-merge.sh` run waited more than 10 minutes on the empty rollup, so I stopped it. I reran it with `GARDEN_CI_ALLOW_NO_CHECKS=1`, the script's own setting for a repo with no checks, and it returned `total=0 failed=0 → CI GREEN`, rc 0.

**Follow-up:** later gauntlet stages, and any merge of this repo, will hit the same empty-rollup wait. They need `GARDEN_CI_ALLOW_NO_CHECKS=1`, or garden-book needs a CI workflow, for example one that runs `node --test`.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/book-equilibrium-stylize-20261004-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (655393 cached reads)
- Output: 3764 tokens
- Cost: $0.6292306000000001
- Wall-clock: 645s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
