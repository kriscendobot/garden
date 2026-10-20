Weaver jobs now get a 7200s handler wall by default instead of the generic 2400s one. The default is configurable through `GARDEN_WEAVER_HANDLER_TIMEOUT`. The handler-budget test passes (35/35), and the change is pushed to `main2` as `3bab9998b76`.

**Changes**
- **`scripts/jobs/common.sh`:** added a `weaver` arm to `role_default_handler_timeout`, the resolver every budget read goes through. The gardener (which enforces the timeout), the reaper (which decides when a claim is stale) and `deadline-nudge.sh` all read the budget through it, so they now agree on 7200s for weaves. That 7200s is a default: an explicit `handler-timeout:` header still overrides it, and the claim-TTL clamp still applies.
- **`scripts/jobs/test/build-handler-budget-test.sh`:** three new checks:
  - a weaver job resolves to 7200s;
  - setting `GARDEN_WEAVER_HANDLER_TIMEOUT` changes that default;
  - the budget actually applied to a weaver claim is 7200s.
- **`skills/job-board/SKILL.md`:** added the weaver row to the per-role budget table.

**Follow-ups**
- Weaver jobs still get the default token budget, not the large one. `role_default_token_budget` doesn't list `weaver`, and I left it alone because the job only asked for the wall-clock fix. If weaves of big PR stacks start running out of tokens, that's the next thing to add.
- The PR #201 weave that timed out was not re-posted by this job. It needs a new weave job (with a date suffix so it isn't swallowed by the old one) once hosts have deployed this commit.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-weaver-handler-budget.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 18 tokens (410071 cached reads)
- Output: 3263 tokens
- Cost: $0.4946022
- Wall-clock: 66s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
