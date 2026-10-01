The round-1 panel on endojs/endo-but-for-bots PR #1406 came back **must-fix**. `panel.sh` exited 0, and its last line was `code-panel single-round — must-fix`.

**Run:** Checked out the PR head (`endojs/endo-but-for-bots@bot/build/claude-pinned-cli-bump`, commit `4a6d91527e`) in an isolated worktree. Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` against base `origin/llm-d4124e6`. Two pre-passes added seats: the PR body has an invented heading, so the integrator was added, and the concision probe fired, so the pruner was added.

**Seats:** 31 in total. 7 requested changes (archivist, breaker, purist, integrator, changeset-auditor, pruner, releaser), 9 were comment-only and 15 approved.

**Must-fix items:**
1. **Flag can be repeated (`argv.js`):** `assertEmptyValueFlags` only checks the first `--tools` or `--setting-sources`. A later `--tools Bash` passes `assertConfinedArgv`, and since the CLI honours the last occurrence, that reopens the built-in tools. The new `assertPinnedValueFlags` already refuses repeats. The fix is the same exactly-once check (ideally one shared `{flag: value}` assertion) plus a refusal test. (breaker, purist)
2. **No changeset:** `@endo/claude` needs a `minor` changeset for the 2.1.280 pin, the new `--permission-mode`, `--permission-prompts` and `enabledPlugins` requirements, and the new exports. Earlier changes to this package all shipped one, e.g. `endo-claude-confined-turn.md`. (changeset-auditor, releaser)
3. **Unrelated edit in the feature commit:** the `…` → `...` rewrite in `designs/endo-claude-inference-backends.md` should be its own `chore:` commit. (integrator)
4. **README wording:** the table header "Flag" doesn't fit the rows that aren't flags, and the `dontAsk` row's text contradicts itself. (archivist)
5. **Too long:** drop the typist-fixer sentence from the PR body and shorten the 2.1.280 results under README "Known gaps". (pruner)

**Review posted:** https://github.com/endojs/endo-but-for-bots/pull/1406#pullrequestreview-5379134262. GitHub refused a request-changes review because the bot owns the PR, so it went up as a COMMENTED review. The body starts with `<!-- garden-panel-verdict: must-fix round=1 ... -->` and a "Panel round 1 — must-fix" heading, then lists the must-fix items, every seat's verdict, and the full findings from the non-approving seats. The approving seats' full text was left out because the whole aggregate (74 KB) is over GitHub's review-size limit.

As instructed, I made no fixes and did not un-draft the PR.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-claude-pinned-cli-bump-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (874423 cached reads)
- Output: 5769 tokens
- Cost: $0.7620646000000001
- Wall-clock: 1034s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
