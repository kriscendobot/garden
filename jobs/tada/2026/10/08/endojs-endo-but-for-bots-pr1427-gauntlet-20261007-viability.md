Gauntlet stage: viability check for endojs/endo-but-for-bots PR #1427

**Result: proceed.** The PR is open, unmerged and not a draft. Its head is `1b1ead43c8` and its base is `master-6ee3fda`. A newer change has not replaced it, and the bug it fixes is still present on `master`. I spent no clean, panel, fix or CI budget.

Deciding question: Does `master` still pin `dorny/paths-filter@d1c1ffe…` with the stale `# v3` comment, so zizmor's `ref-version-mismatch` audit still fails every PR based on `master`? **Yes.**

Evidence:
- **`master` still has the bug.** Line 270 of `.github/workflows/ci.yml` on `master` (`6ee3fda77b`, 2026-07-22) still reads `dorny/paths-filter@d1c1ffe0248fe513906c8e24db8ea791d46f8590 # v3`. `master` has not moved since 2026-07-22, and no newer commit changes that file.
- **The tags show the mismatch.** At `dorny/paths-filter`, the `v3` tag now resolves to `0e4a8c6eff` (v3.0.4). The pinned SHA `d1c1ffe024` is exactly `v3.0.3`. `master`'s last zizmor run passed on 2026-07-22, before `v3` moved, so it doesn't show the current failure.
- **The PR clears the check.** zizmor passes on the PR head. Panel round 1 passed with 33 seats, 32 approve and no must-fix findings.
- **One overlapping fix exists, but it hasn't landed.** The open PR #1425 (a SES fix) carries its own workaround commit, `74e526ba33 ci: repin paths-filter to v3.0.4`. It moves the pin to the v3.0.4 SHA instead of correcting the comment, which is why #1425's zizmor check passes. Since #1425 has not merged, #1427 is still the standalone fix for `master`.
- **No other replacement.** I found no other open or merged PR fixing this pin on `master`. The paths-filter 4.x Dependabot bumps (#188, #913, #1002) predate the current pinned SHA, so they don't affect `master` now.

Follow-up for whoever merges or the maintainer: #1427 and #1425 both edit `ci.yml:270` in different ways. Whichever lands second will conflict, so one should be rebased onto the other. If #1427 merges first, the extra commit in #1425 could be dropped. If #1425 merges first, it makes #1427 redundant, and #1427 should then be closed as superseded.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1427-gauntlet-20261007-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (335632 cached reads)
- Output: 2964 tokens
- Cost: $0.4839984
- Wall-clock: 43s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
