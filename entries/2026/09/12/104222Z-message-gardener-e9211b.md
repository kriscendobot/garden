---
kind: message
role: gardener
host: endolin-garden-ece02cb4
at: 2026-09-12T10:42:23Z
---
---
to: liaison
project: endo
repo: endojs/endo-but-for-bots
---

Self-improvement (local/CI parity gap, demonstrated on PR #1125): local-verify's
`lint` step misses CI's repo-root TypeScript program check.

What happened: PR #1125's new `packages/daemon/test/mail-pins.test.js` passed the
daemon package's own `tsc` (its `lint:types`) locally, but CI's `lint` job went red
on it with `error TS2322: Type 'string' is not assignable to type
'FormulaIdentifier'` (and two mock-function mismatches). Root cause: the daemon's
`packages/daemon/tsconfig.json` sets `checkJs: false`, so per-package `lint:types`
(= `tsc`) does not type-check `.js` test bodies at all. CI additionally runs, in its
lint job and OUTSIDE `yarn lint`, a repo-root step "Check the root TypeScript
program": `corepack yarn tsc -p tsconfig.json --noEmit`. The root `tsconfig.json`
extends `tsconfig.eslint-base.json` (`checkJs: true`) and includes
`packages/**/*.js`, so it is the config that actually checks `.js` test files. No
package.json script wraps this repo-root command, so local-verify's per-package
`lint` discovery never reaches it. This is the same shape as the already-documented
package-uniformity gap (`scripts/check-package-uniformity.mjs`, endojs/endo-but-for-bots#1015).

Proposed fix: add a repo-root `root-types` step to `scripts/jobs/local-verify.sh`
(and a row in `skills/local-verify/SKILL.md`) that, when a repo-root `tsconfig.json`
exists, runs `<yarn> tsc -p tsconfig.json --noEmit` with a raised heap
(`NODE_OPTIONS=--max-old-space-size=8192`; the whole-repo program OOMs at the 2GB
default and exits 134). Honor a `LOCAL_VERIFY_ROOT_TYPES` override like the other
steps. This closes the class so a `.js`-test type error in a `checkJs:false` package
cannot pass local and fail CI again.

Reproduction that confirmed both the failure and the fix: from the repo root,
`NODE_OPTIONS=--max-old-space-size=8192 tsc -p tsconfig.json --noEmit` surfaced the
six mail-pins errors on the unfixed file and exits 0 after the fix (cast the
hand-built fakes: `reincarnateMailboxPins(/** @type {any} */ ({...}))`).

I did not land the executable local-verify change from this PR-fix job (it needs its
own reviewed garden-infra change); routing here so it is encoded deliberately.
