This is a docs-only design PR — two markdown files (`designs/README.md`, `designs/agent-follow-stream-tool.md`), no code packages touched. All CI checks are SUCCESS at the current head. There is no coverage pass to run and no orphaned code to remove. The clean stage is a genuine no-op.

## Completion report

**Job:** endojs/endo-but-for-bots PR #234 — gauntlet stage CLEAN

**Findings:**
- PR #234 (`design(agents): follow-stream tool for lal/fae monitoring (proposed)`) is a **docs-only** change: `designs/README.md` (+6) and `designs/agent-follow-stream-tool.md` (+692). No source packages are touched.
- PR state: OPEN, not draft. All 8 status checks report SUCCESS (browser-tests, lint, copilot-setup-steps, build, zizmor, test, dependabot) at the current head.

**Actions:** None required. Per step 1 (idempotence), the PR is already the right shape — CI is GREEN and there is no code to run coverage on or dead code to orphan for a design-document change. No checkout, no follow-up pushes, no CI re-wait were needed.

**Follow-ups:** None. The design carries an "Open questions" section, so downstream gauntlet handling should treat it as a maintainer answer-surface (per the garden's open-questions design-PR carve-out), but that is outside this clean stage.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr234-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (91804 cached reads)
- Output: 1320 tokens
- Cost: $0.406921
- Wall-clock: 24s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
