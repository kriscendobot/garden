---
ts: 2026-05-13T04:39:00Z
kind: result
role: fixer
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
worktree: dispatches/fixer--pr-128-redraft--20260513-043604--6228d1/project
---

# Result: redrafted PR #128 title and body per #issuecomment-4437027474

Applied the new `pr-formation` skill's discipline to PR #128. No code changes (per the dispatch's "title + body only" scope; the inline `CHANGES_REQUESTED` items were explicitly out of scope and no re-request was authorized).

Steps:

1. Read `skills/pr-formation/SKILL.md` and the maintainer's quoted directive.
2. Fetched the GitHub PR template from `.github/PULL_REQUEST_TEMPLATE.md@llm` (present; decoded base64). Section headings: Description, Security Considerations, Scaling Considerations, Documentation Considerations, Testing Considerations, Compatibility Considerations, Upgrade Considerations.
3. Surveyed the actual scope on `feat/cli-assorted`: one commit (`3afba0844`), seven files: `packages/cli/package.json`, `packages/cli/src/commands/{checkin,checkout,workers,write-text}.js`, `packages/cli/src/endo.js`, `yarn.lock`. (The original body's mention of `read-text` and `subdir` was stale; those were dropped before the PR landed.)
4. Drafted new title: `feat(cli): workers, zip in/out, and write-text verb`. This drops the list-of-features and the `(re-opened from #38 under the bot)` parenthetical. The pr-formation skill cited the old title verbatim as its "bad" example; the new form follows the skill's "Better" recommendation, adjusted for actual shipped scope (no `read-text`).
5. Drafted new body filling every template section. No checklists, no per-file callouts. The provenance note (re-opened from #38) lives in the leading `Refs:` line. Behavior and intent stated in `Description`; risk surface (none new) in `Security`; backward-compatibility in `Compatibility` and `Upgrade`.
6. `gh pr edit 128 --repo endojs/endo-but-for-bots --title ... --body-file /tmp/pr-128-body.md` succeeded; verified the new title via `gh pr view`.
7. Posted top-level comment: <https://github.com/endojs/endo-but-for-bots/pull/128#issuecomment-4437324102>. Neutral tone, cites the authorizing comment, names the three constraints applied (no checklists, no per-file callouts, GitHub template).

The template was found on first try at `.github/PULL_REQUEST_TEMPLATE.md` on the `llm` base branch. No template-not-found fallback was needed.

Self-improvement: nothing this time. The pr-formation skill (just landed) covered every decision point cleanly; the four-part body order the skill recommends (what / why / what to attend to / out of scope) mapped one-for-one onto the template's section structure on this repo, which is mild evidence that the four-part order generalizes. If a future application finds the template forces a different section ordering, that would be the signal to re-tune.
