---
ts: 2026-06-02T02:42:33Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--d7299b
prs:
  - repo: endojs/endo-but-for-bots
    pr: 387
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/387
  - https://github.com/endojs/endo-but-for-bots/pull/387#discussion_r3338318670
---

# dispatch: fixer — #387 rename `.bench-engines` → `.engines` per maintainer feedback

kriskowal CHANGES_REQUESTED on #387 (DRAFT) at 2026-06-02T02:39:33Z with one
inline comment on `packages/benchmark/install-engines.sh` line 42:

> Please rename `.engines`. Nothing limits us from using engines for other
> workflows.

Per `feedback_builder_pr_auto_run_gauntlet.md` (kriscendobot DRAFT auto-pickup)
and the loop's standing rule on addressing maintainer review feedback, the
steward dispatches a fixer.

## Task

Rename the home-directory cache path `$HOME/.bench-engines` to `$HOME/.engines`
across all references. The `.bench-engines` name scopes the cache to the
benchmark package; kriskowal's directive is to make it general so other
workflows can reuse the engines installation.

Affected files (4):
- `packages/benchmark/install-engines.sh` (16 occurrences)
- `packages/benchmark/run-tests.sh` (2 occurrences)
- `packages/benchmark/README.md` (check and update prose if any)
- `packages/hex/test/run-benches.sh` (check and update)

Procedure:
1. `git grep -n "bench-engines"` to enumerate all references.
2. Replace every `.bench-engines` with `.engines` (literal string).
   Leave the inner `engines` subdirectory (e.g.
   `.bench-engines/engines/xs/xst` becomes `.engines/engines/xs/xst`) — that
   second-level `engines/` is the engines-tools subdir, not the same string;
   the maintainer's directive is about the top-level `.bench-engines` name.
3. Verify with `git grep -n "bench-engines"` (expect 0 matches).
4. Verify scripts still parse: `sh -n packages/benchmark/install-engines.sh`,
   `sh -n packages/benchmark/run-tests.sh`,
   `sh -n packages/hex/test/run-benches.sh` all exit 0.
5. Commit as a single chore commit under endolinbot identity:
   ```
   chore(benchmark): rename .bench-engines cache to .engines
   ```
6. Push (regular append): `git push origin
   HEAD:fix-benchmark-wget-engines-master`.

## Per-action authorizations

- Edit the 4 listed source files. Authorized.
- Regular append push to
  `endojs/endo-but-for-bots:fix-benchmark-wget-engines-master`. Authorized.

## Not authorized

- Modifying any other files (out of scope of the rename).
- Force-pushing.
- Resolving the GitHub review thread (steward does that after fixer reports).
- Un-drafting (this PR stays DRAFT until the maintainer reviews the fix).
- Merging.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/fixer--d7299b/garden/roles/COMMON.md`
2. `/home/kris/dispatches/fixer--d7299b/garden/roles/fixer/AGENT.md`
3. Skills referenced by the fixer just-in-time.

Project worktree at `project/` on `fix-benchmark-wget-engines-master`
(head `6884ae24`).

## Report

A `result` journal entry. Include: new head SHA after push, list of files
modified, `git grep -n bench-engines` exit code (expect 1 / no matches),
script `sh -n` results, any PR comments posted (expected: none).
