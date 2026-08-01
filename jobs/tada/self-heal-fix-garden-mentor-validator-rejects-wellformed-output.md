Done. Empty inbox, work committed and pushed.

## Completion report

**Problem.** `validate_mentor_response` (mentor-claude.sh) rejected semantically correct provider output, so a good mentor tick FATALed `garden-mentor` (9× since 2026-07-29). It refused: a lone trailing newline (codex's empty flush), any no-op prose refusal, a block followed by a blank line, blank-separated blocks, a preamble sentence or ``` fence, a decorated first-line path (`` `path` `` / `- path`), and any first-line path ending `.service`/`.timer`/`.md`.

**Fix (both aligned handlers).** Rewrote `validate_mentor_response` and the parallel `validate_foreman_response` as blank/fence-skipping state machines that:
- Skip blank lines and bare ``` fences between/around blocks; treat an all-blank input as a legitimate no-op (return 0, post nothing).
- Treat a reply with **no block at all** (prose refusal) as a no-op, WARN-logging the first ~200 chars so it stays visible — instead of a FATAL.
- Still **fail closed** on the genuinely dangerous shapes: a JOB opened but never closed by ENDJOB, or junk interleaved between/trailing a complete block (mentor SUBTEST 4 / foreman SUBTEST 3 stay green — no fan-out to a second model).
- Normalize the first body line (strip decoration/fence, mirroring the previously-dead `post_mentor_job` normalization) before the path check.
- Widen the extension set to `.sh|.py|.js|.ts|.md|.service|.timer` (matching `already_fixed_pending_deploy`).
- Tolerate leading/trailing whitespace on the `JOB`/`MAINTAINER`/`ROLE`/`ENDJOB` lines.

**Diagnostic gap closed.** Before dying on a genuinely malformed reply, both handlers now record the provider name and first 500 bytes of the raw output to `$GARDEN_STATE/{mentor,foreman}/last-malformed.txt` and log at WARN (the raw temp file was previously deleted unseen by the EXIT trap — the reason this recurred nine times unexplained).

**Tests.** Extended `mentor-provider-order-test.sh` (SUBTEST 6–15) and `foreman-provider-order-test.sh` (SUBTEST 6–11) with one subtest per accepted shape plus fail-closed + diagnostic-recording checks. Results: mentor 21/21, foreman 20/20. Existing SUBTEST 4 (mentor) / 3 (foreman) — trailing prose rejected without fan-out — remain green.

**Changed files:** `scripts/jobs/handlers/mentor-claude.sh`, `scripts/jobs/handlers/foreman-claude.sh`, `scripts/jobs/test/mentor-provider-order-test.sh`, `scripts/jobs/test/foreman-provider-order-test.sh`. Committed as `a958e8cd14` and pushed to `origin/main2`.

**Follow-ups.** None required. The fix lands on `main2`; it reaches the failing host `endolin-garden2-5bcdff64` on the next deliberate deploy of the root checkout (`already_fixed_pending_deploy` will suppress any re-filed duplicate of this improve job in the meantime).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-mentor-validator-rejects-wellformed-output.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 6 on 2 host(s)
- Input: 71 tokens (3470336 cached reads)
- Output: 48074 tokens
- Cost: $3.992483
- Wall-clock: 711s
- Model(s): claude-opus-4-8 ×6

<!-- garden-usage-end -->
