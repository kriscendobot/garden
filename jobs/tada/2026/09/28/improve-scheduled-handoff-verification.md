A pending one-time schedule now counts as a valid handoff successor. An agent can defer a deployment-gated retry with `set-schedule-once.sh` and complete as a handoff without being reaped. The change is pushed to `main2` as `e3e285a3958`. The posted-follow-up gate test passes, including the new cases. The broader `completion-signal-test.sh` fails 19 cases, but it fails the same 19 without my change, so the cause is in the environment and not this edit.

**The fix.** Both `complete-job.sh --handed-off` and `assert-followup-posted.sh` use one shared check, `handoff_successor_posted` in `scripts/jobs/common.sh`, to decide whether a successor exists. I extended that check with `handoff_successor_scheduled`, so both scripts accept the new case.

**What counts as a match.** A record under `schedules/*.md` matches when:
- it has a `once:` timestamp that parses, and
- its `job_basename_prefix` exactly equals the successor's name; if there is no prefix, the schedule's own name is used.

This follows how `scheduler.sh` dispatches `once:` records. The scheduler deletes the record and creates the todo job in the same commit, so the successor is always visible as one or the other.

Three kinds of record do not match:
- recurring `cadence:` schedules, because each dispatch adds a timestamp suffix no report can name in advance;
- records with a `once:` value that doesn't parse;
- a schedule whose name matches but whose prefix names a different job.

One deviation from the spec: it says "future" schedules, but a record that is already due and hasn't fired yet also counts. It is still durable, and the next scheduler run creates the job.

**Tests and docs.**
- New cases in `scripts/jobs/test/followup-posted-gate-test.sh`: (c3) passes for a match by prefix and by name; (c4) blocks each of the three non-matching kinds above.
- Updated the header comment in `assert-followup-posted.sh` and the Complete entry in `skills/job-board/SKILL.md` (which also now lists staged gauntlets as successors).

**Follow-up.** `scripts/jobs/test/completion-signal-test.sh` fails 19 cases on this host both with and without the change, so the problem predates this job. It has no test yet for a scheduled successor, which could be added once it runs cleanly.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-scheduled-handoff-verification.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (979330 cached reads)
- Output: 7269 tokens
- Cost: $0.890878
- Wall-clock: 171s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
