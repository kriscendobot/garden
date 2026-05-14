---
ts: 2026-05-14T04:47:29Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 75
    role: target
  - repo: endojs/endo
    pr: 3232
    role: source-of-feedback
---

# Dispatch: fixer carries endo#3232 feedback to endo-but-for-bots#75 (chacha12)

Dispatch root: `dispatches/fixer--carry-3232-feedback-to-75--20260514-044728--d0c5ed/`. Project worktree at `endojs/endo-but-for-bots@kriskowal-random-chacha12`.

Same shape as the #3257 → #223 carry that landed earlier. endo#3232 is the upstream PR for the chacha12 refactor; the boatman (other-terminal liaison's dispatch) force-pushed the bot's content to that branch. kriskowal left substantive inline feedback at 2026-05-14T04:25-04:35Z. Carry the equivalent fixes to #75.

## Per-action authorization

Standing on endo-but-for-bots (push, comment). READ-ONLY on endojs/endo.

## Known feedback at dispatch time (incomplete; read the full set from gh)

Sample of kriskowal's inline comments visible at dispatch (use `gh api repos/endojs/endo/pulls/3232/comments` for the full set):

- `3239085874` `packages/random/src/random.js:10` — "Let's add an assertion to the test suite to make sure this equivalence sticks."
- `3239082370` `packages/ocapn/test/syrup/fuzz.test.js:102` — "Ditto. Gratuitous rename."
- `3239081576` `packages/ocapn/test/codecs/passable-fuzz.test.js:128` — "This was better when named `random`, unless there was a shadowing issue that I don't see."
- `3239072009` `.changeset/chacha12-next-getstate.md:1` — "We have only made one change in this release cycle, when this PR merges. Please consolidate these changeset."
- `3239068864` `.changeset/endo-chacha12.md:48` — "Omit as not interesting to package authors updating dependencies."
- `3239067688` `.changeset/endo-chacha12.md:42` — "The interface documented here is stale. We changed to an interface consistent with pure-rand-v8, structurally..."
- `3239064618` `.changeset/endo-chacha12.md:31` — "No longer true."
- `3239062xxx` (truncated in dispatch survey) — "Please omit gratuitous process comment."

Read the FULL set on dispatch — there are likely more.

## Task

1. Pull the full review-comment set: `gh api repos/endojs/endo/pulls/3232/comments --jq '[.[] | {id, path, line, position, body, user: .user.login, in_reply_to_id, commit_id}]'`. Plus review bodies: `gh pr view 3232 -R endojs/endo --json reviews,latestReviews`.
2. For each substantive comment, locate the equivalent file/line on #75's branch and apply the fix:
   - Renames flagged "gratuitous" → revert the rename to the prior identifier (the comment usually names the prior identifier).
   - Changeset content edits → trim per the comment.
   - Test additions → author the suggested assertion (e.g., the equivalence assertion).
   - Consolidate changesets → if there are multiple changesets that describe a single release-cycle change, fold them into one.
3. Skip Copilot comments unless kriskowal's review independently surfaces the same point; kriskowal wins on conflicts.
4. Local validation: `cd project && yarn lint && yarn lint:types && yarn ava packages/random/ packages/chacha12/ packages/ocapn/`. Note any pre-existing failures.
5. Force-push to `kriskowal-random-chacha12` (garden-internal branch; force-with-lease).
6. Post one summary comment on **#75** (NOT #3232) listing each carried-over fix with citations to the upstream comment IDs.

## Out of scope

- No commenting on #3232 (no auth for endojs/endo).
- No upstream ferry update (boatman re-ferries later if needed).

## Report

List of comment IDs carried (each with the equivalent edit), commit SHAs, local-validation outcome, summary comment URL on #75.
