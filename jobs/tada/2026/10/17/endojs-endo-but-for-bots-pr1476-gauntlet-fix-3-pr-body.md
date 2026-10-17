I applied the trimmed body to endojs/endo-but-for-bots#1476.

**What I did**
- Wrote the body between the BODY markers to a temporary file and ran `gh pr edit 1476 -R endojs/endo-but-for-bots --body-file <file>`. It succeeded on this host (endolin-garden-ece02cb4), so the 403 seen on oros-studio did not occur here.
- Checked the result with `gh pr view 1476 --json body`:
  - The body starts with `<!-- garden-job: endo-but-for-bots-ocapn-noise-session-reconnect-build -->`.
  - It contains `### Documentation Considerations` once.
  - It matches the intended body exactly, apart from the trailing newline, which GitHub removes.

**Panel-3 must-fixes this answers**
- The missing `### Documentation Considerations` heading is now present.
- The body is under 300 words.
- The Phase 2 ledger line now reads `in-progress` and points to stacked draft #1478.

Nothing else changed: no pushes, no reviews and no garden commits.

**Follow-ups:** none from this job.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `bf0d59985fe814b0690a2f603a843ee7de07125e`; this job presented `88b95820a7efb75d3c020f0b401598ca1a3e0433`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket received a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1476-gauntlet-fix-3-pr-body.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 4 tokens (64419 cached reads)
- Output: 1857 tokens
- Cost: $0.3801198
- Wall-clock: 19s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
