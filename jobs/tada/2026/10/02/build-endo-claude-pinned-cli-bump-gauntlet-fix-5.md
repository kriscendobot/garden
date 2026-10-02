## Fix round 5: endojs/endo-but-for-bots PR #1406

I applied the round-5 panel's must-fix items in one follow-up commit, `9e94a3d99d`, and pushed it with `safe-push-pr-head.sh` (e2f5cecb61 → 9e94a3d99d). CI is green: 31 checks, 0 failed (`ci-wait-merge` rc 0).

**Code changes, in `packages/claude/src/argv.js`:**
- **Flags with no value** (warden, purist, corner-prober): `assertSingleOccurrenceFlags` now requires the token after each flag to exist and not look like a flag. Before, an argv with `--settings` dangling at the end, or `--mcp-config` directly followed by `--strict-mcp-config`, passed the check.
- **`--flag=value` duplicates** (saboteur, breaker): a new `assertNoInlineFlagValues` check refuses any token that starts with `--` and contains `=`. It runs inside `assertConfinedArgv`. The harness never emits that form, and the pinned CLI reads it as the same option, so it could slip past the duplicate checks, which compare whole tokens.
- **Allow and deny lists** (locksmith, spec-keeper): `--allowedTools` and `--disallowedTools` are now in `SINGLE_OCCURRENCE_FLAGS`. Each may appear at most once, must carry a value, and may not be followed by a stray token. I updated the module, constant and gate docstrings to match.

**Test changes, in `packages/claude/test/argv.test.js`:**
- **Rename** (stylist): `pos` → `position` in the property test.
- **New tests:**
  - `--settings` or `--mcp-config` with no value, either at the end or just before another flag.
  - A repeated `--allowedTools` or `--disallowedTools`, or one followed by a stray token.
  - A property test showing a `--flag=value` token is refused for every checked flag.

All 90 tests in `packages/claude` pass locally, and eslint reports no problems on the changed files. I did not run the `tsc` type check: `npx tsc` isn't available in this checkout.

**PR body** (pruner):
- I removed the Documentation Considerations section.
- I moved the live 2.1.280 results table into a PR comment (issuecomment-5956485140). The body now has one sentence pointing to it.

**Follow-ups:**
- **Not fixed:** locksmith also noted that the builtin-plugin denials in `enabledPlugins` are a list of named plugins, so a plugin added in a future CLI version would be enabled by default. They marked it comment-only because the pinned version check forces a re-check before any CLI upgrade, so I did not change it.
- **Not run:** the next panel round (panel-6) is left to the gauntlet driver, as this stage requires.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-claude-pinned-cli-bump-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (1051119 cached reads)
- Output: 8564 tokens
- Cost: $0.9131998000000001
- Wall-clock: 852s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
