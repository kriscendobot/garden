The Claude-on-minion.town press now writes its routine progress entry from the report itself, so a nominal window no longer needs an agent to compose it. The agent is left with interpreting exceptions and alerting the maintainer.

**What was already there.** Commit `275fcdbddb9` on `main2` had already added the mode:
- `claude-on-minion-town-completion-report.sh --write-progress` still prints the JSON report on stdout.
- It then renders the compact entry with `claude-on-minion-town-progress-entry.py`: the window, the counts, the rows not yet in `tada`, each in-window completion, and the exceptions, or "none (nominal)".
- It posts that entry with `journal-entry.sh progress`.

**What I changed:**
- **Wrapper (`main2` `6a1e44eafd6`):** the journal post's output now goes to stderr. The schedule saves the wrapper's stdout as `completion-report.json`, so a progress post can no longer corrupt the JSON. All four cases in `scripts/jobs/test/claude-on-minion-town-completion-report-test.sh` pass, including the one that checks the written entry.
- **Schedule (`journal/schedules/claude-on-minion-town-completion-press.md`, rewritten with `set-schedule.sh`):** cadence (6h), prefix and `last_dispatched` are unchanged. The new body:
  - runs the wrapper once with `--write-progress`, and tells the agent not to write a second roster entry or re-render the summary;
  - replaces "always write one compact progress entry" with: write one short extra entry giving each exception's disposition, and only when the report has exceptions (new dooms, stalled claims, missing prior-roster jobs, or a failed orchestration). A nominal window needs no further journal write;
  - keeps the maintainer-alert rules and the `arc nominal: …` closing line.

I confirmed the new body is on `origin/journal2`.

**Follow-up (not done):** each window still dispatches an agent at mentor tier, just one with nothing to write when things are nominal. To skip the dispatch entirely, the scheduler's `preflight:` gate could return "no work" (exit 2) for a nominal window. That needs the report to find the window before the scheduler records the new dispatch time, and today's wrapper refuses to run in that state, so it would be a separate change.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-deterministic-claude-arc-progress.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 24 tokens (746298 cached reads)
- Output: 4378 tokens
- Cost: $0.7125636 (1 engagement(s) unpriced)
- Wall-clock: 475s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
