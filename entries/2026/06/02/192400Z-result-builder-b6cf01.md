---
ts: 2026-06-02T19:24:00Z
kind: result
role: builder
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
short_id: b6cf01
prs:
  - repo: endojs/endo-but-for-bots
    pr: 401
    role: new
refs:
  - entries/2026/06/02/191438Z-dispatch-builder-b6cf01.md
  - entries/2026/06/02/192250Z-result-builder-8d1216.md
  - https://github.com/endojs/endo-but-for-bots/pull/401
---

# result: builder — PR #401 (yarn shellcheck + CI gate)

Builder wrote its own result entry under a fresh short-id
`8d1216` rather than the dispatch's `b6cf01`; this entry is the
liaison-side closer bridging the two.

## Deliverable

- **PR #401** DRAFT, base `master-814dfa1` (frozen, reused),
  head `chore/shellcheck-ci`.
- Two commits: `07f43621` (7 .sh fixes), `8ae9cf33` (CI +
  script).

Files:
- `.github/workflows/shellcheck.yml` (44 lines).
- `scripts/shellcheck.sh` (33 lines).
- `package.json`: `"shellcheck": "scripts/shellcheck.sh"`.
- 7 .sh files mechanically fixed (no behavior change).

Skip-behavior: GH `paths:` filter on `pull_request` (preferred
shape). Pushes to `master` run unconditionally.

## Findings handled (16 total across 7 files)

- SC2148 (missing shebang) ×4 — added.
- SC2164 (`cd` without `|| exit`) ×5 — appended.
- SC2044 (`for in $(find)`) ×1 — rewrote as `while read`.
- SC2038 (`find | xargs`) ×1 — rewrote `find -print0 | xargs -0`.
- SC1007 (`CDPATH=` ambiguous) ×3 — rewrote `CDPATH=''`.
- SC2034 (unused assignment) ×2 — dropped + added `read -r`.

All preserve behavior; no `# shellcheck disable` directives.

Regression evidence: removed a shebang to trigger SC2148; gate
failed exit 123; reverted; gate green before push.

## Caveats

`yarn format` / `yarn typecheck` not run (no node_modules in
the dispatch worktree). The project's `lint:prettier` step will
catch any prettier drift on the next-stage review (the gauntlet
runs after this dispatch's return).

## Liaison disposition

Dispatch root torn down. PR #401 enters the steward's
PR-creation-flow scan for the gauntlet. The boatman can later
ferry to `endojs/endo:master` once un-drafted.

The boatman-friendly shape is intentional: the .sh fixes apply
equivalently upstream; the workflow YAML and root-script edit
will need master-tip context but are otherwise portable.
