---
posted_at: 2026-11-04T01:30:41Z
requires: host=endolin-garden-ece02cb4
dispatch: automatic
tier: mentor
fallback-tier: minion
---
# Close endojs/endo-but-for-bots#1574 after its design moved to minion.town

Relay from job `endojs-endo-but-for-bots-pr1574-review-f45dd5bb`. The move is done: the design is in the draft PR https://github.com/kriscendobot/minion.town/pull/238, and the companion PR https://github.com/kriscendobot/minion.town/pull/228 points at it. The maintainer asked for the move in https://github.com/endojs/endo-but-for-bots/pull/1574#pullrequestreview-5761501306. The bot PAT on oros gets 403 on endojs PR writes, so these three writes run here.

Do only these steps. Do not edit either minion.town PR and do not delete the head branch.

First run `gh pr view 1574 -R endojs/endo-but-for-bots --json state,comments,reviews`. If the PR is already closed, or a maintainer comment newer than review 5761501306 contradicts closing it, skip the close and report what you found. Skip any reply or comment already posted.

1. Reply on inline thread 4462157174:

   gh api repos/endojs/endo-but-for-bots/pulls/1574/comments/4462157174/replies -F body=@reply.md

   with reply.md containing exactly:

   Moved to https://github.com/kriscendobot/minion.town/pull/238 (commit d94936ff). This pull request will close unmerged, so the design no longer appears in Endo's `designs/`.

2. Close with a comment:

   gh pr close 1574 -R endojs/endo-but-for-bots --comment "$(cat close.md)"

   with close.md containing exactly the text between the markers:

----- BEGIN -----
@kriskowal Moved to https://github.com/kriscendobot/minion.town/pull/238, and the `designs/README.md` rows from this pull request are dropped because nothing here landed. The companion chat Clip design, https://github.com/kriscendobot/minion.town/pull/228, now points there.

Phases W1-W5 of that design still change Endo packages. I added this as open question 7 on #238: should each be proposed in Endo as a design that does not name minion.town before it is built, or is the minion.town design enough? The parked build job waits for your answer.

Closing this pull request unmerged. I kept its branch so existing links keep working.
----- END -----

3. Confirm the PR state is CLOSED and report the reply URL and comment URL.

The parked job `build-claude-api-agent-workbench-20261027` has already been re-gated to `awaiting-maintainer`, so closing #1574 does not promote it.
