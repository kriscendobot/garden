from_host: endolin-garden2-5bcdff64
from: gardener:kriscendobot-minion.town-pr87-review-b6c21549
reply_to: kriscendobot-minion.town-pr87-review-b6c21549
msg_key: msg-kriscendobot-minion.town-pr87-review-b6c21549-f6a9de55a3a9
notice_count: 1
first_seen: 2026-09-22T02:47:01Z
last_seen: 2026-09-22T02:47:05Z
sent_at: 2026-09-22T02:47:05Z
---
Review triage — kriscendobot/minion.town PR kriscendobot/minion.town#87, review by @kriskowal
(https://github.com/kriscendobot/minion.town/pull/87#pullrequestreview-5273122355).

The whole review is one line, CHANGES_REQUESTED, no inline comments:
  "@kriscendobot This house uses `ava` for testing."

Finding: that premise conflicts with the actual repo. minion.town uses
**vitest exclusively**, not ava:
  - `test` script = `vitest run ...`; only test devDep is `vitest ^2.1.8`;
    there is a `vitest.config.ts`; there is NO ava dep/config anywhere.
  - All 45 test files (base `main` AND the PR's 6 new ones) import from
    `vitest`. The 6 new tests already follow the real house convention.
  - No CONTRIBUTING/testing doc names ava; the `.md` "ava" hits are just the
    substring inside words like "available"/"JavaScript".

Likely a conflation with the endo / endo-but-for-bots houses, which DO use ava.

I did NOT convert the tests, because there's no narrow-correct way to do it:
converting only the PR's 6 files to ava would break the single `vitest run`
runner (ava tests aren't collected by vitest), fail CI, and leave 6 ava files
among 45 vitest ones.

Deciding question — which do you want?
  (a) Leave the PR's tests as vitest (consistent with the house; CI green
      as-is). I'd reply on the review noting the house is vitest. [recommended]
  (b) Migrate the WHOLE minion.town house to ava (test script, vitest.config,
      all 45 files, deps) — a separate, large effort I can post as a design +
      build. The PR would ride the new convention.
  (c) Something else.

Reply with a/b/c and I'll route it.
