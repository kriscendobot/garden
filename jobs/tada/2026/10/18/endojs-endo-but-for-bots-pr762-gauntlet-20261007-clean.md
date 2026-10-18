Clean stage for endojs/endo-but-for-bots PR #762: no changes were needed, so nothing was pushed. CI is green at the current head.

- **PR state:** open, not a draft. Head is `endojs:reconstruct/kebab-case-lint-wildcard-exemptions` at `f129f92247a0`.
- **CI:** all 14 checks completed with SUCCESS at that head. That includes lint, cover, and every test, test262, hermes, xs, ocapn-python, viable-release and zizmor job.
- **Coverage:** the PR adds a shell linter, `scripts/lint-file-names.sh`, with its exemptions list. It ships with its own 163-line test script, `scripts/lint-file-names.test.sh`. That test runs in CI through a new step in `.github/workflows/ci.yml` that calls `yarn test:lint-file-names`, and the linter itself is now part of `yarn lint`. There are no JS packages to cover, and the change leaves no dead code behind.
- **Skipped steps:** because CI was already green at this head, I did not take a project checkout, push anything, or run `ci-wait-merge.sh`.

Follow-ups: none. The gauntlet can move on to the panel stage.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr762-gauntlet-20261007-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (155869 cached reads)
- Output: 1318 tokens
- Cost: $0.3563978
- Wall-clock: 23s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
