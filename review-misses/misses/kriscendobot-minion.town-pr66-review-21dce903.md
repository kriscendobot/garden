---
kind: review-miss
primary_job: kriscendobot-minion.town-pr66-review-21dce903
verdict: miss
category: test-gap
pr: 66
cluster: behavior-change-without-regression-test
cluster_pattern: A source PR changes an end-to-end user path without a regression test exercising the new behavior, and the coverage stage or coverage-auditor does not require one before maintainer review.
review_at: 2026-08-30T05:19:44Z
repo: kriscendobot/minion.town
comment_url: https://github.com/kriscendobot/minion.town/pull/66#pullrequestreview-5060008635
identity: kriscendobot/minion.town#66:review:5060008635
producing_role: contributor
missed_by: cleaner/coverage-auditor
severity: minor
grounds: The reviewed head added an in-memory fallback across the HTTP quickstart path but no test exercised that path; the standing cleaner and coverage-auditor rules require reachable new public behavior to receive a specific integration test, and the later fix demonstrates that such a test was practical.
---

The approved review asked for final validation and suggested test coverage for
the newly added in-memory guest path. At the reviewed head, the PR changed the
HTTP quickstart from daemon-only behavior to an in-memory fallback, but added no
test that exercised the fallback through the public HTTP surface. The response
then added a focused integration test that starts the app without a daemon
socket and round-trips guest text, demonstrating that the path was testable
without a new dependency or an architectural rewrite.

**Grounds.** The journal has no gauntlet, cleaner, or panel job for PR #66, and
the PR conversation has no garden panel summary before the maintainer review.
This contributor PR therefore reached the maintainer without the garden's
coverage stages running. Had they run, the standing cleaner procedure requires
an integration test for reachable uncovered behavior, and the mandatory
coverage-auditor seat classifies reachable new public-API lines without coverage
as a change-request finding. The missing regression test was consequently a
known review concern, not a requirement first introduced by the review. The
review's separate question about a decorative log marker is treated as taste,
not as part of this miss.

The primary feedback job did not close as a no-op: the merged PR contains the
new regression test and its public completion comment reports the executed test,
type-check, and CI evidence.
