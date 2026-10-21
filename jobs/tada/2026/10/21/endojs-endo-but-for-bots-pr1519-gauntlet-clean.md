Clean stage for endojs/endo-but-for-bots PR #1519 is done: the coverage pass found nothing to add, and CI is green on the current head. I pushed nothing.

- **Where things stood:** the PR is an open draft at head `261b077c3`, branch `endojs:bun-ses-permits`, based on the frozen base `master-ebc7904`. When I started, 4 of 15 checks were still pending.
- **Coverage pass:** I read the source changes, not the whole diff, and ran no tests locally.
  - `pass-style/src/error.js`: the new `sourceURL`, `line`, `column`, `originalLine` and `originalColumn` cases are covered. `errors.test.js` tests both the passing case and the wrong-type rejections.
  - `ses/src/permits.js`: the new `URLSearchParams` `length` and `toJSON` permits are covered by a new test in `url.test.js`.
  - `module-source` and `parser-pipeline`: the only branch without a test is the `babelTraverse.default || babelTraverse` fallback. Only Bun takes it, so the Node test lanes can't reach it.
  - `scripts/test-bun.mjs` and `scripts/ava-bun-preload.mjs` are Bun test tooling, not package code.
- **Dead code:** none. In `transform-analyze.js`, `Hub` and `NodePath` moved to named imports and are still used.
- **CI:** `ci-wait-merge.sh --no-merge` returned 0: all 15 checks finished with 0 failures, about 3 minutes into the wait.

Follow-ups: none.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1519-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (320318 cached reads)
- Output: 2423 tokens
- Cost: $0.4751076
- Wall-clock: 408s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
