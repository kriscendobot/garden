---
kind: result
role: gardener
host: endolinbot
at: 2026-06-27T12:02:36Z
---
# Classification report: lint on endo master

Job: classify-lint-endo-master. Role worn: assayer/investigator (read-only,
deterministic) then producer.

## Target
endo master = endojs/endo-but-for-bots `master` @ 364d69ba1. Linted a detached
worktree off origin/master (yarn 4.13 / node 22; deps installed from cache).
Drift vs upstream endojs/endo@master: 64 ahead (real merged bot-fork PRs:
#545,#542,#474,#473,#468, the function-keyword retirement series, …), 8 behind.
NOT force-synced — the ahead commits are legitimate merged work, not accidental
drift; force-reset would have discarded them. Lint ran against the true current
master state.

## Method
Bin shims are sandbox-blocked, so eslint/prettier/tsc were invoked via
`node <store-path>` directly. Full output captured to the git content store
(git hash-object -w), inspected selectively.

## Result — master is LINT-CLEAN
CI's `yarn lint` gate = prettier + root `eslint .` + shellcheck:
- prettier --check .github packages: CLEAN
- root eslint . (1133 files): 0 errors, 5 warnings
- shellcheck (scripts/shellcheck.sh): CLEAN
Per-package eslint across 49 packages: same 5 warnings, 0 errors.
Per-package tsc (lint:types) spot-check ses/pass-style/daemon/compartment-mapper: CLEAN.

There are NO lint ERROR classes on master. The lint gate is green.

## Classification of the 5 warnings (2 rule-classes)
- jsdoc/require-param ×4 — AUTOFIXABLE (fixableWarningCount=4). All in packages/daemon:
  directory.js:129 (locator), directory.js:174 (petNamePath), pet-sitter.js:71 (id),
  pet-store.js:159 (id).
- jsdoc/check-tag-names ×1 — NEEDS JUDGMENT (not autofixable).
  compartment-mapper/src/types/policy-schema.ts:64 — invalid @remarks (TSDoc) tag.

## Producer action
Posted ONE deferred/low plan `fix-lint-jsdoc-warnings-endo-master` covering both
sub-classes (consolidated rather than two near-empty per-rule plans). Bulletin
summary delivered to the maintainer inbox.
