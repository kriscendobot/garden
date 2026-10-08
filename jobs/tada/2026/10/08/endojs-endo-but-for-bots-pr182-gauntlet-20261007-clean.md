The clean stage for endojs/endo-but-for-bots PR #182 is done. I made no changes and pushed nothing, and CI is green.

- **PR state:** open and not a draft. The head is `endojs:test/947-isimmutabledataproperty-absent` at `b9f8ec1e86`, based on the frozen `master-46d4edf`.
- **Coverage pass:** nothing to do. The PR only adds one test (32 lines) to `packages/ses/test/scope-constants.test.js`. It is a regression test for #947: it fakes a global object that lists a property name but returns no descriptor for it, and checks that `getScopeConstants` skips that name instead of crashing. Since no source code changed, there is no new code to cover and no dead code left behind. I ran the test file in an isolated checkout (`npx ava test/scope-constants.test.js`) and all 4 tests passed.
- **CI:** `ci-wait-merge.sh --no-merge` returned rc=0, GREEN. Only 2 checks ran on this head (`.github/dependabot.yml` and `copilot-setup-steps`), both passed. The full test suite did not run, probably because the workflows don't trigger on PRs against a frozen `master-<sha>` base. So green here means "no failures among the checks that ran", which doesn't cover the full suite.
- **GitHub rate limit:** some `gh` REST calls (`pr diff`, `check-runs`) failed with a rate-limit error even though `rate_limit` reported quota left. I fetched the diff with git instead. The GraphQL queries and the CI wait worked.

Follow-up: none for this stage. The next gauntlet stage (panel review) can go ahead.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr182-gauntlet-20261007-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 18 tokens (429314 cached reads)
- Output: 2409 tokens
- Cost: $0.4755388
- Wall-clock: 48s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
