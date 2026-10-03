---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Fix the XS bundle break on endojs/endo-but-for-bots#1419 and resume its gauntlet

Maintainer standing instruction (kriskowal, 2026-10-03): "Fix the red-CI gauntlets."

https://github.com/endojs/endo-but-for-bots/pull/1419 (confined application makers
phase 2, stacked on https://github.com/endojs/endo-but-for-bots/pull/1417 via frozen base
`llm-confined-application-makers-p1-0bdf895`) halted its gauntlet
(`build-confined-application-makers-p2-makefromtree-20261003-gauntlet`) at the clean stage:
`build-xsnap` fails at "Generate XS bootstraps" (`yarn bundle:xs`) with
`Cannot find external module "@endo/compartment-mapper/archive-lite.js"` (and capture-lite,
node-modules, archive-parsers, import-parsers) while loading `./src/bus-manager-rust-xs.js`.

Cause (per the clean-stage report): the PR added a static
`import { captureNodeModulesArchive } from './capture-node-modules.js'` to
`packages/daemon/src/manager.js`; that module imports `@endo/compartment-mapper/*`, which
`packages/daemon/scripts/bundle-bus-daemon-rust-xs.mjs` excludes (`EXCLUDED_PACKAGES`).

Fix: defer it with `await import('./capture-node-modules.js')` inside makeFromTree's
node_modules branch (as worker.js defers its compartment-mapper imports). Verify locally
with `yarn workspace @endo/thixotrope run build:xs-bundles && yarn bundle:xs` plus the
daemon tests touched by the PR, push with safe-push-pr-head.sh, drive CI green, then
resume the halted gauntlet at its clean stage (`scripts/jobs/gauntlet.sh --resume-from-stage`),
not from round 1. Report the outcome.
