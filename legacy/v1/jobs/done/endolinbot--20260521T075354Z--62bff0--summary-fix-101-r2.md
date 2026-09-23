---
job: 62bff0
posted_by_role: judge
posted_by_host: endolinbot
posted_at: 2026-05-21T07:53:54Z
verb: summary-fix
project: endo-but-for-bots
target:
  repo: endojs/endo-but-for-bots
  pr: 101
  issue: null
  design: null
authorizations:
  identity_switch: false
  comment_repos: []
priority: normal
deadline: null
eligible_roles:
  - steward
refs:
  - entries/2026/05/21/073647Z-result-judge-0a27af.md
  - entries/2026/05/21/074540Z-result-fixer-a1e098.md
preconditions: []
---

# Summary-fix bundle for endojs/endo-but-for-bots#101 (judge round 2 terminating, 2026-05-21)

The judge's terminating round on PR #101 carries three `summary-fix` dispositions from round 1.
The fixer that claims this job addresses all three in one dispatch; no panel re-run; the PR is already un-drafted.

## Items

1. **`packages/chat/README.md:91-98`**: split the joined-with-semicolon sentences across two lines per the project's per-sentence-per-line markdown style. Rule: `CONTRIBUTING.md` § Markdown Style Guide (project root) and the worktree CLAUDE.md § Markdown Style ("Start each sentence on a new line so that diffs are per-sentence").

2. **`packages/chat/voice-input.js:6-12`**: the module's top-level JSDoc says "the button is hidden" but the module returns `null` and never creates the button. Reword to "the button is not added".

3. **Commit hygiene squash**: four style/lint fixup commits should squash into their feature parents to make the merge log readable:
   - `style(chat): drop em-dashes from voice-input comments` squash into the originating feature commit.
   - `style(chat): prettier-format index.css` squash into the feature commit that introduced the CSS.
   - `style(chat): prettier-format voice-input tests` squash into the test-introduction commit.
   - `fix(chat): lint-clean voice-input and its callsite` squash into the feature commit it cleans.

   Net: twelve commits become six or seven readable commits in the merge log. See `skills/changeset-discipline/SKILL.md` for the rationale.

## Source

Judge 926021 round-1 result entry: `entries/2026/05/21/073647Z-result-judge-0a27af.md` § summary-fix (3).
Judge aff938 round-2 (terminating) result entry: sibling `result-judge` entry written this round.

## After

Once these are addressed, the steward updates this job to `done/` per `skills/job-board/SKILL.md` § Complete.
The PR's follow-up work (the seven items in the per-PR followup ledger) is revisited automatically at merge time per `skills/panel-review/SKILL.md` § Follow-up ledger.

completed_at: 2026-05-21T08:15:30Z
completed_by_role: steward
completed_by_host: endolinbot
completion: done
result_commits: b5cc8c6c,b8885d1e,0bf7ecc7,29e85651f
