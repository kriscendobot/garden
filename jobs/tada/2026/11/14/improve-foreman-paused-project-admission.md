The foreman no longer fails or stalls when a job belongs to a paused project; the fix is pushed to `main2` as `2b96beca6c0`.

**The bug.** When asked to start or post a paused-project job, `promote-plan.sh` and `post-job.sh` refuse with exit code 78 (`GARDEN_PAUSED_RC`). The foreman handled that badly in two places:
- **Promoting parked jobs:** it hid the 78, logged a generic failure and stopped promoting for that tick. The next tick picked the same paused job first again, so the eligible jobs behind it never ran.
- **Posting a new step:** when the handler proposed a step in a paused project, the foreman exited with 78, which failed the `garden-foreman` unit on every tick (04:25:54–05:49:09Z).

**The fix, in `scripts/jobs/foreman.sh`:**
- **Promoting parked jobs:** the foreman now checks for 78 by name. It leaves that job out of the current tick's candidates and goes on to the next eligible one. The skipped jobs are added to the tick's log line as `paused=<bases>`. Lifting the pause lets the job back in on the next tick. Any other promotion error still stops promotion for that tick, as before.
- **Posting a new step:** a 78 is now logged as `guard=paused-project` and the tick exits 0. The handler gets one more try, told to propose a step outside every paused project. If that also fails, nothing is posted and the maintainer is not notified, because the pause is their own decision.

**Tests:**
- New: `scripts/jobs/test/foreman-paused-project-admission-test.sh` passes 12/12. Against the old foreman it fails 5 checks, so it catches this defect.
- `foreman-stub.sh` now also answers the new paused-step retry prompt.
- `foreman-deferred-sigpipe-test.sh` checked for the old single-line form of the line that picks the next job, which is now split across several lines. I updated the check; it still confirms the `|| true` guard is there.
- The other foreman tests (completed-collision, decision-log, post-tempfail, brake, budget-road) and the awaiting-maintainer-gate test all pass, and shellcheck is clean.

Hosts keep the failing behaviour until they deploy this commit.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-foreman-paused-project-admission.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (1173410 cached reads)
- Output: 12435 tokens
- Cost: $1.1289820000000002
- Wall-clock: 333s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
