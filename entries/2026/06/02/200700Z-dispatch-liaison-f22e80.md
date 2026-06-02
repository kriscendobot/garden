---
ts: 2026-06-02T20:07:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--f22e80
prs:
  - repo: endojs/endo-but-for-bots
    pr: 387
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/387
  - https://github.com/endojs/endo-but-for-bots/pull/387#discussion_r... (inline at 02:39Z, line=null)
---

# dispatch: fixer — rename `.engines` -> `.bench-engines` per kriskowal #387 review

User correction: "Did you miss feedback on https://github.com/endojs/endo-but-for-bots/pull/387"

kriskowal left a file-level inline review comment at 02:39Z on #387:
"Please rename `.engines`. Nothing limits us from using engines for other
workflows." The path is `packages/benchmark/install-engines.sh`, line=null
(file-level). A prior fixer had renamed `.bench-engines` -> `.engines` to
match the script name; kriskowal disagrees because `.engines` is too
generic — other endo workflows might also use engines. Revert to the
specific `.bench-engines`.

Note: the separate "Please use shellcheck as well." issue comment from
19:12Z is being addressed by PR #401 (parallel orchestrator). Do not
address shellcheck here.

## References to rewrite

Three files under `packages/benchmark/`:
- `install-engines.sh` (~20 references to `$HOME/.engines/...`)
- `run-tests.sh` (2 references)
- `README.md` (1 reference)

Apply: substitute every occurrence of `$HOME/.engines/` with
`$HOME/.bench-engines/` (and any other `.engines` -> `.bench-engines`
in those three files). Take care NOT to change the inner literal `engines`
in paths like `.engines/engines/xs/xst` -> result should be
`.bench-engines/engines/xs/xst` (only the leading `.engines` directory
name changes, not the internal `engines` segment).

`sed -i 's#\.engines#\.bench-engines#g' file` is correct: it matches
literal `.engines` only at the dot-prefix dir name, since `/engines/`
doesn't match `\.engines`.

Verify with `grep -n '\.engines' packages/benchmark/install-engines.sh
packages/benchmark/run-tests.sh packages/benchmark/README.md` after the
sed — should return zero matches.

Run `sh -n packages/benchmark/install-engines.sh` to confirm POSIX-sh
syntactic validity (exit 0).

## Commit

```
fix(benchmark): rename .engines -> .bench-engines per kriskowal #387

Per kriskowal review on #387: `.engines` is too generic, since other endo
workflows might want their own engines dir. Specialize to `.bench-engines`.
```

Push regular append (no force):
`git push origin HEAD:fix-benchmark-wget-engines-master`.

## Per-action authorizations

- Edit `packages/benchmark/install-engines.sh`, `run-tests.sh`,
  `README.md`. Authorized.
- `grep` verification and `sh -n` syntax check. Authorized.
- Regular append push. Authorized.
- No PR comments.

## Not authorized

- Editing other files.
- Force-push, retcon, un-draft, merge.
- Posting PR comments.
- Adding shellcheck (#401 handles that).

## Dispatch protocol

Read:
1. garden/roles/COMMON.md
2. garden/roles/fixer/AGENT.md
3. Skills referenced just-in-time.

Project worktree on `fix-benchmark-wget-engines-master` (head dda872eb0).

Report: result journal entry with new head SHA, the three changed files
+ line counts, grep-verification result, and `sh -n` exit code.
