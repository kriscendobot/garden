**Completion report: improve-extend-long-running-role-timeouts**

I raised the default time limit for fixer and shepherd jobs from 7200s (2h) to 10800s (3h). Both had been killed at their 7202s limit on 2026-10-31. 10800s is still under the ~14339s single-claim ceiling, so the gardener uses it as-is and does not clamp it. The change is pushed to `main2` as af590fb1fa4.

**What changed:**
- **`scripts/jobs/common.sh`:**
  - The two settings are now `GARDEN_SHEPHERD_HANDLER_TIMEOUT:=10800` and `GARDEN_FIXER_HANDLER_TIMEOUT:=10800`.
  - The matching fallbacks in `role_default_handler_timeout` are also 10800.
  - The comments now cite the 2026-10-31 overruns as the reason.
- **`skills/job-board/SKILL.md`:** updated the budget table, and the note that says the defaults are longer than the 5400s CI wait.
- **`roles/shepherd/AGENT.md`:** the stated default is now 10800s / 3h.
- **`scripts/jobs/test/build-handler-budget-test.sh`:** the fixer, shepherd and `fix`-alias checks now expect 10800.

**Knock-on effect:** the gauntlet clean stage takes its default from the shepherd budget, so it now gets 3h as well. Gauntlet fix and panel stages already had 10800s.

**Tests:** all of these pass: build-handler-budget, handler-budget, promote-plan-shepherd-budget, post-job-build-budget, deadline-nudge, follow-up-gauntlet-budget, gauntlet, reaper-live-handler-guard and reaper-gauntlet-handoff.

**Follow-ups:** none. The new defaults reach running hosts with their next deploy. Producers that write an explicit `handler-timeout:` line read the same setting, so they pick up 10800 too.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-extend-long-running-role-timeouts.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (601635 cached reads)
- Output: 4943 tokens
- Cost: $0.7132830000000001
- Wall-clock: 913s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
