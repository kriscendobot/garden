Pushed to main2 as `ab1d02177`.

## Completion report

**Finding:** The behavior change this job asks for was already fully implemented on `origin/main2` by commits `3e51f3f35` and `1e5ccb552` (both in HEAD before I started). `scripts/jobs/scheduler.sh` no longer re-emits the missing-preflight WARN every tick: when a declared `preflight:` resolves to a missing/non-executable path, `note_missing_preflight` now (a) WARNs at most once per (schedule, resolved-path) breakage via a `$GARDEN_STATE` marker, and (b) escalates exactly once to the maintainer inbox through `alert_maintainer` (deduped on schedule name + throttled), while keeping dispatch fail-open. The marker/note clear the instant the gate is found again, re-arming per breakage. I verified this against the spec and by running the existing `scheduler-preflight-deploy-lag-test.sh` (14/14 pass).

**Gap I closed:** That existing test only covered the **deploy-lag** branch (gate present on `origin/main2`, absent from the deployed root). The **typo / never-landed** branch — the case the job spec most directly names ("a typo in the schedule's `preflight:` path", "a preflight script that was never landed") — had **no regression coverage**. The code path was correct but untested, so a future refactor could silently reintroduce the warned-forever degradation for the most common real-world trigger.

**What changed:** Added `scripts/jobs/test/scheduler-preflight-typo-test.sh`, a hermetic test (throwaway journal + deployed-root fixtures) that drives a schedule whose preflight exists on no branch and asserts: fail-open dispatch preserved (2/2 due ticks post), WARN fires exactly once across ticks, the not-found maintainer notice is delivered exactly once, **no** deploy-lag note is written (distinguishing a typo from deploy-lag — a deploy wouldn't fix it), the dedup marker records the resolved path, and the one-shot signal re-arms once the gate becomes present. 11/11 pass.

**Follow-ups:** None. The self-healing/escalation behavior the job requested is live and now regression-covered on both branches.
