---
ts: 2026-05-22T04:25:00Z
kind: result
role: weaver
project: endo
repo: endojs/endo-but-for-bots
---

Rebased `chore/package-uniformity-master` (PR #253, mirror of endo#3258) onto
current `origin/master` per kriskowal's 2026-05-22T04:20Z directive.

State:

- Pre-rebase HEAD on remote: `4e7aca476` (post-retcon, 6 commits, by fixer 9f06bf).
- Base: `origin/master` = `6804b7dc8`.
- Post-rebase HEAD: `f5ad0c1ea` (still 6 commits).
- Divergence pre-rebase: 6 ahead, 39 behind. Pre-rebase diff touched 164 files
  (overlap between branch's per-package conformance fixes and master's new
  `tsconfig.composite.json` per-package files plus the `syrup-frame` add).

Conflicts: one file, `.github/workflows/ci.yml`. Master had landed a new
`Check composite tsconfig files are up to date` step in the lint job
(7-line addition); our branch had added a `Check package uniformity` step
in the same place. Both checks belong in lint and are independent. Resolution
kept master's step first, then appended our step, preserving both intentions
(no `--ours` / `--theirs`). Post-rebase ci.yml diff vs master is the expected
additive 3-line block.

Sanity:

- Post-rebase diff vs master: 21 files, +1312/-16. Matches PR's original
  intent (uniformity script + per-package conformance fixes: LICENSE adds
  for far/init/lockdown/stream-types-test/eslint-plugin, package.json field
  fixes, SECURITY.md alignments, descriptions for ocapn/ocapn-noise, author
  alignment).
- No yarn.lock in diff (no lockfile conflict; package.json edits were
  field-only).
- `node scripts/check-package-uniformity.mjs` exits 0 on rebased tree.
- All six commits preserved (none skipped as empty).

Push: `git push --force-with-lease=chore/package-uniformity-master:4e7aca476...`
succeeded. Remote `chore/package-uniformity-master` now at `f5ad0c1ea`.

Self-improvement: nothing this time. The conflict was a textbook
"both sides added a new step to the same job" case the conflict-resolution
SKILL's pitfalls already enumerate ("two sides each add ... to the same
signature"); applied the standard preserve-both resolution.
