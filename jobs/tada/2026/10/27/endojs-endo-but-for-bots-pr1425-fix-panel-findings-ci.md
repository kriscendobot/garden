PR #1425 is green except for `build`, which fails on the CI runner rather than on anything this PR changed. I made no code changes, did not rerun anything, and left the PR untouched (no rebase, retarget, body edit or push).

**Status at head `c72a8f3564`:** 14 of 15 checks pass, including lint, zizmor, test-xs, test-hermes, test262 (22.x and 24.x), cover, viable-release, check-action-pins, test-ocapn-python and all four `test` legs. The two macOS `test` legs that were pending finished green while I watched.

**The `build` red** (workflow "Test project mutual dependency versions", run 40552546791):
- It fails at the `Check for cycles` step with `scripts/graph.sh: line 32: tred: command not found`, exit code 127.
- `tred` comes from graphviz, which the GitHub-hosted `ubuntu-latest` runner image no longer has. It's the "tred CI reds are pre-existing" pattern from the exo-dynamodb memory.
- Other PRs fail the same way today: `codex/floot-effort-delegation-recovery` and `feature/api-key-provider-adapters` (three runs). The only change PR #1425 makes is in `ses`, nowhere near the dependency graph script.
- A rerun won't help, because the tool is missing every time and this isn't a flake.
- The fix is in open PR https://github.com/endojs/endo-but-for-bots/pull/1566, "fix(ci): install graphviz-tools and make bwrap tests runner-portable", which passed this same check. Once #1566 is in this PR's base ancestry, `build` should pass with no change to #1425. Rebasing onto it was out of scope for this job.

**Follow-up:** land #1566, then rerun `build` on #1425. Whoever un-drafts #1425 should treat this red as the known runner problem fixed by #1566.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1425-fix-panel-findings-ci.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (289828 cached reads)
- Output: 2138 tokens
- Cost: $0.4638056
- Wall-clock: 44s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
