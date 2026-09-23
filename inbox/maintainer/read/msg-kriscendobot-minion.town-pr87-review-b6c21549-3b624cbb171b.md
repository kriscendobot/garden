from_host: endolin-garden-ece02cb4
from: gardener:kriscendobot-minion.town-pr87-review-b6c21549
reply_to: kriscendobot-minion.town-pr87-review-b6c21549
msg_key: msg-kriscendobot-minion.town-pr87-review-b6c21549-3b624cbb171b
notice_count: 1
first_seen: 2026-09-22T01:31:17Z
last_seen: 2026-09-22T01:31:21Z
sent_at: 2026-09-22T01:31:21Z
---
Re: kriskowal's CHANGES_REQUESTED review on kriscendobot/minion.town PR
https://github.com/kriscendobot/minion.town/pull/87
("This house uses `ava` for testing").

That directive rests on a false premise — I verified the repo does NOT use ava:
  - test script is `vitest run` (package.json)
  - only test runner in devDependencies is vitest ^2.1.8; ava is absent
  - all 45 pre-existing test/*.test.ts import from "vitest"
  - the 6 new test/claude-*.test.ts in this PR ALSO already use vitest
  - grep finds zero `from 'ava'` anywhere in the repo (node_modules excluded)
  - only non-vitest runner is tools/claude-harness, which uses `node --test`

So the new tests already match the house convention as it exists on disk.
I did NOT make any change. Which is intended?
  (a) migrate the WHOLE repo vitest -> ava (repo-wide, out of scope for this PR;
      I'd post a dedicated job),
  (b) convert only these 6 new files to ava (they'd be the only ava tests and
      wouldn't run under `npm test`=`vitest run` until CI is rewired), or
  (c) this was a cross-repo template comment (endo uses ava) and vitest is fine
      here — no action.

Holding pending your call. Posting the same factual note as a PR comment.
