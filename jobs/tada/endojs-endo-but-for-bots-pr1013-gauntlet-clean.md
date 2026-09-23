All CI checks are GREEN at the current head, and this is a pure docs/design PR (adds `designs/relative-routing.md`, edits `designs/README.md` — 349/-1, no code packages touched). There is no source code for a coverage pass and no orphaned dead code. This clean stage is a no-op.

## Clean stage report — endojs/endo-but-for-bots PR #1013

**Idempotence check result:** The PR is already the right shape.

- `gh pr view` shows `state: OPEN`, `isDraft: true`, and all 5 status checks `SUCCESS` at the current head:
  - `browser-tests` (Browser Tests) — SUCCESS
  - `lint` (CI docs-only) — SUCCESS
  - `build` (Test project mutual dependency versions) — SUCCESS
  - `zizmor` (Workflow security audit) — SUCCESS
  - `test` (CI docs-only) — SUCCESS
- The diff is **docs-only**: `designs/relative-routing.md` (+342, new) and `designs/README.md` (+7/-1). No source packages are touched, so there is no coverage pass to run and no change-orphaned dead code to remove.

**Actions taken:** None required. No project checkout, no follow-up commit, and no CI re-wait needed — CI is already terminal-GREEN and nothing changed.

**Follow-ups:** None. The gauntlet driver may proceed to the next stage (panel).

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1013-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (102185 cached reads)
- Output: 1209 tokens
- Cost: $0.36372250000000006
- Wall-clock: 21s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
