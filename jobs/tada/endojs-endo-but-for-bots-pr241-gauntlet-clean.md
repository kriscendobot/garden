This PR (#241) is a pure design/docs PR — it touches only `designs/README.md` and `designs/familiar-run-apps-vfs.md`, with no packages or code. There is nothing for a coverage pass to cover and no orphaned code to remove. CI is already terminal GREEN at the current head (`ac71c04`): all checks (lint, test, build, browser-tests, zizmor, copilot-setup-steps, dependabot) report SUCCESS. The clean stage is a no-op.

## Completion report

**Job:** endojs/endo-but-for-bots PR #241 gauntlet — CLEAN stage.

**What I did:**
- Ran the idempotence check: `gh pr view #241`. PR is OPEN, not draft, and every status check in the rollup is SUCCESS at the current head `ac71c0424b38a5cdd6cd17b7f08fe04af60ab4ed`.
- Inspected the diff: only two files changed — `designs/README.md` (+7) and `designs/familiar-run-apps-vfs.md` (+592, added). This is a documentation-only design PR touching no source packages.

**What changed:** Nothing. There is no code to run a coverage pass against and no dead code the change could have orphaned, so no follow-up commits were pushed.

**CI state:** GREEN / terminal at the current head.

**Follow-ups:** None for the clean stage. The gauntlet driver can proceed to the next stage (panel review).

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr241-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (91473 cached reads)
- Output: 1339 tokens
- Cost: $0.4031504999999999
- Wall-clock: 25s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
