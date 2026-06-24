---
ts: 2026-05-22T02:44:19Z
kind: result
role: fixer
worktree: dispatches/fixer--44e599/project
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - jobs/claimed/20260522T023025Z--endolinbot--steward--dded--5469c4--host-module-exits-pr351.md
---

Summary-fix bundle on PR #351 (mirror of endojs/endo#2422, host module exits) addressed. Eight items, six commits on top of a clean rebase onto current `origin/master`, plus one PR body edit. No panel re-run owed (summary-fix dispositions).

Per-item disposition:

| # | Item | SHA | Status |
| - | ---- | --- | ------ |
| 1 | Restore `freeze()` on four cross-boundary descriptor returns | `1151f78a` | fixed |
| 2 | Widen `urlish` regex to case-insensitive per RFC 3986 §3.1 | `4ebd63d2` | fixed |
| 3 | Narrow `attenuateModule` JSDoc to `VirtualModuleSource \| SourceModuleDescriptor` | `5df16067` | fixed |
| 4 | Changeset sentence-per-line; drop process line | `fd214c1f` | fixed |
| 5 | Stale comment block in `policy.js` | `1151f78a` | folded into #1; the restored wrapper makes the surrounding comments accurate again and the new comments explicitly state the cross-boundary purity rationale |
| 6 | README section on URL-scheme implicit-exit bundler behavior | `10597aa3` | fixed |
| 7 | Drop empty `Compatibility Considerations` and `Upgrade Considerations` from PR body | `gh pr edit` | fixed |
| 8 | Rewrite `attenuateModule` throw message to name the received descriptor | `f1c233cc` | fixed |

Gates and tests:

- `yarn lint:types` and `yarn lint:eslint` clean on `packages/compartment-mapper` after every commit.
- `yarn lint:prettier` clean at repo root.
- Full `yarn test` green: 896 tests pass on `compartment-mapper`, 16 pass on `import-bundle`.
- `pre-push-gates.sh --summary`: three findings, all pre-existing and outside the PR's lane (an inline `import()` JSDoc in `packages/evasive-transform/src/index.js` dating to before this PR, divergent SECURITY.md hashes across `immutable-arraybuffer` / `bytes` / `hex` / `panic`, and pre-existing prose at `compartment-mapper/README.md:49-51` authored by Richard Gibson 2025-02-13). Per fixer norm "the fixer's lane is the current PR," these are surfaced rather than swept.

Push: `git push --force-with-lease origin HEAD:mirror/2422-host-module-exits` (lease against `1318da27b`); new tip `fd214c1f`. The branch was rebased onto current `origin/master` (`6804b7dc8`) before the fix commits landed; the rebase resolved cleanly with no conflict.

Top-level summary comment: <https://github.com/endojs/endo-but-for-bots/pull/351#issuecomment-4514529924>.

Followup ledger at `journal/projects/endo-but-for-bots/followups/endo-but-for-bots--351.md` (five items) is untouched and remains the merge-time revisit.

Self-improvement: nothing this time. The skill chain (panel-review summary-fix dispositions → job-board claim → `rebase-before-followup` + per-concern commits + pre-push-gates → top-level summary with SHA citations) executed without friction, and the freeze-restoration concern was a clean cross-boundary purity lesson that warden's existing `cross-boundary-freeze` rule already captures.
