from_host: endolin-garden2-5bcdff64
from: reaper:endolin-garden2-5bcdff64
sent_at: 2026-08-01T11:43:28Z
poison_base: self-heal-fix-garden-mentor-validator-rejects-wellformed-output
poison_signature: deadline-overrun
notice_count: 1
first_seen: 2026-08-01T11:43:28Z
last_seen: 2026-08-01T11:43:28Z
---
POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 DEADLINE-OVERRUN cycles on endolin-garden2-5bcdff64.
Its handler hit its OWN wall-clock budget every cycle (rc=124, elapsed≈GARDEN_HANDLER_TIMEOUT=2400s):
this job EXCEEDS THE HANDLER BUDGET and would be killed identically on every requeue,
so the reaper surfaced it after 1 overrun cycles (not the full 5-cycle poison threshold).
The work is preserved at jobs/plan/self-heal-fix-garden-mentor-validator-rejects-wellformed-output; it stays HELD until a human promotes it
(promote-plan.sh self-heal-fix-garden-mentor-validator-rejects-wellformed-output) or removes it. Triage: split the job, raise GARDEN_HANDLER_TIMEOUT
for this work, or fix what makes it run long.
Original job base: self-heal-fix-garden-mentor-validator-rejects-wellformed-output

--- original job body ---
---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
scripts/jobs/handlers/mentor-claude.sh
Failure signature: `FATAL: mentor provider 'openai' returned malformed semantic output; refusing fallback to avoid conflicting improvement jobs` (mentor-claude.sh:162), then `FATAL: improve handler failed` (mentor.sh:145), exit 1. Recurring, 9x since 2026-07-29 on endolin-garden2-5bcdff64.

`validate_mentor_response` (mentor-claude.sh:87-105) rejects semantically correct provider output, so a good mentor tick FATALs the unit. Verified by extracting the function and probing it: it rejects a lone newline (an empty last message that codex flushes with a trailing `\n`), any no-op prose reply such as `No clear opportunities.` (the outcome roles/mentor/AGENT.md calls normal — only a 0-byte file passes today), a valid JOB block followed by a blank line, two valid blocks separated by a blank line, any preamble sentence or ``` fence, a path decorated as `` `scripts/jobs/a.sh` `` or `- scripts/jobs/a.sh`, and any first-line path ending `.service`, `.timer`, or `.md`.

Fix the validator to accept these while keeping the fail-closed property that matters — never post a partial/ambiguous block, never solicit a second model after semantic output:
1. Skip blank lines when between blocks and at start/end of input; treat an input whose non-blank lines are zero as the legitimate no-op (return 0, post nothing).
2. Treat a reply with no JOB block at all as a no-op, not a fatal — log the first ~200 chars at WARN so a prose refusal is visible without killing the unit. Keep hard rejection for the genuinely dangerous case: a JOB opened and never closed by ENDJOB, or junk interleaved *between* blocks.
3. Strip ``` fences, leading list/quote markers, and surrounding backticks off the first body line before the path check — mirroring the normalization `post_mentor_job` (line 215) already does, which is currently dead code because the validator rejects those shapes first.
4. Widen the first-line path extension set to match what `already_fixed_pending_deploy` (line 183) already greps for: `.sh|.py|.js|.ts|.md|.service|.timer`. Today a mentor job about a unit file or a role brief can never pass validation.
5. Allow leading/trailing whitespace on the `JOB <slug>` line before matching the slug.

Also close the diagnostic gap that let this recur nine times unexplained: before `die`ing on a genuinely malformed reply, log the provider name and the first ~500 bytes of `$raw` (it is currently deleted unseen by the EXIT trap at line 152), or write it to `$GARDEN_STATE/mentor/last-malformed.txt`.

Extend `scripts/jobs/test/mentor-provider-order-test.sh` with subtests for each accepted shape above, and keep existing SUBTEST 4 green (trailing prose *after* a complete block is still rejected without fanning out to another provider). Apply the same review to the parallel `validate_foreman_response` in `scripts/jobs/handlers/foreman-claude.sh` (same die at line 237) and its test, since the two handlers are deliberately kept aligned.


<!-- garden-deadline-overrun: 1 -->
