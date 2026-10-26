Gauntlet fix round 1 for endojs/endo-but-for-bots#1558 (`design/endo-child-agent-factory`) is pushed and CI is green: 30 of 30 checks passed, `ci-wait-merge.sh` returned rc=0.

**The fix:** The style pre-pass flagged one `typist-friendly-code-points` failure, a U+2192 arrow at `designs/endo-child-agent-factory.md:279`. The same table had three more of these arrows (lines 280–282), so I replaced all four with `->` in one follow-up commit, `828617ae36`. I pushed it with `safe-push-pr-head.sh`, which moved the head from `8faeb579ed` to `828617ae36` without overwriting anything. A local re-run of `pre-push-gates.sh --probes-only --base-ref origin/llm` passed all 10 stages.

**Left out:** The gate's auto-fix also rewrote two characters in `designs/README.md` (an `…` and an `’`). Those lines already existed on `llm` and the pre-pass didn't flag them, so I reverted that change to keep the fix to the reported finding.

**Next:** The PR is still a draft. Per the gauntlet, I did not re-run the panel; the driver posts panel-2 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1558-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (740445 cached reads)
- Output: 3187 tokens
- Cost: $0.685165
- Wall-clock: 682s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
