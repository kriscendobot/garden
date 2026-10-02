I applied all four round-3 must-fix items to PR endojs/endo-but-for-bots#1406. The PR head is now `ae036d0535`, and CI is green on it.

**Changes, pushed with `safe-push-pr-head.sh` (22c23fb0ad → ae036d0535):**
1. **Repeated `--settings` (item 1), commit `3c276d5d95`:** a new `assertSingleOccurrenceFlags` check runs inside `assertConfinedArgv`. It refuses a second `--settings` or `--mcp-config`. Both flags take a per-spawn file path, so their values can't be pinned, and a later occurrence would win. `--settings` was already required, so it must now appear exactly once. I added a unit test with a trailing `--settings /tmp/attacker.json` or `--mcp-config`, and a property test that inserts either flag at any position.
2. **Changeset (item 2), commit `df8c73ae71`:** the changeset now says `--settings` is required and that a repeated `--settings` or `--mcp-config` is refused.
3. **README, commit `ae036d0535`:** the paragraph on when the harness refuses to spawn now mentions the at-most-once check.
4. **PR body (item 3):** I moved the "Live re-run against 2.1.280" table under `### Testing Considerations`, so the body has only the template sections. The testing summary also mentions the new refusal tests.
5. **Summary comment (item 4):** posted at https://github.com/endojs/endo-but-for-bots/pull/1406#issuecomment-5955507330. It maps each round-2 and round-3 must-fix item to the commit that closes it, and notes the one comment-only item left as is: the `DISABLED_BUILTIN_PLUGINS` merge order, which a reviewer raised as non-blocking.

**Verification:** locally, all 84 `packages/claude` tests pass, and eslint, root `tsc` and prettier report nothing.

**CI:** `ci-wait-merge.sh --no-merge` returned 0 (green) about a second after it started, when only 7 checks existed, so I didn't rely on it. I checked the head's check runs directly instead: all are completed, with `lint`, the four `test` legs (22.x and 24.x on ubuntu and macos), `zizmor` and the change-detection jobs passing. The rest were skipped by change detection, and none failed.

**Follow-ups:** none. The driver re-posts panel-4.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-claude-pinned-cli-bump-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1634390 cached reads)
- Output: 9527 tokens
- Cost: $1.075346
- Wall-clock: 837s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
