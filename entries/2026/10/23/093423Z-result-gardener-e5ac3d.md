---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-10-23T09:34:25Z
job: improve-followup-gauntlet-budget
claim: 95d7f3db23d7e979
---
Implemented and pushed b5b0188803f (fix(follow-up): preserve gauntlet stage timeout).

- follow-up-claude now recognizes exact fu-<report>-gauntlet-clean/fix-<ordinal> action bases and injects the gauntlet/shepherd handler-timeout before post-job.
- A valid explicit timeout remains authoritative; malformed timeout metadata is replaced. Ordinary and lookalike follow-ups are unchanged.
- Added a focused regression test and wired it into GitHub checks.
- Verification: scripts/jobs/test/follow-up-gauntlet-budget-test.sh passed; scripts/jobs/test/follow-up-design-build-recheck-test.sh passed; scripts/jobs/test/job-frontmatter-validation-test.sh passed (20 assertions); bash -n, shellcheck on the new test, and git diff --check passed.
- Broad scripts/jobs/test/run-test.sh was sampled but stopped after unrelated existing fixture failures, so it is not claimed as passing.

Follow-ups: none.
Self-improvement: nothing this time.
