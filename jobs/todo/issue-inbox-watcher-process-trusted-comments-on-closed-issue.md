# issue-inbox-watcher: don't drop trusted comments on a closed (or reopened) issue

Map: **build** (garden infra) on branch main2. Isolated worktree off origin/main2;
explicit-pathspec commit; push HEAD:main2 via git-rebase CAS. Touches
`scripts/jobs/issue-inbox-watcher.sh` (closing-etiquette / terminal rule). Sibling to the
comment-watcher reliability fixes (`comment-watcher-no-silent-trusted-drop-always-reactji`,
`comment-source-poll-reviews-on-all-open-prs`) — same theme: never silently drop trusted feedback.

## Observed failure (kriskowal/garden #10, 2026-06-28)
Timeline: kriskowal CLOSED #10 at 16:27:12Z, then COMMENTED on the closed issue twice —
17:07:40Z ("Bulletin still says 'write a reply first'…") and 17:08:28Z ("I would like every
acknowledgement or reply to move the message from unread to read") — then REOPENED at 17:26:19Z.
At 17:09:37Z the watcher processed both comments, logged `issue #10 closed by its submitter
(kriskowal) — terminal, dispatching nothing`, and advanced the cursor to 17:08:28Z. On reopen
the two comments were behind the cursor and never re-dispatched — two trusted directives lost.
The maintainer flagged it ("we missed two replies on #10").

## Root cause
The closing-etiquette rule ("a submitter-close is terminal → dispatch nothing for the issue")
is applied to COMMENTS too: any comment seen while the issue is closed is dropped and the cursor
slides past it. But maintainers DO comment on closed issues — and reopen them. A close means
"satisfied for now," not "ignore anything I say next."

## Required fix
1. **A trusted maintainer's comment AUTHORED AFTER the close is re-engagement — PROCESS it**
   (dispatch the job / deliver the message), do not drop it. The "terminal" stop applies to
   PROACTIVELY following up after a clean close with NO further trusted comment — not to a
   directive the maintainer just typed on the closed thread.
2. **Keep the genuine terminal behavior** only for the close itself (a close event with no
   subsequent trusted comment ⇒ stop autonomous follow-up). Distinguish the close EVENT from a
   trusted COMMENT that post-dates it (compare comment `created_at` vs the issue `closed_at`).
3. **Never silently slide the cursor past a trusted comment.** If a comment is genuinely dropped
   (e.g. from an untrusted author, or a true no-op), LOG the explicit reason + the comment id —
   so a future drop is diagnosable, never invisible (same no-silent-drop principle as the
   comment-watcher fix).
4. **Reopen safety:** a reopened issue is active again; ensure nothing about the prior close
   suppresses its subsequent comments. (With fix #1 this largely follows, but verify the cursor
   logic doesn't leave a reopened issue permanently muted.)

## Tests
Stub the issue source so a TRUSTED comment is authored AFTER the issue's `closed_at`: assert the
watcher DISPATCHES it (does not drop as terminal); assert a close with NO later comment still
stops proactive follow-up; assert any genuine drop logs a reason. Regression-pins the #10 case.

## Deliverable
issue-inbox-watcher.sh processes trusted comments that post-date a close (and survive a reopen),
never silently slides past a trusted comment, with tests pinning the no-missed-reply property.
