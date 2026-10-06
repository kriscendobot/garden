Fix round 3 for endojs/endo-but-for-bots PR #1428 is pushed and CI is green: 14 of 14 checks passed.

**What the panel asked for:** round 3 (review 5424487523, on head `042ec99966`) had one must-fix item, from the prover seat. The `git clean` exclude that keeps `.yarn/install-state.gz` had no regression test. The prover's comment-only note — that the "freshness" prose in `pack-all.mjs` had no test behind it — is covered by the same test.

**What I changed:** commit `400657abe4`, pushed to `fix-upstream-master-ci` with `safe-push-pr-head.sh`. The head moved forward from `042ec99966`; nothing was force-pushed.
- **New `scripts/git-clean-args.mjs`:** holds the shared `git clean` arguments in one frozen list.
- **`scripts/pack-all.mjs`:** both clean steps now use that list, and the second one still adds `-e /dist`. The header comment points to the test.
- **New `scripts/git-clean-args.test.mjs`:** an ava test modeled on `scripts/generate-composite-tsconfigs.test.mjs`. It builds a scratch git repo using the real `.gitignore`, with a tracked file under `.yarn/patches/`. Its three tests check that:
  1. The shared arguments keep `install-state.gz`, `node_modules/` and the tracked patch, and remove stray ignored files.
  2. Dropping the negated exclude deletes `install-state.gz`.
  3. The root `clean` script in `package.json` matches the shared arguments exactly.

**Checks:** the new tests pass locally (`yarn exec ava scripts/git-clean-args.test.mjs`), Prettier is clean, and ESLint reports nothing on the three files. I also ran `tsc -p scripts/tsconfig.json` and saw no errors mentioning the new files. I posted a summary comment on the PR (issuecomment-6010697639). `ci-wait-merge.sh --no-merge` returned 0.

**Follow-up:** CI doesn't run this test, just as it doesn't run the existing `scripts/*.test.mjs` file; it only runs by hand. Wiring scripts tests into CI would be a separate change. The driver will post panel-4.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1428-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (887191 cached reads)
- Output: 7826 tokens
- Cost: $0.7721502
- Wall-clock: 607s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
