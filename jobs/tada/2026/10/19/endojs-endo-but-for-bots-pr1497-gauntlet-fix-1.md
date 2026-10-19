## Gauntlet FIX round 1: endojs/endo-but-for-bots PR #1497

The style pre-pass finding is fixed, pushed to the PR head, and CI is green (30 of 30 checks, 0 failed).

**What I fixed:** the pre-pass `typist-friendly-code-points` probe flagged one `→` (U+2192) at `designs/daemon-agent-tools.md:547`. That line is the first row of the boundary table. I replaced it with `->`, and did the same in the other three rows of that table (lines 548–550) so the table stays consistent. After the change the probe passes.

**Commit:** a24d46b25f, "fix(designs): type ASCII arrows in the daemon-agent-tools boundary table". I pushed it to `endojs/endo-but-for-bots:design/daemon-agent-tools-next-slice` with `safe-push-pr-head.sh`, which moved the head forward from 9b712791f7 to a24d46b25f.

**CI:** `ci-wait-merge.sh --no-merge` returned rc 0.

**Follow-ups:** none required. Two `→` remain in the file:
- Line 314 is inside a code span, so the probe skips it.
- Line 700 is unchanged prose, and the probe only checks changed lines.

I left both alone. Panel-2 will be re-posted by the driver.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1497-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (650562 cached reads)
- Output: 2929 tokens
- Cost: $0.5886684
- Wall-clock: 783s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
