**Panel round 5 for endojs/endo-but-for-bots#1406 returned must-fix.**

- **The run:** `panel.sh` ran in single-round mode against an isolated checkout of `bot/build/claude-pinned-cli-bump` (head `e2f5cecb61b2`, base `llm-d4124e6`) and exited 0. The garden journal recorded the run at `panel-runs/endojs-endo-but-for-bots-1406/9cc21e28438c.md`.
- **Seats:** 33 in total. Ten requested changes: stylist, locksmith, warden, saboteur, breaker, purist, spec-keeper, pruner, corner-prober and fast-checker. Seven left comments only and the rest approved. The PR-body concision probe fired, so the pruner was also run over the PR description.
- **Main findings:**
  - In `packages/claude/src/argv.js`, `assertSingleOccurrenceFlags` and `assertPinnedValueFlags` never check that a value actually follows `--settings` or `--mcp-config`. They also find flags by `indexOf`, so a flag-shaped string sitting in a value slot can be read as a flag.
  - The archivist flagged two out-of-date descriptions: the test name "empty-value flags" in `test/argv.test.js`, and the OAuth/`enabledPlugins` comment in `spawn-files.js`.
- **The review:** posted as review 5394074659, a COMMENTED review starting with `<!-- garden-panel-verdict: must-fix round=5 head=e2f5cecb… -->`, the same shape as rounds 1–4. GitHub refused a request-changes review because the bot can't request changes on its own PR.
- **Size limit:** the full aggregate (about 80 KB) is too big for one review. The review has all ten request-changes seats in full, then as many of the others as fit. A note in it points to the journal record for the rest.

Nothing was fixed or un-drafted, as this stage requires.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-claude-pinned-cli-bump-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (679424 cached reads)
- Output: 3580 tokens
- Cost: $0.6608768
- Wall-clock: 607s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
