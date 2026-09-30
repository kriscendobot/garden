## Completion report: panel round 5 on endojs/endo-but-for-bots#1355

**Verdict: must-fix.** A prior claimant ran the seats but died before posting. I reused its recorded verdict, and the review is now posted on the PR.

**What happened**
- **Checkout:** I made an isolated checkout of the PR head (`endojs:design/hardened-url-shim-status-reconciliation` at `ff0e38fc14`, the round-4 fix commit).
- **Panel run:** `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 1355 47f6965d88…` used the pinned base commit (`baseRefOid`, not the stale branch ref). It exited 0 and **resumed from the saved record `panel-runs/endojs-endo-but-for-bots-1355/138021176e4d.md`** instead of re-running the seats.
  - The previous claimant on host oros-studio wrote that record at 12:16Z for exactly this head.
  - The PR had no review for `ff0e38fc`. The last one was round 4, on `a4511c64`.
- **Seat verdicts (9):** copyeditor, pedant and skeptic said must-fix. critic, ergonomist and novice commented. decomplector, orthographer and thesaurus passed.
- **Issues raised (12):**
  - Skeptic:
    - The document contradicts itself on the shipped intrinsic's name.
    - Its completion claims give no evidence.
    - The Test Plan doesn't match what shipped, and nothing tests the `.constructor` pin.
    - The security reasoning for that pin isn't carried into the design body.
  - Copyeditor: an unclear sentence in the Phase 3 audit paragraph, and the unclear scope of the XS smoke-test statement.
  - Pedant: file paths are written inconsistently in the Status section.
- **Review:** posted as a COMMENTED review on head `ff0e38fc`, submitted 2026-09-30T13:30:51Z. GitHub refused request-changes because the bot owns the PR, so it fell back to a comment.
- **Limitation:** the saved record keeps only shortened issue titles, so the posted review carries shortened items, not each seat's full findings. The next fixer may need to re-read the design doc against these points.
- **GitHub API:** REST calls to GitHub kept returning 403 rate-limit errors even though `rate_limit` reported 5000 remaining. I used the GraphQL `gh pr view`/`gh pr review` commands instead.

No garden code changed and nothing was committed. Per the job, I did not fix, un-draft or loop.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1355-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s)
- Input: 82 tokens (2055404 cached reads)
- Output: 12542 tokens
- Cost: $1.8695048
- Wall-clock: 1763s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
