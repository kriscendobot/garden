This PR touches only design documents (`designs/clip-immutable-nonce-locator.md`, `designs/clip-ocap-synthesis.md`) — no source code, no packages. CI is GREEN at the current head. There is nothing to cover and no dead code to orphan; the clean stage is a no-op.

## Completion report

**Stage:** CLEAN — kriscendobot/minion.town PR #88

- Idempotence check: `gh pr view` shows the sole check `test (typecheck + vitest)` COMPLETED / SUCCESS at the current head (completed 2026-09-04T04:30:08Z). CI is GREEN.
- Scope inspection: the PR changes only two Markdown design files under `designs/`. There is no touched package to run a coverage pass against and no code the change could have orphaned.
- No follow-up commits were needed; nothing pushed to the PR head.

Result: coverage-clean by construction (docs-only), CI green → `clean=done`.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr88-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (85459 cached reads)
- Output: 1012 tokens
- Cost: $0.24729525000000002
- Wall-clock: 19s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
