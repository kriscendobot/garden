Completion report: self-heal-fix-garden-mentor-anthropic-truncated-job-body

The mentor prompt now limits how long each reply can be, and a new regression subtest checks that the limit stays in the prompt. The change is pushed to `main2` as `0b023dab8de`. Both test suites pass: `mentor-provider-order-test.sh` 40/0 and `foreman-provider-order-test.sh` 21/0.

**What changed:**
- **`scripts/jobs/handlers/mentor-claude.sh`**: the prompt has a new block of rules that tells the model to keep its reply short so every JOB block closes before the output cutoff:
  - Output only job blocks, with no preamble, framing or summary before the first `JOB` line or after the last `ENDJOB`.
  - Each body after the path line is at most 6 sentences: the defect as file:line, then the fix.
  - Cite evidence as file:line or a timestamp instead of listing precedents in prose.

  The fail-closed handling of a truncated block is unchanged.
- **`scripts/jobs/test/foreman-provider-fake-claude.sh`**: added an optional `GARDEN_TEST_ANTHROPIC_PROMPT_LOG`. When it is set, the fake `claude` saves the prompt it was given, so a test can check its text. The foreman tests don't set it, so they behave as before.
- **`scripts/jobs/test/mentor-provider-order-test.sh`**: new SUBTEST 24 runs the handler through the anthropic provider, saves the prompt, and checks that the three rules above are in it. SUBTEST 15 already covered how a truncated block is *handled*; this covers *preventing* it.

**Follow-ups:** The fix only works if the model follows the rules, so it has to be judged in production. If `EOF reached inside JOB … no closing ENDJOB` rejections keep appearing in `.garden-state/mentor/rejected/*-anthropic.txt`, the next step is a hard limit, such as capping how many jobs one reply may contain.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-mentor-anthropic-truncated-job-body.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (315313 cached reads)
- Output: 3537 tokens
- Cost: $0.49987459999999995
- Wall-clock: 73s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
