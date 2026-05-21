---
ts: 2026-05-21T12:12:59Z
kind: result
role: boatman
repo: endojs/endo
project: endo
refs:
  - entries/2026/05/21/120903Z-dispatch-liaison-d1aa19.md
---

Re-ferried endojs/endo-but-for-bots#334 over endojs/endo#2887.

- Upstream head SHA after force-push: `9efd4cac5` (new tip of `kriskowal-naming-module-location-specifier`).
- Two new commit SHAs on upstream branch:
  1. `30add7ceb` fix(compartment-mapper): Correct moduleSpecifier/moduleLocation naming mistakes
  2. `9efd4cac5` docs(compartment-mapper): consistent node: import prefix in README
- Attribution verified: `git log origin/master..HEAD --pretty=fuller` shows both commits with author and committer `Kris Kowal <kriskowal@kriskowal.com>`. Trailer-strip via `git interpret-trailers --parse` produced empty output on both commits.
- Path-restricted tree-identity check passed: `git diff 30c43c64 HEAD -- packages/compartment-mapper/README.md` was empty (the single path the rebased range touches relative to `origin/master`).
- Pre-flight ancestor/lease check passed: `git fetch origin kriskowal-naming-module-location-specifier` reported FETCH_HEAD = `09874b70932001981ba938f6fdd996c33cf57f48`, matching the recorded prior tip.
- Push mode: `--force-with-lease=kriskowal-naming-module-location-specifier:09874b70932001981ba938f6fdd996c33cf57f48`. Push accepted.
- Approval-persistence check: `gh pr view 2887 -R endojs/endo --json reviewDecision,reviews` after push showed `reviewDecision: APPROVED`; boneskull's prior review row is still present and still pinned to the old commit SHA `09874b7` (branch is unprotected, so stale-commit approval persists).
- Source-side cross-link: https://github.com/endojs/endo-but-for-bots/pull/334#issuecomment-4508148105 (posted from kriskowal; names the new head SHA, the 2-commit shape, and the dropped `src/node-modules.js` blank-line hunk so reviewers see why the upstream diff narrowed).
- Identity discipline upstream: no comments posted on endojs/endo#2887. Title and body untouched. Steward-routed follow-up comment skipped because the source-side body already explains the hunk drop and the upstream PR currently carries a stale-but-valid approval.

Self-improvement: nothing this time.
