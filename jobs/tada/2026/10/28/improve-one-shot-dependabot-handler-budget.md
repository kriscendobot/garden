`dependabotany-recheck-*` one-shots now dispatch with a 7200s handler budget instead of the 2400s default that killed the PR #1553 recheck. The fix is pushed to `main2` as 7c47efb426a.

**The cause.** For a one-shot schedule, the scheduler turns the body into the job file as-is. The recurring path reads a `handler-timeout:` line from the schedule header, but the one-shot path has nothing like it. Since `set-schedule-once.sh` never wrote a budget into the body, every one-shot ran at the generic 2400s limit.

**What changed:**
- **`scripts/jobs/set-schedule-once.sh`:** if the schedule name or job-name prefix starts with `dependabotany-recheck-`, it now adds `handler-timeout: 7200` to the body's leading frontmatter, creating that frontmatter if the body has none. If the body already declares a `handler-timeout:` there, that value is kept. Running it twice gives the same result, so its internal retry step doesn't add the line a second time.
- **New test, `scripts/jobs/test/schedule-once-dependabotany-handler-timeout-test.sh`:** it uses a throwaway journal, sets three one-shots and runs one real scheduler tick. It checks that:
  - a plain-body recheck dispatches with exactly one `handler-timeout: 7200`, in the same frontmatter as the routing fields;
  - a body that declares 3600 keeps 3600, with no duplicate line;
  - an unrelated one-shot gets no budget.

  It passes 6/6. Against the old script it fails the 7200 check, so it catches the bug. The existing `schedule-once-isolated-fallback-test.sh` still passes 9/9.
- **Docs:** `roles/botanist/AGENT.md` (the step that creates the one-shot) and `skills/schedule/SKILL.md` now describe the automatic budget and how to override it.

**Follow-up:** one-shots already waiting on the journal were written by the old script, so they will still fire without the budget. One way to fix any that are still pending is to re-run `set-schedule-once.sh` for each with the same arguments. Otherwise, re-post any that time out with `handler-timeout: 7200`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-one-shot-dependabot-handler-budget.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (1147863 cached reads)
- Output: 9231 tokens
- Cost: $1.0267845999999998
- Wall-clock: 163s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
