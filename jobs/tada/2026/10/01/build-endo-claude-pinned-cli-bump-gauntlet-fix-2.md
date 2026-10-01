I applied all three round-2 must-fix items on PR #1406 (endojs/endo-but-for-bots), pushed them, and CI is green: `ci-wait-merge.sh --no-merge` returned rc=0, with 31 of 31 checks passing at head `22c23fb0ad`.

**Must-fix items:**
1. **`--settings` is now a required flag** (`daca8cbac2`). I added `--settings` to `REQUIRED_FLAGS` in `packages/claude/src/argv.js`, so there are six presence flags instead of five, and updated the comments and README wording to match. A new test, `an argv without --settings is refused`, covers its absence, and the property test now uses `REQUIRED_FLAGS.length - 1`. The full `@endo/claude` suite passed locally (82 tests).
2. **Completion-summary comment** (https://github.com/endojs/endo-but-for-bots/pull/1406#issuecomment-5935811104). It maps each round-1 must-fix item to the commit that addressed it (`bbc0c7fe2d`, `70abbde69f`, `015996835f`, `68fb89bf1a`) and lists the round-2 fixes. It also records the two declined breaker should-fix items as follow-ups: re-checking `settings.json` at spawn time, and the combined `--flag=value` form getting past the pinned-value check.
3. **Ellipsis change kept in its own commit.** `015996835f` already holds only the `…` → `...` rewrites, with a message explaining why, and no later commit touches `…`. The summary comment records this; no code change was needed.

**CI fix along the way:** the first push failed lint on Prettier formatting in `argv.test.js`. I fixed it in a separate commit, `22c23fb0ad` ("style(claude): prettier-format the argv property test"). I couldn't run the repo-root `tsc` locally, but CI's lint job includes it and passed.

The session was cut off once mid-run and resumed. The formatting commit was still unpushed at that point; it is now pushed.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-claude-pinned-cli-bump-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 12 tokens (502309 cached reads)
- Output: 1963 tokens
- Cost: $1.2332648000000002 (1 engagement(s) unpriced)
- Wall-clock: 3178s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
