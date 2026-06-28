# Bulletin: empty reply must mark-as-read; every ack/reply moves unread→read (issue #10, missed replies)

Map: **fix** on kriskowal/garden, branch **main2** (the GitHub Pages bulletin SPA at
`docs/bulletin/` — kriskowal confirmed "an SPA on main2 is actually fine"). Build in an ISOLATED
worktree off origin/main2; explicit-pathspec commit; push HEAD:main2 via git-rebase CAS.
COMMUNICATE ON THE ISSUE: reply on https://github.com/kriskowal/garden/issues/10 with a summary
of the commit + what changed (comms directive); do NOT use the maintainer inbox.

These two kriskowal replies on #10 were MISSED (made while the issue was briefly closed; the
watcher dropped them — a separate watcher fix is queued). Implement them now:

1. **#10 17:07:40Z** — "Bulletin still says 'write a reply first' when trying to simply mark a
   message as read." The earlier empty-reply change (commit ae9020a97) did NOT take: the reply
   box still BLOCKS an empty submission with a "write a reply first" validation. Remove that
   block — an EMPTY reply must be allowed and must simply mark the message read.
2. **#10 17:08:28Z** — "I would like every acknowledgement or reply to move the current message
   from unread to read." So ANY acknowledgement OR reply (empty or not) moves that message from
   `inbox/maintainer/unread/` to `…/read/` on journal2 (the existing read-move commit), with no
   "write a reply first" gate. Empty reply = mark-as-read only; non-empty = post the reply AND
   mark-as-read.

Verify in the built SPA that clicking acknowledge/submit on a message with an EMPTY box moves it
unread→read (commits the move) and shows no "write a reply first" error.

Deliverable: docs/bulletin/ allows empty replies and moves the message unread→read on every
ack/reply, pushed to main2, with a summary reply on issue #10.
