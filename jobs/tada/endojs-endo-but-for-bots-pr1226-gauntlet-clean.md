The PR is a docs-only design PR (two files under `designs/`, no code touched) and all CI checks are already terminal GREEN (SUCCESS/SKIPPED). There is no code coverage pass to run and no dead code to remove. This clean stage is a no-op.

## Completion report

**Job:** endojs/endo-but-for-bots PR #1226 — gauntlet CLEAN stage.

**Findings:**
- PR #1226 (`docs(designs): a stdio MCP server scoped to one guest's tool surface`) touches only two files: `designs/README.md` (+6) and `designs/endo-guest-stdio-mcp.md` (+405, new). It is a **docs-only** change — no package source is touched, so there is no coverage pass to run and no orphaned code to remove.
- CI at the current head (`ae3c29d0`) is fully terminal GREEN: `browser-tests`, `lint`, `build`, `zizmor`, `test`, and IronHorse detection all SUCCESS; `ironhorse-oracle-sanitizers` correctly SKIPPED.

**Actions taken:** None required — the PR is already the right shape (docs-only, CI green). No isolated checkout, no follow-up push, no CI wait needed per the idempotence-first step.

**Changed:** nothing.

**Follow-ups:** none. The PR remains a draft (expected for a design PR in the gauntlet); subsequent gauntlet stages handle review/un-draft.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1226-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (95400 cached reads)
- Output: 1179 tokens
- Cost: $0.41734999999999994
- Wall-clock: 21s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
