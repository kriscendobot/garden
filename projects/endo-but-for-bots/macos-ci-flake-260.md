---
created: 2026-05-19
updated: 2026-05-19
author: investigator
---

# macos-15 CI flake investigation (issue #260): the umbrella is DNS, not tests

> Abstract: Maintainer asked for empirical data — run the `test (20.x,
> macos-15)` job 12 times at fixed master HEAD and tabulate outcomes
> ([#260 issuecomment-4457142808](https://github.com/endojs/endo-but-for-bots/issues/260#issuecomment-4457142808)).
> Ran 12 sibling branches `probe/macos-ci-flake-260-{01..12}` all
> pointing at one SHA (`7db54c3ed`, master plus one workflow-simplification commit;
> base tree identical to `master@0ec70c6dd`). Outcome: **11 success / 1
> failure**. The single failure was not a test flake — it aborted in 24
> seconds at the `Use Node.js 20.x` step with
> `getaddrinfo ENOTFOUND repo.yarnpkg.com` during corepack's
> auto-download of yarn 4.13.0. That is GitHub Actions macOS-runner
> network infrastructure, not application code. The "macos-15 test
> flake" framing from the parent survey is wrong; the umbrella is
> transient DNS to `repo.yarnpkg.com` on macOS runners. Recommended fix
> is the canonical yarn-4-in-CI deflake: vendor
> `.yarn/releases/yarn-4.13.0.cjs` into the repo and set `yarnPath` in
> `.yarnrc.yml` so corepack never needs to download. The empirical
> data on `test (20.x, macos-15)` *itself* is silent — we only learned
> the setup-node + corepack step flakes; the test step never failed
> (and ran cleanly in all 11 runs that reached it). Summary comment
> posted at [#260
> issuecomment-4492483431](https://github.com/endojs/endo-but-for-bots/issues/260#issuecomment-4492483431).
> All 12 probe branches deleted from origin.

## Shape chosen and rationale

Shape (C) from the dispatch — "branch + minimized workflow + 12 sibling branches pointing at one SHA" — adapted slightly: since the workflow's `on:` only fires on `push: [master]` and `pull_request`, and we wanted to avoid 12 noise PRs, we pushed twelve sibling branches each pointing at the **same** commit, with a `ci.yml` edit on that commit that adds `push:` matching `probe/macos-ci-flake-260-*`. The simplified `ci.yml` retained only the `test (20.x, macos-15)` cell, dropped the `concurrency` block (so concurrent runs across siblings would not cancel each other), and otherwise left the test invocation unchanged.

That pattern gave us:

- Twelve independent CI runs against an identical tree.
- One commit SHA across all twelve, so any difference in outcome is environmental.
- No noise PRs.
- All twelve runs are visible in [CI history](https://github.com/endojs/endo-but-for-bots/actions/workflows/ci.yml) for cross-checking.

## The 12-row table

| Branch suffix | Run ID | Conclusion | Job conclusion (test 20.x macos-15) | Duration |
|---|---|---|---|---|
| 01 | [26127029865](https://github.com/endojs/endo-but-for-bots/actions/runs/26127029865) | success | success | 6m12s |
| 02 | [26127029921](https://github.com/endojs/endo-but-for-bots/actions/runs/26127029921) | success | success | 5m47s |
| 03 | [26127031444](https://github.com/endojs/endo-but-for-bots/actions/runs/26127031444) | success | success | 5m39s |
| 04 | [26127033472](https://github.com/endojs/endo-but-for-bots/actions/runs/26127033472) | success | success | 6m18s |
| 05 | [26127036055](https://github.com/endojs/endo-but-for-bots/actions/runs/26127036055) | success | success | 7m02s |
| 06 | [26127037587](https://github.com/endojs/endo-but-for-bots/actions/runs/26127037587) | success | success | 6m25s |
| 07 | [26127040103](https://github.com/endojs/endo-but-for-bots/actions/runs/26127040103) | success | success | 7m30s |
| 08 | [26127042337](https://github.com/endojs/endo-but-for-bots/actions/runs/26127042337) | success | success | 6m46s |
| 09 | [26127044420](https://github.com/endojs/endo-but-for-bots/actions/runs/26127044420) | success | success | 6m50s |
| 10 | [26127046546](https://github.com/endojs/endo-but-for-bots/actions/runs/26127046546) | success | success | 7m29s |
| 11 | [26127049871](https://github.com/endojs/endo-but-for-bots/actions/runs/26127049871) | success | success | 6m10s |
| 12 | [26127052309](https://github.com/endojs/endo-but-for-bots/actions/runs/26127052309) | **failure** | **failure** | 24s |

Pass rate of the `test (20.x, macos-15)` *job-overall* outcome: 11/12 = 0.917. But the failure was pre-test — see next section.

## Failure-signature analysis

The single failing run (12) aborted in 24 seconds during step 4 (`Use Node.js 20.x`) of the job. The 11 successful runs each took 6–7 minutes total; the failed run never reached the `Install dependencies`, `Run yarn build`, or `Run yarn test` steps (all marked `skipped` in the post-mortem job view).

The log signature:

```
Found in cache @ /Users/runner/hostedtoolcache/node/20.20.2/arm64
##[group]Environment details
[warning]! Corepack is about to download https://repo.yarnpkg.com/4.13.0/packages/yarnpkg-cli/bin/yarn.js
Error: Error when performing the request to https://repo.yarnpkg.com/4.13.0/packages/yarnpkg-cli/bin/yarn.js;
  [cause]: TypeError: fetch failed
    [cause]: Error: getaddrinfo ENOTFOUND repo.yarnpkg.com
      errno: -3008, code: 'ENOTFOUND', syscall: 'getaddrinfo', hostname: 'repo.yarnpkg.com'
```

Interpretation: `actions/setup-node@48b55a0` reported a Node toolchain cache hit (good — no Node download required), then triggered corepack's environment-details probe which calls `yarn --version`, which forced corepack to fetch yarn 4.13.0 from `repo.yarnpkg.com`. DNS resolution failed (NXDOMAIN-style failure surfaced via `ENOTFOUND`). This is not a `repo.yarnpkg.com` outage — eleven other concurrent runs at the same SHA against runners from the same pool succeeded. It is a per-runner transient: the affected runner could not resolve `repo.yarnpkg.com` for the ~10 seconds that corepack's request lasted.

This is **not a test flake**. The test code, the test runner, the application code, and the macos-15 image's compatibility with Endo's test surface are all silent in this data point. We only learned that the setup-node + corepack download step flakes at roughly 1/12 (~8 %), which is high enough to matter and entirely explainable by macOS-runner network transients.

## Severity verdict and umbrella

**Severity: footgun.** A reproducible-by-volume transient that intermittently fails CI before any project code runs.

**Umbrella:** transient DNS resolution failure to `repo.yarnpkg.com` from macOS GitHub Actions runners during corepack's `yarn@4.13.0` auto-download. The macOS image's network configuration appears to occasionally fail to resolve external hostnames immediately after job start, or for at least the ~10-second window corepack's fetch occupies.

**What this changes about the parent survey of five PR-side `test (20.x, macos-15)` failures (#260):** unknown without checking each, but at least some of those failures may have shared this signature rather than being test-level flakiness. A useful follow-up would be sampling the failing job logs from the five PRs cited in the parent survey for the same `ENOTFOUND repo.yarnpkg.com` line. If present in N of 5, the parent-survey conclusion of "macos-15 test flake" needs revising to "macos-15 corepack-download flake".

## Concrete fix candidates

1. **Vendor yarn into the repo (canonical fix).** Add `.yarn/releases/yarn-4.13.0.cjs` and set `yarnPath: .yarn/releases/yarn-4.13.0.cjs` in `.yarnrc.yml`. Corepack honors `yarnPath` if present and does not fetch. This is the documented yarn-4-in-CI offline pattern. Eliminates the umbrella entirely.
2. **Retry the setup-node step.** Wrap step 4 (`Use Node.js 20.x`) in `nick-fields/retry@v3` (or equivalent) with `max_attempts: 3, retry_wait_seconds: 10`. Does not fix the root cause; absorbs the ~8 % transient. Belt-and-suspenders on top of (1) or a fast standalone fix if vendoring yarn is undesirable.
3. **Pin a Yarn version on the runner image.** Less attractive (yarn 4.x is what the repo wants, and runner images ship yarn 1.x); listed for completeness.

Recommended: (1), optionally (1) + (2).

## Probe branches

The 13 probe branches (`probe/macos-ci-flake-260-base` + `-{01..12}`) were pushed to origin during the experiment. All 12 numbered branches deleted via `git push origin --delete` at the end of this dispatch; the base was local-only.

## Citations

- Dispatch: [`journal/entries/2026/05/19/213800Z-dispatch-liaison-c0a194.md`](../../entries/2026/05/19/213800Z-dispatch-liaison-c0a194.md)
- Issue: [endojs/endo-but-for-bots#260](https://github.com/endojs/endo-but-for-bots/issues/260)
- Summary comment posted: [#260 issuecomment-4492483431](https://github.com/endojs/endo-but-for-bots/issues/260#issuecomment-4492483431)
- Maintainer ask: [#260 issuecomment-4457142808](https://github.com/endojs/endo-but-for-bots/issues/260#issuecomment-4457142808)
- kumavis pattern: [#260 issuecomment-4456597105](https://github.com/endojs/endo-but-for-bots/issues/260#issuecomment-4456597105)
