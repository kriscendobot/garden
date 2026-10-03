## Fix round 6: endojs/endo-but-for-bots#1406

I applied all of the round-6 panel's must-fix items in one pass, plus the cheap should-fix items. I pushed two follow-up commits through `safe-push-pr-head.sh`, which moved the head from `9e94a3d99d` to `6bae6af851`. CI finished green: 31 of 31 checks, 0 failed, `ci-wait-merge` rc 0.

**Commit `094b7b09ba`: `fix(claude)`, in `packages/claude/src/argv.js` and its tests**
- **`--` token (breaker):** a bare `--` is refused anywhere in the argv. It also counts as a bare token when it follows a checked value.
- **Allow and deny lists (breaker):** `--allowedTools` and `--disallowedTools` are now required. That makes nine required flags, and all four per-spawn value flags must appear exactly once.
- **Empty values (wire-watcher, corner-prober, saboteur):** an empty value is refused for `--settings`, `--mcp-config`, `--allowedTools` and `--disallowedTools`.
- **Flags hidden as values (corner-prober):**
  - `--bare`, `--strict-mcp-config` and `--disable-slash-commands` must each appear exactly once, and never as another flag's value. For example, `--model --bare` is refused.
  - The values of `--model`, `--max-turns` and `--output-format` must not look like flags.
- **Code cleanup (purist, assessor):** the repeat check is now one shared helper, and the trailing-token check handles elements that aren't strings.
- **New tests:** one for each case above, plus a property test that repeats each checked flag with the same value. All 96 `packages/claude` tests pass locally, and eslint, tsc and prettier are clean.

**Commit `6bae6af851`: `docs(claude)`**
- **Changeset and README (packager, releaser, assessor):** both now describe every argv refusal, including the `--flag=value` and `--` cases and the allow/deny-list flags. The flag counts are corrected to nine required and eight that carry a value.
- **README wording (pruner):** the refusal conditions are now a bulleted list instead of one long sentence.

**PR body and comments**
- **Missing section (integrator):** I added the Documentation Considerations section the template requires.
- **"None." sections (pruner):** pruner wanted these removed, but integrator treats a missing template heading as blocking. I kept the headings and gave each one real content.
- **Change summary (scribe):** I posted a comment (issuecomment-5968058094) that maps each round-5 and round-6 item to the commit that fixed it.

**Not done:** checking the written `settings.json` at spawn time to confirm `enabledPlugins`. Reviewers raised it only as a comment, and the README's Known gaps section already discloses it.

I did not re-run the panel; the driver re-posts panel-7.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-claude-pinned-cli-bump-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 62 tokens (2768936 cached reads)
- Output: 19950 tokens
- Cost: $1.7702991999999997
- Wall-clock: 1448s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
