---
ts: 2026-05-14T04:01:32Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 223
    role: target
  - repo: endojs/endo
    pr: 3257
    role: source-of-feedback
---

# Dispatch: fixer carries endojs/endo#3257 feedback to endo-but-for-bots#223

Dispatch root: `dispatches/fixer--carry-3257-feedback-to-223--20260514-040131--cbd3ec/`. Project worktree at `endojs/endo-but-for-bots` on branch `feat/endo-bytes-upstream`.

Maintainer directive (this session): "Please carry the feedback on https://github.com/endojs/endo/pull/3257 to the corresponding PR in endo-but-for-bots."

endojs/endo#3257 is the upstream ferry of @endo/bytes that the boatman opened on 2026-05-14. Reviews on #3257 at dispatch time:

- `copilot-pull-request-reviewer` COMMENTED at 2026-05-14T03:54:22Z.
- `kriskowal` COMMENTED at 2026-05-14T03:58:04Z.

Both are substantive (kriskowal's COMMENTED is his own review of the bot's ferry; Copilot's is auto-generated). The same package code lives in #223 (`feat/endo-bytes-upstream` on endo-but-for-bots); whatever feedback applies to #3257 applies to #223.

## Per-action authorization

Standing on endo-but-for-bots (push, comment freely). For #3257 (endojs/endo), the bot has only `pull` per kriscendobot's scopes; this dispatch is READ-ONLY on #3257.

## Task

1. Read the reviews + comments on #3257:
   - `gh pr view 3257 -R endojs/endo --json reviews,comments,reviewThreads`
   - For each review: read the body. For Copilot's review, the body is auto-generated bullet points; for kriskowal's, the body is the maintainer's substance.
   - Inline review comments: `gh api repos/endojs/endo/pulls/3257/comments --jq '.[] | {id, path, line, body, user: .user.login, in_reply_to_id}'`. These are the line-anchored comments that surface specific issues.

2. For each substantive comment, identify the equivalent file/line in #223's branch (the file paths are usually identical since the diff was a faithful mirror). Apply the fix.

3. Don't apply Copilot's bullets verbatim if they conflict with kriskowal's substance — the maintainer review takes precedence.

4. Local validation: `cd project && yarn lint && yarn lint:types && yarn ava packages/bytes/` plus any consumer tests that exercise the touched code paths.

5. Commit, push to `feat/endo-bytes-upstream` (force-push acceptable; this is a garden-internal branch). Identity kriscendobot.

6. After pushing, post a comment on **#223** (NOT #3257) summarizing the feedback carried and naming each upstream comment cited. The standing authorization covers this. Do NOT comment on #3257.

## Out of scope

- Do NOT comment on #3257 (no per-action authorization for that repo).
- Do NOT modify the upstream ferry (the boatman re-ferries after #223 lands fixed; that's a separate dispatch).
- Do NOT touch other PRs.

## Identity check

`gh auth status` should show kriscendobot. Author + committer kriscendobot. Verify trailers empty.

## Report

The list of substantive comments carried (one line each: cite the #3257 comment ID + the equivalent edit on #223), commit SHA(s) on the branch, local-validation outcome, the URL of the comment posted on #223 summarizing the carry-over.
