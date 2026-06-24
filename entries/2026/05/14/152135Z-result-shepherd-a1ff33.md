---
ts: 2026-05-14T15:21:35Z
kind: result
role: shepherd
worktree: dispatches/shepherd--76015f/project
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 243
    role: source
refs:
  - entries/2026/05/14/145400Z-dispatch-steward-76015f.md
  - entries/2026/05/14/102529Z-result-shepherd-2f574f.md
---

# Shepherd: PR #243 CI green after two fixes

Four of the five trigger failures resolved with two atomic commits. The fifth (`test-ocapn-guile-interop`) is an infrastructure flake unrelated to PR content. Final rollup on head `bd979ce23`: **25 SUCCESS + 1 FAILURE** (the flake).

## Per-failure diagnosis

### lint (run 25865271861)

`scripts/check-security-md.sh` step reported `packages/harden-test: missing SECURITY.md` and `packages/hex-test: missing SECURITY.md`. Same base-staleness class the prior shepherd noted in the carry-over of `102529Z-result-shepherd-2f574f` (carry-over 1). The two test-only sink packages were added in `7ded0aaf5` (Cut 4 of #206) and `a74d1f4dd` (Cut 2 of #206) to break workspace devDep cycles, but inherited no SECURITY.md sidecar; the uniformity check (#228) now trips on every PR that branches from `llm` after they landed.

### test (run 25865271891) and viable-release 20.x / 24.x (run 25865271861)

All three jobs failed on the same TypeScript-via-JSDoc error at `packages/daemon/src/bus-xs-daemon-polyfills.js(28,24)`:

```
error TS8024: JSDoc '@param' tag has name 'args', but there is
no parameter with that name.
```

Diagnosis: commit `10e351e22` ("chore: regenerate numeric-separators-style autofix with hex groupLength: 4") accidentally re-engaged `eslint-plugin-jsdoc`'s fixer alongside the numeric-separators rule, rewriting three JSDoc blocks:

- The `makeLogFn` block gained `@param {...any} args`, but `makeLogFn` takes only `prefix` (the inner arrow takes `args`).
- The `searchParams.set` block gained an untyped `@param value` line on top of the existing inline `@param {string} key @param {string} value` (same effective declaration twice, noise rather than an error but still wrong).
- The `searchParams.append` block, same pattern as `set`.

Companion to `66d93de63` ("fix(daemon): revert spurious JSDoc autofix from numeric-separators sweep"), which caught and reverted the same class in `bus-daemon-rust-xs.js` and `host.js` but missed `bus-xs-daemon-polyfills.js`.

### test-ocapn-guile-interop (run 25865271978, also re-run 25867361024 after my push)

`guix substitute: warning: bordeaux.guix.gnu.org: connection failed: Network is unreachable`. Both substitute servers (bordeaux + ci.guix.gnu.org) failed to reach the runner during the `guix shell` step, so no Guile build could proceed and the Guile host never advertised a sturdyref. Pure infrastructure flake; nothing in the PR content can fix this. Not in this shepherd's scope to retry workflows; the next steward cycle may opt to `gh run rerun` once Guix substitutes recover.

## Fixes pushed

```
848128bac  fix(daemon): revert spurious JSDoc autofix in bus-xs-daemon-polyfills.js
bd979ce23  chore(harden-test,hex-test): add SECURITY.md sidecars
```

Three files total (one JS revert; two new SECURITY.md sidecars copied byte-identical from `packages/harden/SECURITY.md`, sha256 `071c74...f41d`). Well within the 5-file budget. Both atomic, one concern per commit.

Branch head pushed to `endojs/endo-but-for-bots` `chore/eslint-numeric-separators-style` as `bd979ce23` (previous head `6b738ccc5`).

## Final CI rollup

On head `bd979ce23`:

```
SUCCESS=25:
  browser-tests, lint (root), lint (docs-only),
  build, test, familiar-bundle,
  test (20.x, ubuntu-latest), test (20.x, macos-15),
  test (22.x, ubuntu-latest), test (22.x, macos-15),
  test (24.x, ubuntu-latest), test (24.x, macos-15),
  sandbox-drivers, test-async-hooks (20, ubuntu-latest),
  cover (20.x, ubuntu-latest), cover (24.x, ubuntu-latest),
  test262 (20.x, ubuntu-latest), test262 (24.x, ubuntu-latest),
  test-hermes (ubuntu-latest), check-action-pins,
  viable-release (20.x, ubuntu-latest),
  viable-release (24.x, ubuntu-latest),
  test-xs (20.x, 5.0.0, ubuntu-latest),
  test-ocapn-python, build-wasm

FAILURE=1:
  test-ocapn-guile-interop (guix substitute network flake;
  not actionable in PR content)
```

All four PR-content failures from the trigger are SUCCESS. CI substantively green; the flake is documented and out of scope.

## Carry-overs for the orchestrator

The base-staleness class noted in the prior result entry's carry-over (1) is reaffirmed: PRs against `llm` keep tripping `check-security-md.sh` because the canonical fix has not yet been landed on the base branch. The cleanest long-term fix is to land the two SECURITY.md sidecars on `llm` directly (and on the design-queue branch they were spun off from) rather than have each open PR carry the fix on its own commit, but that's a structural call for the maintainer or a designated boatman, not for the shepherd.

A new carry-over: the `10e351e22` autofix commit re-engaged the jsdoc fixer in addition to the numeric-separators rule it advertised. The post-hoc revert (`66d93de63`) cleaned two of three affected files but missed `bus-xs-daemon-polyfills.js`; my `848128bac` cleans the third. Future autofix sweeps for narrow rules should either (a) pass `--no-eslintrc` and re-add only the target rule, or (b) sweep + diff-review the resulting commit for off-scope edits before pushing. If a third site is later reported, the same revert pattern applies.

The compartment.js (`packages/ses/src/compartment.js`) JSDoc block also got a `@param {...any} args` insertion in `10e351e22`, but the receiving function (`Compartment(...args)`) does take `args`, so TS treats it as a duplicate-tag warning rather than an error; build is green with it. Out of this shepherd's scope; recording so a future stylist may collapse the doubled `@param` if doing a sweep.

Self-improvement: when a dispatch trigger names a hypothesised failure class ("matches the base-staleness class fixed on PR #135"), the shepherd should still pull every `--log-failed` and confirm the actual error before applying the hypothesised fix. In this dispatch, the trigger hypothesis was correct for `lint` (same SECURITY.md sidecar fix) but wrong for `viable-release`: the actual error was a JSDoc autofix artifact in `bus-xs-daemon-polyfills.js`, not the `removeDirectory` fixture issue from PR #135. Applying only the hypothesised fix would have left three jobs red. Add a short "Verify the trigger hypothesis against the actual logs before fixing" note to the shepherd role's Operating norms.
