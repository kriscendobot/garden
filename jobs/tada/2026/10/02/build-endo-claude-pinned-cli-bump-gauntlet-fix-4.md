Fix round 4 for endojs/endo-but-for-bots PR #1406 is done. I fixed both panel must-fix items and the recommended should-fix items, pushed three commits to the PR head (`ae036d0535` → `e2f5cecb61`), and CI came back green on all 31 checks (`ci-wait-merge` rc 0).

**Must-fix items**
1. **Extra values after a flag's value** (`b430e57b39`). `--tools` and `--mcp-config` accept more than one value, so a stray extra argument could slip in (`--tools "" Bash` re-enables Bash). `assertConfinedArgv` now rejects any extra argument after the value of `--tools`, `--setting-sources`, `--permission-mode`, `--permission-prompts`, `--settings` or `--mcp-config`, unless it is another `--` flag. New unit and property tests insert a stray argument after each of those six flags and check it is rejected.
2. **Banner comment** (`b8dd5589c5`). The decorated heading at `argv.test.js:145` is now a plain comment, in its own commit.

**Should-fix items**
- **`--mcp-config` is now required.** It is in `REQUIRED_FLAGS`, and a new test rejects an argv without it.
- **Flag count.** The code, tests and README now say seven required flags instead of six.
- **"Last flag wins."** The comments and README now say any repeated flag is rejected, so it doesn't matter which one the CLI would use.
- **Changeset and README** (`e2f5cecb61`). Both now cover the required `--mcp-config` and the new extra-value check.

Locally, the package's 87 tests, `tsc` and eslint all pass on the changed files. I didn't run Prettier over the README because the file was already unformatted before this change, so its diff contains only my content edit.

I posted a summary comment mapping each item to its commit: https://github.com/endojs/endo-but-for-bots/pull/1406#issuecomment-5956021597. It also says two minor notes were declined: the changeset stays `minor` (a `major` bump is already pending, so the result is the same), and the pinned-value test was left as a table of cases.

No follow-ups from this stage; the driver posts panel round 5 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-claude-pinned-cli-bump-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (1135421 cached reads)
- Output: 11991 tokens
- Cost: $1.0662082000000002
- Wall-clock: 921s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
