The change is on `origin/main2` and all tests pass.

## Completion report

**Job:** Canonicalize `handler-budget-role: fix` → `fixer` before budget resolution in `scripts/jobs/common.sh`, with regression coverage.

**What I did**
- Added a `canonical_budget_role()` helper in `scripts/jobs/common.sh` (beside `role_default_handler_timeout`) that maps the stage-name alias `fix` to the canonical `fixer` and passes every other value (including empty) through untouched.
- Applied it at both `handler-budget-role` read sites — `job_handler_budget_base` and `applied_token_budget` — so the alias is normalized *before* budget resolution. Previously `handler-budget-role: fix` matched no arm of `role_default_handler_timeout`/`role_default_token_budget` and silently fell through to the 2400s fleet default, guaranteeing a deadline overrun for work that needs the 7200s fixer budget.
- Added a "handler-budget-role ALIAS CANONICALIZATION" section to `scripts/jobs/test/build-handler-budget-test.sh`: unit-level checks of `canonical_budget_role` (fix→fixer, fixer unchanged, unrelated role/empty pass-through), an end-to-end check that `handler-budget-role: fix` resolves to the 7200s handler base, and a check that its token budget equals what a real `role: fixer` job gets.

**Verification**
- `build-handler-budget-test.sh`: 32 passed, 0 failed.
- No regressions in `promote-plan-shepherd-budget-test.sh` (9/0) or `gauntlet-test.sh` (39/0).
- `bash -n` and shellcheck clean (only pre-existing style/source-resolution info notes).
- Confirmed the change is present on `origin/main2` (commit `421473a933`).

**Note / follow-up**
- I hit a harness inconsistency where the Edit tool's writes did not reach the filesystem that `bash`/`git` see (git showed a clean tree after apparently-successful edits). I re-applied both edits directly via a bash/python script, which committed correctly. No action needed for this job, but worth flagging as a possible environment issue for other gardeners on this host.
- A single alias (`fix`) is canonicalized; the helper is structured so additional aliases can be added in one place if others surface.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-normalize-fix-handler-budget-role.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 74 tokens (2077205 cached reads)
- Output: 15015 tokens
- Cost: $2.0074734999999997
- Wall-clock: 249s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
