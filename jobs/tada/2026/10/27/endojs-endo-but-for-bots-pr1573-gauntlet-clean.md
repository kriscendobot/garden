I didn't get CI to a final result, so this stage is still pending: CI hadn't finished by the deadline (`ci-wait-merge` rc=4, 5 of 35 checks still running at head `9d7ad83c05`). The driver should re-post the stage. Three checks have already finished red, but all three fail for reasons outside this PR's diff:
- **`build`**: `tred` (graphviz) is missing from the runner. `scripts/check-dependency-cycles.sh` exits 127 at `graph.sh: line 32`.
- **`sandbox-drivers`** and **`cover`**: the same two bwrap tests fail. `ulimit -u` isn't supported by `/bin/sh` ("Illegal option -u"), and the "parent death" test runs no assertions. This is a known failure that predates the PR.

Unless those runner/bwrap problems are fixed or excused, this PR won't reach green.

**Coverage pass** (on the touched packages, `hosted-agent` and `daemon`):
- **New tests, pushed as `7fc19bbd36`** through `safe-push-pr-head.sh` (fast-forward):
  - `packages/hosted-agent/test/inference-provider-registry.test.js` gained two tests. They cover:
    - granting the same request twice returns the existing grant;
    - a conflicting re-grant is refused (`grant-conflict`), and re-granting after revocation is refused (`agent-deleted`);
    - the extra fields `attestation()` adds;
    - `requestByteStream`;
    - the owner, agent and model validation errors.
  - `packages/daemon/test/secret-manager.test.js` gained one test for `provideBase64`'s refusals: `INVALID_STABLE_ID`, `KEY_NEEDED`, the existing-record `IDEMPOTENCY_CONFLICT` and `REVOKED`.
- **Checks:** the tests pass locally (16 in hosted-agent, 24 in secret-manager), eslint and prettier are clean, and the repo-root `tsc` reports no errors in the touched test files.
- **Dead code:** none. The uncovered `makeEndoSecretParticipant` is used by the registry module and the daemon restart test.
- **Peer pushes:** another bot worker pushed two fix commits on top of mine while I waited (`1dcf902a2e`, `9d7ad83c05`). My commit is still in the PR.

**Possible bug in the PR, not fixed (outside this stage's scope):** in `packages/daemon/src/secret-manager.js` `provideBase64`, a call with a *new* `secretId` and a `grantId` that already belongs to another secret is accepted. It quietly re-points that grant at the new secret, so the pet name already bound to the grant resolves to different bytes. The existing-record branch refuses the same input. I posted a repro on the PR for the review panel and fix loop: https://github.com/endojs/endo-but-for-bots/pull/1573#issuecomment-6434151114

<!-- gauntlet-stage-result: clean=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1573-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 84 tokens (3179241 cached reads)
- Output: 17137 tokens
- Cost: $1.6622602
- Wall-clock: 4269s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
