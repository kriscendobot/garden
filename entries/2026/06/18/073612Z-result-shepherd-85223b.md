---
ts: 2026-06-17T23:45:00Z
kind: result
role: shepherd
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/06/18/073612Z-result-shepherd-85223b.md
---

Shepherd on PR #442 (feat/daemon-cas-extraction), prompted by kriskowal
comment 4739165745 at 07:27:47Z.

## Pre-fix head

`e4d85534c` (retcon head, post-fixer-7bc120)

## Failure classification (cycle 1, head e4d85534c)

| Class | Job | Signature | Disposition |
| --- | --- | --- | --- |
| C | lint | `import/no-unresolved` on `@endo/tar/reader.js` in `daemon/src/tar-checkin.js` | fixed this cycle |
| C | familiar-bundle | esbuild `Could not resolve "@endo/tar/reader.js"` | fixed this cycle |
| C | test (all 4 matrix combos) | daemon startup crash (`@endo/tar/reader.js` not found); also `ERR_PACKAGE_PATH_NOT_EXPORTED` for `@endo/daemon/src/mount.js` in `agent-tools/test/git-flow.test.js` | fixed this cycle |
| C | cover (22.x, 24.x ubuntu) | same daemon-startup crash as test | fixed this cycle |

## Root causes

**Cause A: `@endo/tar` dropped from daemon deps during retcon.**

The commit `a62d3e534` (upstream: `feat(daemon): archive immutable Git
trees`) added `@endo/tar` to `packages/daemon/dependencies` and created
`packages/daemon/src/tar-checkin.js` which imports `@endo/tar/reader.js`.
The retcon (`7bc120` series) collapsed the branch to 3 commits but lost
the dep entry in the process. Result: lint (`import/no-unresolved`),
esbuild bundle (`Could not resolve`), TypeScript (`TS2307`), and daemon
runtime crash all hit the same missing package.

`@endo/tar` has a full workspace entry in `yarn.lock` and a
`"./reader.js": "./reader.js"` export in its `package.json`; the dep was
simply missing from daemon's own `package.json`.

**Cause B: `./src/mount.js` and `./src/daemon-node-powers.js` dropped
from daemon exports during retcon.**

Both export paths were present on the `llm` base branch (added by the
same upstream git-archive feature), and `packages/agent-tools/test/
git-flow.test.js` (also on the `llm` base) imports them directly. The
retcon stripped them from daemon's `exports` map without removing the
consumer, causing `ERR_PACKAGE_PATH_NOT_EXPORTED` errors in the test
matrix and `TS2307` in the type-check pass.

## Fix

Two commits on top of `e4d85534c`:

- `0482d5a18` `fix(daemon): restore @endo/tar dep and src/mount.js + src/daemon-node-powers.js exports`
  Restores `"@endo/tar": "workspace:^"` to daemon `dependencies` and
  `"./src/mount.js"` + `"./src/daemon-node-powers.js"` to daemon `exports`.
  Only `packages/daemon/package.json` changed; no source files touched.

- `3b427cf2c` `chore: Update yarn.lock`
  Adds `"@endo/tar": "workspace:^"` to the daemon section of `yarn.lock`.

## Pre-push-gates result

Probes ran. All probe failures are pre-existing in the broader PR diff
(non-ASCII in `endo-fs/src/`, inline imports across many existing packages
from the `llm` base, divergent SECURITY.md hashes from newly-added packages
on `llm`). The two shepherd commits touch only `packages/daemon/package.json`
and `yarn.lock`; no source files changed, no probe violations introduced.

## Push result

```
HEAD -> feat/daemon-cas-extraction: e4d85534c..3b427cf2c
```

CI running as of checks poll at ~23:44Z: all jobs in `pending` state on
runs 27744151192 / 27744151184 / 27744151202 / 27744151205.

## PR comment

https://github.com/endojs/endo-but-for-bots/pull/442#issuecomment-4739251459

Summary posted to @kriskowal citing both root causes and both fix commits.

## Recommended next stage

next: liaison

CI needs to converge before the next stage can be determined. If CI goes
green, the PR can proceed to conductor (APPROVED state from prior review
cycle needs to be re-requested after the fresh commits). If new failures
emerge, another shepherd or fixer cycle is appropriate. Since the PR is
not yet APPROVED post-retcon, the next stage after CI green is likely
maintainer re-review rather than conductor directly.

Self-improvement: The retcon skill should note that dropping a dep while
collapsing commits is a common hazard; adding a "verify all imports
resolve after retcon" check to the pre-push gates or retcon checklist
would catch this class of error before CI. Log this for a future
gardener dispatch.
