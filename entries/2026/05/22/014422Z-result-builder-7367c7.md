---
ts: 2026-05-22T01:44:22Z
kind: result
role: builder
worktree: dispatches/builder--7367c7/project
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/05/22/013728Z-dispatch-liaison-7367c7.md
---

Mirrored endojs/endo#2948 ("docs: Various touch-ups") onto endo-but-for-bots@master as PR #350.

- URL: https://github.com/endojs/endo-but-for-bots/pull/350
- Branch: `mirror/2948-docs-touch-up`
- Head SHA: `9e43ad243d50fc703eaf1cc50e564cbd71705007`
- State: DRAFT (per dispatch instruction)
- Author: Kris Kowal (preserved); Committer: endolinbot

Commit shape: single cherry-pick commit `docs: Various touch-ups` preserving upstream authorship and date. Net: 2 files changed, 29 insertions, 62 deletions.

Conflicts: 2 of the 4 upstream files were superseded by master rewrites in the 9 months since the touch-up.

- `CONTRIBUTING.md`: master carries a comprehensive Markdown Style Guide, Action pinning, Validation, and full Changesets workflow that subsumes and exceeds the touch-up's draft. Resolved by taking master's version (`--ours`). Touch-up contributes nothing here.
- `packages/ocapn/README.md`: master carries a full OCapN package README rewrite (overview, Syrup table, architecture, related packages). Resolved by taking master's version. Touch-up's two-line stub-update is superseded.
- `packages/compartment-mapper/README.md`: cherry-pick applied cleanly. Replaces stale `> TODO:` blocks with current state (policy, JSON imports via Node 23.1 attributes, removed unimplemented Realm/RealmName/ModuleParameter stubs).
- `packages/ses/README.md`: cherry-pick applied cleanly. Updates four `__options__: true` JS comments from "temporary migration affordance" to "required for SES shim compatibility".

Test status: `yarn install` ok; `yarn format` clean (no induced changes); `yarn lint` clean (2 pre-existing warnings, unrelated); `yarn docs` ok (warnings pre-existing); pre-push-gates `--probes-only` reports two failures (`security-md-hash-uniform`, `sentence-per-line-md`), both confirmed pre-existing on master and untouched by this diff (sentence-per-line cites unchanged lines on the same files; SECURITY.md divergence is the known PR #75 condition pending its CI rule). Out of scope for this docs-only mirror.

Per-action authorization observed: push to mirror branch (done); draft PR against master (done, draft); no cross-post to endojs/endo; READ-ONLY honored.

Self-improvement: when a 9-month-old upstream PR cherry-picks with conflicts, document in the PR body which targets were superseded vs. which carry forward; this saves the contractor and the panel from re-discovering the asymmetry. Suggest adding "for an old upstream PR, check whether master has rewritten the target files" as a builder check; not large enough to warrant a skill edit on its own. Borderline; will surface again if it recurs.
