Implemented commit `3369658f2` and opened draft PR https://github.com/endojs/endo-but-for-bots/pull/1063.

Changes:
- Added runtime-conformance probes and captured intrinsic buffer getters to `ses` and `@endo/harden`.
- Added synthetic Node 22 rejection for TypedArrays over resizable/growable buffers while preserving conforming native behavior.
- Added matching runtime-gated regression tests and patch changesets.
- Posted verification summary: https://github.com/endojs/endo-but-for-bots/issues/1062#issuecomment-5427819944

Verification:
- Node 22.23.2 and 24.19.0: `corepack yarn workspace <package> exec ava test/make-hardener.test.js --match='harden *TypedArray*'` passed 3 tests per package.
- `corepack yarn workspace @endo/harden test`: 35 passed.
- `corepack yarn workspace ses exec ava`: 556 passed, 2 known failures, 2 skipped; direct `tsd` passed.
- Both package builds and lints passed. Root `corepack yarn lint` passed with 52 existing warnings.
- `pre-push-gates.sh --no-auto-fix --probes-only --summary --base-ref endo-upstream/master`: all 5 probes passed. Normal auto-fix mode exposed an existing `--fix`/shellcheck incompatibility.
- Full `local-verify.sh` passed format, build, lint, type generation, and docs; unrelated daemon tests failed because the long worktree path caused Unix-socket `listen EINVAL`. A Node 24 touched-package local-verify run passed silently.
- Disabling the compatibility conditions made both new rejection tests fail in both packages; restoring them returned all focused tests to green.

Follow-up: normal gauntlet handoff remains for the draft PR. Sent the liaison a self-improvement note recommending that the tool-shim installer add `tsd`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo1062-typedarray-preventextensions.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1223s

<!-- garden-usage-end -->
