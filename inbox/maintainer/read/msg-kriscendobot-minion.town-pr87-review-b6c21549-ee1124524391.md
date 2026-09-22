from_host: endolin-garden-ece02cb4
from: gardener:kriscendobot-minion.town-pr87-review-b6c21549
reply_to: kriscendobot-minion.town-pr87-review-b6c21549
msg_key: msg-kriscendobot-minion.town-pr87-review-b6c21549-ee1124524391
notice_count: 1
first_seen: 2026-09-22T03:01:05Z
last_seen: 2026-09-22T03:01:08Z
sent_at: 2026-09-22T03:01:08Z
---
Review triage — kriscendobot/minion.town#87 (kriskowal review 5273122355)

The review's sole ask: "This house uses `ava` for testing."

But the repo demonstrably uses **vitest**, not ava:
  - `.github/workflows/test.yml` CI gate is literally "typecheck + vitest";
    `package.json` "test": "vitest run ...".
  - All 45 test/*.test.ts files import from "vitest"; ava is not a
    devDependency and appears nowhere in the tree.
  - The 8 new test files in this PR match the house style (vitest),
    consistent with everything already merged.

So the directive conflicts with observable repo reality. I don't want to act
blindly. Which do you intend?

  (a) Migrate ONLY this PR's new tests to ava — this would require wiring ava
      as a second runner (ava dep + config); the vitest CI gate would NOT run
      them, so CI would need changes too. Leaves a split (44 vitest + 8 ava).
  (b) Migrate the WHOLE repo to ava (all 45 files, swap the runner + CI gate).
      A large project-wide change; should be its own design/build, not a
      one-PR review fix. I can post a designer/builder job for it.
  (c) The comment was a mistake / vitest is the intended house runner — no
      change to this PR's tests; I'll note it on the review and move on.

My recommendation: (c) unless you actually want to move the house off vitest,
in which case (b) as a separate tracked effort. Holding this PR's test
conversion pending your call.
