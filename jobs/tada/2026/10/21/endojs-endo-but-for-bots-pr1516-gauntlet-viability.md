**viability=overtaken.** PR #1516 should not enter the gauntlet loop.

**Deciding question:** Is #1516 still the change that should be reviewed and un-drafted, or does a newer PR already carry and extend its work?

**Evidence:**
- **PR facts:** #1516 is OPEN, unmerged and in draft. Its title is "test: probe AVA suites under Bun (gap-revealing prototype)", its head is `probe/bun-testing` and its base is `master-ebc7904`.
- **It was never meant to merge.** It was built as a probe (job marker `probe-endo-bun-testing-20261020`). Its description says it "deliberately stops short of treating the Bun lane as mergeable" and gives a six-gap report. Under the garden's rules a probe stays draft, and no clean, panel, fix or un-draft chain follows it.
- **A newer PR replaces it.** PR #1519 (`bun-ses-permits`, opened 2026-10-21T07:26Z, draft, same base `master-ebc7904`) is stacked on the probe head `2b7550456`. GitHub's compare shows `bun-ses-permits` is 9 commits ahead of `probe/bun-testing` and 0 behind, so all of #1516's commits are in #1519.
- **#1519 is now the PR meant to merge.** It settles Gap 3 (the SES permits for Bun's `URLSearchParams` additions) and fixes defects in the probe's launcher. It also wires the Bun CI job as required for the green packages, with the full matrix as an advisory step.
- **The bot already said so on #1516.** Its comment of 2026-10-21T07:26:33Z reads: "The successor, https://github.com/endojs/endo-but-for-bots/pull/1519, settles Gap 3 … and re-measures the Bun lane."
- **The reason for #1516 no longer stands.** Its job was to bring gaps to light, and that is done. The follow-on implementation lives in #1519, so a gauntlet should target #1519, not #1516.

Option: close as superseded

Nothing was changed: no commits, no PR edits, and no clean, panel, fix, CI-wait or un-draft budget spent.

<!-- gauntlet-stage-result: viability=overtaken -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1516-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (157137 cached reads)
- Output: 1822 tokens
- Cost: $0.41838739999999996
- Wall-clock: 37s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
