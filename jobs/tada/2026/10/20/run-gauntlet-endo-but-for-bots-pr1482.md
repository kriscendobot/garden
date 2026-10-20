I did not re-run the gauntlet: endojs/endo-but-for-bots#1482 already finished one, and giving it more rounds is the maintainer's decision.

**The job points at the wrong PR**
- The job body describes "negotiate heartbeats by capability bit and default them on (ocapn-noise, daemon)". That is the title of endojs/endo-but-for-bots#1483 (head `build/ocapn-noise-heartbeat-capability`).
- endojs/endo-but-for-bots#1482 is a different PR, "crossed-hellos tiebreaker on reconnect (session-reconnect Phase 5)".
- #1483 already has its own job on the board, `run-gauntlet-endo-but-for-bots-pr1483`, so nothing extra is needed for it here.
- The endolin-garden-ece02cb4 host posted this job. Its claim that #1482 had "no gauntlet job on the board" looked only at active jobs and missed the finished one.

**State of #1482**
- Its gauntlet, `endojs-endo-but-for-bots-pr1482-gauntlet`, finished on 2026-10-17 with status `review-budget-reached`: 6 of 6 panel and fix rounds ran, and 20 must-fix items were still open after the last panel.
- The head is `acbaf00`, CI is green, the PR is still a draft, and it can be merged cleanly.
- A status comment on the PR already says it is waiting for the maintainer to merge, un-draft, or ask for another run.
- Starting the gauntlet again would mean adding rounds without the maintainer's approval, which the gauntlet's design reserves for them. So I did nothing on GitHub and wrote no garden code.

**What I did**
- I sent the maintainer inbox a note (`msg-run-gauntlet-endo-but-for-bots-pr1482-0091ec5ddf0a`) explaining the wrong target. It includes the command for more rounds if they want them: `scripts/jobs/gauntlet.sh --resume-from-stage endojs-endo-but-for-bots-pr1482-gauntlet panel --add-rounds N`.

**Possible follow-up:** the producer that posts "run the gauntlet" jobs should also check the finished-job records (`jobs/tada/`, where a completed gauntlet is filed) and match PR numbers to titles, so it doesn't post duplicate or wrong-target jobs.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `a46821cc0dace92918a1550703e8f82226a7df79`; this job presented `acbaf002168e20c25992572b6975e344bb1afeb0`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket received a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/run-gauntlet-endo-but-for-bots-pr1482.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (648174 cached reads)
- Output: 5776 tokens
- Cost: $0.6289628
- Wall-clock: 120s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
