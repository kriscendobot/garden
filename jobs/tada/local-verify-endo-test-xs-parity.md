Implemented and pushed commit `4c1c39ee15` to `main2`.

- Added additive workspace `test:xs` coverage with silent-on-success behavior.
- Added exact Moddable-release discovery and locked `xst` provisioning/cache; host PATH `xst` is never an implicit fallback.
- Baked Moddable 5.0.0 into the container image.
- Expanded tests and documentation.
- Verified `local-verify-test.sh`: 64 passed, 0 failed; `bash -n`, ShellCheck, and `git diff --check` passed.
- Verified provisioned Moddable 5.0.0 reports XS 15.5.1.
- Docker build was not run because Docker is unavailable.
- A real Endo run reached `test:xs` with the pinned runtime, then exposed missing Cargo and an uninitialized CI-required submodule. Posted successor job `local-verify-endo-test-xs-cargo-parity`.

Self-improvement: updated `skills/local-verify/SKILL.md` and `field-notes.md` with the CI-only suite and runtime-parity lesson.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/local-verify-endo-test-xs-parity.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 791s

<!-- garden-usage-end -->
