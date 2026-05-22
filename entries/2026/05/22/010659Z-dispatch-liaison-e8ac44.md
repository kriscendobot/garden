---
ts: 2026-05-22T01:06:59Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: fixer
prs:
  - repo: endojs/endo
    pr: 3047
    role: source
  - repo: endojs/endo-but-for-bots
    pr: 344
    role: mirror
---

# Dispatch: fixer carries feedback from endojs/endo#3047 onto endo-but-for-bots#344

Dispatch root: `dispatches/fixer--e8ac44/`. Project worktree on `endojs/endo-but-for-bots@mirror/3047-readmes` (head `b299f855c`).

Maintainer directive (2026-05-22): *"Please mirror https://github.com/endojs/endo/pull/3047 and respond to feedback, based on master branch."*

The mirror was opened earlier in this engagement as `endojs/endo-but-for-bots#344` (head `b299f855c`, base `master`, branch `mirror/3047-readmes`). The contractor's PR-creation-flow scan has already rebased it onto current `master` (per journal entry `5189b8a9`); the dispatch root checks out the rebased tip. This dispatch is the **respond-to-feedback** half of the directive.

## Upstream review state (as of 2026-05-22T01)

Substantial inline-review activity on `endojs/endo#3047`:

- **erights** (Mark S. Miller): senior contributor with maintainer-equivalent weight on `pass-style`, `ses`, `marshal`, `eventual-send`, `captp`, `patterns`, OCapN, and capability-security per `journal/projects/endo/README.md` § Authority structure. Substantive review on several READMEs; the docs themselves are not in erights' topic list (so it's high-signal-input, not auto-route-to-fixer), but the technical points about `pass-style` / `marshal` / `eventual-send` READMEs are in his topic list and read as authoritative.
- **gibson042**: review item asking the PR to also update `packages/skel` and `create-` templates as a convention rollout.
- **jcorbin**: items on BNF-style `|` notation, alice/bob viewpoint clarity in CLI README examples.
- 30 inline review comments distributed across the touched READMEs.

## Task

1. Read `garden/roles/COMMON.md`, then `garden/roles/fixer/AGENT.md` (or `garden/roles/judge/AGENT.md` if the fixer role file references it; choose the fixer-shape entry point).
2. Read `garden/skills/review-feedback-followup-commits/SKILL.md` (canonical procedure: follow-up commits on top, one concern per commit, lockfile in its own commit, do not amend), `garden/skills/rebase-before-followup/SKILL.md`, `garden/skills/pr-review-thread-replies/SKILL.md`, `garden/skills/em-dash-style/SKILL.md`, `garden/skills/relative-paths/SKILL.md`.
3. **Enumerate upstream review feedback.** `gh api repos/endojs/endo/pulls/3047/comments --paginate` and `gh api repos/endojs/endo/pulls/3047/reviews --paginate`. Group by file + author. Distinguish:
   - **In-scope** items: substantive content concerns in the touched README files; technical corrections; cross-link asks; clarification asks.
   - **Out-of-scope** items: asks to also update `packages/skel` or `create-` templates (gibson042's review) — these are *follow-up work the maintainer asks elsewhere*; surface as an "out-of-scope, deferred" entry in the report rather than expanding this PR's diff.
4. **For each in-scope item, apply a follow-up commit on top of `mirror/3047-readmes`.** Per the skill: one concern per commit, `docs(<pkg>): <one-liner>` message, parenthesized `(#344)` PR number, body cites the upstream review comment URL (e.g., `Addresses endojs/endo#3047 review comment <https://github.com/endojs/endo/pull/3047#discussion_r…>`).
5. **Apply the feedback to the mirror's README files,** not to upstream — the fixer commits on `mirror/3047-readmes`. The upstream `endojs/endo#3047`'s own response is the maintainer's job; this dispatch shapes the mirror so that when the boatman later ferries the mirror, the upstream PR will inherit the responses cleanly.
6. **Run local validation after each batch:** `yarn format`, `yarn lint`, `yarn docs`, pre-push-gates. The sentence-per-line-md probe is especially relevant on README edits.
7. **Push to the fork:** `git push origin HEAD:mirror/3047-readmes`. Non-force unless rebasing tip.
8. **Do NOT reply on upstream review threads.** The thread replies belong to the boatman's later upstream-side ferry; the fixer just lays the bot-side commits.
9. **Do NOT un-draft.** The judge un-drafts after the PR-creation-flow chain completes; this fixer dispatch is *rsvp*, not *un-draft*.

## Authority weight (erights items)

erights' substantive comments on `pass-style` / `marshal` / `eventual-send` README content carry technical-authority weight per `journal/projects/endo/README.md` § Authority structure. Treat those items as directives on the technical content. erights' meta-procedural comments ("the diff is confusing because the PR is also stacking on `kriskowal-docs-memoize`") are signal-to-the-maintainer rather than fixer-actionable; surface those in the report, do not act on them.

## Per-action authorization

- Push to `endojs/endo-but-for-bots:mirror/3047-readmes`.
- READ-ONLY on `endojs/endo`. No comments on upstream PR #3047. No comments on the bot mirror PR #344 either (the orchestrator handles cross-link if needed later).

## Out of scope

- No reply on upstream `endojs/endo#3047` review threads.
- No expansion of the PR's scope to also touch `packages/skel` or `create-` templates (gibson042's item is deferred follow-up work).
- No un-draft.
- No upstream ferry.

## Report

≤ 500 words. Number of in-scope items addressed, with a one-line summary of each (cite the upstream review comment URL). Number of out-of-scope / deferred items, with reason. List of follow-up commits added with their SHAs and conventional-commit messages. Final head SHA of `mirror/3047-readmes`. Local test status. One-line `Self-improvement: ...`. Write the result as `journal/entries/2026/05/22/<HHMMSSZ>-result-fixer-e8ac44.md` and push journal (rebase if non-fast-forward).
