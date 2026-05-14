---
ts: 2026-05-14T22:53:00Z
kind: dispatch
role: steward
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 82
    role: source
refs:
  - entries/2026/05/14/225200Z-message-steward-7e3a91.md
---

# Dispatch: builder proposes a resilience PR for `test-ocapn-guile-interop` (iteration II per maintainer)

Dispatch root: `dispatches/builder--f0aba2/`. Project worktree on `endojs/endo-but-for-bots@llm`.

## The directive

Maintainer at ~2026-05-14T22:50Z (verbatim, same routing as the sibling `225200Z-message-steward-7e3a91.md`):

> Let's dispatch a builder to propose a PR to increase the resilience of that job, again.

PR #82 (merged) was the first iteration — `ci(ocapn-guile-interop): make guix dependency resilient to ci.guix.gnu.org outages`. The current operational failure indicates that pass was insufficient against the upstream Guix substitute-server's current behavior; iteration II is owed.

## Per-action authorization

- Push one new branch `ci/ocapn-guile-interop-resilience-ii` to the bot fork.
- Open a draft PR against base `llm` (the workflow lives on llm; master-base mirror can follow under the regular master-base-mirror pattern if appropriate).
- Read the workflow file `.github/workflows/test-ocapn-guile-interop.yml` on llm.
- Read PR #82's diff and merge commit (`gh pr view 82 --json files,commits`) for the prior resilience pattern.
- Read recent failing runs of `test-ocapn-guile-interop` via `gh run list --workflow=test-ocapn-guile-interop.yml --status=failure` to identify the current failure signature(s).

## Task

Iteration II of the OCapN Guile Interop CI resilience. The current failure pattern is not yet captured by the maintainer; the builder identifies it from the recent run logs and proposes a targeted resilience change.

Candidate resilience axes (the builder picks one or more; no need to land all):

- **Wider retry window**. PR #82 used `nick-fields/retry`; check if the timeout/backoff bounds need increasing for the current upstream condition (substitute-server slow but not entirely down).
- **Fallback substitute server**. Configure Guix to fall back to a secondary substitute server (`bordeaux.guix.gnu.org` if available) or to `--no-substitutes` for the specific build.
- **Skip-on-substitute-outage** with explicit `if: failure() && contains(steps.<id>.outputs.log, '<substitute marker>')` step that converts the failure into a `continue-on-error` pass plus a posted status note. (This is the operational-but-resilient mode.)
- **Pin substitute resolution to a known-good mirror snapshot** for the duration of the breakage.

The maintainer's "again" framing suggests the resilience pattern from #82 needs revisiting in the same spirit — not a fundamentally different design. Lean toward incremental hardening rather than a workflow rewrite.

## Out of scope

- No change to test fixtures or test logic; resilience belongs in the workflow.
- No master-base mirror in this dispatch (file a separate steward `dispatch` for the mirror if the diff is reusable on master after the llm-side lands).
- No removal of the workflow.
- No comment on PR #82, PR #109 (which currently shows the failure), or other PRs whose CI is affected.

## Commits

- One commit on `ci/ocapn-guile-interop-resilience-ii` (off `llm`) with the workflow change.
- Conventional-commit message shape: `ci(ocapn-guile-interop): <one-line summary> (iter II per #82)`.
- Push at end.
- Open the PR with `gh pr create --draft --base llm --head ci/ocapn-guile-interop-resilience-ii`.
- PR title and body follow `skills/pr-formation/SKILL.md`. The body names the chosen resilience axis (or axes), quotes the failure signature observed in recent runs, and cross-references PR #82 as the prior iteration.

## Report

≤ 500 words: PR number, the failure signature(s) observed in recent runs, the chosen resilience axis (or axes), one paragraph of justification, and one-line `Self-improvement: ...`.
