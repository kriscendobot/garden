Rebased PR #943 onto live `llm` (`0c3598ada`), force-pushed head `4597e9cd3`, and retargeted the PR to `llm`. The branch now contains only `@endo/ascii` plus regenerated composite-tsconfig and lockfile entries. The obsolete SHA-256 XS integration was dropped because live `llm` replaced that implementation and removed those test files. PR #888 remains untouched on `llm-bfc91f5`.

Verification:
- `@endo/ascii`: 8 AVA tests passed; TypeScript and ESLint passed.
- `@endo/sha256`: 71 AVA tests passed; TypeScript passed; ESLint reported zero errors and one existing warning.
- Composite-tsconfig check passed.
- Package-uniformity checker and 18 tests passed.
- Package-level SHA-256 `test:xs` no longer exists on live `llm`.
- Immutable install reached the native `better-sqlite3` build but failed because its build executables lacked permission; affected package checks were run directly.
- PR is mergeable, CI has restarted, and the approval remains present.
- Posted summary: https://github.com/endojs/endo-but-for-bots/pull/943#issuecomment-5285016013

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr943-weave-llm.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 508s

<!-- garden-usage-end -->
