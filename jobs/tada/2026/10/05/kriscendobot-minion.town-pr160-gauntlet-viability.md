PR #160 is still viable: it hasn't been superseded and the problem it fixes is still present, so the gauntlet can go ahead. I spent no clean, panel, fix, CI-wait or un-draft budget, and made no commits or pushes.

**Deciding question:** Does `main` still start the confined `claude -p` MCP command with the root `ENDO_SOCK` and `ENDO_GUEST_FORMULA_ID`, with issue #149 open and no newer PR or commit already doing the guest-scoped broker? **Yes.**

**Evidence:**
- **PR state:** open and still a draft. Head is `2bd8430` on `claude-guest-scoped-mcp`, base is `main-9ac858d` (`9ac858df`). It was opened 2026-10-05 and fix round 2 was pushed today.
- **Base history:** `main` has no commits past the PR's base `9ac858df`. So nothing newer can have replaced it, and the root-socket and formula-id launch it removes is still the current code.
- **Linked issue:** #149 ("Claude CLI backend: guest-scoped bootstrap for the confined session's MCP command") is still open, and the PR says `Fixes #149`.
- **No competing work:** searching all minion.town PRs found no other guest-broker implementation. The related merged PRs #148 and #150 came before this one; they are the setup it fixes, not replacements.
- **Design and follow-ups:** the approach follows endojs/endo-but-for-bots#1407. This PR filed issues #161 (the broker should serve only the reduced tool list) and #162 (separate unix users).

My previous attempt put the stage marker on the last line, where the completion signal has to go, so the job wasn't recorded as done. This time the marker comes just before the signal.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr160-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (162937 cached reads)
- Output: 1946 tokens
- Cost: $0.8112568
- Wall-clock: 27s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
