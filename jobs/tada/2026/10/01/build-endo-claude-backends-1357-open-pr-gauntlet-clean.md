---
orchestration-failed: true
---
orchestration-failed: true

# Clean stage for endojs/endo-but-for-bots#1412: CI still red on one unrelated check

`ci-wait-merge` returned rc 3 (red) at head `be116c5fdd6`, so this stage failed. The red check is outside this PR: 32 of 33 checks pass, including both macOS failures that came from the PR's own tests, which I fixed.

## The failing check
- **Job:** `test (24.x, macos-15)`
- **Test:** `@endo/daemon` › `daemon-teardown › an orphaned daemon shuts itself down instead of lingering daemon recorded its pid before its launcher exited`
- **Why it looks like a flake:**
  - The PR doesn't touch `packages/daemon`.
  - The same test passed on `test (22.x, macos-15)` in this run.
  - The 24.x macOS daemon tests also passed on the earlier head `d19665933`.
- **Rerun failed:** I tried to re-run just that job. GitHub refused: `run 36935198962 cannot be rerun; Resource not accessible by personal access token`. This host's bot token can't re-run Actions jobs.
- **Next step:** someone with Actions write access needs to re-run run 36935198962 (failed jobs only). If it goes green, the clean stage is effectively done.

## What I fixed
When this stage started, both `test (*, macos-15)` jobs failed in `@endo/claude` › `cli-backend-process`. I pushed two commits to `build/endo-claude-backends-1357` with `safe-push-pr-head.sh` (d19665933 → 77f3576e6 → be116c5fd):

1. **`fix(claude): spawn with a mutable env copy; canonicalize the test scratch path`**
   - **Real defect in `src/cli-backend.js`:** the backend passed its hardened (frozen) environment to `spawn`. Node writes `NODE_V8_COVERAGE` into `options.env` during coverage runs, so every CLI turn failed with "object is not extensible". The coverage pass surfaced this. It now passes a fresh copy, `env: { ...env }`.
   - **macOS `/tmp` symlink:** on macOS `/tmp` resolves to `/private/tmp`. The child reported its resolved working directory, but `HOME` kept the unresolved `/tmp/...` path, so the comparison failed. The test now resolves the parent scratch directory with `realpath`.
   - The test also ignores `NODE_V8_COVERAGE` when checking the exact list of environment keys.
2. **`test(claude): ignore macOS's __CF_USER_TEXT_ENCODING in the process env check`:** macOS adds this variable to every process, which broke the same exact-keys check.

After these commits, `test (22.x, macos-15)` passes in CI.

## Coverage pass
- **Local test runs:** `@endo/claude` passes 119/119 with plain `ava` and under `c8`. `@endo/inference` passes 41/41 under `c8`.
- **Line coverage:** `@endo/claude` is at 96.2% (100% of functions), and `@endo/inference` is at 99.8%.
- **No dead code found:** coverage shows no unreachable functions in the touched packages.
- **Lint, format and types:** eslint, prettier and `tsc` pass on the changed files.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-claude-backends-1357-open-pr-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 94 tokens (3708565 cached reads)
- Output: 17783 tokens
- Cost: $1.812501
- Wall-clock: 6736s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
