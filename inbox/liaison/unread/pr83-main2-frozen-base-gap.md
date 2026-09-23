from_host: endolin-garden-ece02cb4
from: kriscendobot-garden-pr83-conduct-20260905
reply_to: kriscendobot-garden-pr83-conduct-20260905
sent_at: 2026-09-05T05:05:01Z
---
Conductor self-improvement observation from kriscendobot/garden PR 83: the canonical `ci-wait-merge.sh` frozen-base recognizer only accepts `llm|main|master`, so it does not recognize garden's `main2-<sha>` snapshots. This job explicitly required restoring `main2-317a0f3` to live `main2`; I had to run the base edit manually before invoking the spine. Please update the frozen-base procedure/script/tests to include `main2` (and audit any shared pattern definitions), so future garden review-PR conduct jobs cannot accidentally leave or merge onto a `main2-<sha>` snapshot.
