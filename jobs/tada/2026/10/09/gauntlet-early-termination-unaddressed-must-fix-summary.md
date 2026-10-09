---
handed-off: gauntlet-mustfix-summary-orch
deliverable-complete: false
---
I didn't build the feature. Instead I split the job into three smaller jobs and handed them to a new orchestration, `gauntlet-mustfix-summary-orch`, which now owns all the remaining work. No code, docs or commits landed on `main2` in either attempt.

**Why:** the full job (renderer, wiring into `scripts/jobs/gauntlet.sh`, a new resume flag, cleanup of juror text, tests, docs, journal example) doesn't fit one attempt's budget. Each attempt had about $1 or less, and the first ran out mostly on orientation.

**What's posted:** three parked jobs, run one after another. If one fails, the run halts and the maintainer is notified.
1. **`gauntlet-mustfix-summary-renderer`**: a script with no LLM in it that reads the gauntlet's panel and fix reports in `jobs/tada/` and produces the summary:
   - each unaddressed must-fix item with juror seat, `file:line`, truncated text and the round it was first raised;
   - each item marked persistent, new in the last round, or reintroduced;
   - the round-by-round trend, cost so far, and rounds used against the cap;
   - a verdict of converging, stuck on N persistent items, or moving target, from written rules;
   - juror text cleaned and fenced so it can't forge headings, links or @-mentions;
   - only the count line plus "list unavailable" for old-format reports;
   - tests for a persistent item, a moving-target series, an old-format report, an oversize item and a hostile item.
2. **`gauntlet-mustfix-summary-add-rounds`**: a resume option along the lines of `--resume-from-stage <g> <stage> --add-rounds N` that raises the round cap and resumes in one step, with tests and docs (the usage header, operator docs, and the gauntlet section of `pr-creation-flow`).
3. **`gauntlet-mustfix-summary-wiring`**:
   - puts the summary in a collapsed block on the PR terminal comment, under the same marker so a re-run doesn't post twice;
   - adds the summary and the resume command to the maintainer inbox notice;
   - writes a journal record next to the gauntlet record;
   - adds a note telling the `minion.town` arc supervisors to act on that record;
   - adds tests for each terminal state and confirms a parse failure never blocks the terminal state;
   - posts the journal message with a worked example from the `endojs-endo-but-for-bots-pr995-gauntlet` halt.

Each job carries a shortened copy of the original spec. The first attempt's note to the maintainer inbox explaining the budget problem still stands; no reply had arrived when I checked.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/gauntlet-early-termination-unaddressed-must-fix-summary.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (357730 cached reads)
- Output: 6116 tokens
- Cost: $1.0509602
- Wall-clock: 116s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
