orchestration-failed: true

Blocking defect in `a1dd898451`: the handler invokes `kimi --auto -p ...`. Official Kimi Code 0.29.0 rejects that combination: `error: Cannot combine --prompt with --auto.` The documented `-p` mode already uses automatic permissions. Remove `--auto` from both fresh and resume invocations and add a regression assertion.

Validated: explicit-model-only routing, isolated per-job KIMI_CODE_HOME/worktree, credential non-disclosure, completion sentinel/report capture, resume/requeue, bounded process cleanup, reputation metadata, and zero-default mystic eligibility. Passed: `kimi-provider-test.sh` (18), `worker-spine-kinds-test.sh` (101), `model-routing-test.sh` (29), completion-signal (17), orphan-reap (15), scaler (12).

Also observed `gardener-worktree-test.sh` is currently unusable because its fixture lacks `scripts/jobs/quota-panel.sh`; it failed before exercising its assertions.

No deploy or live canary is authorized until the CLI flag conflict is fixed and focused tests rerun.
