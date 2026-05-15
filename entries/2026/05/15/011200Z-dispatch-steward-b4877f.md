---
ts: 2026-05-15T01:12:00Z
kind: dispatch
role: steward
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 126
    role: target
---

# Dispatch: conductor refreshes title+body and merges PR #126 (per maintainer comment 4454679616)

Dispatch root: `dispatches/conductor--b4877f/`. Project worktree on `endojs/endo-but-for-bots@ci/no-npm-lifecycle`.

## The directive

Maintainer comment on PR #126 (id 4454679616, 2026-05-14T20:58:20Z, verbatim):

> Please refresh the title and description to address readers of the eventual merge commit message, per standing instructions. Then merge.

User confirmed the steward should act at ~2026-05-15T01:12Z. The maintainer's "standing instructions" reference `skills/pr-formation/SKILL.md` (and the project's own `CLAUDE.md` § Commit and PR discipline).

## Per-action authorization

- Edit PR #126's title and body via `gh pr edit 126`.
- Merge PR #126 via `gh pr merge 126 --squash` (or `--merge` per the repo's default; conductor decides).
- No edit to the diff itself; the merge ships the existing commits as-is.

The bot identity (`kriscendobot`) historically has limited workflow-scope on its own fork; if the merge is blocked by missing OAuth scope, post a comment naming the block and surface back to the steward for liaison routing.

## Task

1. **Title refresh.** The current title is `ci: disable npm lifecycle scripts in workflows (re-opened from #26 under the bot)`. Per pr-formation merge-commit-message style:
   - Drop the `(re-opened from #26 under the bot)` provenance suffix; that belongs in the body, not the merge commit subject.
   - Tighten verb and scope. Candidate: `ci: disable npm lifecycle scripts in all workflows` or similar — conductor picks the precise wording.

2. **Body refresh.** Current body is the re-open-under-bot template plus the original PR body verbatim. Per pr-formation:
   - Drop the "Forwarded from #26 under the bot" preamble and the "Original PR body" wrapper. The body should read as the merge-commit narrative directly.
   - Drop the trailing "Forwarded inline review comments" / "Forwarded reviews" / "Forwarded conversation" sections. Those are forwarding-pattern artifacts, not merge-commit content. (The inline comments listed there have already been addressed by the dropping-of-the-lint-script in follow-up commits, per the original body's "Scope of this PR" section.)
   - Drop the `- [ ] Test plan` checklist (`pr-formation` forbids author-checklists in PR bodies).
   - Drop the `cc @kriskowal` and trailing meta lines (`Co-Authored-By`, `Generated with`); GitHub adds those to commits, not to the merge-commit body.
   - Keep the substantive `## Summary`, `## Design`, `## Scope of this PR`, `## Not included` material. Tighten the prose if any sentence is redundant with the title.

3. **Merge.** After title+body refresh, run `gh pr merge 126` with the squash-or-merge choice the repo's convention names (squash is the common case for the bot's PRs based on the merged-PR history). The merge commit's title and body are produced from the PR's title and body, which is the whole point of the refresh.

## Out of scope

- No edit to the diff itself.
- No comment replying to the maintainer's comment; the action (refresh + merge) is the response.
- No master-base mirror in this dispatch; #250 already mirrors #126's diff onto master and is a separate engagement.

## Commits

No new commits; the diff is the existing one. The title+body edit happens via `gh pr edit` (metadata only). The merge produces a merge commit (or squash commit) per repo convention.

## Report

≤ 400 words: the refreshed title, the refreshed body (or a 3-line summary of what changed if the body is long), the merge result (commit SHA on `llm`), and one-line `Self-improvement: ...`. If the merge is blocked (workflow OAuth scope), report the block and the comment posted naming it.
