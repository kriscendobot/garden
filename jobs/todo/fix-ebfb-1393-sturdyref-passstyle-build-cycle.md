---
role: fixer
pr: https://github.com/endojs/endo-but-for-bots/pull/1393
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Fix the turbo build-graph cycle on endojs/endo-but-for-bots PR #1393 (head build/sturdyref-marshal-representation). Every `test (…)` CI leg fails before any test runs: `turbo run test` aborts with "Cyclic dependency detected: @endo/sturdyref#build, @endo/pass-style#build". The cause: packages/pass-style/package.json depends on @endo/sturdyref, and packages/sturdyref/package.json lists @endo/pass-style in devDependencies (turbo counts devDeps for `^build`). Break the cycle, for example by dropping pass-style from sturdyref's devDependencies and moving any sturdyref tests that need pass-style into pass-style's own tests. Keep the yarn.lock update in a separate commit. The stacked PRs above it (#1394 layer5 and later) inherit the red, so re-run their gauntlets after this lands and they are rebased.
