The PR is a docs-only design PR (touches only `designs/README.md` and `designs/mount-denied-segments-cli.md`), and all CI checks are GREEN at the current head. There are no packages with code touched, so the coverage pass is a no-op and there's no orphaned code to remove. This clean stage is idempotently satisfied.

## Completion report

**Job:** Gauntlet CLEAN stage for endojs/endo-but-for-bots PR #814 (`design(cli): specify mount denied-segment flags`).

**What I did:**
- Checked PR shape via `gh pr view`: PR is OPEN, draft, head `endojs:design/mount-denied-segments-cli`.
- Enumerated changed files — the PR touches only two design documents (`designs/README.md`, `designs/mount-denied-segments-cli.md`). It is a pure docs-only change; no packages, no source code.
- Reviewed CI: all checks report `SUCCESS` (`build`, `lint`, `test`, `browser-tests`, `zizmor`, plus the `CI (docs-only)` workflow) at the current head.

**Result:** No coverage pass is applicable (no code touched) and there is no dead/orphaned code to remove. CI is already terminal-GREEN, so the clean stage is a no-op. No follow-up commits or pushes were needed; no project worktree required.

**Follow-ups:** None. The gauntlet driver may proceed to the next stage.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr814-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (91699 cached reads)
- Output: 1149 tokens
- Cost: $0.39293849999999997
- Wall-clock: 24s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
