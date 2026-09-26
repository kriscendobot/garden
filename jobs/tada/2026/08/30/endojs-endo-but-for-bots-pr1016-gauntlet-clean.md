The PR is a docs-only change — a single added design markdown file (`designs/ironhorse-rejection-handling.md`, +303/-0), no code and no packages touched. All CI checks are GREEN at the current head. There is no source code to run a coverage pass against and no code the change could have orphaned, so the clean stage is a no-op.

## Completion report

**Job:** endojs-endo-but-for-bots-pr1016-gauntlet-clean (gauntlet CLEAN stage, PR #1016)

**Findings:**
- PR #1016 (`design/ironhorse-rejection-handling`) adds exactly one file: `designs/ironhorse-rejection-handling.md` (+303/-0). It is a pure design/rationale document — no code, no touched packages.
- CI is fully GREEN at the current head: `browser-tests`, `lint`, `build`, `zizmor`, and `test` all report SUCCESS (docs-only CI workflow).
- Nothing to do for coverage: there is no source under test and no dead code the change could have orphaned. The clean stage is idempotently a no-op.

**Changes made:** none (no coverage pass applicable, no follow-up pushes needed).

**Follow-ups:** none for this stage. The PR remains a draft, as expected for a design-review surface; downstream gauntlet stages (panel/fix-loop/un-draft) proceed per the driver.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1016-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (102163 cached reads)
- Output: 1187 tokens
- Cost: $0.37363650000000004
- Wall-clock: 20s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
