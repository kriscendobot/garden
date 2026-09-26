The PR is a **design-document-only** change: it adds `designs/ses-top-level-await.md` (585 lines) and edits `designs/README.md` (+21/−3). No source or test files in any package are touched (`changedFiles: 2`, both under `designs/`).

Clean-stage assessment:
- **Coverage pass**: nothing to do. There are no touched packages, no new/changed source code, and therefore no lines to cover.
- **Dead code**: none orphaned — a markdown design lands no code and removes none.
- **CI**: `statusCheckRollup` is empty and `gh pr checks` reports "no checks reported" — this repo runs no CI on a design-doc branch, so there is no pending/red state to wait on. Green by absence at head `4424f3a`.
- PR is already the right shape: `isDraft:false`, `state:OPEN`. Nothing to push.

This stage is a no-op — nothing to fix, no follow-ups.

## Completion report

- Inspected PR #249 (`design(ses,module-source): top-level-await proposal`). It is design-only: `designs/ses-top-level-await.md` (added) + `designs/README.md` (modified), no package source or tests.
- Coverage-driven-testing pass: not applicable — no touched packages, no code to cover, no dead code orphaned.
- No changes made, so nothing pushed to the PR head.
- CI: no checks configured for this branch (empty rollup); terminal green-by-absence at head `4424f3a96da4f84c5f559133a93568ec3539cd3a`.
- Follow-ups: none.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr249-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (132927 cached reads)
- Output: 1802 tokens
- Cost: $0.4415124999999999
- Wall-clock: 32s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
