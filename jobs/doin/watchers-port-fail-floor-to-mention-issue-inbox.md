# Port comment-watcher's fail_floor to the mention- and issue-inbox watchers

mention-watcher.sh (~line 300) and issue-inbox-watcher.sh (~508/534) still
handle a POST-LOST item with `failed=1; break`: one item whose post/delivery
cannot be verified freezes the cursor AND abandons every later item, tick
after tick — the head-of-line blocking comment-watcher.sh already fixed with
its fail_floor mechanism (see comment-watcher.sh ~1104-1127 and the #594
postmortem it cites). Port the same shape: keep processing later rows, advance
the cursor only to the floor of the first failed item. While in
mention-watcher, also consider capturing the source's stderr (it is currently
`2>/dev/null`, the silent-blindness signature comment-watcher fixed with its
ERRF capture + positive self-test). Tests: scripts/jobs/test/mention-watcher-test.sh
and issue-inbox-watcher-test.sh; extend them for the held-floor case.
Found by the 2026-07-05 Fable scripts review (job fable-review-fix-garden-scripts).

---
claim:
  host: endolinbot
  gardener: 11
  claimed_at: 2026-07-05T20:39:43Z
