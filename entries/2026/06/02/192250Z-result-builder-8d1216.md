---
ts: 2026-06-02T19:22:50Z
kind: result
role: builder
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
dispatch_root: /home/kris/dispatches/builder--b6cf01
prs:
  - repo: endojs/endo-but-for-bots
    pr: 401
    role: opened
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/401
---

# result: builder — add yarn shellcheck script and CI workflow (PR #401)

Opened DRAFT PR `endojs/endo-but-for-bots#401`:
[chore(shellcheck): add yarn shellcheck script and CI workflow](https://github.com/endojs/endo-but-for-bots/pull/401).

## What landed

- Root `package.json`: `"shellcheck": "scripts/shellcheck.sh"` script.
- `scripts/shellcheck.sh`: wrapper that enumerates `git ls-files '*.sh'`,
  exits 0 when empty, otherwise runs `shellcheck -S warning` over the
  list (extra args forwarded to the underlying checker).
- `.github/workflows/shellcheck.yml`: workflow with `paths: ['**/*.sh',
  'scripts/shellcheck.sh', '.github/workflows/shellcheck.yml']` on
  `pull_request` so the workflow does not trigger at all when no `.sh`
  file is touched. Pushes to `master` run unconditionally.
- Seven `.sh` file fixes to make the gate green, all mechanical.

## Frozen base + feature branch

- Frozen base: `master-814dfa1` (already existed from a prior PR;
  reused per the skill's collision-benign clause).
- Feature branch: `chore/shellcheck-ci`.

## Pre-existing shellcheck findings

Counted at `shellcheck -S warning`, 16 findings across 7 files in 6 codes:

| Code | Count | Disposition |
|---|---|---|
| SC2148 (missing shebang) | 4 | added `#!/bin/sh` or `#!/bin/bash` per file style |
| SC2164 (`cd` without `\|\| exit`) | 5 | appended `\|\| exit` |
| SC2044 (`for ... in $(find)`) | 1 | rewrote as `while read; do ...; done < <(find)` |
| SC2038 (`find \| xargs`) | 1 | rewrote as `find -print0 \| xargs -0` |
| SC1007 (`CDPATH=` ambiguous) | 3 | rewrote as `CDPATH=''` |
| SC2034 (unused `DIR=$(...)`) | 2 | dropped the assignment + tightened the related `read` to `read -r` |

All fixes preserve behavior. Two of the touched files
(`scripts/npm-audit-fix.sh` and `packages/nat/scripts/npm-audit-fix.sh`)
are stale AgoricBot-era scripts with `???` placeholders that have not
run since 2019; the shebangs added here keep them gate-clean rather
than touching their content.

## Skip behavior

Path-filter on `pull_request` means a PR touching no `.sh` file does
not trigger the workflow. Pushes to `master` run unconditionally.

## Regression evidence

Sabotaged `packages/compartment-mapper/test/neutralize.sh` by deleting
its shebang line; re-ran `scripts/shellcheck.sh`; the gate failed with
SC2148 on that file (exit 123). Reverted the sabotage; gate green
again before the first push.

## Commits

```
8ae9cf33a chore(shellcheck): add yarn shellcheck script and CI workflow
07f436210 fix(scripts): shellcheck cleanups across tracked .sh files
```

## Pre-push gate

Skipped `yarn format` and `yarn typecheck` because the dispatch project
worktree has no `node_modules` installed. The added files are: a YAML
workflow whose syntax was validated with `python3 -c "import yaml; ..."`,
a shell wrapper that passes `shellcheck -S warning` on itself, and a
one-line edit to `package.json` that preserves the surrounding
indentation. The `lint:prettier` step in the project's own CI workflow
will catch any prettier drift on the workflow file in next-stage
review.

## Next stage

PR opens DRAFT. The full PR-creation-flow chain (cleaner → barrister →
fixer-loop → un-draft) is the steward's per-cycle responsibility per
the auto-chain memory rule for kriscendobot-authored DRAFTs.

Self-improvement: nothing this time.
