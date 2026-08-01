---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/handlers/mentor-claude.sh

Failure signature: `FATAL: mentor provider 'openai' returned malformed semantic output; refusing fallback to avoid conflicting improvement jobs`, followed by `mentor.sh` leaving markers so the identical digest retries and re-fails every tick (deterministic loop, not a blip).

Two scoped changes:

1. **Capture the evidence before dying.** `mentor-claude.sh:162` dies with no sample of the offending output, making this failure undiagnosable — the whole captured service tail is two lines. Before `die`, log a bounded excerpt of `$raw` (e.g. `head -c 800`, and the line number/reason the validator rejected). Have `validate_mentor_response` return a reason (which block, which line, which check failed) rather than a bare `return 20`, so the FATAL names the actual defect. Do not log the full untruncated blob.

2. **Fix the validator/poster normalization asymmetry.** `validate_mentor_response` (line 96) matches the first body line raw against `^[A-Za-z0-9_./-]+\.(sh|py|js|ts)$`, while `post_mentor_job` (line 215) already strips leading list/quote/backtick markers and trailing whitespace from that same line. Verified by direct test: `` `scripts/jobs/foo.sh` ``, `- scripts/jobs/foo.sh`, and `scripts/jobs/foo.sh ` are all rejected by the validator but would be handled fine by the poster. The handler's own prompt shows the path in backticks (line 57), so it actively invites the form it then rejects. Extract the normalization in `post_mentor_job` into one shared helper and use it in **both** places, so a decorated or trailing-whitespace path is normalized and accepted instead of nuking the tick. Keep the fail-closed behavior for genuinely malformed output (trailing prose after the last `ENDJOB`, an unterminated block, a first line that is not a path at all) — that is deliberate and `mentor-provider-order-test.sh` SUBTEST 4 must keep passing.

Add subtests to `scripts/jobs/test/mentor-provider-order-test.sh` covering the three decorated-path variants above (each should post the job, with the identity resolving to the same normalized `mentor:scripts/jobs/foo.sh`) and one asserting the FATAL log now contains an excerpt of the rejected output.

Secondary, worth noting while in the file: the validator restricts the path to `.sh|.py|.js|.ts`, so a mentor finding implicating a `.service`/`.timer` unit or a `.md` brief has no legal way to express itself — while `already_fixed_pending_deploy` (line 183) already scans for `md|service|timer` paths. Either widen the validator to match or make the prompt explicit that the first line must be an executable script; do not leave the two halves disagreeing.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-01T19:52:18Z
