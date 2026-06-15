---
ts: 2026-06-15T05:42:25Z
kind: result
role: fixer
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
worktree: dispatches/fixer--725c2a/project
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/401
  - https://github.com/endojs/endo/pull/3300
  - https://github.com/endojs/endo-but-for-bots/pull/401#issuecomment-4704904304
---

# Result: fixer 725c2a — PR #401 latest upstream-3300 feedback bundle

Three changes on mirror PR #401 addressing the latest round of feedback on
upstream endo#3300 (turadg, kriskowal, gibson042).

## Heads

- Pre-head:  `2ee513b4b` (origin/chore/shellcheck-ci at dispatch start)
- Post-head: `bde80b9f1` (after combined fix commit, push accepted)
- Commit:    `bde80b9f1` `chore(shellcheck): rename to lint:sh, fold into yarn lint, drop git-blob pipeline (#401)`

## Bundle (one combined commit; mechanically tight)

1. **Rename `package.json` script `shellcheck` to `lint:sh`.** Per
   maintainer's "or better lint:sh" preference over turadg's
   `lint:shellcheck`.

2. **Roll `lint:sh` into `yarn lint`.** Root composition becomes
   `lint:prettier && lint:eslint && lint:sh`. The CI workflow drops the
   dedicated `Run yarn shellcheck` step; the existing
   `Show shellcheck version` step doubles as the install-presence check
   turadg called out. The `.github/workflows/shellcheck.yml` was already
   removed in 2ee513b4b (previous fixer round); no further workflow
   deletion needed.

3. **Drop git-object-store-as-pipeline-intermediary in
   `scripts/shellcheck.sh`.** Replaced the
   `git hash-object` + `git cat-file blob | tr '\n' '\0' | xargs -0`
   shape with a direct `git ls-files -z '*.sh' | xargs -0 -r shellcheck
   -S warning "$@"`. The maintainer explicitly rejected the
   git-object-store-as-intermediary pattern in favor of null-delimited
   list pipes via `xargs -0` anywhere applicable. `xargs -r` preserves
   the empty-input no-op; `-S warning` and `"$@"` pass-through carry
   over. Added a graceful skip when shellcheck is not installed so the
   broader `yarn lint` keeps working for contributors without it.

## Local verification

- `yarn lint:sh`: exit 0 (no findings on tracked .sh).
- `yarn lint` (full composition): exit 0; prettier + eslint + shellcheck
  all pass.
- Pre-push gate (`pre-push-gates.sh --summary`): all probes pass;
  `yarn format` auto-fixed 3 paths and silently re-staged.
- The shellcheck script itself passes `shellcheck -S warning
  scripts/shellcheck.sh`.

## CI

Triggered run 27526435014 on push; `build`, `check-action-pins`, and
`zizmor` already green at result-write time. `lint` and the broader
matrix in flight. Will be confirmed on the PR's review thread by next
orchestrator scan.

## Comment

Top-level summary posted at PR #401 (issuecomment-4704904304) citing
SHA bde80b9f1 and the three bundled changes. Per the dispatch's
discipline note, the upstream endo#3300 PR was NOT touched; the
maintainer ferries that.

Self-improvement: nothing this time.
