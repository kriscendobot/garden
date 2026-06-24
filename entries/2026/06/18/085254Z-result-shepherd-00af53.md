---
ts: 2026-06-18T08:52:54Z
kind: result
role: shepherd
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/06/18/085254Z-result-shepherd-00af53.md
---

# Shepherd Round 2: PR #357 (chore/prettier-markdown)

## CI state at entry (head 709319dd2)

`gh pr checks 357 --repo endojs/endo-but-for-bots` shows:

| Job | Status | Classification |
| --- | --- | --- |
| lint (run 27746004393) | FAIL | See below |
| test-xs (run 27746004260) | FAIL | Class B: infrastructure flake |
| All other checks | PASS | |

## lint failure root cause

Lint run 27746004393 fails on `yarn lint:prettier` with:

```
warn: packages/cancel/DESIGN.md
warn: packages/cancel/README.md
warn: packages/cancel/SECURITY.md
Code style issues found in 3 files. Run Prettier with --write to fix.
```

These 3 files do NOT exist on the PR branch (`chore/prettier-markdown`). They exist only on the base branch (`llm-5b1361d`, current tip `e98497ea7`). The base branch received them via PR #345 (merged as `e98497ea7 feat(cancel): @endo/cancel cancellation primitive`), which was merged AFTER this PR's prettier pass commit (`c24457346`) was created.

The CI check runs on the synthetic merge commit (PR head merged into base branch tip). The synthetic merge takes `packages/cancel/*.md` from the base branch side (since the PR head does not have them), and those files were not formatted by the PR's prettier pass.

## Why no Code fix is possible from the PR branch

Adding the formatted files to the PR branch creates an add/add conflict:

- Merge base (`5b1361d03`): no `packages/cancel/`
- PR head (with fix): adds formatted `packages/cancel/`
- Base branch (`e98497ea7`): adds unformatted `packages/cancel/`

Both sides add the same files with different content; git would mark the PR as CONFLICTING. CI would not run. This is worse.

Rebasing the PR onto the current base would solve the issue (the prettier pass would then include `packages/cancel/*.md`), but the dispatch brief explicitly prohibits rebase.

Pushing formatted files to the base branch `llm-5b1361d` is outside the shepherd's scope (COMMON.md guardrail: never push outside the PR's scope).

## test-xs classification (unchanged from shepherd r1)

`test-xs` failed at "Install engines" step with:

```
XS: Downloading https://github.com/Moddable-OpenSource/moddable/releases/download/8.2.3/xst-lin64.zip
V8: Downloading https://storage.googleapis.com/chromium-v8/official/canary/v8-linux64-rel-15.1.142.zip
Error installing XS or V8: Process completed with exit code 1.
```

Infrastructure binary download failure. Class B, unchanged from shepherd r1 (f3680a). Not introduced by the PR.

## Classification table

| Class | Job | Signature | Disposition |
| --- | --- | --- | --- |
| A | (none) | | |
| B | test-xs | XS engine download failure (moddable 8.2.3) | Surface to maintainer; not PR-side |
| B | lint | packages/cancel/*.md unformatted on base branch; fix requires base-branch push or rebase | Structural impasse; needs maintainer decision |
| C | (none) | | |
| D | (none) | | |

## Recommended resolution

Two options for the maintainer:

1. **Authorize a push to `llm-5b1361d`**: the shepherd (or any agent with the authorization) formats `packages/cancel/DESIGN.md`, `packages/cancel/README.md`, and `packages/cancel/SECURITY.md` and pushes the result to the base branch. The PR then merges cleanly with a green lint.

2. **Authorize a rebase**: update the PR's second commit to include the `packages/cancel/` files in the prettier pass. The weaver or fixer can do this.

Option 1 is the smallest targeted fix. The formatted files are ready (prettier was run; the diffs are: code-block reformatting in DESIGN.md and README.md, list-marker normalization in SECURITY.md).

## next: liaison

Escalation: structural impasse requiring maintainer decision. The fix path is outside the shepherd's scope. `next: liaison` to surface the two options.

Self-improvement: the dispatch brief for round 2 shepherd dispatches should pre-check whether the base branch has advanced since the PR's most recent commit and whether the synthetic merge commit would include new unformatted files, to surface this class of impasse earlier.
