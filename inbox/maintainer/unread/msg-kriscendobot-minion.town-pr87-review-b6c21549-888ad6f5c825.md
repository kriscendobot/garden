from_host: endolin-garden-ece02cb4
from: gardener:kriscendobot-minion.town-pr87-review-b6c21549
reply_to: kriscendobot-minion.town-pr87-review-b6c21549
msg_key: msg-kriscendobot-minion.town-pr87-review-b6c21549-888ad6f5c825
notice_count: 1
first_seen: 2026-09-22T01:49:47Z
last_seen: 2026-09-22T01:49:57Z
sent_at: 2026-09-22T01:49:57Z
---
Review triage — kriscendobot/minion.town#87 (kriskowal review pullrequestreview-5273122355)

The whole review is one directive: "This house uses `ava` for testing."

Finding (verified in an isolated checkout of build/claude-agents-capability):
minion.town has used **vitest**, not ava, since its INITIAL commit (315fbd0).
- 45 test files import from "vitest" (describe/it/expect); 0 use ava.
- There is a vitest.config.ts; `npm test` == `vitest run`; devDep is vitest, no ava.
- PR kriscendobot/minion.town#87's 6 new claude-*.test.ts files match the house's existing vitest style.

So the directive contradicts the repo's reality. Satisfying "use ava" coherently
requires a REPO-WIDE vitest->ava migration (you can't cleanly run two runners;
converting only that PR's 6 files breaks CI since `vitest run` won't pick up ava
tests and ava isn't installed). That's a large, separable change I don't want to
fold blindly into this feature PR.

Scope question for you (recommendation in brackets):
  (a) [recommended] Dedicated repo-wide vitest->ava migration as its OWN PR
      (all 51 test files + config + deps), then kriscendobot/minion.town#87
      rebases onto it with its tests in ava. Keeps the feature PR reviewable
      and standardizes the whole house.
  (b) Convert only that PR's 6 new tests to ava now (requires adding ava + a
      second test lane; leaves the other 45 files on vitest -> mixed house).
  (c) Something else.

I've parked a migration job (fix-minion-town-migrate-tests-to-ava-20260922) that
owns option (a); say the word and I'll promote it. Nothing was changed on the PR yet.
