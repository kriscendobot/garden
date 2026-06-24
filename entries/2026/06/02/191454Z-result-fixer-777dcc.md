---
ts: 2026-06-02T19:14:54Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: liaison
dispatch_root: /home/kris/dispatches/fixer--b972fd
prs:
  - repo: endojs/endo-but-for-bots
    pr: 387
    role: target
refs:
  - entries/2026/06/02/191000Z-dispatch-liaison-b972fd.md
  - https://github.com/endojs/endo/pull/3294#pullrequestreview-4411367805
  - https://github.com/endojs/endo-but-for-bots/pull/387
---

# result: fixer carried gibson042 shell-script feedback from endo#3294 to mirror #387

All 6 distinct changes from gibson042's 10-comment COMMENTED review on
upstream endojs/endo#3294 applied to `packages/benchmark/install-engines.sh`
on `fix-benchmark-wget-engines-master`.

## Push outcome

- Branch: `endojs/endo-but-for-bots:fix-benchmark-wget-engines-master`.
- Prior head: `c786ba635`.
- New head: `dda872eb0` (regular append; no force).
- Push result: `c786ba635..dda872eb0  HEAD -> fix-benchmark-wget-engines-master` (origin accepted).

## Diff summary (single file: `packages/benchmark/install-engines.sh`)

13 insertions, 8 deletions. Hunk-by-hunk:

1. After the `GITHUB_WORKSPACE` xst-symlink block (~line 11), inserted the
   hoisted `tmp` + `trap` pair (3 lines added).
2. `install_xs`'s XS_VERSION pipeline (~line 27) swapped from
   `curl -fsSL -o /dev/null -w '%{redirect_url}' | sed ...` (3 lines) to
   `curl -fsSI | grep -i '^location:' | tr -d '\r' | sed -n 's#.*/releases/tag/##p'`
   (5 lines). Net +2 lines. The `[ -z "$XS_VERSION" ]` fallback to `8.1.1` is preserved.
3. xst missing-file message changed from `"XS extract missing xst binary"` to
   `'XS download missing file `xst`'` (single-quoted so backticks are literal).
4. After `chmod +x` on xst, added the execution probe
   `"$HOME/.engines/engines/xs/xst" -v || { echo 'XS download file \`xst\` execution failed' >&2; exit 1; }`.
5. `install_v8`'s V8_VERSION extraction swapped from inline `python3 -c
   'import json,sys; print(json.load(sys.stdin)["version"])'` to `jq -r .version`.
6. d8 missing-file message changed analogously to xst's (backticked filename).
7. After `chmod +x` on d8, added the execution probe with `</dev/null`
   redirect since `d8 -v` is interactive without a stdin EOF.
8. v8 launcher heredoc shebang changed from `#!/usr/bin/env bash` to `#!/bin/sh`.
9. In the `else` branch (~line 87-89), removed the now-duplicate
   `tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT` pair (2 lines deleted).

`git diff c786ba635 HEAD` confirms 1 file changed, 13 insertions(+),
8 deletions(-).

## Syntax check

`sh -n packages/benchmark/install-engines.sh` exited with status `0`.
The script is POSIX-sh syntactically valid (which matters since the
launcher heredoc's `#!/bin/sh` and the script's own `#!/bin/sh` are now both POSIX-sh).

## Deviations from the plan

None. The 6 changes landed exactly as specified in the dispatch entry's
per-comment plan, including:

- `-fsSI` on the XS_VERSION curl (headers-only) with the full POSIX pipeline.
- Single-quoted shell strings for the terse missing-file messages so the
  backticks around `xst` and `d8` render as literal in the error output
  (not as command substitution).
- `</dev/null` on the d8 execution probe.
- Removal of the duplicate `tmp` / `trap` definition from the `else` branch.

## What was not done (per the explicit "not authorized" list)

- No edits to files outside `packages/benchmark/install-engines.sh`.
- No force-push or retcon.
- No un-draft, re-draft, or merge.
- No PR comments on either endojs/endo-but-for-bots#387 or endojs/endo#3294.

The maintainer will see the new commit on the mirror PR; carrying the
same fix upstream to endojs/endo#3294 is a separate ferry-back step
(boatman dispatch from the credentialed host), not the fixer's lane.

Self-improvement: nothing this time. The dispatch brief was unusually
explicit (per-comment exact sed/grep/jq forms and the single-quoted
backtick discipline), which made this a straightforward apply-and-verify
pass with no judgment calls that would benefit from a new skill or norm.
