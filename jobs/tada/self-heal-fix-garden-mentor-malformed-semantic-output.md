Pushed to main2 as `2d2655f068`. The job is complete.

## Completion report

**Job:** `self-heal-fix-garden-mentor-malformed-semantic-output` — fix the mentor validator FATAL loop and its undiagnosability.

**Context:** A related fix (`a958e8cd14`, ~50 min before I claimed) had already rewritten both aligned validators to a fence/blank-skipping state machine, widened the extension set to `.md|.service|.timer`, added `record_malformed_reply`, extracted `_mentor_norm_line`, and added accepted-shape subtests 6–15. So the *normalization asymmetry* (req 2) and the *extension-set widening* (secondary) were already landed. Two spec gaps remained; I closed them:

**Changes to `scripts/jobs/handlers/mentor-claude.sh`:**
1. **Reason-naming (req 1, the remaining half).** `validate_mentor_response` now sets a `mentor_reject_reason` global — naming the line number, which check failed, and a 120-char excerpt of the offending text — before every fail-closed `return 20` (empty-body, path-check, second-JOB, EOF-unterminated, interleaved-junk). The FATAL `die` and `record_malformed_reply` both interpolate that reason, and the recorded diagnostic now captures **800** bytes (was 500) of `$raw` plus the reason. The two-line-tail undiagnosable failure is fixed.
2. **Shared normalizer (req 2, the remaining half).** `post_mentor_job` now calls `_mentor_norm_line` instead of its duplicated inline sed, so the poster's identity derivation and the validator's accept check can never disagree.

**Changes to `scripts/jobs/test/mentor-provider-order-test.sh`:**
- **SUBTEST 16** — the three decorated variants (`` `path` ``, `- path`, `path `) each post under a distinct slug but collapse onto **one** `mentor:scripts/jobs/zzz-norm.sh` identity via post-job.sh's directive dedup (exactly one job lands), proving the shared normalizer.
- **SUBTEST 17** — asserts the FATAL log names the reject reason (`unterminated block`) and quotes a unique marker excerpt of the rejected output, and that `last-malformed.txt` carries both.

**Verification:** `bash scripts/jobs/test/mentor-provider-order-test.sh` → **26/26 passed, 0 failed**. Fail-closed SUBTEST 4 still passes. `shellcheck`/`bash -n` clean (only pre-existing info-level notes). Pushed to `main2` at `2d2655f068`.

**Follow-ups:** None required for mentor. Note the *sibling* `foreman-claude.sh` shares the same validator shape (touched by the same HEAD commit) but its `foreman_reject_reason` was out of this job's scope — if the maintainer wants the identical reason-naming + shared-normalizer treatment there for symmetry, that's a small separate follow-up.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-mentor-malformed-semantic-output.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 33 tokens (1162465 cached reads)
- Output: 23658 tokens
- Cost: $1.9044785
- Wall-clock: 326s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
