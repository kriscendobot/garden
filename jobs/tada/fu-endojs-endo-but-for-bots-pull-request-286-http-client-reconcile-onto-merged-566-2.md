No reply. The job is a watch/report task and is complete — CI has fully settled and the outcome is unambiguous.

## Completion report

**Job:** Watch/shepherd CI on endojs/endo-but-for-bots PR #286 (endo http mk Phase 1) and confirm the full-daemon e2e suite passes; surface any failures.

**Result: the full-daemon e2e suite does NOT pass.** One deterministic, Node-version-specific test failure.

**Final CI status (run 29053310697/29053310473, head `feat/cli-http-client-mk-phase-1`):**
- All non-matrix checks green: lint, build, browser-tests, familiar-bundle, sandbox-drivers, coverage (22.x/24.x), test262 (22.x/24.x), test-hermes, test-xs, test-async-hooks, viable-release, check-action-pins, zizmor, build-wasm, ws-relay health.
- Full-daemon `test` matrix:
  - `test (22.x, ubuntu-latest)` — **FAIL**
  - `test (22.x, macos-15)` — **FAIL**
  - `test (24.x, ubuntu-latest)` — pass
  - `test (24.x, macos-15)` — pass

**The failure** (identical on both 22.x jobs, so not flake/infra):
- Test: `@endo/daemon › http-client › client request to allowed origin succeeds` (the one happy-path test of the PR's new http-client feature; the negative/validation tests all pass).
- `TypeError: Cannot assign to read only property 'Symbol(headers map sorted)' of object '[object Object]'` at `decodeErrorCommon (packages/marshal/src/marshal.js:316)` → `decodeErrorFromCapData` → `fromCapData` → `CTP_RETURN` (captp) → `daemon/src/connection.js:192`.
- Cause: the daemon-side http request returns/propagates a whatwg `Headers` object across CapTP. Node 22's undici caches a lazy internal `Symbol(headers map sorted)` slot on `Headers`; hardening/lockdown freezes it, so client-side error reconstruction can't reassign it and throws. Node 24's undici changed that internal, so 24.x passes. It's inside this PR's new feature — a genuine bug gated on the Node 22 runtime.

**Actions taken:**
- Watched all checks through to full settlement (no reruns issued — the failure is deterministic, so a rerun would not change it).
- Surfaced the finding to the maintainer via `message-user` with the failing test, the matrix breakdown, the root-cause analysis, and a recommended fix direction (avoid marshalling/hardening the live `Headers` across CapTP — pass plain header entries, or normalize headers before the boundary).

**Follow-up:** dispatch a fixer for PR #286 to make `http-client › client request to allowed origin succeeds` pass on Node 22.x. No code changes were made here (watch/report scope). No garden-repo changes; nothing to commit/push.
