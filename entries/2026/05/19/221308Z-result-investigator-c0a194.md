---
ts: 2026-05-19T22:13:08Z
kind: result
role: investigator
project: endo-but-for-bots
from: liaison
refs:
  - https://github.com/endojs/endo-but-for-bots/issues/260
  - https://github.com/endojs/endo-but-for-bots/issues/260#issuecomment-4492483431
prs:
  - repo: endojs/endo-but-for-bots
    issue: 260
    role: source
---

# Result: investigator c0a194 — macos-15 CI "flake" is corepack DNS, not tests

Dispatch: [`213800Z-dispatch-liaison-c0a194.md`](213800Z-dispatch-liaison-c0a194.md). Topic file (canonical): [`journal/projects/endo-but-for-bots/macos-ci-flake-260.md`](../../../../projects/endo-but-for-bots/macos-ci-flake-260.md).

**Shape chosen.** Adapted (C) from the dispatch: 12 sibling branches `probe/macos-ci-flake-260-{01..12}` all pointing at `7db54c3ed` (one workflow-simplification commit on top of `master@0ec70c6dd`, base tree identical to master). The simplified `ci.yml` retained only `test (20.x, macos-15)`, added `push:` matching the probe prefix, and dropped `concurrency` so siblings would not cancel each other. No PRs opened.

**12-row table** (job conclusion = `test (20.x, macos-15)`):

| # | Run ID | Conclusion |
|---|---|---|
| 01 | 26127029865 | success |
| 02 | 26127029921 | success |
| 03 | 26127031444 | success |
| 04 | 26127033472 | success |
| 05 | 26127036055 | success |
| 06 | 26127037587 | success |
| 07 | 26127040103 | success |
| 08 | 26127042337 | success |
| 09 | 26127044420 | success |
| 10 | 26127046546 | success |
| 11 | 26127049871 | success |
| 12 | **26127052309** | **failure** |

Pass rate: 11/12 = 91.7 %.

**Failure signature.** Run 12 aborted in 24 s at step 4 (`Use Node.js 20.x`); the 11 successes ran 5m39s–7m30s. The failing run never reached install/build/test (those steps marked `skipped`). Log shows: Node toolchain cache hit, then corepack triggered the auto-download of yarn 4.13.0 from `repo.yarnpkg.com` and DNS resolution failed:

```
[cause]: Error: getaddrinfo ENOTFOUND repo.yarnpkg.com
  errno: -3008, code: 'ENOTFOUND', syscall: 'getaddrinfo'
```

The 11 concurrent successes prove this is not an upstream `repo.yarnpkg.com` outage; it is a per-macOS-runner network transient lasting roughly the 10 seconds corepack's fetch occupied.

**Severity: footgun.** The umbrella is **not** "macos-15 test flake" but "transient DNS to `repo.yarnpkg.com` from macOS GitHub runners during corepack auto-download of yarn 4.13.0". The empirical data on the test step itself is silent — every run that reached the test step passed it. The parent-survey "macos-15 flake" framing of #260 may have miscategorized some of its five exemplars; sampling those failed job logs for the same `ENOTFOUND` line would tell.

**Fix candidates:**

1. **Vendor yarn into the repo** — add `.yarn/releases/yarn-4.13.0.cjs` and set `yarnPath` in `.yarnrc.yml`. Corepack honors `yarnPath` and skips the network. Canonical yarn-4-in-CI offline pattern; eliminates the umbrella.
2. **Retry the setup-node step** — `nick-fields/retry@v3` around step 4 with `max_attempts: 3`. Cheap belt-and-suspenders; doesn't fix root cause but absorbs the ~8 % transient.
3. Pin runner-image yarn version — less attractive; runner images ship yarn 1.x.

Recommended: (1), optionally (1)+(2).

**Comment URL.** Summary tabulation + severity + fix candidates posted at [endojs/endo-but-for-bots#260 issuecomment-4492483431](https://github.com/endojs/endo-but-for-bots/issues/260#issuecomment-4492483431).

**Cleanup.** All 12 probe branches deleted from `origin/endojs/endo-but-for-bots` via `git push origin --delete probe/macos-ci-flake-260-{01..12}`. Base branch was local-only.

**Self-improvement:** When characterizing a "test flake", always extract the failure signature *before* assuming the test step itself failed — pre-step infrastructure failures (network, toolchain, runner setup) are common and the empirically-correct umbrella sits there, not under the test framework.
