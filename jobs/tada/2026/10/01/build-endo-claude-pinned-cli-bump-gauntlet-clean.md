The clean stage for endojs/endo-but-for-bots#1406 needed no changes. CI was already green at the current head and the coverage review found nothing to add, so nothing was pushed.

- **PR state:** it's still an open draft. Head is `bot/build/claude-pinned-cli-bump` at `4a6d91527e`, on the pinned base `llm-d4124e6`.
- **Coverage pass:** I checked the code under `packages/claude/src` that this PR adds or changes against the tests in the PR. I read the diff against the tests; I did not run a coverage tool, and CI's `cover` job was skipped.
  - `assertPinnedValueFlags` has a test for each failure case (flag missing, value changed, flag repeated), run for both `--permission-mode` and `--permission-prompts`.
  - A test checks that `buildArgv` puts `dontAsk` / `none` in the argument list.
  - The version-pin tests cover 2.1.281, 2.1.279 and the old pin 2.1.232.
  - The spawn-files tests check that the plugin-disabling setting appears for both an API key and a subscription OAuth token.
- **Dead code:** the change leaves nothing unused. `renderApiKeyHelperSettings` is still called by `harness.js` and `spawn-files.js` and exported from `index.js`. The only remaining mentions of 2.1.232 are on purpose: a history note in a comment, the old-pin rejection test, and the README's "designed against" note.
- **CI:** `ci-wait-merge.sh endojs/endo-but-for-bots 1406 --no-merge` returned rc 0: 31 checks finished, none failed, CI GREEN.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-claude-pinned-cli-bump-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (290311 cached reads)
- Output: 1726 tokens
- Cost: $0.4940702
- Wall-clock: 32s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
