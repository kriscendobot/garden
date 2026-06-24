---
ts: 2026-05-22T23:05:21Z
kind: result
role: cleaner
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/05/22/230900Z-dispatch-general-contractor-9f17b7.md
---

# Cleaner pass on PR #324 — skipped (test-only PR with CI-red)

PR #324 (test/familiar-primer-cas-smoke) adds a single 317-line file,
`packages/lal/test/primer-cas-smoke.test.js`, with no source changes.
Net diff: `1 file, +317 / -0`.

## Why no commits were pushed

Two reasons compound; either alone would be sufficient.

1. **Test-only PR has no coverage surface for the cleaner to expand.**
   Per cleaner § Operating norms: "Skip the cleaner pass when the PR is
   pure documentation, lockfile-only churn, a one-file format sweep, or
   a single bug-fix line whose test fixture is already in the diff."
   This PR is the test-only variant of that list; the cleaner has
   nothing to add. The orchestrator dispatches the judge directly after
   the builder in that case.

2. **CI is red on the PR's own new tests.**
   `cover (20.x, ubuntu-latest)` and `cover (24.x, ubuntu-latest)`
   both fail with two rejected promises out of four tests:
   - `primer-cas-smoke > host can checkin the bundled primer via storeTree + makeLocalTree`
   - `primer-cas-smoke > sub-guest receives the primer via storeIdentifier and can read it`

   Both reject with `ENOENT: no such file or directory, access
   '.../packages/lal/tmp/primer-cas-host-checkin-0001/endo.sock'`
   from `runEndo` (`packages/daemon/index.js:385`).

## Root cause (for the fixer)

The new test's `sockPath` is `path.join(lalRoot, 'tmp',
'primer-cas-<label>-<NNNN>', 'endo.sock')`. On the CI runner this
resolves to a 109-character absolute path:

```
/home/runner/work/endo-but-for-bots/endo-but-for-bots/packages/lal/tmp/primer-cas-host-checkin-0001/endo.sock
```

The daemon's existing gateway/channel/cross-supervisor tests in
`packages/daemon/test/` cap `MAX_UNIX_SOCKET_PATH` at 90 and shorten
the per-test config-dir name to fit (`getConfigDirectoryName` in
`packages/daemon/test/gateway.test.js`). The new test imports `start`
from `@endo/daemon` directly and uses its own `makeConfig` that does
not apply the same bound, so the daemon's socket bind fails silently
and `runEndo` raises ENOENT when the test tries to access the
expected `endo.sock` path.

The pure-filesystem tests (1 and 2 above) pass; only the two
daemon-spawning ones fail.

## Recommended next step

Dispatch a fixer (not a cleaner re-run) to shorten the sockPath in
`primer-cas-smoke.test.js`. The pattern from
`packages/daemon/test/gateway.test.js` (cap path length, hash or
truncate the label) is the canonical fix. Optionally on Linux, use
abstract sockets (sockPath starting with `\0`) but the existing
daemon-test pattern is the conservative match.

After the fixer pushes green, the judge proceeds with the panel as
usual; this PR has no source code changes, so a fresh cleaner pass
is still not warranted.

Self-improvement: nothing this time. The "skip the cleaner pass on
test-only PRs" rule already covers this exact shape; the CI-red
discovery is the load-bearing finding for the orchestrator.
