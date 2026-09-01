---
role: shepherd
handler-timeout: 7200
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Shepherd CI rerun for PR 1107

Monitor attempt 2 of https://github.com/endojs/endo-but-for-bots/actions/runs/33505548479, rerun in response to https://github.com/endojs/endo-but-for-bots/pull/1107#issuecomment-5494282148.

The only original failure was `test (22.x, ubuntu-latest)`, after all 1217 tests completed, with an unhandled `Error: Termination requested` during teardown. Attempt 2 job https://github.com/endojs/endo-but-for-bots/actions/runs/33505548479/job/99865557084 is in progress.

If attempt 2 passes, post a concise top-level PR comment confirming the rerun and linking the successful job. If it fails, inspect the new logs and shepherd the PR according to the evidence. Do not alter the PR merely to retrigger CI. Use the isolated project worktree keyed by this successor job if a code change proves necessary.
