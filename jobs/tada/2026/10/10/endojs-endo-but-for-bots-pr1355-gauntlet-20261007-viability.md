The gauntlet for PR #1355 can go ahead. I checked the PR, the current `llm` branch and the upstream merge, and spent nothing on cleaning, panels, fixes, CI waits or un-drafting.

**PR facts:** endojs/endo-but-for-bots#1355, "docs(designs): mark hardened URL shim complete". It is open, not a draft, and GitHub reports it as mergeable. Base is `llm-47f6965` and head is `3c06675b1b`. It changes two files, `designs/hardened-url-shim.md` and `designs/README.md`, to mark the design Complete because the implementation merged upstream in endojs/endo#3332.

Deciding question: Does `llm` still list `designs/hardened-url-shim.md` as unfinished, even though the upstream implementation it records (endojs/endo#3332) has merged, and has no other PR or commit already done this update?

Evidence:
- **Upstream has shipped it.** endojs/endo#3332 merged on 2026-08-21T23:42:11Z. Its title uses the shipped names (`%InitialURL%`/`%SharedURL%` split). The implementation file `packages/ses/src/tame-url-constructor.js` is also present on `llm`.
- **`llm` is still out of date.** Line 7 of `designs/hardened-url-shim.md` still reads `| **Status** | Not Started |`. The only commit to that file on `llm` is the original design commit, `6ddaa541d2` (2026-05-08).
- **Nothing has displaced the PR.**
  - #756 ("re-land hardened URL shim design") is an older ASCII and URL cleanup of the same file. It does not mark the design complete, so it doesn't supersede #1355, though the two may conflict textually.
  - #1356 and #719 are implementation PRs and are closed.
  - #1381 updated a different design (text codecs).
- **There are open review findings for the fix loop to handle.** The bot's earlier design panel came back must-fix. It asked to close out the `## Open questions` the shipped implementation answers, restructure the run-on Status prose, and point readers to the renamed identifiers before they appear. The PR has no human reviews yet.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1355-gauntlet-20261007-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (238283 cached reads)
- Output: 2084 tokens
- Cost: $0.4728086
- Wall-clock: 28s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
