---
ts: 2026-05-22T00:47:32Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: builder
prs:
  - repo: endojs/endo
    pr: 3047
    role: source
---

# Dispatch: builder mirrors endojs/endo#3047 (docs: populate READMEs) onto endo-but-for-bots@master

Dispatch root: `dispatches/builder--23d295/`. Project worktree on `endojs/endo-but-for-bots@master` (detached at `0ec70c6dd`).

Maintainer directive (2026-05-22): *"Please mirror https://github.com/endojs/endo/pull/3047 and respond to feedback, based on master branch."*

This dispatch is the **mirror half** of the directive. After the mirror PR is open, a **separate fixer dispatch** will respond to inline review feedback on the upstream `endojs/endo#3047`; that fixer-feedback dispatch is orchestrator-managed, not part of this builder's task.

## What landed in endojs/endo#3047 (kriskowal's branch)

Upstream PR <https://github.com/endojs/endo/pull/3047>:

- Author: kriskowal
- Title: "docs: Populate READMEs"
- Source branch: `kriskowal-docs-readmes` (already fetched into the project worktree as `endo-upstream/kriskowal-docs-readmes`)
- Base on upstream: `master`
- 29 files, +661 / -41
- Documentation pass: populates READMEs across the workspace.

## Task

1. Read `garden/roles/COMMON.md`, then `garden/roles/builder/AGENT.md`.
2. Read `garden/skills/library-lookup/SKILL.md`, `garden/skills/pre-push-gates/SKILL.md`, `garden/skills/pr-formation/SKILL.md`, `garden/skills/em-dash-style/SKILL.md`, `garden/skills/relative-paths/SKILL.md` (docs-only changes; the prose style rules apply).
3. **Apply the upstream diff onto `master`**. Per the maintainer's directive, the base is `master` (not `llm`) — the standard implementation-on-master shape. Two equivalent shapes:
   - **a)** `git checkout -b mirror/3047-readmes`; cherry-pick from `endo-upstream/kriskowal-docs-readmes`.
   - **b)** Reset onto `master` and re-form as per-package `docs(<pkg>): populate README` commits + any cross-cutting `docs: ...` commit.
   - Since this is a docs-only diff with low merge risk, prefer **shape (a)** if the cherry-pick range is small (under 10 commits) and the upstream commit grouping is already per-package; fall back to **(b)** otherwise. Inspect `git log endo-upstream/kriskowal-docs-readmes ^endo-upstream/master --oneline` first to decide.
4. **Local validation.**
   - `yarn lint` at root (catches markdown formatting via the project's lint config, if any).
   - `yarn format` (Prettier on markdown — the most common docs-PR nit per `project/CLAUDE.md` § Pre-PR checklist).
   - `yarn docs` if it covers README rendering.
   - Run `garden/skills/pre-push-gates/<script>` before the first push (the sentence-per-line and em-dash probes are especially relevant on docs PRs).
5. **Commit shape.**
   - Per-package `docs(<pkg>): ...` commits where the upstream history allows.
   - **Separate** `chore: Update yarn.lock` only if dependencies changed (unlikely for docs).
   - Conventional-commit messages citing the upstream PR (`Mirror of endojs/endo#3047.`).
6. **Push to the fork.** `git push origin HEAD:refs/heads/mirror/3047-readmes`. First push is non-force.
7. **Open the draft PR on `endojs/endo-but-for-bots`.** Base: `master`. Title: `docs: populate READMEs (mirror of endojs/endo#3047)`. Body uses kriskowal's upstream PR body as the starting point + a leading paragraph naming the mirror relationship. Mark draft per `pr-creation-flow`.
8. **Do NOT** address upstream-PR review feedback in this dispatch. The orchestrator runs a separate fixer dispatch after this builder returns; that fixer reads the inline review threads on `endojs/endo#3047` and applies their feedback as follow-up commits on the mirror branch. Leaving the response work to a separate fixer keeps this builder's diff legible as "the bare mirror" against `git diff endo-upstream/kriskowal-docs-readmes`.

## Per-action authorization

- Push to `endojs/endo-but-for-bots:mirror/3047-readmes` (the fork the bot owns).
- Open draft PR on `endojs/endo-but-for-bots` against `master`.
- READ-ONLY on `endojs/endo`. No comments anywhere outside the new PR's own body.

## Out of scope

- No address of upstream-PR review feedback (separate fixer dispatch handles).
- No un-draft of the mirror PR (steward's PR-creation-flow scan handles, or the orchestrator un-drafts after the fixer-feedback dispatch concludes — at the orchestrator's call).
- No upstream ferry.
- No edits to source code outside the README files.

## Report

≤ 300 words. The fork PR URL + head SHA. The commit shape chosen. Any merge conflicts encountered. Local test status (pass/fail per command). The list of READMEs touched (one bullet per package). One-line `Self-improvement: ...`.
