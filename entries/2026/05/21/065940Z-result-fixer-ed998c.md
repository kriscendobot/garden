---
ts: 2026-05-21T06:59:40Z
kind: result
role: fixer
worktree: dispatches/fixer--6cfc66/project
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - jobs/claimed/endolinbot--20260521T065435Z--8eb3d5--consistency-pr-334.md
  - entries/2026/05/21/065033Z-dispatch-liaison-8e433a.md
---

# Summary-fix job 8eb3d5: README node: prefix consistency on PR #334

Resolution: **forward extension**. Changed the six prior unprefixed occurrences in `packages/compartment-mapper/README.md` to use `node:` prefix so all eight import lines (24-25, 87-88, 111-112, 151-152) use the prefixed form. Single file, README only, no source impact.

Commit: `30c43c645 docs(compartment-mapper): consistent node: import prefix in README` (6 insertions, 6 deletions; no yarn.lock churn).

Push: `c37c80134..30c43c645  HEAD -> mirror/2887-naming-module-location-specifier`. Pushed under `endolinbot` identity.

## Pre-push gate

After `yarn install`, the gate ran auto-fix stages and probes. After unstaging the out-of-scope yarn-lint-fix edits that spilled into other packages (`packages/evasive-transform/src/index.js`, `packages/ses/src/compartment.js`), the gate's two non-pass findings on the scoped diff:

- `security-md-hash-uniform`: divergent SECURITY.md hashes across `immutable-arraybuffer`, `bytes`, `hex`, `panic`. **Preexisting in base**; nothing this PR touches. Out of scope for summary-fix 8eb3d5.
- `sentence-per-line-md`: `packages/compartment-mapper/README.md:49-51` carry multi-sentence prose lines. Verified against `HEAD~1`: the lines exist on the PR's prior head; my edit only changed lines 24-25, 87-88, 111-112. The probe flags the whole file when any line in it changes, surfacing preexisting drift. Out of scope for this summary-fix; addressing would scope-creep beyond the panel's single complaint.

No regressions introduced by the fix. The two preexisting findings are recorded here for the steward's followup ledger; they did not block this push.

## Per-item disposition

| Item                                        | Disposition       |
| ------------------------------------------- | ----------------- |
| node: prefix consistency on README          | fixed (commit 30c43c645) |
| security-md-hash-uniform divergence         | surfaced; out of scope (preexisting base drift) |
| sentence-per-line-md on README lines 49-51  | surfaced; out of scope (preexisting base drift, not introduced by this fix) |

Self-improvement: nothing this time.
