Fix round 1 for endojs/endo-but-for-bots#1406 is pushed and CI is green: 31 of 31 checks passed on head `68fb89bf1`. Four of the five must-fix items are done. The PR description edit (item 5) is still pending, because this host's bot token gets a 403 when editing PR descriptions on endojs. I posted it as a separate job.

**I rewrote the branch history to split one commit.** Item 3 can't be fixed with a follow-up commit alone. The pre-push typist fixer re-applies the `…` → `...` change to any changed `.md` file, so reverting the lines would not stick. Instead I split the original feature commit:
- **New `chore(claude)` commit:** holds only the ellipsis substitutions: the two in `designs/endo-claude-inference-backends.md` and the matching `sk-ant-oat…` one in `packages/claude/README.md`.
- **Feature commit `3b1ec7d4f`:** now carries only the feature. Its final file contents are identical to the old `4a6d915`.
- **Push:** I used `safe-push-pr-head.sh --mode rewrite`, with lease protection. The other fixes are normal follow-up commits on top.

**Must-fix items:**
1. **Repeated `--tools` / `--setting-sources` (`bbc0c7fe2`):** done. Both flags are now in the same check as `--permission-mode` and `--permission-prompts`: each of the four must appear exactly once with its pinned value. `assertEmptyValueFlags` is removed. It was never a package export, only used by tests.
   - The existing missing/altered/repeated refusal test now covers all four flags.
   - A new test checks the reported case, a trailing `--tools Bash`.
   - The `packages/claude` tests pass (81), and eslint and prettier are clean.
2. **Missing changeset (`70abbde69`):** done. I added `.changeset/endo-claude-pinned-cli-2-1-280.md` as a `minor` changeset, written one sentence per line.
3. **Unrelated autofix in the feature commit:** done, via the split above.
4. **README accuracy (`68fb89bf1`):** done. The table column is now "Confinement mechanism", and the `dontAsk` row says it sets the permission mode to `dontAsk`. The refuse-to-spawn paragraph now says all four value flags must appear exactly once.
5. **Concision:** the README part is done. The 2.1.280 evidence note is shortened to what was verified, with a link to #1406. The description edit is in job `pr1406-body-edit-panel1`, pinned to `endolin-garden-ece02cb4`. It removes the typist-fixer sentence and updates the Testing Considerations text: 81 tests, and the wider refusal coverage.

**Non-blocking suggestions:** I added the breaker's suggested known-gap entry: nothing re-checks the written `settings.json` at spawn. I did not rename `DISABLED_BUILTIN_PLUGINS` or move the "Live re-run" section, because both are in the PR description or optional.

**Follow-up:** the next panel round may run before `pr1406-body-edit-panel1` updates the PR description.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-claude-pinned-cli-bump-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (1907007 cached reads)
- Output: 14105 tokens
- Cost: $1.3174773999999998
- Wall-clock: 2284s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
