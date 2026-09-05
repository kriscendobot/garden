Implemented and pushed commit `0389ac0130` to `main2`.

- Pre-push gates now detect npm, Yarn, pnpm, or Bun from `packageManager`, falling back to lockfiles and then Yarn.
- Format, lint-fix/lint, and typecheck use the selected runner; npm forwards `--fix` correctly.
- Added npm regression coverage and updated the skill documentation.
- Verified with ShellCheck, pre-push gate tests, convention-probe tests, and the gate itself.
- Follow-ups: none.
- Self-improvement: updated `skills/pre-push-gates/SKILL.md` with the new package-manager procedure.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-pre-push-gates-package-manager.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 371s

<!-- garden-usage-end -->
